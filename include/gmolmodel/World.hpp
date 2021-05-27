#ifndef WORLD_H_
#define WORLD_H_

/* -------------------------------------------------------------------------- *
 *		                       Robosampling                                 *
 * -------------------------------------------------------------------------- *
 * This is part of Robosampling		                                       *
 */

#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <unistd.h>
#include <time.h>
#include <thread>
#include <array>
//#include <random>
#include <math.h>

//#include <Eigen/Dense>
//#include <unsupported/Eigen/MatrixFunctions>
//#include <Eigen/Eigenvalues>
//#include <Eigen/LU>
//using Eigen::MatrixXd;

#include "Simbody.h"
#include "Molmodel.h"

#include "readAmberInput.hpp"

#include "ParaMolecularDecorator.hpp"
#include "FixmanTorque.hpp"

#include <boost/timer/timer.hpp>

#ifndef BaseSampler
#define BaseSampler HMCSampler
#endif

#include "server.hpp"
#include "Topology.hpp"
//#include "LAHMCSampler.hpp"
#include "HMCSampler.hpp"
#include "ConformationalSearch.hpp"

// TODO write a pdb writer for all the Compounds
// TODO move this in Topology since they work only for one Compound
// The following use PdbStructure for a Compound's Default Configuration
void writePdb(const SimTK::Compound& c, SimTK::State& advanced,
		 const char *dirname, const char *prefix, int midlength, const char *sufix);

void writePdb(	  SimTK::Compound& c, SimTK::State& advanced,
		 const char *dirname, const char *prefix, int midlength, const char *sufix);

void writePdb(const SimTK::Compound& c, SimTK::State& advanced,
		 const char *dirname, const char *prefix, int midlength, const char *sufix, double aTime);

void writePdb(	  SimTK::Compound& c, SimTK::State& advanced,
		 const char *dirname, const char *prefix, int midlength, const char *sufix, double aTime);

void writePdb(SimTK::PdbStructure pdb, const char *FN);

//==============================================================================
//                   CLASS World
//==============================================================================
/**
 *  Contains a Symbody system and additional data that define a regimen
 **/
class World {
public: 
	// --- Structural functions ---
	/** Constructor **/
	explicit World(int worldIndex, int requestedNofMols, bool isVisual=true, SimTK::Real visualizerFrequency = 0.0015);

	/** Creates a topology object and based on amberReader forcefield 
	 parameters - defines Biotypes; - adds BAT parameters to DuMM **/
	void AddMolecule(readAmberInput *amberReader, 
		std::string rbFN, std::string flexFN, std::string regimenSpec,
		std::string argRoot, std::string argRootMobility);

	/** Assign a scale factor for generalized velocities to every mobilized 
	body **/
	void setUScaleFactorsToMobods(void);

	/** Add a membrane represented by a contact surface **/
	void addMembrane(SimTK::Real xWidth, SimTK::Real yWidth, SimTK::Real zWidth, int resolution);

	/** Get the number of molecules **/
	int getNofMolecules() const;
 
	/** Calls CompoundSystem.modelCompounds and realizes Topology 
	To be called after loading all Compounds. **/
	void modelTopologies(std::string GroundToCompoundMobilizerType);

	/** Add contact surfaces to bodies **/
	const SimTK::State& addContacts(int prmtopIndex);
	
	/** Add contact constraints to specific bodies **/
	const SimTK::State& addConstraints(int prmtopIndex);

	const SimTK::State& realizeTopology();

	void loadCompoundRelatedMaps();

	void loadMobodsRelatedMaps();
	//...............

	// --- Mixing functions: Pass configurations among Worlds
	/** Get the current Compound Cartesian coords **/
	std::vector< std::vector< std::pair<bSpecificAtom *, SimTK::Vec3> > >  getAtomsLocationsInGround(const SimTK::State&);

	/** Set Compound, MultibodySystem and DuMM configurations according to
	some other World's atoms **/
	SimTK::State& setAtomsLocationsInGround(SimTK::State&, std::vector< std::vector< std::pair<bSpecificAtom *, SimTK::Vec3> > > otherWorldsAtomsLocations);

	/** Return own CompoundSystem **/
	CompoundSystem *getCompoundSystem() const;

	/** Set own Compound system **/
	// TODO find a solution for the old one
	void setCompoundSystem(CompoundSystem *compoundSystem);

	/** Update Gmolmodel bSpecificAtom Cartesian coordinates according to
	Molmodel Compound which in turn relizes Position and uses matter
	 to calculate locations. **/
	void updateAtomListsFromCompound(const SimTK::State &state);

	/** To be called before use of getXs, getYs or getZs **/
	void updateCoordBuffers();

	/** Get the coordinates buffers **/
	std::vector<SimTK::Real> getXs();
	std::vector<SimTK::Real> getYs();
	std::vector<SimTK::Real> getZs();

	/** Access to molecule (Topology) objects 
	Get a readble reference of one of the molecules **/
	const Topology& getTopology(std::size_t moleculeNumber) const;

	/** Get a writeble reference of one of the molecules **/
	Topology& updTopology(std::size_t moleculeNumber);  
	//...............
   
	//.......................
	// --- Thermodynamics ---
	//.......................
	/** Get the World (macro) temperature **/
	SimTK::Real getTemperature();

	/** Set the World (macro) temperature **/
	void setTemperature(SimTK::Real);
	//...............

	// --- Simulation ---
	/** Get/Set seed for reproducibility. **/
	void setSeed(int whichSampler, uint32_t argSeed);
	uint32_t getSeed(int whichSampler) const;

	/** Use the Fixman torque as an additional force subsystem.
	Careful not have different temperatures for World and Fixman Torque. **/
	void addFixmanTorque();

	/** Amber like scale factors. **/
	void setAmberForceFieldScaleFactors();

	/** Set a global scaling factor for all the terms the forcefield **/
	void setGlobalForceFieldScaleFactor(SimTK::Real);

	/** Set GBSA implicit solvent scale factor **/
	void setGbsaGlobalScaleFactor(SimTK::Real);

	/** Get a writeble pointer to the DuMM force field **/
	SimTK::DuMMForceFieldSubsystem * updForceField();

	/** Return true if the Fixman torque flag is set **/
	bool isUsingFixmanTorque() const;
	//...............

	/** Get U scale factor for the mobilized body **/
	float getMobodUScaleFactor(SimTK::MobilizedBodyIndex& ) const;
	//...............

	//...................
	// --- Statistics ---
	//...................
	/** How many samples did we have so far **/
	std::size_t getNofSamples() const;

	/** Sampler manipulation functions **/
	std::size_t getNofSamplers() const;

	/** Add a sampler to the World **/
	BaseSampler* addSampler(std::string);
	BaseSampler* addSampler(SamplerName);

	// TODO Use Sampler polymorphism
	/** Get a sampler based on its position in the samplers vector **/
	BaseSampler * getSampler(std::size_t which) const;

	/** Get a writable sampler based on its position in the samplers vector **/
	BaseSampler * updSampler(std::size_t which);

	/** Get writble pointer to FixmanTorque implementation **/
	FixmanTorque * updFixmanTorque();

	/** Get pointer to FixmanTorque implementation **/
	FixmanTorque * getFixmanTorque() const;

	//...............
  
	// -- Debugging / helper functions ---
	/** Print information about Simbody systems **/
	void PrintSimbodyStateCache(SimTK::State&);
  
	/** Print a Compound Cartesian coordinates as given by
	 * Compound::calcAtomLocationInGroundFrame **/
	void printPoss(const SimTK::Compound& c, SimTK::State& someState);

	/** Print a Compound Cartesian velocities as given by
 * Compound::calcAtomVelocityInGroundFrame **/
	void printVels(const SimTK::Compound& c, SimTK::State& someState);

	/** Print a Compound Cartesian coordinates and velocities
	 * as given by Compound::calcAtomLocationInGroundFrame and
	 * Compound::calcAtomVelocityInGroundFrame**/
	void printPossVels(const SimTK::Compound& c, SimTK::State& someState);
	//...............
 


public:

	// --- The three S: Study, System and State related ---
	/** System->MultibodySystem->MolecularMechanicsSystems->CompoundSystem **/
	std::unique_ptr<SimTK::CompoundSystem> compoundSystem;

	/** Subsystem->SimbodyMatterSubsystem **/
	std::unique_ptr<SimTK::SimbodyMatterSubsystem> matter;

	/** Subsystem->ForceSubsystem->GeneralForceSubsystem **/
	std::unique_ptr<SimTK::GeneralForceSubsystem> forces;

	/** Subsystem->ForceSubsystem->DuMMForceFieldSubsystem **/
	std::unique_ptr<SimTK::DuMMForceFieldSubsystem> forceField;

	/** Nof molecules **/
	int moleculeCount;


	/** Molecules (topologies<-Compounds) objects **/
	//std::vector<bMoleculeReader *> moleculeReaders;
	std::vector<Topology> topologies;
	std::vector<std::string> roots;
	std::vector<std::string> rootMobilities;

	/** Joint types **/
	//std::map< SimTK::MobilizedBodyIndex, SimTK::BondMobility::Mobility> mbx2mobility;

	/** Vectors of Cartesian coordinates **/
	std::vector<SimTK::Real> Xs;
	std::vector<SimTK::Real> Ys;
	std::vector<SimTK::Real> Zs;

	/** This vector stores a configuration if is needed for later use **/
	SimTK::Transform *TVector;
  
	/** Topologies graphs as tables - to be removed **/
	int **mbxTreeMat;    // tree representing the bonding
	SimTK::Real *branchMassVec; // branch masses self body included
	//...............

	// --- Thermodynamics ---
	SimTK::Real temperature;
	//...............

	// --- Simulation ---
	std::unique_ptr<SimTK::VerletIntegrator> integ;
	std::unique_ptr<SimTK::TimeStepper> ts;
	std::vector<std::unique_ptr<BaseSampler>> samplers;

	// Contact related
	std::unique_ptr<ContactTrackerSubsystem> tracker;
	std::unique_ptr<CompliantContactSubsystem> contactForces;
	ContactCliqueId clique1;
	std::unique_ptr<MobilizedBody::Weld> membrane;
	std::unique_ptr<Body::Rigid> memBody;

	bool _useFixmanTorque;
	//...............

	// --- Statistics ---
	//...............
  
	// --- Graphics ---
	bool visual;

	// Our decorations
	std::unique_ptr<ParaMolecularDecorator> paraMolecularDecorator;

	// Decoration subsystem
	std::unique_ptr<SimTK::DecorationSubsystem> decorations;

	// Visualizer
	std::unique_ptr<SimTK::Visualizer> visualizer;

	// Visualizer reporter
	std::unique_ptr<SimTK::Visualizer::Reporter> visualizerReporter;
	//...............

	// --- Mixing data ---
	int ownWorldIndex;
	//...............

	/** Get writble pointer to Fixman Torque and other forces**/
	// std::unique_ptr<FixmanTorque> FixmanTorqueImpl;
	// std::unique_ptr<SimTK::Force::Custom> ExtForce;

	FixmanTorque* FixmanTorqueImpl = nullptr;
	SimTK::Force::Custom* ExtForce = nullptr;

private:
	
	// Maps a generalized velocity scale factor for every mobod
	std::map< SimTK::MobilizedBodyIndex, float > mbx2uScale;


};

#endif /*WORLD_H_*/

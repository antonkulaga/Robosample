#!/bin/bash

# TODO: 
# update gitignore

######################################################################
# CHOOSE THE FOLLOWING VARIABLES ACCORDING TO YOUR SYSTEM & DESIRES
######################################################################

# Robosample HOME DIR
export ROBOSAMPLE_HOME=$(pwd);

# Build type = "Release" / "Debug" (argv 1)
export BUILD_TYPE=$1



# 0/1 if you want to :
#	- checkout to a specific branch/commit 
#	- pull updates 

export SIMBODY_GIT_PULL=0
export SIMBODY_GIT_BRANCH="master"

export MOLMODEL_GIT_PULL=0
export MOLMODEL_GIT_BRANCH="calc_energy_openmm"

export OPENMM_GIT_PULL=0
export OPENMM_GIT_BRANCH="master"

export ROBOSAMPLE_GIT_PULL=0
export ROBOSAMPLE_GIT_BRANCH="calc_energy_openmm"


#	- regenerate cmake (for the first time usage OR if you modified CMake files)
#	- add to PATH variable to bashrc (for the first time usage ONLY !!!!!!)

export SIMBODY_REGENERATE=1
export MOLMODEL_REGENERATE=1
export OPENMM_REGENERATE=1
export ROBOSAMPLE_REGENERATE=1

export SIMBODY_EXPORT_PATH=0
export MOLMODEL_EXPORT_PATH=0
export OPENMM_EXPORT_PATH=0
export ROBOSAMPLE_EXPORT_PATH=0

######################################################################


if [ ! "${BUILD_TYPE}" = "Release" ] && [ ! "${BUILD_TYPE}" = "Debug" ] 
  then 
     echo "Specify build type: Debug/Release !"
     echo "Example:"
     echo "bash build_custom_1st_time.sh Release"
     exit 1;
fi

export BUILD_DIRNAME='build-'${BUILD_TYPE,,}
export INSTALL_DIRNAME='install-'${BUILD_TYPE,,}

echo "BUILD_DIRNAME is : ${BUILD_DIRNAME}"
echo "INSTALL_DIRNAME is : ${INSTALL_DIRNAME}"



################
#   SIMBODY    #
################

cd ${ROBOSAMPLE_HOME}/Molmodel/Simbody01
echo "Current directory is : $(pwd)"

git checkout ${SIMBODY_GIT_BRANCH};
if [ ${SIMBODY_GIT_PULL} -eq 1 ];
	then git pull;
fi

mkdir -p ${BUILD_DIRNAME}
mkdir -p ${INSTALL_DIRNAME}

if [ ${SIMBODY_REGENERATE} -eq 1 ]
then
  if [ -z "${BUILD_DIRNAME}" ]
  then 
     exit 1;
  else
    echo "You are in dir: $(pwd)"
    echo "Deleting contents of ${BUILD_DIRNAME}/*:"
    rm -rfIv ${BUILD_DIRNAME}/*
    cd ${BUILD_DIRNAME}
    cmake \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_INSTALL_PREFIX=../${INSTALL_DIRNAME} ..
    fi
fi


make -j$(nproc)
make install


if [ ${SIMBODY_EXPORT_PATH} -eq 1 ]
  then
    cd ../${INSTALL_DIRNAME}/
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$(pwd)/lib/" >> ~/.bashrc
fi


################
#   OPENMM     #
################

cd ${ROBOSAMPLE_HOME}/openmm/
echo "Current directory is : $(pwd)"

git checkout ${OPENMM_GIT_BRANCH}
if [ ${OPENMM_GIT_PULL} -eq 1 ]
  then 
    git pull
fi

mkdir -p ${BUILD_DIRNAME}
mkdir -p ${INSTALL_DIRNAME}

if [ ${OPENMM_REGENERATE} -eq 1 ]
then
  if [ -z "${BUILD_DIRNAME}" ]
  then 
     exit 1;
  else
    echo "You are in dir: $(pwd)"
    echo "Deleting contents of ${BUILD_DIRNAME}/*:"
    rm -rfIv ${BUILD_DIRNAME}/*
    cd ${BUILD_DIRNAME}
    cmake \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=../${INSTALL_DIRNAME} ..
  fi
fi

make -j$(nproc)
make install


if [ ${OPENMM_EXPORT_PATH} -eq 1 ]
  then
    cd ../${INSTALL_DIRNAME}/
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$(pwd)/lib/" >> ~/.bashrc
fi



################
#   MOLMODEL   #
################


cd ${ROBOSAMPLE_HOME}/Molmodel/
echo "Current directory is : $(pwd)"


git checkout ${MOLMODEL_GIT_BRANCH} 
if [ ${MOLMODEL_GIT_PULL} -eq 1 ]
  then 
    git pull;
fi

mkdir -p ${BUILD_DIRNAME}
mkdir -p ${INSTALL_DIRNAME}


if [ ${MOLMODEL_REGENERATE} -eq 1 ]
then
  if [ -z "${BUILD_DIRNAME}" ]
  then 
     exit 1;
  else
    echo "You are in dir: $(pwd)"
    echo "Deleting contents of ${BUILD_DIRNAME}/*:"
    rm -rfIv ${BUILD_DIRNAME}/*
    cd ${BUILD_DIRNAME}
    cmake \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DSimTK_INSTALL_PREFIX=${ROBOSAMPLE_HOME}/Molmodel/${INSTALL_DIRNAME} \
      -DSimbody_DIR=${ROBOSAMPLE_HOME}/Molmodel/Simbody01/${INSTALL_DIRNAME}/lib/cmake/simbody/ \
      -DOpenMM_INCLUDE_DIR=${ROBOSAMPLE_HOME}/openmm/${INSTALL_DIRNAME}/include \
      -DOpenMM_LIBRARIES=${ROBOSAMPLE_HOME}/openmm/${INSTALL_DIRNAME}/lib/libOpenMM.so \
      -DOpenMM_LIBRARY=${ROBOSAMPLE_HOME}/openmm/${INSTALL_DIRNAME}/lib/libOpenMM.so ..
  fi
fi

make -j$(nproc)
make install



if [ ${MOLMODEL_EXPORT_PATH} -eq 1 ]
  then
    cd ../${INSTALL_DIRNAME}/
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'"$(pwd)/lib/" >> ~/.bashrc
    echo "OpenMMPlugin_PATH=${ROBOSAMPLE_HOME}/Molmodel/${INSTALL_DIRNAME}/lib/plugins" >> ~/.bashrc
fi



################
#  ROBOSAMPLE  #
################


cd ${ROBOSAMPLE_HOME}
echo "Current directory is : $(pwd)"

git checkout ${ROBOSAMPLE_GIT_BRANCH}
if [ ${ROBOSAMPLE_GIT_PULL} -eq 1 ]
  then 
    git pull;
fi


mkdir -p ${BUILD_DIRNAME}
mkdir -p ${INSTALL_DIRNAME}


if [ ${ROBOSAMPLE_REGENERATE} -eq 1 ]
then
  if [ -z "${BUILD_DIRNAME}" ]
  then 
     exit 1;
  else
    echo "You are in dir: $(pwd)"
    echo "Deleting contents of ${BUILD_DIRNAME}/*:"
    rm -rfIv ${BUILD_DIRNAME}/*
    cd ${BUILD_DIRNAME}
    cmake \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${ROBOSAMPLE_HOME}/${INSTALL_DIRNAME} \
      -DSimbody_DIR=${ROBOSAMPLE_HOME}/Molmodel/Simbody01/${INSTALL_DIRNAME} \
      -DMolmodel_DIR=${ROBOSAMPLE_HOME}/Molmodel/${INSTALL_DIRNAME} \
      -DOpenMM_INCLUDE_DIR=${ROBOSAMPLE_HOME}/openmm/${INSTALL_DIRNAME}/include \
      -DOpenMM_LIBRARIES=${ROBOSAMPLE_HOME}/openmm/${INSTALL_DIRNAME}/lib/libOpenMM.so \
      -DOpenMM_LIBRARY=${ROBOSAMPLE_HOME}/openmm/${INSTALL_DIRNAME}/lib/libOpenMM.so ..
  fi
fi

make -j$(nproc)


source ~/.bashrc


echo "Running ldconfig is required to update the lib paths. This requires sudo priviledges:"
echo "sudo ldconfig"
sudo ldconfig


# add test input files
cp -ri ../tests_inputs/* .
mkdir temp
mkdir temp/pdbs

# add tests
cp ../tests/test-memory.sh test-memory.sh

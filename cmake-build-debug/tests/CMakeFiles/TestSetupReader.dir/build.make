# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/pcuser/Installers/clion-2019.1.1/bin/cmake/linux/bin/cmake

# The command to remove a file.
RM = /home/pcuser/Installers/clion-2019.1.1/bin/cmake/linux/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/pcuser/git3/Robosample

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/pcuser/git3/Robosample/cmake-build-debug

# Include any dependencies generated for this target.
include tests/CMakeFiles/TestSetupReader.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/TestSetupReader.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/TestSetupReader.dir/flags.make

tests/CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.o: tests/CMakeFiles/TestSetupReader.dir/flags.make
tests/CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.o: ../tests/TestSetupReader.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/pcuser/git3/Robosample/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.o"
	cd /home/pcuser/git3/Robosample/cmake-build-debug/tests && /usr/bin/g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.o -c /home/pcuser/git3/Robosample/tests/TestSetupReader.cpp

tests/CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.i"
	cd /home/pcuser/git3/Robosample/cmake-build-debug/tests && /usr/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/pcuser/git3/Robosample/tests/TestSetupReader.cpp > CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.i

tests/CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.s"
	cd /home/pcuser/git3/Robosample/cmake-build-debug/tests && /usr/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/pcuser/git3/Robosample/tests/TestSetupReader.cpp -o CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.s

# Object files for target TestSetupReader
TestSetupReader_OBJECTS = \
"CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.o"

# External object files for target TestSetupReader
TestSetupReader_EXTERNAL_OBJECTS =

tests/TestSetupReader: tests/CMakeFiles/TestSetupReader.dir/TestSetupReader.cpp.o
tests/TestSetupReader: tests/CMakeFiles/TestSetupReader.dir/build.make
tests/TestSetupReader: /usr/local/lib/libSimTKsimbody_d.so.3.7
tests/TestSetupReader: lib/libGMOLMODEL_dynamic.so
tests/TestSetupReader: /usr/local/lib/libSimTKmath_d.so.3.7
tests/TestSetupReader: /usr/local/lib/libSimTKcommon_d.so.3.7
tests/TestSetupReader: /usr/local/lib/libSimTKsimbody_d.so.3.7
tests/TestSetupReader: /usr/local/lib/libSimTKmath_d.so.3.7
tests/TestSetupReader: /usr/local/lib/libSimTKcommon_d.so.3.7
tests/TestSetupReader: /usr/lib/libblas.so
tests/TestSetupReader: /usr/lib/liblapack.so
tests/TestSetupReader: /usr/lib/libblas.so
tests/TestSetupReader: /usr/lib/liblapack.so
tests/TestSetupReader: /usr/local/openmm/lib/libOpenMM.so
tests/TestSetupReader: tests/CMakeFiles/TestSetupReader.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/pcuser/git3/Robosample/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable TestSetupReader"
	cd /home/pcuser/git3/Robosample/cmake-build-debug/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/TestSetupReader.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/TestSetupReader.dir/build: tests/TestSetupReader

.PHONY : tests/CMakeFiles/TestSetupReader.dir/build

tests/CMakeFiles/TestSetupReader.dir/clean:
	cd /home/pcuser/git3/Robosample/cmake-build-debug/tests && $(CMAKE_COMMAND) -P CMakeFiles/TestSetupReader.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/TestSetupReader.dir/clean

tests/CMakeFiles/TestSetupReader.dir/depend:
	cd /home/pcuser/git3/Robosample/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/pcuser/git3/Robosample /home/pcuser/git3/Robosample/tests /home/pcuser/git3/Robosample/cmake-build-debug /home/pcuser/git3/Robosample/cmake-build-debug/tests /home/pcuser/git3/Robosample/cmake-build-debug/tests/CMakeFiles/TestSetupReader.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/TestSetupReader.dir/depend


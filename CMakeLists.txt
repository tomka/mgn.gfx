#################################
# Preamble
##############

cmake_minimum_required(VERSION 2.8.1)

# Using Tango or Phobos?
set(CMAKE_D_USE_PHOBOS True)
# Want to built documentation?
set(CMAKE_D_BUILD_DOCS False)

#################################
# Project
##############

# The name of our project is "MGNGFX".  CMakeLists files in this project can
# refer to the root source directory of the project as ${MGNGFX_SOURCE_DIR} and
# to the root binary directory of the project as ${MGNGFX_BINARY_DIR}.
PROJECT (MGNGFX D)

# Recurse into the "src" and "samples" subdirectories.  This does not actually
# cause another cmake executable to run.  The same process will walk through
# the project's entire directory structure.
ADD_SUBDIRECTORY (src)
ADD_SUBDIRECTORY (samples)

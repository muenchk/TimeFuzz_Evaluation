cmake_minimum_required(VERSION 3.22)

project(maze_small_hard
	VERSION 0.0.1
	LANGUAGES C CXX
)
include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
if("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
	message(FATAL_ERROR "in-source builds are not allowed")
endif()

SET(CMAKE_WARN_DEPRECATED       OFF CACHE BOOL "" FORCE)


add_executable("${PROJECT_NAME}" "maze_small_hard.cpp")
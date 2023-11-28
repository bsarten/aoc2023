cmake_minimum_required(VERSION 3.15.1)

project(aoc2023 LANGUAGES Swift)

if(CMAKE_SYSTEM_NAME STREQUAL Windows OR CMAKE_SYSTEM_NAME STREQUAL Darwin)
  option(BUILD_SHARED_LIBS "Build shared libraries by default" YES)
endif()

add_subdirectory(1)

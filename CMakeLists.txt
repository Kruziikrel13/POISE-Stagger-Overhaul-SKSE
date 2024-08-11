cmake_minimum_required(VERSION 3.21)
set(AE_VERSION 1)

# --- Project Information --- #
project(loki_POISE
        VERSION 1.0.0
        LANGUAGES CXX)

option(BUILD_SKYRIMAE "Build for Skyrim AE" OFF)

include(cmake/build.cmake)

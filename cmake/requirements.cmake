include(FetchContent) # Source dependencies via this
macro(fetch_content NAME REPOSITORY TAG)
  FetchContent_Declare(${NAME}
                            GIT_REPOSITORY ${REPOSITORY}
                            GIT_TAG ${TAG}
                            OVERRIDE_FIND_PACKAGE)
  FetchContent_GetProperties(${NAME})
  if (NOT ${NAME}_POPULATED)
    FetchContent_Populate(${NAME})
  endif()
  add_subdirectory(${${NAME}_SOURCE_DIR} ${${NAME}_BINARY_DIR})
endmacro()
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/required_configs)

# --- CommonLibSSE Dependencies --- #
set(SPDLOG_INSTALL ON)
set(BUILD_TESTING false) # Reduces required dependencies for CommonLib
fetch_content(spdlog "https://github.com/gabime/spdlog" "v1.14.1")
fetch_content(binary_io "https://github.com/Ryan-rsm-McKenzie/binary_io" main)
fetch_content(simpleini "https://github.com/brofield/simpleini" master)
set(SIMPLEINI_INCLUDE_DIRS ${simpleini_SOURCE_DIR})
fetch_content(tomlplusplus "https://github.com/marzer/tomlplusplus" master)
set(TOMLPLUSPLUS_INCLUDE_DIRS ${tomlplusplus_SOURCE_DIR}/include)
fetch_content(xbyak "https://github.com/herumi/xbyak" master)
set(XBYAK_INCLUDE_DIRS ${xbyak_SOURCE_DIR})

# --- Project Dependencies --- #
# CommonLibSSE
find_path(CommonLibPath
    include/REL/Relocation.h
    PATHS ${CMAKE_SOURCE_DIR}/extern/CommonLibSSE)
if(${CommonLibPath} STREQUAL "CommonLibPath-NOTFOUND" OR NOT IS_DIRECTORY ${CommonLibPath})
    message(FATAL_ERROR "Cannot find CommonLibSSE")
endif()
add_subdirectory(${CommonLibPath} CommonLibSSE)

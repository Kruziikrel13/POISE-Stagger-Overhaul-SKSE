# --- build.cmake --- #
include(cmake/init.cmake)

# --- 1.6.640 / 1.5.97 --- #
# PROJECT_VERSION_TWEAK is used to denote which version of Skyrim the resulting DLL was built for
if(ENABLE_SKYRIM_AE)
  add_compile_definitions(SKYRIM_AE SKYRIM_SUPPORT_AE)
  set(SkyrimVersion "AE")
  set(PROJECT_VERSION_TWEAK 1) 
else()
  set(SkyrimVersion "SSE")
  set(PROJECT_VERSION_TWEAK 0)
endif()

# ---- Add source files ----
add_compile_definitions(SKSE_SUPPORT_XBYAK)
include(cmake/headerlist.cmake)
include(cmake/sourcelist.cmake)
include(cmake/requirements.cmake)

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}
        FILES ${HEADERS} ${SOURCES})

# ---- Create DLL ----
add_library(${PROJECT_NAME} SHARED
      ${HEADERS} ${SOURCES} .clang-format)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)

target_compile_definitions(${PROJECT_NAME} PRIVATE _UNICODE)

target_include_directories(CommonLibSSE PRIVATE
                ${XBYAK_INCLUDE_DIRS})

target_include_directories(${PROJECT_NAME} PRIVATE
                ${CMAKE_CURRENT_BINARY_DIR}/include
                ${CMAKE_CURRENT_SOURCE_DIR}/src
                ${TOMLPLUSPLUS_INCLUDE_DIRS}
                ${XBYAK_INCLUDE_DIRS}
                ${SIMPLEINI_INCLUDE_DIRS})

target_link_libraries(${PROJECT_NAME} PRIVATE
                CommonLibSSE::CommonLibSSE)

target_precompile_headers(${PROJECT_NAME} PRIVATE
  ${PRECOMPILED_HEADER})

target_compile_options(
                ${PROJECT_NAME}
                PRIVATE
                        /sdl	# Enable Additional Security Checks
                        /utf-8	# Set Source and Executable character sets to UTF-8
                        /Zi	# Debug Information Format

                        /permissive-	# Standards conformance

                        /Zc:alignedNew	# C++17 over-aligned allocation
                        /Zc:auto	# Deduce Variable Type
                        /Zc:char8_t
                        /Zc:__cplusplus	# Enable updated __cplusplus macro
                        /Zc:externC
                        /Zc:externConstexpr	# Enable extern constexpr variables
                        /Zc:forScope	# Force Conformance in for Loop Scope
                        /Zc:hiddenFriend
                        /Zc:implicitNoexcept	# Implicit Exception Specifiers
                        /Zc:lambda
                        /Zc:noexceptTypes	# C++17 noexcept rules
                        /Zc:preprocessor	# Enable preprocessor conformance mode
                        /Zc:referenceBinding	# Enforce reference binding rules
                        /Zc:rvalueCast	# Enforce type conversion rules
                        /Zc:sizedDealloc	# Enable Global Sized Deallocation Functions
                        /Zc:strictStrings	# Disable string literal type conversion
                        /Zc:ternary	# Enforce conditional operator rules
                        /Zc:threadSafeInit	# Thread-safe Local Static Initialization
                        /Zc:tlsGuards
                        /Zc:trigraphs	# Trigraphs Substitution
                        /Zc:wchar_t	# wchar_t Is Native Type

                        /external:anglebrackets
                        /external:W0

                        /W4	# Warning level
                        /WX	# Warning level (warnings are errors)

                        "$<$<CONFIG:DEBUG>:>"
                        "$<$<CONFIG:RELEASE>:/Zc:inline;/JMC-;/Ob3>"
)

target_link_options(
                ${PROJECT_NAME}
                PRIVATE
                        /WX	# Treat Linker Warnings as Errors

                        "$<$<CONFIG:DEBUG>:/INCREMENTAL;/OPT:NOREF;/OPT:NOICF>"
                        "$<$<CONFIG:RELEASE>:/INCREMENTAL:NO;/OPT:REF;/OPT:ICF;/DEBUG:FULL>"
)

# ---- Post build ----
set(INSTALL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/install/$<CONFIG>/${SkyrimVersion}/SKSE/Plugins")
add_custom_command(
    TARGET "${PROJECT_NAME}"
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E make_directory ${INSTALL_DIR}
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${PROJECT_NAME}>" ${INSTALL_DIR}
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${PROJECT_NAME}>" ${INSTALL_DIR}
    VERBATIM)

if(DEFINED MO2_MODS_DIR)
  message(NOTICE "Copying Skryim ${SkyrimVersion} build to ${MO2_MODS_DIR}")
  add_custom_command(
    TARGET "${PROJECT_NAME}"
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/install/$<CONFIG>/${SkyrimVersion} "${MO2_MODS_DIR}/${PROJECT_NAME} - $<CONFIG>.${SkyrimVersion}")
endif()

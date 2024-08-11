configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Version.h.in
        ${CMAKE_CURRENT_BINARY_DIR}/include/Version.h @ONLY)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.rc.in
        ${CMAKE_CURRENT_BINARY_DIR}/version.rc @ONLY)

set(HEADERS ${headers}
        ${CMAKE_CURRENT_BINARY_DIR}/version.rc
        ${CMAKE_CURRENT_BINARY_DIR}/include/Version.h
	src/Loki_PluginTools.h
	src/PCH.h
	src/POISE/PoiseMod.h
	src/POISE/TrueHUDAPI.h
	src/POISE/TrueHUDControl.h
	src/ActorCache.h)
set(PRECOMPILED_HEADER
      src/PCH.h)

@echo off

cmake --fresh --preset compiledb
IF EXIST compile_commands.json DEL /F compile_commands.json
mklink compile_commands.json build\compiledb\compile_commands.json

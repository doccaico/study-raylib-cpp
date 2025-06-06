@echo off


setlocal


:: Debug = 0, Release = 1
if "%2" == "" (
    set release_mode=0
) else if "%2" == "--debug" (
    set release_mode=0
) else if "%2" == "--release" (
    set release_mode=1
) else (
    goto :HELP
)


set compiler=cl.exe
set compiler_flags=-std:c++20 /utf-8 -nologo -Oi -TP -fp:precise -Gm- -MP -FC -EHsc- -GR- -GF
set compiler_defines=-DUNICODE -D_UNICODE
set compiler_includes=-I ..\vendor\raylib\include\
set compiler_warnings= ^
    -W4 -WX ^
    -wd4100 -wd4101 -wd4127 -wd4146 ^
    -wd4505 ^
    -wd4456 -wd4457
if %release_mode% EQU 0 ( REM Debug
    set compiler_flags=%compiler_flags% -Od -MDd
    REM -Z7
    set compiler_defines=%compiler_defines% -DDEBUG -D_DEBUG
) else ( REM Release
    set compiler_flags=%compiler_flags% -O2 -MT
    REM -Z7
    set compiler_defines=%compiler_defines% -DNDEBUG
)
set compiler_settings=%compiler_includes% %compiler_flags% %compiler_defines% %compiler_warnings%

set linker_flags=/libpath:..\vendor\raylib\lib\
REM set linker_flags=/NODEFAULTLIB:msvcrt /ENTRY:mainCRTStartup  
set linker_flags=%linker_flags% /ENTRY:mainCRTStartup
REM set linker_libs=..\vendor\raylib\lib\raylib.lib winmm.lib shell32.lib user32.lib gdi32.lib opengl32.lib
set linker_libs=raylib.lib opengl32.lib winmm.lib shell32.lib user32.lib gdi32.lib
if %release_mode% EQU 0 ( REM Debug
    set linker_flags=%linker_flags% /NODEFAULTLIB:msvcrt
) else ( REM Release
    set linker_flags=%linker_flags% /SUBSYSTEM:WINDOWS /NODEFAULTLIB:libcmt
)
set linker_settings=%linker_libs% %linker_flags%


if        "%1" == "01_game_of_life"     ( goto :01_GAME_OF_LIFE
REM ) else if "%1" == "window"          ( goto :WINDOW
) else                              ( goto :HELP
)


:HELP
    echo Usage : $ run.cmd [directory's name] [--debug^|--release]
    echo   Example: $ run.cmd message_box           (debug mode)
    echo            $ run.cmd message_box --debug   (debug mode)
    echo            $ run.cmd message_box --release (release mode)
goto :EOF


:01_GAME_OF_LIFE
    pushd %1
    %compiler% %compiler_settings% main.cpp -Fo:main ^
        /link %linker_settings% -OUT:%1.exe && %1.exe
    popd
goto :EOF


REM vim: ft=dosbatch fenc=utf8 ff=dos

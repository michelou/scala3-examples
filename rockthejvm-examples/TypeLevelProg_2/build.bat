@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_LINT%==1 (
    call :lint
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DECOMPILE%==1 (
    call :decompile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
if %_TEST%==1 (
    call :test
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _CLASSES_DIR, _TARGET_DIR, _TARGET_DOCS_DIR, _TASTY_CLASSES_DIR
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_MAIN_SOURCE_DIR=%_SOURCE_DIR%\main\scala"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"
set "_TASTY_CLASSES_DIR=%_TARGET_DIR%\tasty-classes"
set "_TEST_CLASSES_DIR=%_TARGET_DIR%\test-classes"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

if not exist "%JAVA_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Java SDK installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JAVA_CMD=%JAVA_HOME%\bin\java.exe"
set "_JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
set "_JAVADOC_CMD=%JAVA_HOME%\bin\javadoc.exe"

if not exist "%SCALA3_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala 3 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SCALA_CMD=%SCALA3_HOME%\bin\scala.bat"
set "_SCALAC_CMD=%SCALA3_HOME%\bin\scalac.bat"
set "_SCALADOC_CMD=%SCALA3_HOME%\bin\scaladoc.bat"

set _SCALAFMT_CMD=
if exist "%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat" (
    set "_SCALAFMT_CMD=%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat"
)
set _SCALAFMT_CONFIG_FILE=
for %%f in ("%~dp0\.") do set "_SCALAFMT_CONFIG_FILE=%%~dpf.scalafmt.conf"

set _CFR_CMD=
if exist "%CFR_HOME%\bin\cfr.bat" (
    set "_CFR_CMD=%CFR_HOME%\bin\cfr.bat"
)
set _DIFF_CMD=
if exist "%GIT_HOME%\usr\bin\diff.exe" (
    set "_DIFF_CMD=%GIT_HOME%\usr\bin\diff.exe" 
)
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

@rem input parameter: %*
:args
set _CLEAN=0
set _COMPILE=0
set _DECOMPILE=0
set _DOC=0
set _HELP=0
set _LINT=0
set _RUN=0
set _SCALAC_OPTS=-deprecation -feature -explain
set _TASTY=0
set _TEST=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-tasty" ( set _TASTY=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="decompile" ( set _COMPILE=1& set _DECOMPILE=1
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="lint" ( set _LINT=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if "%__ARG%"=="test" ( set _COMPILE=1& set _TEST=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 (
    set _STDERR_REDIRECT=
    set _STDOUT_REDIRECT=
) else (
    set _STDERR_REDIRECT=2^>NUL
    set _STDOUT_REDIRECT=1^>NUL
)
set _MAIN_CLASS=rockthejvm.TypeLevelProgramming
set _MAIN_ARGS=

for %%i in ("%~dp0\.") do set "_PROJECT_NAME=%%~ni"
set _PROJECT_URL=github.com/%USERNAME%/dotty-examples
set _PROJECT_VERSION=0.1-SNAPSHOT

if %_DECOMPILE%==1 if not defined _CFR_CMD (
    echo %_WARNING_LABEL% cfr installation not found 1>&2
    set _DECOMPILE=0
)
if %_LINT%==1 (
    if not defined _SCALAFMT_CMD (
        echo %_WARNING_LABEL% Scalafmt installation not found 1>&2
        set _LINT=0
    ) else if not defined _SCALAFMT_CONFIG_FILE (
        echo %_WARNING_LABEL% Scalafmt configuration file not found 1>&2
        set _LINT=0
    )
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TASTY=%_TASTY% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DECOMPILE=%_DECOMPILE% _DOC=%_DOC% _LINT=%_LINT% _RUN=%_RUN% _TEST=%_TEST% 1>&2
    echo %_DEBUG_LABEL% Variables  : "JAVA_HOME=%JAVA_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "SCALA_HOME=%SCALA_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "SCALA3_HOME=%SCALA3_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _MAIN_CLASS=%_MAIN_CLASS% _MAIN_ARGS=%_MAIN_ARGS% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%           print commands executed by this script
echo     %__BEG_O%-tasty%__END%           compile both from source and TASTy files
echo     %__BEG_O%-timer%__END%           print total elapsed time
echo     %__BEG_O%-verbose%__END%         print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%            delete generated files
echo     %__BEG_O%compile%__END%          compile Java/Scala source files
echo     %__BEG_O%decompile%__END%        decompile generated code with %__BEG_N%CFR%__END%
echo     %__BEG_O%doc%__END%              generate HTML documentation
echo     %__BEG_O%help%__END%             print this help message
echo     %__BEG_O%lint%__END%             analyze Scala source files with %__BEG_N%Scalafmt%__END%
echo     %__BEG_O%test%__END%             execute unit tests with %__BEG_N%JUnit%__END%
goto :eof

:clean
call :rmdir "%_ROOT_DIR%project\target"
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter(s): %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:lint
set __SCALAFMT_OPTS=--test --config "%_SCALAFMT_CONFIG_FILE%"
if %_DEBUG%==1 set __SCALAFMT_OPTS=--debug %__SCALAFMT_OPTS%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAFMT_CMD%" %__SCALAFMT_OPTS% %_MAIN_SOURCE_DIR%\ 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Scala source files with Scalafmt 1>&2
)
@rem Scalafmt throws a java.nio.file.InvalidPathException
@rem if source directory is surrounded with double quotes.
call "%_SCALAFMT_CMD%" %__SCALAFMT_OPTS% %_MAIN_SOURCE_DIR%\
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%" 1>NUL

set "__TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\java\*.java"
if %_ACTION_REQUIRED%==1 (
    call :compile_java
    if not !_EXITCODE!==0 goto :eof
)
call :action_required "%__TIMESTAMP_FILE%" "%_MAIN_SOURCE_DIR%\*.scala"
if %_ACTION_REQUIRED%==1 (
    call :compile_scala
    if not !_EXITCODE!==0 goto :eof
)
echo. > "%__TIMESTAMP_FILE%"

if %_TASTY%==0 goto :eof

if not exist "%_TASTY_CLASSES_DIR%\" mkdir "%_TASTY_CLASSES_DIR%"

set "__TASTY_TIMESTAMP_FILE=%_TASTY_CLASSES_DIR%\.latest-build"

call :action_required "%__TASTY_TIMESTAMP_FILE%" "%_CLASSES_DIR%\*.tasty"
if %_ACTION_REQUIRED%==1 (
    call :compile_tasty
    if not !_EXITCODE!==0 goto :eof
)
echo. > "%__TASTY_TIMESTAMP_FILE%"
goto :eof

:compile_java
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\javac_opts.txt"
set "__CPATH=%_LIBS_CPATH%%_CLASSES_DIR%"
echo -classpath "%__CPATH:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\javac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f %%f in ('dir /s /b "%_SOURCE_DIR%\main\java\*.java" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Java source files 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Java source file
) else ( set __N_FILES=%__N% Java source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_JAVAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_scala
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\scalac_opts.txt"
set "__CPATH=%_LIBS_CPATH%%_CLASSES_DIR%"
echo %_SCALAC_OPTS% -classpath "%__CPATH:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f %%f in ('dir /s /b "%_MAIN_SOURCE_DIR%\*.scala" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala source files 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala source file
) else ( set __N_FILES=%__N% Scala source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_tasty
set "__OPTS_FILE=%_TARGET_DIR%\tasty_scalac_opts.txt"
set "__CPATH=%_CLASSES_DIR%"
echo -from-tasty -classpath "%__CPATH:\=\\%" -d "%_TASTY_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\tasty_scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f %%f in ('dir /s /b "%_CLASSES_DIR%\*.tasty" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N% TASTy files to directory "!_TASTY_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not !ERRORLEVEL!==0 (
    echo %_ERROR_LABEL% Compilation of %__N% TASTy files failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set "__PATH=%~1"
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

@rem input parameter: %1=flag to add Scala 3 libs
@rem output parameter: _LIBS_CPATH
:libs_cpath
set __ADD_SCALA3_LIBS=%~1

for /f "delims=" %%f in ("%~dp0\.") do set "__BATCH_FILE=%%~dpfcpath.bat"
if not exist "%__BATCH_FILE%" (
    echo %_ERROR_LABEL% Batch file "%__BATCH_FILE%" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%__BATCH_FILE%" %_DEBUG% 1>&2
call "%__BATCH_FILE%" %_DEBUG%
set "_LIBS_CPATH=%_CPATH%"

if defined __ADD_SCALA3_LIBS (
    if not defined SCALA3_HOME (
        echo %_ERROR_LABEL% Variable SCALA3_HOME not defined 1>&2
        set _EXITCODE=1
        goto :eof
    )
    for /f "delims=" %%f in ("%SCALA3_HOME%\lib\*.jar") do (
        set "_LIBS_CPATH=!_LIBS_CPATH!%%f;"
    )
)
goto :eof

@rem output parameter: _EXTRA_CPATH
:extra_cpath
set "__LIB_PATH=%SCALA3_HOME%\lib"
set _EXTRA_CPATH=
for %%f in (%__LIB_PATH%\*.jar) do set "_EXTRA_CPATH=!_EXTRA_CPATH!%%f;"
goto :eof

@rem output parameters: _VERSION_STRING, _VERSION_SUFFIX
:version_string
for /f "tokens=1-3,4,*" %%i in ('"%_SCALAC_CMD%" -version 2^>^&1') do (
    set "_VERSION_STRING=scala3_%%l"
)
@rem keep only "-NIGHTLY" in version suffix when compiling with a nightly build
for /f "usebackq" %%i in (`powershell -c "$s='%_VERSION_STRING%';$i=$s.indexOf('NIGHTLY',0);$j=$s.indexOf('SNAPSHOT');if($i -gt 0){$s.substring(0, $i+7)}elseif($j -gt 0){$s.substring(0, $j+8)}else{$s}"`) do (
    set _VERSION_SUFFIX=_%%i
)
goto :eof

:decompile
set "__OUTPUT_DIR=%_TARGET_DIR%\cfr-sources"
if not exist "%__OUTPUT_DIR%" mkdir "%__OUTPUT_DIR%"

call :extra_cpath
if not %_EXITCODE%==0 goto :eof

set __CFR_OPTS=--extraclasspath "%_EXTRA_CPATH%" --outputdir "%__OUTPUT_DIR%"

if exist "%_CLASSES_DIR%\*.class" ( set "__CLASS_DIRS=%_CLASSES_DIR%"
) else ( set __CLASS_DIRS=
)
for /f "delims=" %%f in ('dir /b /s /ad "%_CLASSES_DIR%" 2^>NUL') do (
    if exist "%%f\*.class" set __CLASS_DIRS=!__CLASS_DIRS! "%%f"
)
if %_VERBOSE%==1 echo Decompile Java bytecode to directory "!__OUTPUT_DIR:%_ROOT_DIR%=!" 1>&2
for %%i in (%__CLASS_DIRS%) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_CFR_CMD%" %__CFR_OPTS% "%%i\*.class" 1>&2
    call "%_CFR_CMD%" %__CFR_OPTS% "%%i"\*.class %_STDERR_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to decompile generated code in directory "%%i" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
call :version_string
if not %_EXITCODE%==0 goto :eof

@rem output file contains Scala and CFR headers
set "__OUTPUT_FILE=%_TARGET_DIR%\cfr-sources%_VERSION_SUFFIX%.java"
echo // Compiled with %_VERSION_STRING% > "%__OUTPUT_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% type "%__OUTPUT_DIR%\*.java" ^>^> "%__OUTPUT_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Save generated Java source files to file "!__OUTPUT_FILE:%_ROOT_DIR%=!" 1>&2
)
set __JAVA_FILES=
for /f "delims=" %%f in ('dir /b /s "%__OUTPUT_DIR%\*.java" 2^>NUL') do (
    set __JAVA_FILES=!__JAVA_FILES! "%%f"
)
if defined __JAVA_FILES type %__JAVA_FILES% >> "%__OUTPUT_FILE%" 2>NUL

if not defined _DIFF_CMD (
    if %_DEBUG%==1 ( echo %_WARNING_LABEL% diff command not found 1>&2
    ) else if %_VERBOSE%==1 ( echo diff command not found 1>&2
    )
    goto :eof
)
set __DIFF_OPTS=--strip-trailing-cr

set "__CHECK_FILE=%_SOURCE_DIR%\build\cfr-sources%_VERSION_SUFFIX%.java"
if exist "%__CHECK_FILE%" (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_DIFF_CMD%" %__DIFF_OPTS% "%__OUTPUT_FILE%" "%__CHECK_FILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Compare output file with check file "!__CHECK_FILE:%_ROOT_DIR%=!" 1>&2
    )
    call "%_DIFF_CMD%" %__DIFF_OPTS% "%__OUTPUT_FILE%" "%__CHECK_FILE%"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Output file and check file differ 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:doc
if not exist "%_TARGET_DOCS_DIR%" mkdir "%_TARGET_DOCS_DIR%" 1>NUL

set "__DOC_TIMESTAMP_FILE=%_TARGET_DOCS_DIR%\.latest-build"

call :action_required "%__DOC_TIMESTAMP_FILE%" "%_CLASSES_DIR%\*.tasty"
if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\scaladoc_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
for /f %%i in ('dir /s /b "%_CLASSES_DIR%\*.tasty" 2^>NUL') do (
    echo %%i>> "%__SOURCES_FILE%"
)
set "__OPTS_FILE=%_TARGET_DIR%\scaladoc_opts.txt"
echo -siteroot "%_TARGET_DOCS_DIR%" -d "%_TARGET_DOCS_DIR%" -project "%_PROJECT_NAME%" -project-version "%_PROJECT_VERSION%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML documentation into directory "!_TARGET_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Generation of HTML documentation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% HTML documentation saved into directory "%_TARGET_DOCS_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo HTML documentation saved into directory "!_TARGET_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
)
echo. > "%__DOC_TIMESTAMP_FILE%"
goto :eof

:run
set "__MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class"
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Main class '%_MAIN_CLASS%' not found ^(%__MAIN_CLASS_FILE%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set __SCALA_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class "%_MAIN_CLASS%" 1>&2
)
call "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute Scala main clas "%_MAIN_CLASS%" 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_TASTY%==1 (
    call :run_tasty
    if not !_EXITCODE!==0 goto :eof
)
goto :eof

:run_tasty
if not exist "%_TASTY_CLASSES_DIR%" (
    echo %_WARNING_LABEL% TASTy output directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem we append _CLASSES_DIR to also include classes generated from Java source files
set __SCALA_OPTS=-classpath "%_LIBS_CPATH%%_TASTY_CLASSES_DIR%;%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% ^(compiled from TASTy^) 1>&2
)
call "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not !ERRORLEVEL!==0 (
    echo %_ERROR_LABEL% Program execution failed ^(%_MAIN_CLASS%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test
call :test_compile
if not %_EXITCODE%==0 goto :eof

call :libs_cpath includeScalaLibs
if not %_EXITCODE%==0 goto :eof

set __TEST_JAVA_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"

@rem see https://github.com/junit-team/junit4/wiki/Getting-started
set __N=0
set __FAILED=0
for /f "usebackq" %%f in (`dir /s /b "%_TEST_CLASSES_DIR%\*JUnitTest.class" 2^>NUL`) do (
    for %%i in (%%~dpf) do set __PKG_NAME=%%i
    set __PKG_NAME=!__PKG_NAME:%_TEST_CLASSES_DIR%\=!
    if defined __PKG_NAME ( set "__MAIN_CLASS=!__PKG_NAME:\=.!%%~nf"
    ) else ( set "__MAIN_CLASS=%%~nf"
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__TEST_JAVA_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS! 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute test class "!__MAIN_CLASS!" 1>&2
    )
    call "%_JAVA_CMD%" %__TEST_JAVA_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS! %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
        set /a __FAILED+=1
        @rem goto :eof
    )
    set /a __N+=1
)
set /a __ECHO_MSG=%_VERBOSE%+%_DEBUG%
if %__ECHO_MSG%==0 goto :eof
if %__N%==0 ( echo %_WARNING_LABEL% No test found 1>&2
) else if %__N%==1 ( echo %__FAILED% of 1 test failed
) else ( echo %__FAILED% of %__N% tests failed
)
goto :eof

:test_compile
if not exist "%_TEST_CLASSES_DIR%" mkdir "%_TEST_CLASSES_DIR%" 1>NUL

set "__TEST_TIMESTAMP_FILE=%_TEST_CLASSES_DIR%\.latest-build"

call :action_required "%__TEST_TIMESTAMP_FILE%" "%_SOURCE_DIR%\test\scala\*.scala"
if %_ACTION_REQUIRED%==0 goto :eof

call :test_compile_scala
if not %_EXITCODE%==0 goto :eof

echo. > "%__TEST_TIMESTAMP_FILE%"
goto :eof

:test_compile_scala
set "__SOURCES_FILE=%_TARGET_DIR%\scalac_test_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\test\scala\*.scala" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala test source files 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala test source file
) else ( set __N_FILES=%__N% Scala test source files
)
call :libs_cpath includeScalaLibs
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\scalac_test_opts.txt"
set "__CPATH=%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"
echo %_SCALAC_OPTS% -classpath "%__CPATH:\=\\%" -d "%_TEST_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_TEST_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_TEST_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

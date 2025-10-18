@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :props
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
    call :run%_INSTRUMENTED%
    if not !_EXITCODE!==0 goto end
)
if %_TEST%==1 (
    call :test
    if not !_EXITCODE!==0 goto end
)
if %_HILITE_ME%==1 (
    call :hilite_me
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
set _TIMER=0

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_SOURCE_MAIN_DIR=%_SOURCE_DIR%\main\scala"
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

if not exist "%SCALA_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala 2 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SCALA2=%SCALA_HOME%\bin\scala.bat"
set "_SCALAC2=%SCALA_HOME%\bin\scalac.bat"
set "_SCALADOC2=%SCALA_HOME%\bin\scaladoc.bat"

if not exist "%SCALA3_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala 3 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SCALA3=%SCALA3_HOME%\bin\scala.bat"
set "_SCALAC3=%SCALA3_HOME%\bin\scalac.bat"
set "_SCALADOC3=%SCALA3_HOME%\bin\scaladoc.bat"

set _SCALA_CLI_CMD=
if defined SCALA_CLI_HOME if exist "%SCALA_CLI_HOME%\scala-cli.exe" (
    set "_SCALA_CLI_CMD=%SCALA_CLI_HOME%\scala-cli.exe"
)
set _SCALAFMT_CMD=
if exist "%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat" (
    set "_SCALAFMT_CMD=%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat"
)
set _SCALAFMT_CONFIG_FILE=
for %%f in ("%~dp0\.") do set "_SCALAFMT_CONFIG_FILE=%%~dpf.scalafmt.conf"

set _CFR_CMD=
if defined CFR_HOME if exist "%CFR_HOME%\bin\cfr.bat" (
    set "_CFR_CMD=%CFR_HOME%\bin\cfr.bat"
)
set _DIFF_CMD=
if exist "%GIT_HOME%\usr\bin\diff.exe" (
    set "_DIFF_CMD=%GIT_HOME%\usr\bin\diff.exe" 
)
@rem use newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

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

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
set _RESET=[0m
goto :eof

@rem output parameters: _MAIN_CLASS_DEFAULT, _MAIN_ARGS_DEFAULT
@rem                    _PROJECT_NAME, _PROJECT_URL, _PROJECT_VERSION
:props
set _MAIN_CLASS_DEFAULT=myexamples.Main
set _MAIN_ARGS_DEFAULT=

for %%i in ("%~dp0\.") do set "_PROJECT_NAME=%%~ni"
set _PROJECT_URL=github.com/%USERNAME%/dotty-examples
set _PROJECT_VERSION=1.0-SNAPSHOT

set "__PROPS_FILE=%_ROOT_DIR%project\build.properties"
if exist "%__PROPS_FILE%" (
    for /f "tokens=1,* delims==" %%i in (%__PROPS_FILE%) do (
        set __NAME=
        set __VALUE=
        for /f "delims= " %%n in ("%%i") do set __NAME=%%n
        @rem line comments start with "#"
        if defined __NAME if not "!__NAME:~0,1!"=="#" (
            @rem trim value
            for /f "tokens=*" %%v in ("%%~j") do set __VALUE=%%v
            set "_!__NAME:.=_!=!__VALUE!"
        )
    )
    if defined _main_class set _MAIN_CLASS_DEFAULT=!_main_class!
    if defined _main_args set _MAIN_ARGS_DEFAULT=!_main_args!
    if defined _project_name set _PROJECT_NAME=!_project_name!
    if defined _project_url set _PROJECT_URL=!_project_url!
    if defined _project_version set _PROJECT_VERSION=!_project_version!
)
goto :eof

@rem input parameter: %*
:args
set _CLEAN=0
set _COMPILE=0
set _DECOMPILE=0
set _DOC=0
set _HELP=0
set _HILITE_ME=0
set _INSTRUMENTED=
set _LANGUAGE=scala
set _LINT=0
set _MAIN_CLASS=%_MAIN_CLASS_DEFAULT%
set _MAIN_ARGS=%_MAIN_ARGS_DEFAULT%
set _RUN=0
set _SCALA_VERSION=3
set _SCALAC_OPTS=-deprecation -feature
set _SCALAC_OPTS_EXPLAIN=0
set _SCALAC_OPTS_EXPLAIN_TYPES=0
set _SCALAC_OPTS_PRINT=0
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
    if "%__ARG%"=="-cli" ( set _SCALA_CLI=_cli
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-explain" ( set _SCALAC_OPTS_EXPLAIN=1
    ) else if "%__ARG%"=="-explain-types" ( set _SCALAC_OPTS_EXPLAIN_TYPES=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-print" ( set _SCALAC_OPTS_PRINT=1
    ) else if "%__ARG%"=="-scala2" ( set _LANGUAGE=scala& set _SCALA_VERSION=2
    ) else if "%__ARG%"=="-scala3" ( set _LANGUAGE=scala& set _SCALA_VERSION=3
    ) else if "%__ARG%"=="-tasty" ( set _TASTY=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else if "%__ARG:~0,6%"=="-main:" (
        call :set_main "!__ARG:~6!"
        if not !_EXITCODE!== 0 goto args_done
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="decompile" ( set _COMPILE=1& set _DECOMPILE=1
    ) else if "%__ARG%"=="doc" ( set _COMPILE=1& set _DOC=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="hilite" ( set _HILITE_ME=1
    ) else if "%__ARG%"=="lint" ( set _LINT=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if "%__ARG%"=="run:i" ( set _COMPILE=1& set _RUN=1& set _INSTRUMENTED=_instrumented
    ) else if "%__ARG%"=="test" ( set _COMPILE=1& set _TEST=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
set _STDERR_REDIRECT=2^>NUL
if %_DEBUG%==1 set _STDERR_REDIRECT=

if %_COMPILE%==1 if %_SCALA_VERSION%==2 if exist "%_SOURCE_DIR%\main\scala2" (
    @rem overwrite main source directory if Scala 2/3 sources differ 
    set "_SOURCE_MAIN_DIR=%_SOURCE_DIR%\main\scala2"
)
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
if defined _INSTRUMENTED if not exist "%JACOCO_HOME%\lib\jacococli.jar" (
    echo %_WARNING_LABEL% JaCoCo installation not found 1>&2
    set _INSTRUMENTED=
)
set "_SCALA_CMD=!_SCALA%_SCALA_VERSION%!"
set "_SCALAC_CMD=!_SCALAC%_SCALA_VERSION%!"
set "_SCALADOC_CMD=!_SCALADOC%_SCALA_VERSION%!"

if %_SCALAC_OPTS_EXPLAIN%==1 set _SCALAC_OPTS=%_SCALAC_OPTS% -explain
if %_SCALAC_OPTS_EXPLAIN_TYPES%==1 (
    if %_SCALA_VERSION%==3 ( set _SCALAC_OPTS=%_SCALAC_OPTS% -explain-types
    ) else ( set _SCALAC_OPTS=%_SCALAC_OPTS% -explaintypes
    )
)
if %_SCALAC_OPTS_PRINT%==1 (
    if %_SCALA_VERSION%==3 ( set _SCALAC_OPTS=%_SCALAC_OPTS% -pagewidth 128 -color never -Xprint:lambdaLift
    ) else ( set _SCALAC_OPTS=%_SCALAC_OPTS% -print
    )
)
if %_TASTY%==1 if not %_SCALA_VERSION%==3 (
    echo %_WARNING_LABEL% Option '-tasty' only supported by Scala 3 1>&2
    set _TASTY=0
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Properties : _PROJECT_NAME=%_PROJECT_NAME% _PROJECT_VERSION=%_PROJECT_VERSION% 1>&2
    echo %_DEBUG_LABEL% Options    : _EXPLAIN=%_SCALAC_OPTS_EXPLAIN% _INSTRUMENTED=%_INSTRUMENTED% _PRINT=%_SCALAC_OPTS_PRINT% _SCALA_VERSION=%_SCALA_VERSION% _TASTY=%_TASTY% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DECOMPILE=%_DECOMPILE% _DOC=%_DOC% _LINT=%_LINT% _RUN=%_RUN% _TEST=%_TEST% 1>&2
    if defined _CFR_CMD echo %_DEBUG_LABEL% Variables  : "CFR_HOME=%CFR_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "JAVA_HOME=%JAVA_HOME%" 1>&2
    if defined _SCALA_CLI_CMD echo %_DEBUG_LABEL% Variables  : "SCALA_CLI_HOME=%SCALA_CLI_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "SCALA_HOME=%SCALA_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "SCALA3_HOME=%SCALA3_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _MAIN_CLASS=%_MAIN_CLASS% _MAIN_ARGS=%_MAIN_ARGS% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('call "%_PWSH_CMD%" -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-explain%__END%         set compiler option %__BEG_O%-explain%__END%
echo     %__BEG_O%-explain-types%__END%   set compiler option %__BEG_O%-explain-types%__END%
echo     %__BEG_O%-main:^<name^>%__END%     define main class name ^(default: %__BEG_O%%_MAIN_CLASS_DEFAULT%%__END%^)
echo     %__BEG_O%-print%__END%           print IR after compilation phase 'lambdaLift'
echo     %__BEG_O%-scala2%__END%          use Scala 2 tools
echo     %__BEG_O%-scala3%__END%          use Scala 3 tools ^(default^)
echo     %__BEG_O%-tasty%__END%           compile both from source and TASTy files
echo     %__BEG_O%-timer%__END%           print total execution time
echo     %__BEG_O%-verbose%__END%         print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%            delete generated files
echo     %__BEG_O%compile%__END%          compile Java/Scala source files
echo     %__BEG_O%decompile%__END%        decompile generated code with %__BEG_N%CFR%__END%
echo     %__BEG_O%doc%__END%              generate HTML documentation
echo     %__BEG_O%help%__END%             print this help message
echo     %__BEG_O%hilite%__END%           generate formatted HTML code snippets
echo     %__BEG_O%lint%__END%             analyze Scala source files with %__BEG_N%Scalafmt%__END%
echo     %__BEG_O%run[:i]%__END%          execute main class ^(instrumented execution: %__BEG_O%:i%__END%^)
echo     %__BEG_O%test%__END%             execute unit tests with %__BEG_N%JUnit%__END%
echo.
echo   %__BEG_P%Properties:%__END%
echo   ^(to be defined in SBT configuration file %__BEG_O%project\build.properties%__END%^)
echo     %__BEG_O%main.class%__END%       alternative to option %__BEG_O%-main%__END%
echo     %__BEG_O%main.args%__END%        list of arguments to be passed to main class "%_MAIN_CLASS%"
if %_VERBOSE%==0 goto :eof
echo.
echo   %__BEG_P%Build tools:%__END%
echo     %__BEG_O%^> build clean run%__END%
echo     %__BEG_O%^> gradle -quiet clean run%__END%
echo     %__BEG_O%^> mvn -quiet clean compile exec:java%__END%
goto :eof

@rem output parameter: _MAIN_CLASS
:set_main
set __ARG=%~1
set __VALID=0
for /f %%i in ('call "%_PWSH_CMD%" -C "$s='%__ARG%'; if($s -match '^[\w$]+(\.[\w$]+)*$'){1}else{0}"') do set __VALID=%%i
@rem if %_DEBUG%==1 echo %_DEBUG_LABEL% __ARG=%__ARG% __VALID=%__VALID% 1>&2
if %__VALID%==0 (
    echo %_ERROR_LABEL% Invalid class name passed to option "-main" ^(%__ARG%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _MAIN_CLASS=%__ARG%
goto :eof

:clean
if defined _SCALA_CLI (
    call :clean_cli
    goto :eof
)
call :rmdir "%_ROOT_DIR%project\target"
call :rmdir "%_TARGET_DIR%"
@rem mill -> out\, sbt -> project\target\
call :rmdir "%_ROOT_DIR%out"
call :rmdir "%_ROOT_DIR%project\target"
if exist "%_ROOT_DIR%hotspot_pid*.log" del /q "%_ROOT_DIR%hotspot_pid*.log"
@rem https://romanowski.github.io/scala-cli/docs/guides/internals/#scala-build-directory
for /f "delims=" %%f in ('dir /ad /b /s "%_SOURCE_DIR%" ^| findstr /e ".scala-build" 2^>NUL') do (
    call :rmdir "%%f"
)
goto :eof

:clean_cli
set __CLI_OPTS=
if %_DEBUG%==1 ( set __CLI_OPTS=-v %__SCALA_CLI_OPTS%
) else if %_VERBOSE%==1 ( set __CLI_OPTS=-v %__SCALA_CLI_OPTS%
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CLI_CMD%" clean %__CLI_OPTS% "%_SOURCE_MAIN_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Clean project 1>&2
)
call "%_SCALA_CLI_CMD%" clean %__CLI_OPTS% "%_SOURCE_MAIN_DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to clean project 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:lint
set __SCALAFMT_OPTS=--test --config "%_SCALAFMT_CONFIG_FILE%"
if %_DEBUG%==1 set __SCALAFMT_OPTS=--debug %__SCALAFMT_OPTS%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAFMT_CMD%" %__SCALAFMT_OPTS% "%_SOURCE_MAIN_DIR%\" 1>&2
) else if %_VERBOSE%==1 ( echo Analyze Scala source files with Scalafmt 1>&2
)
call "%_SCALAFMT_CMD%" %__SCALAFMT_OPTS% "%_SOURCE_MAIN_DIR%\"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to analyze Scala source files with Scalafmt 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
if defined _SCALA_CLI (
    call :compile_cli
    goto :eof
)
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%" 1>NUL

set "__TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\java\*.java"
if %_ACTION_REQUIRED%==1 (
    call :compile_java
    if not !_EXITCODE!==0 goto :eof
)
call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_MAIN_DIR%\*.scala"
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

:compile_cli
if %_SCALA_VERSION%==2 ( set __CLI_OPTS=--scala 2.13
) else ( set __CLI_OPTS=--scala 3
)
set __CLI_OPTS=-O -deprecation %__CLI_OPTS%
if %_DEBUG%==1 ( set __CLI_OPTS=-v %__CLI_OPTS%
) else if %_VERBOSE%==1 ( set __CLI_OPTS=-v %__CLI_OPTS%
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CLI_CMD%" compile %__CLI_OPTS% "%_SOURCE_MAIN_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile Scala source files in directory "!_SOURCE_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALA_CLI_CMD%" compile %__CLI_OPTS% "%_SOURCE_MAIN_DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile Scala source files in directory "!_SOURCE_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_java
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\javac_opts.txt"
set "__CPATH=%_LIBS_CPATH%%_CLASSES_DIR%"
echo -deprecation -classpath "%__CPATH:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\javac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('dir /s /b "%_SOURCE_DIR%\main\java\*.java" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Java source file found 1>&2
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
@rem call :libs_cpath
@rem if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\scalac_opts.txt"
set "__CPATH=%_CLASSES_DIR%"
echo %_SCALAC_OPTS% -classpath "%__CPATH:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('dir /s /b "%_SOURCE_MAIN_DIR%\*.scala" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala source file
) else ( set __N_FILES=%__N% Scala source files
)
set __PRINT_FILE_REDIRECT=
if %_SCALAC_OPTS_PRINT%==1 (
    call :version_string
    if not !_EXITCODE!==0 goto :eof
    set "__PRINT_FILE=%_TARGET_DIR%\scalac-print!_VERSION_SUFFIX!.scala"
    if %_SCALA_VERSION%==3 ( set __PRINT_FILE_REDIRECT=2^> "!__PRINT_FILE!"
    ) else ( set __PRINT_FILE_REDIRECT=1^> "!__PRINT_FILE!"
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" %__PRINT_FILE_REDIRECT%
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
for /f "delims=" %%f in ('dir /s /b "%_CLASSES_DIR%\*.tasty" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No TASTy file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% TASTy file
) else ( set __N_FILES=%__N% TASTy files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_TASTY_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_TASTY_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
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
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : "%__TARGET_FILE%" 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^("%__PATH_ARRAY1:~1%"^) 1>&2
)
goto :eof

@rem input parameters: %1=file timestamp 1, %2=file timestamp 2
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
    for /f "delims=" %%f in ('dir /s /b "%SCALA3_HOME%\lib\*.jar"') do (
        set "_LIBS_CPATH=!_LIBS_CPATH!%%f;"
    )
)
goto :eof

@rem output parameter: _EXTRA_CPATH
:extra_cpath
if %_SCALA_VERSION%==3 ( set "__LIB_PATH=%SCALA3_HOME%\lib"
) else ( set "__LIB_PATH=%SCALA_HOME%\lib"
)
set _EXTRA_CPATH=
for /f "delims=" %%f in ("%__LIB_PATH%\compiler*.jar" "%__LIB_PATH%\scala*.jar" "%__LIB_PATH%\tasty*.jar") do (
    set "_EXTRA_CPATH=!_EXTRA_CPATH!%%f;"
)
goto :eof

@rem output parameters: _VERSION_STRING, _VERSION_SUFFIX
:version_string
for /f "tokens=1-3,4,*" %%i in ('"%_SCALAC_CMD%" -version 2^>^&1') do (
    set "_VERSION_STRING=scala%_SCALA_VERSION%_%%l"
)
@rem keep only "-NIGHTLY" in version suffix when compiling with a nightly build 
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "$s='%_VERSION_STRING%';$i=$s.indexOf('NIGHTLY',0);$j=$s.indexOf('SNAPSHOT');if($i -gt 0){$s.substring(0, $i+7)}elseif($j -gt 0){$s.substring(0, $j+8)}else{$s}"`) do (
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
for /f "delims=" %%i in ('dir /s /b "%_CLASSES_DIR%\*.tasty" 2^>NUL') do (
    echo %%i>> "%__SOURCES_FILE%"
)
set "__OPTS_FILE=%_TARGET_DIR%\scaladoc_opts.txt"
if %_SCALA_VERSION%==2 (
    echo -d "%_TARGET_DOCS_DIR%" -doc-title "%_PROJECT_NAME%" -doc-footer "%_PROJECT_URL%" -doc-version "%_PROJECT_VERSION%" > "%__OPTS_FILE%"
) else (
    echo -d "%_TARGET_DOCS_DIR%" -project "%_PROJECT_NAME%" -project-version "%_PROJECT_VERSION%" > "%__OPTS_FILE%"
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML documentation into directory "!_TARGET_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate HTML documentation into directory "!_TARGET_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% HTML documentation saved into directory "%_TARGET_DOCS_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo HTML documentation saved into directory "!_TARGET_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
)
echo. > "%__DOC_TIMESTAMP_FILE%"
goto :eof

:run
if defined _SCALA_CLI (
    call :run_cli
    goto :eof
)
call :run_common
goto :eof

:run_cli
if %_SCALA_VERSION%==2 ( set __CLI_OPTS=--scala 2.13
) else ( set __CLI_OPTS=--scala 3
)
set __CLI_OPTS=%__CLI_OPTS% --main-class "%_MAIN_CLASS%"
if %_DEBUG%==1 ( set __CLI_OPTS=-v %__CLI_OPTS%
) else if %_VERBOSE%==1 ( set __CLI_OPTS=-v %__CLI_OPTS%
)
set __MAIN_ARGS=-- 1

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CLI_CMD%" run %__CLI_OPTS% "%_SOURCE_MAIN_DIR%" %__MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class "%_MAIN_CLASS%" 1>&2
)
call "%_SCALA_CLI_CMD%" run %__CLI_OPTS% "%_SOURCE_MAIN_DIR%" %__MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute Scala main class "%_MAIN_CLASS%" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run_common
set "__MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class"
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Main class '%_MAIN_CLASS%' not found ^("%__MAIN_CLASS_FILE%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem call :libs_cpath
@rem if not %_EXITCODE%==0 goto :eof

set __SCALA_OPTS=-classpath "%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class "%_MAIN_CLASS%" 1>&2
)
call "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute Scala main class "%_MAIN_CLASS%" 1>&2
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
set __SCALA_OPTS=-classpath "%_LIBS_CPATH%%_TASTY_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class "%_MAIN_CLASS%" ^(compiled from TASTy^) 1>&2
)
call "%_SCALA_CMD%" %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute Scala main class "%_MAIN_CLASS%" ^(compiled from TASTy^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem experimental (see https://www.jacoco.org/jacoco/trunk/doc/agent.html)
:run_instrumented
set "__MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class"
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Main class '%_MAIN_CLASS%' not found ^(%__MAIN_CLASS_FILE%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__JACOCO_AGENT_FILE=%JACOCO_HOME%\lib\jacocoagent.jar"
set "__JACOCO_CLI_FILE=%JACOCO_HOME%\lib\jacococli.jar"
if not exist "%__JACOCO_AGENT_FILE%" (
    echo %_ERROR_LABEL% JaCoCo agent library not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __CLASS_FILES=
for /f "delims=" %%f in ('dir /s /b "%_CLASSES_DIR%\*.class" 2^>NUL') do (
    set __CLASS_FILES=!__CLASS_FILES! "%%f"
)
for /f "delims=" %%f in ("%_CLASSES_DIR%\.") do set "__INSTR_CLASSES_DIR=%%~dpfinstrumented-classes"
if not exist "!__INSTR_CLASSES_DIR!" mkdir "!__INSTR_CLASSES_DIR!"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" -jar "!__JACOCO_CLI_FILE!" instrument --quiet --dest "!__INSTR_CLASSES_DIR!" %__CLASS_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Instrument Java class files 1>&2
)
call "%_JAVA_CMD%" -jar "!__JACOCO_CLI_FILE!" instrument --quiet --dest "!__INSTR_CLASSES_DIR!" %__CLASS_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to instrument Java class files 1>&2
    set _EXITCODE=1
    goto :eof
)
set __LIBS_CPATH=
for /f "delims=" %%f in ("%SCALA3_HOME%\lib\*.jar") do (
    set "__JAR_FILE=%%~nxf"
    if "!__JAR_FILE:~0,5!"=="dotty" ( set "__LIBS_CPATH=!__LIBS_CPATH!%%f;"
    ) else if "!__JAR_FILE:~0,5!"=="tasty" ( set "__LIBS_CPATH=!__LIBS_CPATH!%%f;"
    ) else if "!__JAR_FILE:~0,5!"=="scala" ( set "__LIBS_CPATH=!__LIBS_CPATH!%%f;"
    )
)
set "__EXEC_FILE=%_TARGET_DIR%\jacoco.exec"
set __JAVA_OPTS=-Xmx768m -Xms768m -javaagent:"%__JACOCO_AGENT_FILE%=destfile=!__EXEC_FILE!,append=false" -classpath "%__LIBS_CPATH%%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__JAVA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class "%_MAIN_CLASS%" 1>&2
)
call "%_JAVA_CMD%" %__JAVA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute Scala main class "%_MAIN_CLASS%" 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__TARGET_HTML_DIR=%_TARGET_DIR%\instrumented-html"
if not exist "%__TARGET_HTML_DIR%\" mkdir "%__TARGET_HTML_DIR%" 1>NUL

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" -jar "!__JACOCO_CLI_FILE!" report "%__EXEC_FILE%" --classfiles "%_CLASSES_DIR%" --encoding UTF8 --html "%__TARGET_HTML_DIR%" --name "%_PROJECT_NAME%" --quiet --sourcefiles "%_SOURCE_MAIN_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML report in directory "!__TARGET_HTML_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_JAVA_CMD%" -jar "!__JACOCO_CLI_FILE!" report "%__EXEC_FILE%" --classfiles "%_CLASSES_DIR%" --encoding UTF8 --html "%__TARGET_HTML_DIR%" --name "%_PROJECT_NAME%" --quiet --sourcefiles "%_SOURCE_MAIN_DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% JaCoCo instrumentation report saved into file "%__TARGET_HTML_DIR%\index.html" 1>&2
) else if %_VERBOSE%==1 (
    echo JaCoCo instrumentation report saved into file "!__TARGET_HTML_DIR:%_ROOT_DIR%=!\index.html" 1>&2
)
goto :eof

:compile_test
if not exist "%_TEST_CLASSES_DIR%" mkdir "%_TEST_CLASSES_DIR%" 1>NUL

set "__TEST_TIMESTAMP_FILE=%_TEST_CLASSES_DIR%\.latest-build"

call :action_required "%__TEST_TIMESTAMP_FILE%" "%_SOURCE_DIR%\test\scala\*.scala"
if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\test_scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%i in ('dir /s /b "%_SOURCE_DIR%\test\scala\*.scala" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala test source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala test source file
) else ( set __N_FILES=%__N% Scala test source files
)
call :libs_cpath includeScalaLibs
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\test_scalac_opts.txt"
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
echo. > "%__TEST_TIMESTAMP_FILE%"
goto :eof

:test
call :compile_test
if not %_EXITCODE%==0 goto :eof

call :libs_cpath includeScalaLibs
if not %_EXITCODE%==0 goto :eof

set __TEST_JAVA_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"

@rem see https://github.com/junit-team/junit4/wiki/Getting-started
for /f "usebackq" %%f in (`dir /s /b "%_TEST_CLASSES_DIR%\*JUnitTest.class" 2^>NUL`) do (
    for %%i in (%%~dpf) do set __PKG_NAME=%%i
    set __PKG_NAME=!__PKG_NAME:%_TEST_CLASSES_DIR%\=!
    if defined __PKG_NAME ( set "__MAIN_CLASS=!__PKG_NAME:\=.!%%~nf"
    ) else ( set "__MAIN_CLASS=%%~nf"
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__TEST_JAVA_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS! 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute test "!__MAIN_CLASS!" 1>&2
    )
    call "%_JAVA_CMD%" %__TEST_JAVA_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS!
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to execute test "!__MAIN_CLASS!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:hilite_me
if not exist "%_TARGET_DIR%\html" mkdir "%_TARGET_DIR%\html"
@rem # hilite.me API documentation
@rem 
@rem GET or POST to http://hilite.me/api with these parameters:
@rem 
@rem * code: source code to format
@rem * lexer: [lexer](http://pygments.org/docs/lexers/) to use, default it 'python'
@rem * options: optional comma-separated list of lexer options
@rem * style: [style](http://pygments.org/docs/styles/) to use, default is 'colorful'
@rem * linenos: if not empty, the HTML will include line numbers
@rem * divstyles: CSS style to use in the wrapping <div> element, can be empty
@rem 
@rem The request will return the HTML code in UTF-8 encoding.
set __URI=http://hilite.me/api
set __LEXER=scala
set __N=0
for /f "delims=" %%i in ('dir /s /b "%_SOURCE_DIR%\main\scala\*.scala" 2^>NUL') do (
    set "__SOURCE_FILE=%%i" 
    set "__OUT_FILE=%_TARGET_DIR%\html\%%~ni.html"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% call "%_PWSH_CMD%" -c "$progressPreference='silentlyContinue';$code=Get-Content -Encoding UTF8 -Raw "!__SOURCE_FILE!";Invoke-WebRequest -Method POST -Uri %__URI% -Body @{code=$code; lexer='%__LEXER%'} -Outfile '!__OUT_FILE!'" 1>&2
    ) else if %_VERBOSE%==1 ( echo Generate pretty-printed HTML code for Scala source file "!__SOURCE_FILE:%_ROOT_DIR%=!" 1>&2
    )
    call "%_PWSH_CMD%" -c "$progressPreference='silentlyContinue';$code=Get-Content -Encoding UTF8 -Raw "!__SOURCE_FILE!";Invoke-WebRequest -Method POST -Uri %__URI% -Body @{code=$code; lexer='%__LEXER%'} -Outfile '!__OUT_FILE!'"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to get response from web request to %_URI% 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set /a __N+=1
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %__N% HTML code snippets saved into directory "%_TARGET_DIR%\html" 1>&2
) else if %_VERBOSE%==1 ( echo %__N% HTML code snippets saved into directory "!_TARGET_DIR:%_ROOT_DIR%=!\html" 1>&2
)
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('call "%_PWSH_CMD%" -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('call "%_PWSH_CMD%" -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

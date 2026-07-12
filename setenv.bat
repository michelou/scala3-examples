@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
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

set _ANT_PATH=
set _BAZEL_PATH=
set _BLOOP_PATH=
set _CLAUDE_PATH=
set _COURSIER_PATH=
set _GIT_PATH=
set _GRADLE_PATH=
set _JMC_PATH=
set _MAVEN_PATH=
set _MILL_PATH=
set _MSYS_PATH=
set _SBT_PATH=
set _SCALA_CLI_PATH=
set _VSCODE_PATH=

if %_USE_CLAUDE%==1 (
    call :claude
    if not !_EXITCODE!==0 (
        @rem optional
        echo %_WARNING_LABEL% Claude not installed 1>&2
        set _EXITCODE=0
    )
)
@rem %1=version, %2=vendor
@rem eg. bellsoft, corretto, bellsoft, openj9, redhat, sapmachine, temurin, zulu
call :java 25 "temurin"
if not %_EXITCODE%==0 goto end

@rem last call to :java defines variable JAVA_HOME
call :java 21 "temurin"
if not %_EXITCODE%==0 goto end

call :scala2
if not %_EXITCODE%==0 goto end

call :scalafmt
if not defined _SCALAFMT_CMD (
    @rem optional
    echo %_WARNING_LABEL% Scalafmt installation not found 1>&2
	echo ^(run Coursier command cs.exe install scalafmt^) 1>&2
    set _EXITCODE=0
)
call :scala3
if not %_EXITCODE%==0 goto end

call :scala3_rc
if not %_EXITCODE%==0 goto end

call :sbt
if not %_EXITCODE%==0 goto end

call :ant
if not %_EXITCODE%==0 goto end

call :bazel
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Bazel installation not found 1>&2
    set _EXITCODE=0
)
@rem bloop depends on python
call :python 3
if not %_EXITCODE%==0 goto end

call :bloop
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Bloop installation not found 1>&2
    set _EXITCODE=0
)
call :cfr
if not %_EXITCODE%==0 goto end

call :coursier
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Coursier installation not found 1>&2
    set _EXITCODE=0
)
call :git
if not %_EXITCODE%==0 goto end

call :gradle
if not %_EXITCODE%==0 goto end

call :jacoco
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% JaCoCo installation not found 1>&2
    set _EXITCODE=0
)
call :javafx
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% JavaFX installation not found 1>&2
    set _EXITCODE=0
)
call :jmc
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Java Mission Control installation not found 1>&2
    set _EXITCODE=0
)
call :maven
if not %_EXITCODE%==0 goto end

call :maven_plugin
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Scala Maven plugin installation not found 1>&2
    set _EXITCODE=0
)
call :mill
if not %_EXITCODE%==0 goto end

call :msys
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% MSYS2 installation not found 1>&2
    set _EXITCODE=0
)
call :msvs
if not %_EXITCODE%==0 goto end

call :scala_cli
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Scala-CLI installation not found 1>&2
    set _EXITCODE=0
)
call :vscode
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% VS Code installation not found 1>&2
    set _EXITCODE=0
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
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

@rem input parameter: %*
@rem output parameters: _BASH, _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _MSYS=0
set _USE_CLAUDE=0
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done
:args_retry
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _MSYS=0& set _BASH=1
    ) else if "%__ARG%"=="-claude" ( set _USE_CLAUDE=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-msys" ( set _BASH=0& set _MSYS=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else if "%__ARG%"=="-verbsoe" (
        echo %_WARNING_LABEL% Unknown option "%__ARG%"; let's assume you meant "-verbose" 1>&2
        set __ARG=-verbose
        goto args_retry
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _BASH=%_BASH% _USE_CLAUDE=%_USE_CLAUDE% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME (2 characters: letter + ':')
:drive_name
set "__GIVEN_PATH=%~1"
@rem remove trailing path separator if present
if "%__GIVEN_PATH:~-1,1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
@rem deprecated since Windows 11
@rem for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
@rem     set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
@rem )
@rem alternative in Windows 11
for /f "delims=" %%i in ('fsutil fsinfo drives') do (
    set "__LINE=%%i"
    set "__DRIVES=!__LINE:Drives:=!"
    set "__DRIVES=!__DRIVES:\=!"
    for %%d in (!__DRIVES!) do (
        set "__DRIVE_NAMES=!__DRIVE_NAMES:%%d=!"
    )
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(fsutil^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    @rem Windows local file systems are not case sensitive (by default)
    if /i "!__SUBST_DRIVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
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
echo     %__BEG_O%-bash%__END%       start Git bash shell instead of Windows command prompt
echo     %__BEG_O%-claude%__END%     add Claude command to the project environment
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-help%__END%       print this help message
echo     %__BEG_O%-msys%__END%       start MSYS2 bash shell instead of Windows command prompt
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        print this help message
goto :eof

@rem output parameters: _CLAUDE_HOME, _CLAUDE_PATH
:claude
set _CLAUDE_HOME=
set _CLAUDE_PATH=

set __CLAUDE_CMD=
for /f "delims=" %%f in ('where claude.exe 2^>NUL') do set "__CLAUDE_CMD=%%f"
if defined __CLAUDE_CMD (
    for /f "delims=" %%i in ("%__CLAUDE_CMD%") do set "__CLAUDE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__CLAUDE_BIN_DIR!\.") do set "_CLAUDE_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Claude executable found in PATH 1>&2
    @rem keep _CLAUDE_PATH undefined since executable already in path
    goto :eof
) else if defined CLAUDE_HOME (
    set "_CLAUDE_HOME=%CLAUDE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CLAUDE_HOME 1>&2
) else (
    if exist "%USERPROFILE%\.local\bin" set "_CLAUDE_HOME=%USERPROFILE%\.local"
    if defined _CLAUDE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Claude installation directory "!_CLAUDE_HOME!" 1>&2
    )
)
if not exist "%_CLAUDE_HOME%\bin\claude.exe" (
    echo %_ERROR_LABEL% Claude executable not found ^("%_CLAUDE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CLAUDE_PATH=;%_CLAUDE_HOME%\bin"
goto :eof

@rem output parameter: _PYTHON_HOME
:python
set _PYTHON_HOME=

set __PYTHON_CMD=
for /f "delims=" %%f in ('where python.exe 2^>NUL') do (
    set "__PYTHON_CMD=%%f"
    @rem we ignore Scoop/Windows managed Python installation
    if not "!__PYTHON_CMD:scoop=!"=="!__PYTHON_CMD!" ( set __PYTHON_CMD=
    ) else if not "!__PYTHON_CMD:WindowsApps=!"=="%__PYTHON_CMD%" ( set __PYTHON_CMD=
    )
)
if defined __PYTHON_CMD (
    for /f "delims=" %%i in ("%__PYTHON_CMD%") do set "_PYTHON_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Python executable found in PATH 1>&2
    goto :eof
) else if defined PYTHON_HOME (
    set "_PYTHON_HOME=%PYTHON_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable PYTHON_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Python\" ( set "_PYTHON_HOME=!__PATH!\Python"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Python-3*" 2^>NUL') do set "_PYTHON_HOME=!__PATH!\%%f"
        if not defined _PYTHON_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Python-3*" 2^>NUL') do set "_PYTHON_HOME=!__PATH!\%%f"
        )
    )
    if defined _PYTHON_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Python installation directory "!_PYTHON_HOME!" 1>&2
    )
)
if not exist "%_PYTHON_HOME%\python.exe" (
    echo %_ERROR_LABEL% Python executable not found ^("%_PYTHON_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _BLOOP_HOME, _BLOOP_PATH
:bloop
set _BLOOP_HOME=
set _BLOOP_PATH=

set __BLOOP_CMD=
for /f "delims=" %%f in ('where bloop.exe 2^>NUL') do set "__BLOOP_CMD=%%f"
if defined __BLOOP_CMD (
    @rem for %%i in ("%__BLOOP_CMD%") do set "__BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("%__BLOOP_CMD%") do set "_BLOOP_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of bloop executable found in PATH 1>&2
    @rem keep _BLOOP_PATH undefined since executable already in path
    goto :eof
) else if defined BLOOP_HOME (
    set "_BLOOP_HOME=%BLOOP_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BLOOP_HOME 1>&2
) else (
    set _PATH=C:\opt
    if exist "!__PATH!\bloop\" ( set "_BLOOP_HOME=!__PATH!\bloop"
    ) else (
       for /f "delims=" %%f in ('dir /ad /b "!_PATH!\bloop*" 2^>NUL') do set "_BLOOP_HOME=!_PATH!\%%f"
    )
    if defined _BLOOP_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Bloop installation directory "!_BLOOP_HOME!" 1>&2
    )
)
if not exist "%_BLOOP_HOME%\bloop.exe" (
    echo %_ERROR_LABEL% bloop executable not found ^("%_BLOOP_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BLOOP_PATH=;%_BLOOP_HOME%"
goto :eof

@rem input parameters:%1=required version %2=vendor 
@rem output parameter: _JAVA_HOME (resp. JAVA11_HOME)
:java
set _JAVA_HOME=

set __VERSION=%~1
set __VENDOR=%~2
if not defined __VENDOR ( set __JDK_NAME=jdk-%__VERSION%
) else ( set __JDK_NAME=jdk-%__VENDOR%-%__VERSION%
)
set __JAVAC_CMD=
for /f "delims=" %%f in ('where javac.exe 2^>NUL') do (
    set "__JAVAC_CMD=%%f"
    @rem we ignore Scoop managed Java installation
    if not "!__JAVAC_CMD:scoop=!"=="!__JAVAC_CMD!" set __JAVAC_CMD=
)
if defined __JAVAC_CMD (
    call :jdk_version "%__JAVAC_CMD%"
    if !_JDK_VERSION!==%__VERSION% (
        for /f "delims=" %%i in ("%__JAVAC_CMD%") do set "__BIN_DIR=%%~dpi"
        for /f "delims=" %%f in ("%__BIN_DIR%") do set "_JAVA_HOME=%%~dpf"
    ) else (
        echo %_ERROR_LABEL% Required JDK installation not found ^("%__JDK_NAME%"^) 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
if defined JAVA_HOME (
    set "_JAVA_HOME=%JAVA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JAVA_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\%__JDK_NAME%*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
    if not defined _JAVA_HOME (
        set "__PATH=%ProgramFiles%\Java"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\%__JDK_NAME%*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
    )
    if defined _JAVA_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Java SDK installation directory "!_JAVA_HOME!" 1>&2
    )
)
if not exist "%_JAVA_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Executable javac.exe not found ^("%_JAVA_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
call :jdk_version "%_JAVA_HOME%\bin\javac.exe"
set "_JAVA!_JDK_VERSION!_HOME=%_JAVA_HOME%"
goto :eof

@rem input parameter: %1=javac file path
@rem output parameter: _JDK_VERSION
:jdk_version
set "__JAVAC_CMD=%~1"
if not exist "%__JAVAC_CMD%" (
    echo %_ERROR_LABEL% Command javac.exe not found ^("%__JAVAC_CMD%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set __JAVAC_VERSION=
for /f "usebackq tokens=1,*" %%i in (`"%__JAVAC_CMD%" -version 2^>^&1`) do set __JAVAC_VERSION=%%j
set "__PREFIX=%__JAVAC_VERSION:~0,2%"
@rem either 1.7, 1.8 or 11..18
if "%__PREFIX%"=="1." ( set _JDK_VERSION=%__JAVAC_VERSION:~2,1%
) else ( set _JDK_VERSION=%__PREFIX%
)
goto :eof

@rem output parameter: SCALA_HOME
:scala2
set _SCALA_HOME=

set __SCALAC_CMD=
for /f "delims=" %%f in ('where scalac.bat 2^>NUL') do (
    set __VERSION=
    for /f "tokens=1,2,3,4,*" %%i in ('scalac.bat -version 2^>^&1') do set "__VERSION=%%l"
    if defined __VERSION if "!__VERSION:~0,1!"=="2" set "__SCALAC_CMD=%%f"
)
if defined __SCALAC_CMD (
    for /f "delims=" %%i in ("%__SCALAC_CMD%") do set "__SCALA_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__SCALA_BIN_DIR!..") do set "_SCALA_HOME=%%f"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Scala 2 executable found in PATH 1>&2
) else if defined SCALA_HOME (
    set "_SCALA_HOME=%SCALA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\scala\" ( set "_SCALA_HOME=!__PATH!\scala"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala-2*" 2^>NUL') do set "_SCALA_HOME=!__PATH!\%%f"
    )
    if defined _SCALA_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala 2 installation directory "!_SCALA_HOME!" 1>&2
    )
)
if not exist "%_SCALA_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala executable not found ^("%_SCALA_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _SCALAFMT_CMD
:scalafmt
set _SCALAFMT_CMD=

@rem Coursier installed software
if exist "%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat" (
    set "_SCALAFMT_CMD=%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat"
)
goto :eof

@rem output parameter: _SCALA3_HOME
:scala3
set _SCALA3_HOME=

set __SCALAC_CMD=
for /f "delims=" %%f in ('where scalac.bat 2^>NUL') do (
    set __VERSION=
    for /f "tokens=1,2,3,4,*" %%i in ('scalac.bat -version 2^>^&1') do set "__VERSION=%%l"
    if defined __VERSION if "!__VERSION:~0,1!"=="3" set "__SCALAC_CMD=%%f"
)
if defined __SCALAC_CMD (
    for /f "delims=" %%i in ("%__SCALAC_CMD%") do set "__SCALA3_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__SCALA3_BIN_DIR!\.") do set "_SCALA3_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Scala 3 executable found in PATH 1>&2
) else if defined SCALA3_HOME (
    set "_SCALA3_HOME=%SCALA3_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA3_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\scala3\" ( set "_SCALA3_HOME=!__PATH!\scala3"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala3-3.3*" 2^>NUL') do set "_SCALA3_HOME=!__PATH!\%%f"
        if not defined _SCALA3_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala3-3.3*" 2^>NUL') do set "_SCALA3_HOME=!__PATH!\%%f"
        )
    )
    if defined _SCALA3_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala 3 installation directory "!_SCALA3_HOME!" 1>&2
    )
)
if not exist "%_SCALA3_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala 3 executable not found ^("%_SCALA3_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _SCALA3_RC_HOME
:scala3_rc
set _SCALA3_RC_HOME=

set __SCALAC_CMD=
for /f "delims=" %%f in ('where scalac.bat 2^>NUL') do (
    set __VERSION=
    for /f "tokens=1,2,3,4,*" %%i in ('scalac.bat -version 2^>^&1') do set "__VERSION=%%l"
    if defined __VERSION if not "!__VERSION:RC=!"=="!__VERSION!" set "__SCALAC_CMD=%%f"
)
if defined __SCALAC_CMD (
    for /f "delims=" %%i in ("%__SCALAC_CMD%") do set "__SCALA3_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__SCALA3_BIN_DIR!\.") do set "_SCALA3_RC_HOME=%%~dpf"
) else if defined SCALA3_RC_HOME (
    set "_SCALA3_RC_HOME=%SCALA3_RC_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA3_RC_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala3-3*RC*" 2^>NUL') do set "_SCALA3_RC_HOME=!__PATH!\%%f"
    if not defined _SCALA3_RC_HOME (
        set "__PATH=%ProgramFiles%"
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala3-3*RC*" 2^>NUL') do set "_SCALA3_RC_HOME=!__PATH!\%%f"
    )
    if defined _SCALA3_RC_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala 3 RC installation directory "!_SCALA3_RC_HOME!" 1>&2
    )
)
if not exist "%_SCALA3_RC_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala 3 RC executable not found ^("%_SCALA3_RC_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _SBT_HOME, _SBT_PATH
:sbt
set _SBT_HOME=
set _SBT_PATH=

set __SBT_CMD=
for /f "delims=" %%f in ('where sbt.bat 2^>NUL') do set "__SBT_CMD=%%f"
if defined __SBT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of sbt executable found in PATH 1>&2
    @rem keep _SBT_PATH untouched since executable already in path
    goto :eof
) else if defined SBT_HOME (
    set "_SBT_HOME=%SBT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SBT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sbt\" ( set "_SBT_HOME=!__PATH!\sbt"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\sbt-*" 2^>NUL') do set "_SBT_HOME=!__PATH!\%%f"
        if not defined _SBT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\sbt-*" 2^>NUL') do set "_SBT_HOME=!__PATH!\%%f"
        )
    )
    if defined _SBT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default sbt installation directory "!_SBT_HOME!" 1>&2
    )
)
if not exist "%_SBT_HOME%\bin\sbt.bat" (
    echo %_ERROR_LABEL% sbt executable not found ^("%_SBT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBT_PATH=;%_SBT_HOME%\bin"
goto :eof

@rem output parameters: _ANT_HOME, _ANT_PATH
:ant
set _ANT_HOME=
set _ANT_PATH=

set __ANT_CMD=
for /f "delims=" %%f in ('where ant.bat 2^>NUL') do set "__ANT_CMD=%%f"
if defined __ANT_CMD (
    for /f "delims=" %%i in ("%__ANT_CMD%") do set "__ANT_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__ANT_BIN_DIR!\.") do set "_ANT_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Ant executable found in PATH 1>&2
    @rem keep _ANT_PATH untouched since executable already in path
    goto :eof
) else if defined ANT_HOME (
    set "_ANT_HOME=%ANT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ANT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\apache-ant\" ( set "_ANT_HOME=!__PATH!\apache-ant"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        if not defined _ANT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        )
    )
    if defined _ANT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Ant installation directory "!_ANT_HOME!" 1>&2
    )
)
if not exist "%_ANT_HOME%\bin\ant.cmd" (
    echo %_ERROR_LABEL% Ant executable not found ^("%_ANT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_ANT_PATH=;%_ANT_HOME%\bin"
goto :eof

@rem output parameters: _BAZEL_HOME, _BAZEL_PATH
:bazel
set _BAZEL_HOME=
set _BAZEL_PATH=

set __BAZEL_CMD=
for /f "delims=" %%f in ('where bazel.exe 2^>NUL') do set "__BAZEL_CMD=%%f"
if defined __BAZEL_CMD (
    for /f "delims=" %%i in ("%__BAZEL_CMD%") do set "_BAZEL_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Bazel executable found in PATH 1>&2
    @rem keep _BAZEL_PATH untouched since executable already in path
    goto :eof
) else if defined BAZEL_HOME (
    set "_BAZEL_HOME=%BAZEL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BAZEL_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\bazel\" ( set "_BAZEL_HOME=!__PATH!\bazel"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "_BAZEL_HOME=!__PATH!\%%f"
        if not defined _BAZEL_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "_BAZEL_HOME=!__PATH!\%%f"
        )
    )
    if defined _BAZEL_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Bazel installation directory "!_BAZEL_HOME!" 1>&2
    )
)
if not exist "%_BAZEL_HOME%\bazel.exe" (
    echo %_ERROR_LABEL% Bazel executable not found ^("%_BAZEL_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BAZEL_PATH=;%_BAZEL_HOME%"
goto :eof

@rem http://www.benf.org/other/cfr/
@rem output parameter: _CFR_HOME
:cfr
set _CFR_HOME=

set __CFR_CMD=
for /f "delims=" %%f in ('where cfr.bat 2^>NUL') do set "__CFR_CMD=%%f"
if defined __CFR_CMD (
    for /f "delims=" %%i in ("%__CFR_CMD%") do set "__CFR_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__CFR_BIN_DIR!\.") do set "_CFR_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of CFR executable found in PATH 1>&2
    goto :eof
) else if defined CFR_HOME (
    set "_CFR_HOME=%CFR_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CFR_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\cfr*" 2^>NUL') do set "_CFR_HOME=!__PATH!\%%f"
    if defined _CFR_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default CFR installation directory "!_CFR_HOME!" 1>&2
    )
)
if not exist "%_CFR_HOME%\bin\cfr.bat" (
    echo %_ERROR_LABEL% CFR executable not found ^("%_CFR_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _COURSIER_HOME, _COURSIER_PATH
:coursier
set _COURSIER_HOME=
set _COURSIER_PATH=

set __CS_CMD=
for /f "delims=" %%f in ('where cs.exe 2^>NUL') do set "__CS_CMD=%%f"
if defined __CS_CMD (
    for /f "delims=" %%i in ("%__CS_CMD%") do set "_COURSIER_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Coursier executable found in PATH 1>&2
    goto :eof
) else if defined COURSIER_HOME (
    set "_COURSIER_HOME=%COURSIER_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable COURSIER_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\coursier\" ( set "_COURSIER_HOME=!__PATH!\coursier"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\coursier-*" 2^>NUL') do set "_COURSIER_HOME=!__PATH!\%%f"
        if not defined _COURSIER_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\coursier-*" 2^>NUL') do set "_COURSIER_HOME=!__PATH!\%%f"
        )
    )
    if defined _COURSIER_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Coursier installation directory "!_COURSIER_HOME!" 1>&2
    )
)
if not exist "%_COURSIER_HOME%\cs.exe" (
    echo %_ERROR_LABEL% Coursier executable not found ^("%_COURSIER_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_COURSIER_PATH=;%_COURSIER_HOME%"
goto :eof

@rem output parameters: _GRADLE_HOME, _GRADLE_PATH
:gradle
set _GRADLE_HOME=
set _GRADLE_PATH=

set __GRADLE_CMD=
for /f "delims=" %%f in ('where gradle.bat 2^>NUL') do set "__GRADLE_CMD=%%f"
if defined __GRADLE_CMD (
    for /f "delims=" %%i in ("%__GRADLE_CMD%") do set "__GRADLE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__GRADLE_BIN_DIR!\.") do set "_GRADLE_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Gradle executable found in PATH 1>&2
    @rem keep _GRADLE_PATH untouched since executable already in path
    goto :eof
) else if defined GRADLE_HOME (
    set "_GRADLE_HOME=%GRADLE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GRADLE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\gradle\" ( set "_GRADLE_HOME=!__PATH!\gradle"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\gradle-*" 2^>NUL') do set "_GRADLE_HOME=!__PATH!\%%f"
        if not defined _GRADLE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\gradle-*" 2^>NUL') do set "_GRADLE_HOME=!__PATH!\%%f"
        )
    )
    if defined _GRADLE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Gradle installation directory "!_GRADLE_HOME!" 1>&2
    )
)
if not exist "%_GRADLE_HOME%\bin\gradle.bat" (
    echo %_ERROR_LABEL% Gradle executable not found ^("%_GRADLE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GRADLE_PATH=;%_GRADLE_HOME%\bin"
goto :eof

@rem output parameters: _JACOCO_HOME
:jacoco
set _JACOCO_HOME=

if defined JACOCO_HOME (
    set "_JACOCO_HOME=%JACOCO_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JACOCO_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\jacoco\" ( set "_JACOCO_HOME=!__PATH!\jacoco"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jacoco-*" 2^>NUL') do set "_JACOCO_HOME=!__PATH!\%%f"
        if not defined _JACOCO_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jacoco-*" 2^>NUL') do set "_JACOCO_HOME=!__PATH!\%%f"
        )
    )
    if defined _JACOCO_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JaCoCo installation directory "!_JACOCO_HOME!" 1>&2
    )
)
if not exist "%_JACOCO_HOME%\lib\jacococli.jar" (
    echo %_ERROR_LABEL% JaCoCo library not found ^("%_JACOCO_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _JAVAFX_HOME
:javafx
set _JAVAFX_HOME=

if defined JAVAFX_HOME (
    set "_JAVAFX_HOME=%JAVAFX_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JAVAFX_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\javafx\" ( set "_JAVAFX_HOME=!__PATH!\javafx"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\javafx-*" 2^>NUL') do set "_JAVAFX_HOME=!__PATH!\%%f"
        if not defined _JAVAFX_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\javafx-*" 2^>NUL') do set "_JAVAFX_HOME=!__PATH!\%%f"
        )
    )
    if defined _JAVAFX_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JavaFX installation directory "!_JAVAFX_HOME!" 1>&2
    )
)
if not exist "%_JAVAFX_HOME%\lib\javafx.graphics.jar" (
    echo %_ERROR_LABEL% JavaFX Graphics library not found ^("%_JAVAFX_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _JMC_HOME, _JMC_PATH
:jmc
set _JMC_HOME=
set _JMC_PATH=

set __JMC_CMD=
for /f "delims=" %%f in ('where jmc.exe 2^>NUL') do set "__JMC_CMD=%%f"
if defined __JMC_CMD (
    for /f "delims=" %%i in ("%__JMC_CMD%") do set "__JMC_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__JMC_BIN_DIR!\.") do set "_JMC_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of JMC executable found in PATH 1>&2
    @rem keep _JMC_PATH untouched since executable already in path
    goto :eof
) else if defined JMC_HOME (
    set "_JMC_HOME=%JMC_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JMC_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\jmc\" ( set "_JMC_HOME=!__PATH!\jmc"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jmc-*" 2^>NUL') do set "_JMC_HOME=!__PATH!\%%f"
        if not defined _JMC_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jmc-*" 2^>NUL') do set "_JMC_HOME=!__PATH!\%%f"
        )
    )
    if defined _JMC_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JMC installation directory "!_JMC_HOME!" 1>&2
    )
)
if not exist "%_JMC_HOME%\bin\jmc.exe" (
    echo %_ERROR_LABEL% JMC executable not found ^("%_JMC_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JMC_PATH=;%_JMC_HOME%\bin"
goto :eof

@rem output parameters: _MAVEN_HOME, _MAVEN_PATH
:maven
set _MAVEN_HOME=
set _MAVEN_PATH=

set __MVN_CMD=
for /f "delims=" %%f in ('where mvn.cmd 2^>NUL') do (
    set "__MVN_CMD=%%f"
    @rem we ignore Scoop managed Maven installation
    if not "!__MVN_CMD:scoop=!"=="!__MVN_CMD!" set __MVN_CMD=
)
if defined __MVN_CMD (
    for /f "delims=" %%i in ("%__MVN_CMD%") do set "__MAVEN_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__MAVEN_BIN_DIR!\.") do set "_MAVEN_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Maven executable found in PATH 1>&2
    @rem keep _MAVEN_PATH untouched since executable already in path
    goto :eof
) else if defined MAVEN_HOME (
    set "_MAVEN_HOME=%MAVEN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAVEN_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\apache-maven\" ( set "_MAVEN_HOME=!__PATH!\apache-maven"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\apache-maven-*" 2^>NUL') do set "_MAVEN_HOME=!__PATH!\%%f"
        if not defined _MAVEN_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\apache-maven-*" 2^>NUL') do set "_MAVEN_HOME=!__PATH!\%%f"
        )
    )
    if defined _MAVEN_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Maven installation directory "!_MAVEN_HOME!" 1>&2
    )
)
if not exist "%_MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven executable not found ^("%_MAVEN_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAVEN_PATH=;%_MAVEN_HOME%\bin"
goto :eof

:maven_plugin
set __JAR_FILE=
for /f "delims=" %%f in ('dir /s /b "%USERPROFILE%\.m2\repository\scala-maven-plugin-*.jar" 2^>NUL') do (
    set "__JAR_FILE=%%f"
)
if not defined __JAR_FILE (
    echo %_WARNING_LABEL% Scala Maven plugin not found 1>&2
    echo ^(archive file is https://github.com/michelou/dotty-examples/tree/master/bin/scala-maven-plugin-1.0.zip^)
)
goto :eof

@rem output parameters: _MILL_HOME, _MILL_PATH
:mill
set _MILL_HOME=
set _MILL_PATH=

set __MILL_CMD=
for /f "delims=" %%f in ('where mill.bat 2^>NUL') do set "__MILL_CMD=%%f"
if defined __MILL_CMD (
    for /f "delims=" %%i in ("%__MILL_CMD%") do set "_MILL_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Mill executable found in PATH 1>&2
    @rem keep _MILL_PATH untouched since executable already in path
    goto :eof
) else if defined MILL_HOME (
    set "_MILL_HOME=%MILL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MILL_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mill\" ( set "_MILL_HOME=!__PATH!\mill"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mill-*" 2^>NUL') do set "_MILL_HOME=!__PATH!\%%f"
        if not defined _MILL_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mill-*" 2^>NUL') do set "_MILL_HOME=!__PATH!\%%f"
        )
    )
    if defined _MILL_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Mill installation directory "!_MILL_HOME!" 1>&2
    )
)
if not exist "%_MILL_HOME%\mill.bat" (
    echo %_ERROR_LABEL% Mill executable not found ^("%_MILL_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MILL_PATH=;%_MILL_HOME%"
goto :eof

@rem output parameter: _MSVS_HOME
:msvs
set _MSVS_HOME=

set "__WSWHERE_CMD=%_ROOT_DIR%bin\vswhere.exe"
for /f "delims=" %%f in ('"%__WSWHERE_CMD%" -property installationPath 2^>NUL') do set "_MSVS_HOME=%%~f"
if not exist "%_MSVS_HOME%\" (
    echo %_ERROR_LABEL% Could not find installation directory for Microsoft Visual Studio 2019 1>&2
    echo        ^(see https://github.com/oracle/graal/blob/master/compiler/README.md^) 1>&2
    set _EXITCODE=1
    goto :eof
)
call :subst_path "%_MSVS_HOME%"
if not %_EXITCODE%==0 goto :eof
set "_MSVS_HOME=%_SUBST_PATH%"
goto :eof

@rem input parameter: %1=directory path
@rem output parameter: _SUBST_PATH
:subst_path
set "_SUBST_PATH=%~1"
set __DRIVE_NAME=X:
set __ASSIGNED_PATH=
for /f "tokens=1,2,*" %%f in ('subst ^| findstr /b "%__DRIVE_NAME%" 2^>NUL') do (
    if not "%%h"=="%_SUBST_PATH%" (
        echo %_WARNING_LABEL% Drive %__DRIVE_NAME% already assigned to "%%h" 1>&2
        goto subst_path_end
    )
    set "__ASSIGNED_PATH=%%h"
)
if not defined __ASSIGNED_PATH (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% subst "%__DRIVE_NAME%" "%_SUBST_PATH%" 1>&2
    subst "%__DRIVE_NAME%" "%_SUBST_PATH%"
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
        goto :eof
    )
)
:subst_path_end
set "_SUBST_PATH=%__DRIVE_NAME%"
goto :eof

@rem output parameters: _MSYS_HOME, _MSYS_PATH
:msys
set _MSYS_HOME=
set _MSYS_PATH=

set __MSYS2_CMD=
for /f "delims=" %%f in ('where msy2_shell.cmd 2^>NUL') do set "__MSYS2_CMD=%%f"
if defined __MSYS2_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of msys2 command found in PATH 1>&2
    @rem keep _MSYS_PATH untouched since executable already in path
    goto :eof
) else if defined MSYS_HOME (
    set "_MSYS_HOME=%MSYS_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MSYS_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\msys64\" ( set "_MSYS_HOME=!__PATH!\msys64"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\msys64*" 2^>NUL') do set "_MSYS_HOME=!__PATH!\%%f"
    )
    if defined _MSYS_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default MSYS2 installation directory "!_MSYS_HOME!" 1>&2
    )
)
if not exist "%_MSYS_HOME%\msys2_shell.cmd" if %_MSYS%==1 (
    set _MSYS=0
    echo %_ERROR_LABEL% MSYS2 command not found ^("%_MSYS_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MSYS_PATH=;%_MSYS_HOME%\usr\bin"
goto :eof

@rem output parameters: _SCALA_CLI_HOME, _SCALA_CLI_PATH
:scala_cli
set _SCALA_CLI_HOME=
set _SCALA_CLI_PATH=

set __SCALA_CLI_CMD=
for /f "delims=" %%f in ('where scala-cli.exe 2^>NUL') do set "__SCALA_CLI_CMD=%%f"
if defined __SCALA_CLI_CMD (
    for /f "delims=" %%f in ("%__SCALA_CLI_CMD%") do set "_SCALA_CLI_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Scala CLI command found in PATH 1>&2
    goto :eof
) else if defined SCALA_CLI_HOME (
    set "_SCALA_CLI_HOME=%SCALA_CLI_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA_CLI_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\scala-cli\" ( set "_SCALA_CLI_HOME=!__PATH!\scala-cli"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala-cli*" 2^>NUL') do set "_SCALA_CLI_HOME=!__PATH!\%%f"
        if not defined _SCALA_CLI_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\scala-cli*" 2^>NUL') do set "_SCALA_CLI_HOME=!__PATH!\%%f"
        )
    )
    if defined _SCALA_CLI_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala CLI installation directory "!_SCALA_CLI_HOME!" 1>&2
    )
)
if not exist "%_SCALA_CLI_HOME%\scala-cli.exe" (
    echo %_ERROR_LABEL% Scala CLI command not found ^("%_SCALA_CLI_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SCALA_CLI_PATH=;%SCALA_CLI_HOME%"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    for /f "delims=" %%i in ("%__GIT_CMD%") do set "__GIT_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__GIT_BIN_DIR!\.") do set "_GIT_HOME=%%~dpf"
    @rem Executable git.exe is present both in bin\ and \mingw64\bin\
    if not "!_GIT_HOME:mingw=!"=="!_GIT_HOME!" (
        for /f "delims=" %%f in ("!_GIT_HOME!\.") do set "_GIT_HOME=%%~dpf"
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH untouched since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory "!_GIT_HOME!" 1>&2
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^("%_GIT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\mingw64\bin;%_GIT_HOME%\usr\bin"
goto :eof

@rem output parameters: _VSCODE_HOME, _VSCODE_PATH
:vscode
set _VSCODE_HOME=
set _VSCODE_PATH=

set __CODE_CMD=
for /f "delims=" %%f in ('where code.cmd 2^>NUL') do set "__CODE_CMD=%%f"
if defined __CODE_CMD (
    for /f "delims=" %%i in ("%__CODE_CMD%") do set "__CODE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__CODE_BIN_DIR!\.") do set "_VSCODE_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of VSCode executable found in PATH 1>&2
    @rem keep _VSCODE_PATH untouched since executable already in path
    goto :eof
) else if defined VSCODE_HOME (
    set "_VSCODE_HOME=%VSCODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable VSCODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\VSCode\" ( set "_VSCODE_HOME=!__PATH!\VSCode"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\VSCode-*" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        if not defined _VSCODE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Microsoft*Code" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        )
        if not defined _VSCODE_HOME (
            set "__PATH=%LOCALAPPDATA%\Programs"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Microsoft*Code" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        )
    )
    if defined _VSCODE_HOME (
        @rem remove trailing path separator if present
        if "!_VSCODE_HOME:~-1!" == "\" set "_VSCODE_HOME=!_VSCODE_HOME:~0,-1!"
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default VSCode installation directory "!_VSCODE_HOME!" 1>&2
    )
)
if not exist "%_VSCODE_HOME%\bin\code.cmd" (
    echo %_ERROR_LABEL% VSCode command not found ^("%_VSCODE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_VSCODE_PATH=;%_VSCODE_HOME%\bin"
goto :eof

:clean
set "__ROOT_DIR=%~dp0"
for /f "delims=" %%i in ('dir /ad /b "%__ROOT_DIR%\" 2^>NUL') do (
    for /f "delims=" %%j in ('dir /ad /b "%%i\target\scala-*" 2^>NUL') do (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% rmdir /s /q %__ROOT_DIR%%%i\target\%%j\classes 1^>NUL 2^>^&1 1>&2
        rmdir /s /q "%__ROOT_DIR%%%i\target\%%j\classes" 1>NUL 2>&1
    )
)
goto :eof

:print_env
set __USE_CLAUDE=%1
set __VERBOSE=%2
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __VERSIONS_LINE3=
set __VERSIONS_LINE4=
set __WHERE_ARGS=
setlocal enabledelayedexpansion

if %__USE_CLAUDE%==1 (
    where /q "%CLAUDE_HOME%\bin:claude.exe"
    if !ERRORLEVEL!==0 (
        for /f "tokens=1,*" %%i in ('call "%CLAUDE_HOME%\bin\claude.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% Claude %%i,"
        set __WHERE_ARGS=%__WHERE_ARGS% "%CLAUDE_HOME%\bin:claude.exe"
    )
)
where /q "%JAVA_HOME%\bin:javac.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('call "%JAVA_HOME%\bin\javac.exe" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% javac %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JAVA_HOME%\bin:javac.exe"
)
where /q "%SCALA_HOME%\bin:scalac.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('call "%SCALA_HOME%\bin\scalac.bat" -version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SCALA_HOME%\bin:scalac.bat"
)
where /q "%SCALA3_HOME%\bin:scalac.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('call "%SCALA3_HOME%\bin\scalac.bat" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SCALA3_HOME%\bin:scalac.bat"
)
set "__SCALAFMT_CMD=%LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat"
if exist "%__SCALAFMT_CMD%" (
    for /f "tokens=1,2,*" %%i in ('call "%__SCALAFMT_CMD%" -version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalafmt %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%__SCALAFMT_CMD:bin\=bin:%"
)
where /q "%ANT_HOME%\bin:ant.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('call "%ANT_HOME%\bin\ant.bat" -version ^| findstr version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% ant %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%ANT_HOME%\bin:ant.bat"
)
where /q "%GRADLE_HOME%\bin:gradle.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('call "%GRADLE_HOME%\bin\gradle.bat" -version ^| findstr Gradle') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% gradle %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GRADLE_HOME%\bin:gradle.bat"
)
where /q "%MAVEN_HOME%\bin:mvn.cmd"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%MAVEN_HOME%\bin\mvn.cmd" -version ^| findstr Apache') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mvn %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MAVEN_HOME%\bin:mvn.cmd"
)
where /q "%SBT_HOME%\bin:sbt.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('call "%SBT_HOME%\bin\sbt.bat" --script-version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% sbt %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SBT_HOME%\bin:sbt.bat"
)
where /q "%SCALA_CLI_HOME%:scala-cli.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,*" %%i in ('"%SCALA_CLI_HOME%\scala-cli.exe" -version ^| findstr CLI') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% scala-cli %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SCALA_CLI_HOME%:scala-cli.exe"
)
where /q "%MILL_HOME%:mill.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-4,*" %%i in ('call "%MILL_HOME%\mill.bat" --no-server --version ^| findstr /i mill') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% mill %%m,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MILL_HOME%:mill.bat"
)
where /q "%BAZEL_HOME%:bazel.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%BAZEL_HOME%\bazel.exe" --version') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bazel %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%BAZEL_HOME%:bazel.exe"
)
@rem where /q bloop.cmd
@rem if %ERRORLEVEL%==0 (
@rem     start /min "bloop_8212" bloop.cmd server
@rem     timeout /t 2 /nobreak 1>NUL
@rem     for /f "tokens=1,*" %%i in ('bloop.cmd about --version 2^>^&1 ^| findstr /b bloop') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bloop %%j,"
@rem     set __WHERE_ARGS=%__WHERE_ARGS% bloop.cmd
@rem     taskkill.exe /fi "WindowTitle eq bloop_8212*" /t /f 1>NUL
@rem )
where /q "%CFR_HOME%\bin:cfr.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('call "%CFR_HOME%\bin\cfr.bat" 2^>^&1 ^| findstr /b CFR') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% cfr %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%CFR_HOME%\bin:cfr.bat"
)
where /q "%COURSIER_HOME%:coursier.bat"
if %ERRORLEVEL%==0 (
    for /f %%i in ('call "%COURSIER_HOME%\coursier.bat" --version 2^>^&1') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% coursier %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%COURSIER_HOME%:coursier.bat"
)
where /q "%MSYS_HOME%\usr\bin:make.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%MSYS_HOME%\usr\bin\make.exe" --version 2^>^&1 ^| findstr Make') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% make %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MSYS_HOME%\usr\bin:make.exe"
)
where /q "%PYTHON_HOME%:python.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%PYTHON_HOME%\python.exe" --version 2^>^&1') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% python %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%PYTHON_HOME%:python.exe"
)
where /q "%JACOCO_HOME%\lib:jacococli.jar"
if %ERRORLEVEL%==0 if exist "%JAVA_HOME%\bin\java.exe" (
    for /f "delims=. tokens=1-3,*" %%i in ('call "%JAVA_HOME%\bin\java.exe" -jar "%JACOCO_HOME%\lib\jacococli.jar" version') do set "__VERSIONS_LINE4=%__VERSIONS_LINE4% jacoco %%i.%%j.%%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JACOCO_HOME%\lib:jacococli.jar"
)
where /q "%VSCODE_HOME%\bin:code.cmd"
if %ERRORLEVEL%==0 (
    set __VERSION=
    for /f "tokens=1,*" %%i in ('call "%VSCODE_HOME%\bin\code.cmd" --version') do (
        if not defined __VERSION set __VERSION=%%i
    )    
    set "__VERSIONS_LINE4=%__VERSIONS_LINE4% code !__VERSION!,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%VSCODE_HOME%:code.exe"
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE4=%__VERSIONS_LINE4% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE4=%__VERSIONS_LINE4% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
where /q "%GIT_HOME%\bin:bash.exe"
if %ERRORLEVEL%==0 (
    for /f "usebackq tokens=1-3,4,*" %%i in (`"%GIT_HOME%\bin\bash.exe" --version ^| findstr bash`) do (
        set "__VERSION=%%l"
        set "__VERSIONS_LINE4=%__VERSIONS_LINE4% bash !__VERSION:-release=!"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
echo   %__VERSIONS_LINE3%
echo   %__VERSIONS_LINE4%
if %__VERBOSE%==1 (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do (
        set "__LINE=%%p"
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
    echo Environment variables: 1>&2
    if defined ANT_HOME echo    "ANT_HOME=%ANT_HOME%" 1>&2
    if defined BAZEL_HOME echo    "BAZEL_HOME=%BAZEL_HOME%" 1>&2
    if defined CFR_HOME echo    "CFR_HOME=%CFR_HOME%" 1>&2
    if defined CLAUDE_HOME echo    "CLAUDE_HOME=%CLAUDE_HOME%" 1>&2
    if defined COURSIER_DATA_DIR echo    "COURSIER_DATA_DIR=!COURSIER_DATA_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    if defined COURSIER_HOME echo    "COURSIER_HOME=%COURSIER_HOME%" 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined GRADLE_HOME echo    "GRADLE_HOME=%GRADLE_HOME%" 1>&2
    if defined JAVA_HOME echo    "JAVA_HOME=%JAVA_HOME%" 1>&2
    if defined JAVA11_HOME echo    "JAVA11_HOME=%JAVA11_HOME%" 1>&2
    if defined JAVA17_HOME echo    "JAVA17_HOME=%JAVA17_HOME%" 1>&2
    if defined JAVA21_HOME echo    "JAVA21_HOME=%JAVA21_HOME%" 1>&2
    if defined JAVACOCO_HOME echo    "JAVACOCO_HOME=%JAVACOCO_HOME%" 1>&2
    if defined JAVAFX_HOME echo    "JAVAFX_HOME=%JAVAFX_HOME%" 1>&2
    if defined MAVEN_HOME echo    "MAVEN_HOME=%MAVEN_HOME%" 1>&2
    if defined MILL_HOME echo    "MILL_HOME=%MILL_HOME%" 1>&2
    if defined MSVS_HOME echo    "MSVS_HOME=%MSVS_HOME%" 1>&2
    if defined MSYS_HOME echo    "MSYS_HOME=%MSYS_HOME%" 1>&2
    if defined PYTHON_HOME echo    "PYTHON_HOME=%PYTHON_HOME%" 1>&2
    if defined SBT_HOME echo    "SBT_HOME=%SBT_HOME%" 1>&2
    if defined SCALA_CLI_HOME echo    "SCALA_CLI_HOME=%SCALA_CLI_HOME%" 1>&2
    if defined SCALA_HOME echo    "SCALA_HOME=%SCALA_HOME%" 1>&2
    if defined SCALA3_HOME echo    "SCALA3_HOME=%SCALA3_HOME%" 1>&2
    if defined SCALA3_HOME echo    "SCALA3_RC_HOME=%SCALA3_RC_HOME%" 1>&2
    if defined VSCODE_HOME echo    "VSCODE_HOME=!VSCODE_HOME:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do (
        set "__LINE=%%i"
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
)
endlocal
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined ANT_HOME set "ANT_HOME=%_ANT_HOME%"
        if not defined BAZEL_HOME set "BAZEL_HOME=%_BAZEL_HOME%"
        if not defined BLOOP_HOME set "BLOOP_HOME=%_BLOOP_HOME%"
        if not defined CFR_HOME set "CFR_HOME=%_CFR_HOME%"
        if %_USE_CLAUDE%==1 (
            if not defined CLAUDE_HOME set "CLAUDE_HOME=%_CLAUDE_HOME%"
            @rem see https://wiip.fr/en/blog/claude-code-powershell-tool
            set CLAUDE_CODE_USE_POWERSHELL_TOOL=1
        )
        if not defined COURSIER_HOME set "COURSIER_HOME=%_COURSIER_HOME%"
        if exist "%LOCALAPPDATA%\coursier\data" set "COURSIER_DATA_DIR=%LOCALAPPDATA%\coursier\data"
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined GRADLE_HOME set "GRADLE_HOME=%_GRADLE_HOME%"
        if not defined JACOCO_HOME set "JACOCO_HOME=%_JACOCO_HOME%"
        if not defined JAVA_HOME set "JAVA_HOME=%_JAVA_HOME%"
        if not defined JAVA11_HOME set "JAVA11_HOME=%_JAVA11_HOME%"
        if not defined JAVA17_HOME set "JAVA17_HOME=%_JAVA17_HOME%"
        if not defined JAVA21_HOME set "JAVA21_HOME=%_JAVA21_HOME%"
        if not defined JAVAFX_HOME set "JAVAFX_HOME=%_JAVAFX_HOME%"
        if not defined MAVEN_HOME set "MAVEN_HOME=%_MAVEN_HOME%"
        if not defined MILL_HOME set "MILL_HOME=%_MILL_HOME%"
        if not defined MSVS_HOME set "MSVS_HOME=%_MSVS_HOME%"
        if not defined MSYS_HOME set "MSYS_HOME=%_MSYS_HOME%"
        if not defined PYTHON_HOME set "PYTHON_HOME=%_PYTHON_HOME%"
        if not defined SBT_HOME set "SBT_HOME=%_SBT_HOME%"
        if not defined SCALA_HOME set "SCALA_HOME=%_SCALA_HOME%"
        if not defined SCALA_CLI_HOME set "SCALA_CLI_HOME=%_SCALA_CLI_HOME%"
        if not defined SCALA3_HOME set "SCALA3_HOME=%_SCALA3_HOME%"
        if not defined SCALA3_RC_HOME set "SCALA3_RC_HOME=%_SCALA3_RC_HOME%"
        if not defined VSCODE_HOME set "VSCODE_HOME=%_VSCODE_HOME%"
        @rem We prepend %_GIT_HOME%\bin to hide C:\Windows\System32\bash.exe
        set "PATH=%_GIT_HOME%\bin;%PATH%%_ANT_PATH%%_BAZEL_PATH%%_COURSIER_PATH%%_GRADLE_PATH%%_JMC_PATH%%_MAVEN_PATH%%_MILL_PATH%%_SBT_PATH%%_MSYS_PATH%;%_SCALA_CLI_PATH%%_BLOOP_PATH%%_GIT_PATH%%_VSCODE_PATH%;%~dp0bin"
        call :print_env %_USE_CLAUDE% %_VERBOSE%
        if not "%CD:~0,2%"=="%_DRIVE_NAME%" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME% 1>&2
            cd /d %_DRIVE_NAME%
        )
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        ) else if %_MSYS%==1 (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_MSYS_HOME%\msys2_shell.cmd -mingw64 -where %_DRIVE_NAME%" 1>&2
            cmd.exe /c "%_MSYS_HOME%\msys2_shell.cmd -mingw64 -where %_DRIVE_NAME%"
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

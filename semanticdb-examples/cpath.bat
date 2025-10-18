@echo off
setlocal enabledelayedexpansion

@rem output parameter: _CPATH

if not defined _DEBUG set _DEBUG=%~1
if not defined _DEBUG set _DEBUG=0
set _VERBOSE=0

if not defined _MVN_CMD set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
if %_DEBUG%==1 echo [%~n0] "_MVN_CMD=%_MVN_CMD%" 1>&2

if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=--quiet
)
@rem we use the newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
set __CENTRAL_REPO=https://repo1.maven.org/maven2
set "__LOCAL_REPO=%USERPROFILE%\.m2\repository"

set "__TEMP_DIR=%TEMP%\lib"
if not exist "%__TEMP_DIR%" mkdir "%__TEMP_DIR%"
if %_DEBUG%==1 echo [%~n0] "__TEMP_DIR=%__TEMP_DIR%" 1>&2

set __SCALA_BINARY_VERSION=2.13

set __SCALA_VERSION=2.13.17

set __SCALAMETA_VERSION=4.14.0

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH_SCALA

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.scala-lang/scala-reflect
call :add_jar "org.scala-lang" "scala-reflect" "%__SCALA_VERSION%"

@rem https://mvnrepository.com/artifact/com.lihaoyi/fansi
@rem dependency of pprint
call :add_jar "com.lihaoyi" "fansi_%__SCALA_BINARY_VERSION%" "0.5.1"

@rem https://mvnrepository.com/artifact/com.lihaoyi/pprint
call :add_jar "com.lihaoyi" "pprint_%__SCALA_BINARY_VERSION%" "0.9.4"

@rem https://mvnrepository.com/artifact/org.scalameta/common
call :add_jar "org.scalameta" "common_%__SCALA_BINARY_VERSION%" "%__SCALAMETA_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalameta/scalameta
call :add_jar "org.scalameta" "scalameta_%__SCALA_BINARY_VERSION%" "%__SCALAMETA_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalameta/semanticdb-scalac
call :add_jar "org.scalameta" "semanticdb-scalac_%__SCALA_VERSION%" "%__SCALAMETA_VERSION%"

set "__LIBS_CPATH_SCALA=%_LIBS_CPATH%"

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH_JAVA

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.scalameta/common
call :add_jar "org.scalameta" "common_%__SCALA_BINARY_VERSION%" "%__SCALAMETA_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalameta/scalameta
call :add_jar "org.scalameta" "scalameta_%__SCALA_BINARY_VERSION%" "%__SCALAMETA_VERSION%"

@rem https://mvnrepository.com/artifact/com.sourcegraph/semanticdb-javac
call :add_jar "com.sourcegraph" "semanticdb-javac" "0.11.1"

set "__LIBS_CPATH_JAVA=%_LIBS_CPATH%"

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH_KOTLIN

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.scalameta/common
call :add_jar "org.scalameta" "common_%__SCALA_BINARY_VERSION%" "%__SCALAMETA_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalameta/scalameta
call :add_jar "org.scalameta" "scalameta_%__SCALA_BINARY_VERSION%" "%__SCALAMETA_VERSION%"

@rem https://mvnrepository.com/artifact/com.sourcegraph/semanticdb-kotlinc
call :add_jar "com.sourcegraph" "semanticdb-kotlinc" "0.6.0"

set "__LIBS_CPATH_KOTLIN=%_LIBS_CPATH%"

goto end

@rem #########################################################################
@rem ## Subroutines

@rem input parameters: %1=group ID, %2=artifact ID, %3=version
@rem global variable: _LIBS_CPATH
:add_jar
@rem https://mvnrepository.com/artifact/org.portable-scala
set __GROUP_ID=%~1
set __ARTIFACT_ID=%~2
set __VERSION=%~3

set __JAR_NAME=%__ARTIFACT_ID%-%__VERSION%.jar
set __JAR_PATH=%__GROUP_ID:.=\%\%__ARTIFACT_ID:/=\%
set __JAR_FILE=
for /f "usebackq delims=" %%f in (`where /r "%__LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
    set "__JAR_FILE=%%f"
)
if not exist "%__JAR_FILE%" (
    set __JAR_URL=%__CENTRAL_REPO%/%__GROUP_ID:.=/%/%__ARTIFACT_ID%/%__VERSION%/%__JAR_NAME%
    set "__JAR_FILE=%__TEMP_DIR%\%__JAR_NAME%"
    if not exist "!__JAR_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_PWSH_CMD%" -c "Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file "%__JAR_NAME%" to directory "!__TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
        )
        call "%_PWSH_CMD%" -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file "%__JAR_NAME%" to directory "!_TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
            set _EXITCODE=1
            goto :eof
        )
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar 1>&2
        ) else if %_VERBOSE%==1 ( echo Install Maven artifact into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!\%__SCALA_XML_PATH%" 1>&2
        )
        @rem see https://stackoverflow.com/questions/16727941/how-do-i-execute-cmd-commands-through-a-batch-file
        call "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to install Maven artifact into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!" ^(error:!ERRORLEVEL!^) 1>&2
        )
        for /f "usebackq delims=" %%f in (`where /r "%_LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
            set "__JAR_FILE=%%f"
        )
    )
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__JAR_FILE%;"
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    set "_CPATH=%__LIBS_CPATH_SCALA%"
    set "_CPATH_JAVA=%__LIBS_CPATH_JAVA%"
    set "_CPATH_KOTLIN=%__LIBS_CPATH_KOTLIN%"
)

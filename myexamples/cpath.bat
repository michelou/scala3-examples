@echo off
setlocal enabledelayedexpansion

@rem output parameter: _CPATH

if not defined _DEBUG set _DEBUG=%~1
if not defined _DEBUG set _DEBUG=0
set _VERBOSE=0

if not defined _MVN_CMD set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
if %_DEBUG%==1 echo [%~n0] "_MVN_CMD=%_MVN_CMD%"

if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=--quiet
)
@rem use newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
set _CENTRAL_REPO=https://repo1.maven.org/maven2
set "_LOCAL_REPO=%USERPROFILE%\.m2\repository"

set "_TEMP_DIR=%TEMP%\lib"
if not exist "%_TEMP_DIR%" mkdir "%_TEMP_DIR%"
if %_DEBUG%==1 echo [%~n0] "_TEMP_DIR=%_TEMP_DIR%"

set __SCALA_BINARY_VERSION=2.13

@rem #########################################################################
@rem ## Libraries to be added to _LIBS_CPATH

set _LIBS_CPATH=

@rem https://mvnrepository.com/artifact/org.apiguardian/apiguardian-api
call :add_jar "org.apiguardian" "apiguardian-api" "1.1.2"

@rem https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-api
call :add_jar "org.junit.jupiter" "junit-jupiter-api" "5.14.0"

@rem https://mvnrepository.com/artifact/org.portable-scala/portable-scala-reflect
call :add_jar "org.portable-scala" "portable-scala-reflect_%__SCALA_BINARY_VERSION%" "1.1.3"

@rem https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml
call :add_jar "org.scala-lang.modules" "scala-xml_3" "2.4.0"

@rem https://mvnrepository.com/artifact/junit/junit
call :add_jar "junit" "junit" "4.13.2"

@rem https://mvnrepository.com/artifact/com.novocode/junit-interface
call :add_jar "com.novocode" "junit-interface" "0.11"

@rem https://mvnrepository.com/artifact/org.hamcrest/hamcrest
call :add_jar "org.hamcrest" "hamcrest" "2.2"

set __SCALATEST_VERSION=3.2.19

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-compatible
call :add_jar "org.scalatest" "scalatest-compatible" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-core
call :add_jar "org.scalatest" "scalatest-core_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-funsuite
call :add_jar "org.scalatest" "scalatest-funsuite_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-funspec
call :add_jar "org.scalatest" "scalatest-funspec_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest
call :add_jar "org.scalatest" "scalatest_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalactic
call :add_jar "org.scalactic" "scalactic_3" "%__SCALATEST_VERSION%"

set __SPECS2_VERSION=5.6.4

@rem https://mvnrepository.com/artifact/org.specs2/specs2-core
call :add_jar "org.specs2" "specs2-core_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-common
call :add_jar "org.specs2" "specs2-common_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-junit
call :add_jar "org.specs2" "specs2-junit_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-junit
call :add_jar "org.specs2" "specs2-matcher_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-fp
call :add_jar "org.specs2" "specs2-fp_3" "%__SPECS2_VERSION%"

set __JMH_VERSION=1.37
@rem JMH 1.34 - 1.37 depend on Jopt 5.0.4
@rem (previously : JMH 1.27, 1.29, 1.31-33 depend on Jopt 4.6)
set __JOPT_VERSION=5.0.4

@rem https://mvnrepository.com/artifact/net.sf.jopt-simple/jopt-simple
call :add_jar "net.sf.jopt-simple" "jopt-simple" "%__JOPT_VERSION%"

@rem https://mvnrepository.com/artifact/org.openjdk.jmh/jmh-core
call :add_jar "org.openjdk.jmh" "jmh-core" "%__JMH_VERSION%"

@rem https://mvnrepository.com/artifact/org.openjdk.jmh/jmh-generator-annprocess
call :add_jar "org.openjdk.jmh" "jmh-generator-annprocess" "%__JMH_VERSION%"

@rem https://mvnrepository.com/artifact/org.openjdk.jmh/jmh-core-benchmarks
call :add_jar "org.openjdk.jmh" "jmh-core-benchmarks" "%__JMH_VERSION%"

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
for /f "usebackq delims=" %%f in (`where /r "%_LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
    set "__JAR_FILE=%%f"
)
if not exist "%__JAR_FILE%" (
    set __JAR_URL=%_CENTRAL_REPO%/%__GROUP_ID:.=/%/%__ARTIFACT_ID%/%__VERSION%/%__JAR_NAME%
    set "__JAR_FILE=%_TEMP_DIR%\%__JAR_NAME%"
    if not exist "!__JAR_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% call "%_PWSH_CMD%" -c "Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file "%__JAR_NAME%" to directory "!_TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
        )
        call "%_PWSH_CMD%" -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file "%__JAR_NAME%" to directory "!_TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
            set _EXITCODE=1
            goto :eof
        )
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar 1>&2
        ) else if %_VERBOSE%==1 ( echo Install Maven artifact into directory "!_LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!\%__SCALA_XML_PATH%" 1>&2
        )
        @rem see https://stackoverflow.com/questions/16727941/how-do-i-execute-cmd-commands-through-a-batch-file
        call "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to install Maven artifact into directory "!_LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!" ^(error:!ERRORLEVEL!^) 1>&2
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
    set "_CPATH=%_LIBS_CPATH%"
)
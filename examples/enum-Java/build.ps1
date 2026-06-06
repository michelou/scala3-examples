#!/usr/bin/env pwsh
#
# Copyright (c) 2018-2026 Stéphane Micheloud
#
# Licensed under the MIT License.
#

## only for interactive debugging !
$DEBUG = $false

#########################################################################
## Environment setup

$EXITCODE = 0

$EXE = ""
if ($PSVersionTable.PSVersion -lt "6.0" -or $IsWindows) {
  # Fix case when both the Windows and Linux builds of this program
  # are installed in the same directory.
  $EXE = '.exe'
}

$BASENAME = (Get-Item $PSScriptRoot).Basename
$ROOT_DIR = $PSScriptRoot
$PATH_SEP = [IO.Path]::PathSeparator
$SEP = [IO.Path]::DirectorySeparatorChar

$SOURCE_DIR = $ROOT_DIR + $SEP + 'src'
$SOURCE_JAVA_DIR = $SOURCE_DIR + $SEP + 'main' + $SEP + 'java'
$SOURCE_SCALA_DIR = $SOURCE_DIR + $SEP + 'main' + $SEP + 'scala'
$TARGET_DIR = $ROOT_DIR + $SEP + 'target'
$TARGET_DOCS_DIR = $TARGET_DIR + $SEP + 'docs'
$CLASSES_DIR = $TARGET_DIR + $SEP + 'classes'

$JAVAC_CMD = $Env:JAVA_HOME + $SEP + 'bin' + $SEP + 'javac' + $EXE
if (! (Test-Path -PathType Leaf -Path $JAVAC_CMD)) {
    $JAVAC_CMD = $null
}
$SCALAC_CMD = $Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scalac.bat'
if (! (Test-Path -PathType Leaf -Path $SCALAC_CMD)) {
    $SCALAC3_CMD = $null
}
$SCALA_CMD = $Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scala.bat'
if (! (Test-Path -PathType Leaf -Path $SCALA_CMD)) {
    $SCALA_CMD = $null
}
$SCALADOC_CMD = $Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scaladoc.bat'
if (! (Test-Path -PathType Leaf -Path $SCALADOC_CMD)) {
    $SCALADOC_CMD = $null
}

$PROJECT_NAME = $BASENAME
$PROJECT_VERSION = '"1.0-SNAPSHOT'

#########################################################################
## Script arguments

$COMMANDS = @()

## Possible values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend
$DebugPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'

$TIMER = $false
$VERBOSE = $false
$N = 0
foreach ($ARG in $args) {
    if ($ARG.StartsWith("-")) {
        ## option
        if ($ARG -ieq "-debug") { $DEBUG = $true; $DebugPreference='Continue'
        } elseif ($ARG -ieq "-help"   ) { $COMMANDS = 'Print-Help'
        } elseif ($ARG -ieq "-timer"  ) { $TIMER = $true
        } elseif ($ARG -ieq "-verbose") { $VERBOSE = $true; $VerbosePreference = 'Continue'
        } else {
            Write-Error "Unknown option ""$ARG"""
            $EXITCODE = 1
            break
        }
    } else {
        ## subcommand
        if ($ARG -ieq "clean") { $COMMANDS += 'Clean'
        } elseif ($ARG -ieq "compile") { $COMMANDS += 'Compile'
        } elseif ($ARG -ieq "decompile") { $COMMANDS += 'Decompile'
        } elseif ($ARG -ieq "doc" ) { $COMMANDS += 'Compile', 'Doc'
        } elseif ($ARG -ieq "help") { $COMMANDS = 'Print-Help'
        } elseif ($ARG -ieq "lint") { $COMMANDS += 'Lint'
        } elseif ($ARG -ieq "run" ) { $COMMANDS += 'Compile', 'Run'
        } elseif ($ARG -ieq "test") { $COMMANDS += 'Compile', 'Test'
        } else {
            Write-Error "Unknown subcommand ""$ARG"""
            $EXITCODE = 1
            break
        }
        $N++
    }
}
$MAIN_NAME = 'Test'
$MAIN_CLASS = $MAIN_NAME
$MAIN_ARGS = $null

$SOURCE_MAIN_FILE = $SOURCE_MAIN_DIR + $SEP + $MAIN_NAME + '.scala'

Write-Debug "Options    : DEBUG=$DEBUG TIMER=$TIMER VERBOSE=$VERBOSE"
Write-Debug "Subcommands: $COMMANDS"
if ($Env:CFR_HOME) { Write-Debug "Variables  : ""CFR_HOME=$Env:CFR_HOME""" }
Write-Debug "Variables  : ""GIT_HOME=$Env:GIT_HOME"""
Write-Debug "Variables  : ""JAVA_HOME=$Env:JAVA_HOME"""
Write-Debug "Variables  : ""SCALA_HOME=$Env:SCALA_HOME"""
Write-Debug "Variables  : ""SCALA3_HOME=$Env:SCALA3_HOME"""
Write-Debug "Variables  : MAIN_NAME=$MAIN_NAME MAIN_ARGS=$MAIN_ARGS"
Write-Debug "Variables  : PROJECT_NAME=$PROJECT_NAME"

if ($TIMER) { $TIMER_START = Get-Date }

#########################################################################
## Subroutines

function Main
{
    foreach($COMMAND in $COMMANDS) {
        &$COMMAND
        if ($EXITCODE -ne 0) { exit $EXITCODE }
    }
    if ($TIMER) {
        $DURATION = New-TimeSpan -Start $TIMER_START -End (Get-Date)
        Write-Output "Total execution time: $DURATION"
    }
    Cleanup $EXITCODE
}

function Print-Help
{
    Write-Output "Usage: $BASENAME { <option> | <subcommand> }"
    Write-Output ""
    Write-Output "   Options:"
    Write-Output "     -debug      print commands executed by this script"
    Write-Output "     -timer      print total execution time"
    Write-Output "     -verbose    print progress messages"
    Write-Output ""
    Write-Output "   Subcommands:"
    Write-Output "     clean       delete generated files"
    Write-Output "     compile     compile Java/Scala source files"
    Write-Output "     decompile   decompile generated code with CFR"
    Write-Output "     doc         generate HTML documentation"
    Write-Output "     help        print this help message"
    Write-Output "     lint        analyze Scala source files with Scalafmt"
    Write-Output "     run         execute main program ""$MAIN_CLASS"""
}

function Clean
{
    Delete-Dir $TARGET_DIR
}

function Delete-Dir
{
    param (
        [string] $dir
    )
    if (Test-Path -PathType Container -Path $dir) {
        Write-Debug "[System.IO.Directory]::Delete('$dir', $true)"
        Write-Verbose "Delete directory ""$($dir.Replace($ROOT_DIR + $SEP, ''))"""
        try {
            #[System.IO.Directory]::Delete($dir, $true)
            Remove-Item -Path $dir -Force -Recurse
        } catch {
            Write-Error "Failed to delete directory ""$($dir.Replace($ROOT_DIR + $SEP, ''))"""
            $EXITCODE = 1
            return
        }
    }
}

function Lint
{
    Write-Warning "Subcommand 'Lint' is not yet implemented"
}

function Compile
{
    if (! (Test-Path -PathType Container -Path $CLASSES_DIR)) {
        $_ = New-Item -ItemType Directory -Path $CLASSES_DIR
    }
    $TIMESTAMP_FILE = $TARGET_DIR + $SEP + '.latest-build'
    if (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_JAVA_DIR" '*.java') {
        Compile-Java
    }
    if (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_SCALA_DIR" '*.scala') {
        Compile-Scala
    }
    $_ = New-Item -ItemType File -Path $TIMESTAMP_FILE -Force
}

function Test-Action-Required
{
    param (
        [string] $FilePath,
        [string] $DirPath,
        [string] $Pattern
    )
    $REQUIRED = $false
    if (Test-Path -PathType Container -Path $DirPath) {
        if (Test-Path -PathType Leaf -Path $FilePath) {
            $FILE_LAST_TIME = (Get-Item $FilePath).LastWriteTime
            $DIR_LAST_TIME = (Get-ChildItem -Path $DirPath -Include $Pattern -Recurse | Sort LastWriteTime | Select -Last 1).LastWriteTime
            $REQUIRED = $FILE_LAST_TIME -lt $DIR_LAST_TIME
        } else {
            $REQUIRED = $true
        }
    }
    Write-Debug "REQUIRED=$REQUIRED ($Pattern)"
    return $REQUIRED
}

function Compile-Java
{
    $OPTS_FILE = $TARGET_DIR + $SEP + 'javac_opts.txt'
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR
    Write-Output "-classpath ""$($CPATH.Replace('\', '\\'))"" -d ""$($CLASSES_DIR.Replace('\', '\\'))""" > $OPTS_FILE

    $FILES = (Get-ChildItem -Path $SOURCE_JAVA_DIR -Include "*.java" -Recurse).FullName
    $N = $FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Java source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Java source file"
    } else { $N_FILES = "$N Java source files"
    }
    $SOURCES_FILE = $TARGET_DIR + $SEP + 'javac_sources.txt'
    Write-Output $FILES > $SOURCES_FILE

    Write-Debug """$JAVAC_CMD"" ""@$OPTS_FILE"" ""@$SOURCES_FILE"""
    Write-Verbose "Compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$JAVAC_CMD" "@$OPTS_FILE" "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR +$SEP, ''))"""
        $EXITCODE = 1
        return
    }
}

function Compile-Scala
{
    $OPTS_FILE = $TARGET_DIR + $SEP + 'scalac_opts.txt'
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR
    Write-Output "-classpath ""$($CPATH.Replace('\', '\\'))"" -d ""$($CLASSES_DIR.Replace('\', '\\'))""" > $OPTS_FILE

    $FILES = (Get-ChildItem -Path $SOURCE_SCALA_DIR -Include "*.scala" -Recurse).FullName
    $N = $FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Scala source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Scala source file"
    } else { $N_FILES = "$N Scala source files"
    }
    $SOURCES_FILE = $TARGET_DIR + $SEP + 'scalac_sources.txt'
    Write-Output $FILES > $SOURCES_FILE

    Write-Debug """$SCALAC_CMD"" ""@$OPTS_FILE"" ""@$SOURCES_FILE"""
    Write-Verbose "Compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$SCALAC_CMD" "@$OPTS_FILE" "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $N_FILES to directory ""$($CLASSES_DIR.Replace($ROOT_DIR +$SEP, ''))"""
        $EXITCODE = 1
        return
    }
}
<#
function Build-Classpath
{
    $CPATH = $null

    $REPO_DIR = $Env:USERPROFILE + $SEP + '.m2' + $SEP + 'repository'
    if (! (Test-Path -PathType Container -PATH $REPO_DIR)) {
        Write-Error "Maven local repository not found"
        set $EXITCODE = 1
        return $CPATH
    }
    ## https://mvnrepository.com/artifact/org.scala-lang/scala-library
    $JAR_FILE = (Get-ChildItem -Path ($REPO_DIR + $SEP + 'org' + $SEP + 'scala-lang') -Include 'scala-library-2.13.*.jar' -Recurse)
    if ($JAR_FILE.Count -gt 0) { $CPATH = $CPATH + $($JAR_FILE | Select-Object -Last 1).FullName + $PATH_SEP }

    return $CPATH 
}
#>
function Decompile
{
}

function Doc
{
    if (! (Test-Path -PathType Container -Path $TARGET_DOCS_DIR)) {
        $_ = New-Item -ItemType Directory -Path $TARGET_DOCS_DIR
    }
    $TIMESTAMP_FILE = $TARGET_DOCS_DIR +$SEP + '.latest-build'
    if (! (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$CLASSES_DIR" '*.tasty')) { return }

    $SOURCES_FILE = $TARGET_DIR + $SEP + 'scaladoc_sources.txt'
    if (Test-Path -Path $SOURCES_FILE) { Remove-Item $SOURCES_FILE }

    $FILES = (Get-ChildItem -Path $CLASSES_DIR -Include "*.tasty" -Recurse).FullName
    Write-Output > $SOURCES_FILE

    $OPTS_FILE = $TARGET_DIR + $SEP + 'scaladoc_opts.txt'
    Write-Output "-d ""$($TARGET_DOCS_DIR.Replace($SEP,$SEP + $SEP))"" -project ""$PROJECT_NAME"" -project-version ""$PROJECT_VERSION""" > $OPTS_FILE
    Write-Debug "$SCALADOC_CMD @$OPTS_FILE @$SOURCES_FILE"
    Write-Verbose "Generate HTML documentation into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR, ''))"""

    &"$SCALADOC_CMD"  "@$SOURCES_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to generate HTML documentation into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR, ''))"""
        Cleanup 1
    }
    Write-Debug "HTML documentation saved into directory ""$TARGET_DOCS_DIR"""
    Write-Verbose "HTML documentation saved into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR, ''))"""

    $_ = New-Item -ItemType File -Path $TIMESTAMP_FILE -Force
}

function Run
{
    $MAIN_CLASS_FILE = $CLASSES_DIR + $SEP + $MAIN_CLASS.Replace('.', $SEP) + '.class'
    if (! (Test-Path -PathType Leaf -Path $MAIN_CLASS_FILE)) {
        Write-Error "Scala main class ""$MAIN_CLASS"" not found ($MAIN_CLASS_FILE)"
        Cleanup 1
    }
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR
    $SCALA_OPTS = "-classpath ""$CPATH"""

    Write-Debug """$SCALA_CMD"" $SCALA_OPTS $MAIN_CLASS $MAIN_ARGS"
    Write-Verbose "Execute Scala main class ""$MAIN_CLASS"""
    &"$SCALA_CMD" -classpath "$CPATH" $MAIN_CLASS $MAIN_ARGS
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute Scala main class ""$MAIN_CLASS"""
        Cleanup 1
    }
    if ($TASTY) {
        Write-Output "call :run_tasty"
        #[[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    }
}

function Compile-Test
{
    Write-Warning "Subcommand 'Compile-Test' is not yet implemented"
}

function Test
{
    Write-Warning "Subcommand 'Test' is not yet implemented"
}

function Cleanup
{
    param (
        [int] $ExitCode
    )
    Write-Debug "ExitCode=$ExitCode"
    exit $ExitCode
}

#########################################################################
## Entry-point

Main

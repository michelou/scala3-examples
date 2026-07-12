#!/usr/bin/env pwsh
#
# Copyright (c) 2018-2026 Stéphane Micheloud
#
# Licensed under the MIT License.
#

## https://powershellisfun.com/2023/04/24/using-the-requires-statement-in-powershell/
#Requires -Version 5.1

## only for interactive debugging !
$DEBUG = $false

#########################################################################
## Environment setup

$EXITCODE = 0

$BAT = ""
$EXE = ""
if ($PSVersionTable.PSVersion -lt "6.0" -or $IsWindows) {
  # Fix case when both the Windows and Linux builds of this program
  # are installed in the same directory.
  $BAT = '.bat'
  $EXE = '.exe'
}

$BASENAME = (Get-Item $PSScriptRoot).Basename
$ROOT_DIR = $PSScriptRoot
$PATH_SEP = [IO.Path]::PathSeparator
$SEP      = [IO.Path]::DirectorySeparatorChar

$SOURCE_DIR       = Join-Path -Path $ROOT_DIR   -ChildPath 'src'
$SOURCE_JAVA_DIR  = [IO.Path]::Combine($SOURCE_DIR, 'main', 'java')
$SOURCE_SCALA_DIR = [IO.Path]::Combine($SOURCE_DIR, 'main', 'scala')
$RESOURCES_DIR    = [IO.Path]::Combine($SOURCE_DIR, 'main', 'resources')

$TARGET_DIR       = Join-Path -Path $ROOT_DIR   -ChildPath 'target'
$TARGET_DOCS_DIR  = Join-Path -Path $TARGET_DIR -ChildPath 'docs'
$CLASSES_DIR      = Join-Path -Path $TARGET_DIR -ChildPath 'classes'

$JAVAC_CMD = $Env:JAVA_HOME + $SEP + 'bin' + $SEP + 'javac' + $EXE
if (! (Test-Path -PathType Leaf -Path $JAVAC_CMD)) {
    Write-Error "Java compiler not found (check variable ""JAVA_HOME"")"
    Cleanup 1
}
$SCALAC2 = $Env:SCALA_HOME + $SEP + 'bin' + $SEP + 'scalac' + $BAT
if (! (Test-Path -PathType Leaf -Path $SCALAC2)) {
    Write-Error "Scala 3 compiler not found (check variable ""SCALA_HOME"")"
    Cleanup 1
}
$SCALAC3 = $Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scalac' + $BAT
if (! (Test-Path -PathType Leaf -Path $SCALAC3)) {
    Write-Error "Scala 3 compiler not found (check variable ""SCALA3_HOME"")"
    Cleanup 1
}
$SCALA_CLI_CMD = $Env:SCALA_CLI_HOME + $SEP + 'scala-cli' + $EXE
if (! (Test-Path -PathType Leaf -Path $SCALA_CLI_CMD)) {
    $SCALA_CLI_CMD = $null
}
$SCALAFMT_CMD = $Env:LOCALAPPDATA + $SEP + 'Coursier' + $SEP + 'data' + $SEP + 'bin' + $SEP + 'scalafmt' + $BAT
if (! (Test-Path -PathType Leaf -Path $SCALAFMT_CMD)) {
    $SCALAFMT_CMD = $null
}
$SCALAFMT_CONFIG_FILE = $ROOT_DIR + $SEP + '.scalafmt.conf'
if (! (Test-Path -PathType Leaf -Path $SCALAFMT_CONFIG_FILE)) {
    $SCALAFMT_CONFIG_FILE = $null
}
$CFR_CMD = $Env:CFR_HOME + $SEP + 'bin' + $SEP + 'cfr'
if (! (Test-Path -PathType Leaf -Path $CFR_CMD)) {
    $CFR_CMD = $null
}
$PS_VERSION = $PSVersionTable.PSVersion.ToString()
$PROJECT_URL = "github.com/$USER/scala3-examples"
$PROJECT_NAME = $BASENAME
$PROJECT_VERSION = '1.0-SNAPSHOT'

#########################################################################
## Script arguments

$COMMANDS = @()

## Possible values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend
$DebugPreference   = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'

$HELP = $false
## https://virtuslab.com/blog/scala/scala-cli-the-new-scala-runner
$SCALA_CLI = $false
$SCALA_VERSION = 3
$TIMER = $false
$USE_RC = $false  ## release candidate
$VERBOSE = $false
$N = 0
foreach ($ARG in $args) {
    if ($ARG.StartsWith('-')) {
        ## option
        if ($ARG -ieq '-cli') { $SCALA_CLI = $true
        } elseif ($ARG -ieq '-debug') { $DEBUG = $true; $DebugPreference='Continue'
        } elseif ($ARG -ieq '-help'   ) { $HELP = $true
        } elseif ($ARG -ieq "-rc"     ) { $USE_RC = $true
        } elseif ($ARG -ieq "-scala2" ) { $SCALA_VERSION = 2
        } elseif ($ARG -ieq "-scala3" ) { $SCALA_VERSION = 3
        } elseif ($ARG -ieq '-timer'  ) { $TIMER = $true
        } elseif ($ARG -ieq '-verbose') { $VERBOSE = $true; $VerbosePreference = 'Continue'
        } else {
            Write-Error "Unknown option ""$ARG"""
            $EXITCODE = 1
            break
        }
    } else {
        ## subcommand
        if ($ARG -ieq 'clean') { $COMMANDS += 'Clean'
        } elseif ($ARG -ieq "compile") { $COMMANDS += 'Compile'
        } elseif ($ARG -ieq "decompile") { $COMMANDS += 'Decompile'
        } elseif ($ARG -ieq "doc" ) { $COMMANDS += 'Compile', 'Doc'
        } elseif ($ARG -ieq "help") { $HELP = $true
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
## Source name and class name may differ
$MAIN_NAME = 'Main'
$MAIN_CLASS = 'Planet'
$MAIN_ARGS = 1

if ($COMMANDS -contains 'Compile' -and $SCALA_VERSION -eq 2) {
    ## overwrite main source directory if Scala 2/3 sources differ
    $SOURCE_SCALA2_DIR = $SOURCE_DIR + $SEP + 'main' + $SEP + 'scala2'
    if (Test-Path -PathType Container -Path $SOURCE_SCALA2_DIR) {
    $SOURCE_SCALA_DIR = $SOURCE_SCALA2_DIR
    }
}
if ($COMMANDS -contains 'Decompile' -and ! $CFR_CMD) {
    Write-Warning "CFR command not found (check variable CFR_HOME)"
    $COMMANDS = $COMMANDS.Replace('Decompile', '')
}
if ($COMMANDS -contains 'Lint') {
    if (! $SCALAFMT_CMD) {
        Write-Warning "Scalafmt command not found (installation managed by Coursier)"
        $COMMANDS = $COMMANDS.Replace('Lint', '')
    } elseif (! $SCALAFMT_CONFIG_FILE) {
        Write-Warning "Scalafmt configuration file not found"
        $COMMANDS = $COMMANDS.Replace('Lint', '')
    }
}
if ($SCALA_CLI) {
    if ($SCALA_CLI_CMD) {
        $COMMANDS = $COMMANDS.Replace('Clean', 'Clean-CLI')
        $COMMANDS = $COMMANDS.Replace('Compile', 'Compile-CLI')
        $COMMANDS = $COMMANDS.Replace('Run', 'Run-CLI')
    } else {
        Write-Warning "Scala CLI installation not found (check variable ""$SCALA_CLI_HOME"")"
        $SCALA_CLI = $false
    }
}
$USE_CODE_RUNNER = $false
if ($SCALA_VERSION -eq 2) {
    $SCALA_CMD = $Env:SCALA_HOME + $SEP + 'bin' + $SEP + 'scala' + $BAT
    $SCALAC_CMD = $SCALAC2
    $SCALADOC_CMD = $Env:SCALA_HOME + $SEP + 'bin' + $SEP + 'scaladoc' + $BAT
    $SCALAC_OPTS = @('-deprecation')
} elseif ($USE_RC -and $Env:SCALA3_RC_HOME) {
    $SCALA_CMD = $Env:SCALA3_RC_HOME + $SEP + 'bin' + $SEP + 'scala' + $BAT
    $SCALAC_CMD = $SCALAC3
    $SCALADOC_CMD = $Env:SCALA3_RC_HOME + $SEP + 'bin' + $SEP + 'scaladoc' + $BAT
    $SCALAC_OPTS = @('-deprecation', '-feature')
    $SCALA3_RC_VERSION = (Select-String -Path ($Env:SCALA3_RC_HOME + $SEP + 'VERSION') -Pattern 'version' | Select-Object -ExpandProperty Line).Replace('version:=', '')
    $USE_CODE_RUNNER = Test-Path -Path ($Env:SCALA3_RC_HOME + $SEP + 'libexec' + $SEP + 'common')
} else {
    $SCALA_CMD =$Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scala' + $BAT
    $SCALAC_CMD = $Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scalac' + $BAT
    $SCALADOC_CMD = $Env:SCALA3_HOME + $SEP + 'bin' + $SEP + 'scaladoc' + $BAT
    $SCALAC_OPTS = @('-deprecation', '-feature')
    $_USE_CODE_RUNNER = Test-Path -PathType Leaf -Path ($Env:SCALA3_HOME + $SEP + 'libexec' + $SEP + 'common')
}
Write-Debug "Properties : PROJECT_NAME=$PROJECT_NAME PROJECT_VERSION=$PROJECT_VERSION PS_VERSION=$PS_VERSION"
Write-Debug "Properties : SCALA_VERSION=$SCALA_VERSION USE_CODE_RUNNER=$USE_CODE_RUNNER USE_RC=$USE_RC"
Write-Debug "Options    : DEBUG=$DEBUG TIMER=$TIMER VERBOSE=$VERBOSE"
Write-Debug "Subcommands: $COMMANDS"
if ($CFR_CMD) { Write-Debug "Variables  : ""CFR_HOME=$Env:CFR_HOME""" }
Write-Debug "Variables  : ""GIT_HOME=$Env:GIT_HOME"""
Write-Debug "Variables  : ""JAVA_HOME=$Env:JAVA_HOME"""
Write-Debug "Variables  : ""SCALA_HOME=$Env:SCALA_HOME"""
Write-Debug "Variables  : ""SCALA3_HOME=$Env:SCALA3_HOME"""
if ($Env:SCALA3_RC_HOME) { Write-Debug "Variables  : ""SCALA3_RC_HOME=$Env:SCALA3_RC_HOME""" }
Write-Debug "Variables  : MAIN_NAME=$MAIN_NAME MAIN_CLASS=$MAIN_CLASS MAIN_ARGS=$MAIN_ARGS"

if ($TIMER) { $TIMER_START = Get-Date }

#########################################################################
## Subroutines

function Main
{
    if ($HELP) {
        Print-Help
        Cleanup $EXITCODE
    }
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
    Write-Output "     -rc         use Scala 3 release candidate if available"
    Write-Output "     -scala2     use Scala 2 distribution"
    Write-Output "     -scala3     use Scala 3 distribution (default)"
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
    Write-Output "     run         execute main class ""$MAIN_CLASS"""
}

function Clean
{
    Delete-Directory -DirPath $TARGET_DIR
}

function Delete-Directory
{
    param (
        [string] $DirPath
    )
    if (Test-Path -PathType Container -Path $DirPath) {
        Write-Debug "[System.IO.Directory]::Delete('$DirPath', $true)"
        Write-Verbose "Delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
        try {
            #[System.IO.Directory]::Delete($DirPath, $true)
            Remove-Item -Path $DirPath -Force -Recurse
        } catch {
            Write-Error "Failed to delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
            $EXITCODE = 1
            return
        }
    }
}

function Clean-CLI
{
    $CLI_OPTS = @('--bsp-directory', $TARGET_DIR)
    if ($DEBUG) {
        $CLI_OPTS += '-v'
        Write-Debug """$SCALA_CLI_CMD"" clean $CLI_OPTS $SOURCE_SCALA_DIR"
    } elseif ($VERBOSE) {
        $CLI_OPTS += '-v'
        Write-Verbose "Clean project (scala-cli)"
    }
    &"$SCALA_CLI_CMD" clean $CLI_OPTS $SOURCE_SCALA_DIR
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to clean project (scala-cli)"
        $EXITCODE = 1
        return
    }
}

function Lint
{
    $SCALAFMT_OPTS = @('--test', '--config', $SCALAFMT_CONFIG_FILE)
    if ($DEBUG) { $SCALAFMT_OPTS += '--debug' }

    Write-Debug "$SCALAFMT_CMD $SCALAFMT_OPTS ""SOURCE_SCALA_DIR"""
    Write-Warning "Analyze Scala source files with Scalafmt"
    &"$SCALAFMT_CMD" $SCALAFMT_OPTS "$SOURCE_SCALA_DIR"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to analyze Scala source files with Scalafmt"
        $EXITCODE = 1
        return
    }
}

function Compile
{
    if (! (Test-Path -PathType Container -Path $CLASSES_DIR)) {
        $_ = New-Item -ItemType Directory -Path $CLASSES_DIR
    }
    $TIMESTAMP_FILE = Join-Path -Path $TARGET_DIR -ChildPath '.latest-build'
    if (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_JAVA_DIR" -Pattern '*.java') {
        Compile-Java
    }
    if (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_SCALA_DIR" -Pattern '*.scala') {
        Compile-Scala
    }
    if (Test-Path -Path $RESOURCES_DIR\*) {
        Copy-Item -Path $RESOURCES_DIR -Destination $CLASSES_DIR
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

function Compile-CLI
{
    $TIMESTAMP_FILE = Join-Path -Path $TARGET_DOCS_DIR -ChildPath '.latest-build'
    if (! (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$SOURCE_DIR" '*.scala')) { return }

    $CLI_OPTS = @('--scala')
    if ($SCALA_VERSION -eq 2) { $CLI_OPTS += '-2.13'
    } elseif ($USE_RC) { $CLI_OPTS += $SCALA3_RC_VERSION
    } else { $CLI_OPTS += '3.3'
    }    
    $CLI_OPTS += @('-O', '-deprecation', '--compilation-output', $TARGET_DIR, '--bsp-directory', $TARGET_DIR)
    Write-Debug """$SCALA_CLI_CMD"" compile $CLI_OPTS ""$SOURCE_SCALA_DIR"""
    Write-Verbose ""
    &"$SCALA_CLI_CMD" compile $CLI_OPTS "$SOURCE_SCALA_DIR"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile Scala source files to directory ""$($CLASSES_DIR.Replace($ROOT_DIR +$SEP, ''))"""
        $EXITCODE = 1
        return
    }
    $_ = New-Item -ItemType File -Path $TIMESTAMP_FILE -Force
}

function Compile-Java
{
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'javac_opts.txt'
    [System.IO.File]::WriteAllLines($OPTS_FILE, "-classpath ""$($CPATH.Replace('\', '\\'))"" -d ""$($CLASSES_DIR.Replace('\', '\\'))""")

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_JAVA_DIR -Include "*.java" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Java source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Java source file"
    } else { $N_FILES = "$N Java source files"
    }
    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'javac_sources.txt'
    [System.IO.File]::WriteAllLines($SOURCES_FILE, $SOURCE_FILES)

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
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'scalac_opts.txt'
    [System.IO.File]::WriteAllLines($OPTS_FILE, "-classpath ""$($CPATH.Replace('\', '\\'))"" -d ""$($CLASSES_DIR.Replace('\', '\\'))""")

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_SCALA_DIR -Include "*.scala" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Scala source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Scala source file"
    } else { $N_FILES = "$N Scala source files"
    }
    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'scalac_sources.txt'
    [System.IO.File]::WriteAllLines($SOURCES_FILE, $SOURCE_FILES)

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

    $REPO_DIR = [IO.Path]::Combine($Env:USERPROFILE, '.m2', 'repository')
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
    $TIMESTAMP_FILE = Join-Path -Path $TARGET_DOCS_DIR -ChildPath '.latest-build'
    if (! (Test-Action-Required -FilePath "$TIMESTAMP_FILE" -DirPath "$CLASSES_DIR" '*.tasty')) { return }

    $SOURCES_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'scaladoc_sources.txt'
    if (Test-Path -Path $SOURCES_FILE) { Remove-Item $SOURCES_FILE }

    $FILES = (Get-ChildItem -Path $CLASSES_DIR -Include "*.tasty" -Recurse).FullName
    Write-Output > $SOURCES_FILE

    $OPTS_FILE = Join-Path -Path $TARGET_DIR -ChildPath 'scaladoc_opts.txt'
    Write-Output "-d ""$($TARGET_DOCS_DIR.Replace($SEP, $SEP + $SEP))"" -project ""$PROJECT_NAME"" -project-version ""$PROJECT_VERSION""" > $OPTS_FILE
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
    $MAIN_CLASS_FILE = Join-Path -Path $CLASSES_DIR -ChildPath $($MAIN_CLASS.Replace('.', $SEP) + '.class')
    if (! (Test-Path -PathType Leaf -Path $MAIN_CLASS_FILE)) {
        Write-Error "Scala main class ""$MAIN_CLASS"" not found ($MAIN_CLASS_FILE)"
        Cleanup 1
    }
    #$CPATH = $(Build-Classpath) + $CLASSES_DIR
    $CPATH = $CLASSES_DIR
    $SCALA_OPTS = @('-classpath', """$CPATH""")
    $SCALA_OPTS_DEBUG = @('-classpath', """$($CPATH.Replace($Env:USERPROFILE,'%USERPROFILE%'))""")

    Write-Debug """$SCALA_CMD"" $SCALA_OPTS_DEBUG $MAIN_CLASS $MAIN_ARGS"
    Write-Verbose "Execute Scala main class ""$MAIN_CLASS"""
    &"$SCALA_CMD" $SCALA_OPTS $MAIN_CLASS $MAIN_ARGS
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute Scala main class ""$MAIN_CLASS"""
        Cleanup 1
    }
    if ($TASTY) {
        Write-Output "call :run_tasty"
        #[[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    }
}

function Run-CLI
{
    $CLI_OPTS = @('--scala')
    if ($SCALA_VERSION -eq 2) { $CLI_OPTS += '-2.13'
    } elseif ($USE_RC) { $CLI_OPTS += $SCALA3_RC_VERSION
    } else { $CLI_OPTS += '3.3'
    }
    $CLI_OPTS += @('--main-class', $MAIN_CLASS)
    $MAIN_ARGS=@()

    Write-Debug """$SCALA_CLI_CMD"" run $CLI_OPTS $SOURCE_SCALA_DIR -- $MAIN_ARGS"
    Write-Verbose ""
    &"$SCALA_CLI_CMD" run $CLI_OPTS $SOURCE_SCALA_DIR -- $MAIN_ARGS
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute Scala main class ""$MAIN_CLASS"""
        $EXITCODE = 1
        return
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

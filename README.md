# <span id="top">Playing with Scala 3 on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:60px;max-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;" src="docs/images/dotty.png" alt="Dotty project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> code examples coming from various websites - mostly from the <a href="https://dotty.epfl.ch/" rel="external">Dotty</a> project - or written by ourself.<br/>
    In particular it includes build scripts (<a href="https://ant.apache.org/manual/using.html" rel="external">Ant files</a>, <a href="https://cloudblogs.microsoft.com/opensource/2023/02/21/introducing-bash-for-beginners/" rel="external">Bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://docs.gradle.org/current/userguide/tutorial_using_tasks.html" rel="external">Gradle scripts</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>, <a href="https://maven.apache.org/guides/introduction/introduction-to-the-pom.html" rel="external">Maven scripts</a>) for experimenting with the <a href="https://www.scala-lang.org/blog/2018/04/19/scala-3.html" rel="external">Scala 3</a> language on a Windows machine.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Scala 3][scala3_home] on Windows:

- Running Scala 3 on Windows [**&#9660;**](#bottom)
- [Building Scala 3 on Windows](BUILD.md)
- [Data Sharing and Scala 3 on Windows](CDS.md)
- [OpenJDK and Scala 3 on Windows](OPENJDK.md)

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [COBOL][cobol_examples], [Component Pascal][cp_examples], [Dafny][dafny_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Erlang][erlang_examples], [Flix][flix_examples], [Go][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Spark][spark_examples], [Spring][spring_examples], [Standard&nbsp;ML][sml_examples], [TruffleSqueak][trufflesqueak_examples], [WiX Toolset][wix_examples] and [Zig][zig_examples] are other topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.51][git_releases] ([*release notes*][git_relnotes])
- [Scala 3.3 LTS][scala3_lts_releases] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][scala3_lts_relnotes])
- [Temurin OpenJDK 17 LTS][temurin_openjdk17] <sup id="anchor_02">[2](#footnote_02)</sup> ([*release notes*][temurin_openjdk17_relnotes], [*bug fixes*][temurin_openjdk17_bugfixes], [Java 17 API][oracle_openjdk17_api])
<!--
- [Temurin OpenJDK 11 LTS][temurin_openjdk11] <sup id="anchor_02">[2](#footnote_02)</sup> ([*release notes*][temurin_openjdk11_relnotes], [*bug fixes*][temurin_openjdk11_bugfixes])
-->

Optionally one may also install the following software:

- [Apache Ant 1.10][apache_ant] (requires Java 8) ([*release notes*][apache_ant_relnotes])
- [Apache Maven 3.9][apache_maven] ([requires Java 8+][apache_maven_history]) ([*release notes*][apache_maven_relnotes])
- [Bazel 8.4 LTS][bazel_releases] <sup id="anchor_03">[3](#footnote_03)</sup> ([*release notes*][bazel_relnotes])
- [CFR 0.15][cfr_releases] (Java decompiler)
- [Gradle 9.1][gradle_install] ([requires Java 8+][gradle_compatibility]) ([*release notes*][gradle_relnotes])
- [JaCoCo 0.8][jacoco_downloads] <sup id="anchor_04">[4](#footnote_04)</sup> ([*change log*][jacoco_changelog])
- [JavaFX 17 LTS][javafx17_downloads] ([*release notes*][javafx17_relnotes])
- [JavaFX 21 LTS][javafx21_downloads] ([*release notes*][javafx21_relnotes])
- [JITWatch 1.4][jitwatch_releases] (requires Java 11+)
- [Mill 1.0][mill_releases] <sup id="anchor_05">[5](#footnote_05)</sup>  ([*change log*][mill_changelog])
- [MSYS2 2024][msys2_releases] ([*change log*][msys2_changelog])
- [sbt 1.11][sbt_downloads] (requires Java 8+) ([*release notes*][sbt_relnotes])
- [Scala 2.13][scala_releases] (requires Java 8+) ([*release notes*][scala_relnotes], [*Scala API*][scala_api])
- [Scala 2.13 DEV][scala_snapshots]
- [Scala 3.7 Next][scala3_next_releases] <sup id="anchor_06">[6](#footnote_06)</sup> ([*release notes*][scala3_next_relnotes])
- [scala-cli 1.9][scala_cli_downloads] ([*release notes*][scala_cli_relnotes])
- [Temurin OpenJDK 21 LTS][temurin_openjdk21] <sup id="anchor_02">[2](#footnote_02)</sup> ([*release notes*][temurin_openjdk21_relnotes], [*Java 21 API*][oracle_openjdk21_api])
- [Visual Studio Code 1.105][vscode_downloads] ([*release notes*][vscode_relnotes])

<!--
- [Bloop 1.5][bloop_releases] (requires Java 8 and Python 2/3) ([*release notes*][bloop_relnotes])
- [Python 3.8][python_release] ([*change log*][python_changelog])
- [Temurin OpenJDK 8 LTS][temurin_openjdk8] <sup id="anchor_02">[2](#footnote_02)</sup> ([*release notes*][temurin_openjdk8_relnotes])
-->

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a [Windows installer][windows_installer]. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][unix_opt] directory on Unix).

For instance our development environment looks as follows (*October 2025*) <sup id="anchor_06">[6](#footnote_06)</sup>:

<pre style="font-size:80%;">
C:\opt\apache-ant\                 <i>( 40 MB)</i>
C:\opt\apache-maven\               <i>( 10 MB)</i>
C:\opt\bazel\                      <i>( 47 MB)</i>
C:\opt\cfr-0.152\                  <i>(  2 MB)</i>
C:\opt\Git\                        <i>(367 MB)</i>
C:\opt\gradle\                     <i>(138 MB)</i>
C:\opt\jacoco\                     <i>( 10 MB)</i>
C:\opt\javafx-sdk-17.0.15\         <i>(137 MB)</i>
C:\opt\javafx-sdk-21.0.6\          <i>(138 MB)</i>
C:\opt\jdk-temurin-1.8.0u422-b05\  <i>(189 MB)</i>
C:\opt\jdk-temurin-17.0.16_8\      <i>(302 MB)</i>
C:\opt\jdk-temurin-21.0.8_9\       <i>(327 MB)</i>
C:\opt\jitwatch-1.4.9\             <i>( 36 MB)</i>
C:\opt\mill\                       <i>( 67 MB)</i>
C:\opt\msys64\                     <i>(5.5 GB)</i>
C:\opt\Python-3.11.1\              <i>(299 MB)</i>
C:\opt\sbt\                        <i>(110 MB)</i>
C:\opt\scala-2.13.17\              <i>( 24 MB)</i>
C:\opt\scala-cli\                  <i>( 95 MB)</i>
C:\opt\scala3-3.3.7\               <i>( 38 MB)</i>
C:\opt\scala3-3.7.4\               <i>(131 MB)</i>
C:\opt\VSCode\                     <i>(341 MB)</i>
</pre>
 <!-- jdk8: 242-b08 = 184 MB, 252-b09 = 181 MB , 262-b10 = 184 MB -->
 <!-- jdk8: 345-b01 = 186 MB -->
 <!-- jdk11: 11.0.8 = 314 MB, 11.0.9 = 316 MB, 11.0.11 = 300 MB -->
 <!-- jdk11: 11.0.16 = 301 MB, 11.0.18 = 301 MB -->
 <!-- sbt: 1.3.6 = 55.1 MB, 1.3.7 = 60.9 MB, 1.3.8 = 61.0 MB -->
 <!-- sbt: 1.3.9 = 61.2 MB, 1.3.10 = 61.2 MB, 1.3.11 = 61.3 MB, 1.4.1 = 48.0 MB -->
 <!-- sbt: 1.4.2 = 47.7 MB, 1.4.3 = 47.7 MB, 1.4.6 -> 48 MB, 1.4.6 = MB -->
 <!-- sbt: 1.4.7 = 48.3 MB, 1.4.8 = 48.3 MB, 1.5.0 = 48.3 MB -->
 <!-- sbt: 1.5.1 to 1.5.5 = 50.6 MB -->
 <!-- sbt: 1.6.1 = 50.6 MB, 1.6.2 = 50.6 MB -->
 <!-- sbt: 1.8.0 = 80.6 MB, 1.7.2 = 80.6 MB, 1.8.0 = 80.6 MB, 1.9.3 = 110.0 MB -->
 <!-- sbt: 1.9.6 = 136 MB, 1.9.7 = 135 MB, 1.9.8 -> 135 MB, 1.9.9 = 136 MB -->
 <!-- sbt: 1.10.0 = 137 MB, 1.10.1 = 137 MB, 1.10.3 = 137 MB -->
 <!-- scala3: 3.4.2 = 39 MB, 3.5.0 = 131 MB -->

> **:mag_right:** [Git for Windows][git_releases] provides a Bash emulation used to run [**`git.exe`**][git_cli] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

This project is organized as follows:

<pre style="font-size:80%;">
bin\*.bat
bin\cfr-0.152.zip
bin\3.0\{<a href="bin/3.0/common.bat">common.bat</a>, <a href="bin/3.0/scala.bat">scala.bat</a>, <a href="bin/3.0/scalac.bat">scalac.bat</a>, <a href="bin/3.0/scaladoc.bat">scaladoc.bat</a>}
bin\3.1\{<a href="bin/3.1/common.bat">common.bat</a>, <a href="bin/3.1/scala.bat">scala.bat</a>, <a href="bin/3.1/scalac.bat">scalac.bat</a>, <a href="bin/3.1/scaladoc.bat">scaladoc.bat</a>}
bin\3.2\{<a href="bin/3.2/common.bat">common.bat</a>, <a href="bin/3.2/scala.bat">scala.bat</a>, <a href="bin/3.2/scalac.bat">scalac.bat</a>, <a href="bin/3.2/scaladoc.bat">scaladoc.bat</a>}
bin\dotty\
docs\
examples\{<a href="examples/README.md">README.md</a>, <a href="examples/dotty-example-project/">dotty-example-project</a>, ..}
maven-plugins\{<a href="maven-plugins/README.md">README.md</a>, <a href="./maven-plugins/scala-maven-plgin">scala-maven-plugin</a>, etc.}
myexamples\{<a href="myexamples/README.md">README.md</a>, <a href="myexamples/00_AutoParamTupling/">00_AutoParamTupling</a>, ..}
plugin-examples\{<a href="plugin-examples/README.md">README.md</a>, <a href="plugin-examples/DivideZero/">DivideZero</a>, ..}
rockthejvm-examples\{<a href="rockthejvm-examples/README.md">README.md</a>, <a href="rockthejvm-examples/Enums/">Enums</a>, ..}
<a href="https://github.com/michelou/scala3">scala3</a>\     <i>(Git submodule)</i>
semanticdb-examples\{<a href="semanticdb-examples/README.md">README.md</a>, <a href="semanticdb-examples/hello/">hello</a>, ..}
<a href="CONTRIBUTIONS.md">CONTRIBUTIONS.md</a>
<a href="DEPS.md">DEPS.md</a>
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
<a href="UBUNTU_WSL.md">UBUNTU_WSL.md</a>
</pre>

where

- directory [**`bin\`**](bin/) provides several utility [batch files][windows_batch_file].
- file [**`bin\cfr-0.152.zip`**](bin/cfr-0.152.zip) contains a zipped distribution of [CFR][cfr_releases].
- directory [**`bin\3.2\`**](bin/3.2/) contains the batch commands for [Scala 3][scala3_lts_relnotes].
- directory [**`bin\dotty\`**](bin/dotty/) contains several [batch files][windows_batch_file]/[bash scripts][unix_bash_script] for building the [Scala 3][scala3_home] software distribution on a Windows machine.
- directory [**`docs\`**](docs/) contains [Scala 3][scala3_home] related papers/articles (see file [**`docs\README.md`**](docs/README.md)).
- directory [**`examples\`**](examples/) contains [Scala 3][scala3_home] examples grabbed from various websites (see file [**`examples\README.md`**](examples/README.md)).
- directory [**`maven-plugins\`**](maven-plugins) presents our Maven plugin [`scala-maven-plugin`](./maven-plugins/README.md#scala_maven_plugin).
- directory [**`myexamples\`**](myexamples/) contains self-written [Scala 3][scala3_home] examples (see file [**`myexamples\README.md`**](myexamples/README.md)).
- directory [**`plugin-examples\`**](plugin-examples/) contains [Scala 3][scala3_home] plugin examples (see file [**`plugin-examples\README.md`**](plugin-examples/README.md)).
- directory [**`rockthejvm-examples\`**](rockthejvm-examples/) contains [Scala 3][scala3_home] code examples (see file [**`rockthejvm-examples\README.md`**](rockthejvm-examples/README.md)).
- directory **`scala3\`** contains our fork of the [scala/scala3][github_scala_scala3] repository as a [Github submodule](.gitmodules).
- directory [**`semanticdb-examples\`**](semanticdb-examples/) contains [SemanticDB][semanticdb_guide] code examples (see file [**`semanticdb-examples\README.md`**](semanticdb-examples/README.md)).
- file [**`CONTRIBUTIONS.md`**](CONTRIBUTIONS.md) lists PRs and issues we reported so far.
- file [**`DEPS.md`**](DEPS.md) lists library dependencies of available Scala distributions.
- file [**`README.md`**](README.md) is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch command for setting up our environment.
- file [**`UBUNTU_WSL.md`**](UBUNTU_WSL.md) presents a [Scala 3][scala3_home] code examples in [Ubuntu WSL][wsl].

<!--
> **:mag_right:** We use [VS Code][microsoft_vscode] with the extension [Markdown Preview Github Styling](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) to edit our Markdown files (see article ["Mastering Markdown"](https://guides.github.com/features/mastering-markdown/) from [GitHub Guides][github_guides].
-->

We also define a virtual drive &ndash; e.g. drive **`Y:`** &ndash; in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).
> **:mag_right:** Inside batch file [**`setenv.bat`**](./setenv.bat) we use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> Y: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\dotty-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="commands">Batch/Bash commands</span> [**&#x25B4;**](#top)

We distinguish different sets of batch/bash commands:

1. [**`setenv.bat`**](setenv.bat) &ndash; This batch command makes external tools such as [**`maven.cmd`**][apache_maven_cli], [**`mill.bat`**][mill_cli] and [**`sbt.bat`**][sbt_cli] directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; <a href="setenv.bat">setenv</a> help</b>
   Usage: setenv { &lt;option&gt; | &lt;subcommand&gt; }
   &nbsp;
     Options:
       -bash       start Git bash shell instead of Windows command prompt
       -debug      print commands executed by this script
       -verbose    print progress messages
   &nbsp;
     Subcommands:
       help        print this help message
   </pre>

2. Directory [**`bin\`**](bin/) &ndash; This directory contains several utility batch files:
   - [**`cleanup.bat`**](bin/cleanup.bat) removes the generated class files from every example directory (both in [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) directories).
   - [**`dirsize.bat <dir_path_1> ..`**](bin/dirsize.bat) prints the size in Kb/Mb/Gb of the specified directory paths.
   - [**`getnightly.bat`**](bin/getnightly.bat) downloads/installs the distribution from the latest [Dotty nightly build](https://search.maven.org/search?q=g:ch.epfl.lamp).
   - [**`searchjars.bat <class_name>`**](bin/searchjars.bat) searches for the given class name into all Scala JAR files.
   - [**`timeit.bat <cmd_1> { & <cmd_2> }`**](bin/timeit.bat) prints the execution time of the specified commands.
   - [**`touch.bat <file_path>`**](bin/touch.bat) updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory [**`bin\3.0\`**](bin/3.0/) - This directory contains batch files to be copied to the **`bin\`** directory of the [Scala 3][scala3_home] installation for versions *prior to 3.0.2* in order to use the [**`scalac.bat`**](bin/3.0/scalac.bat), [**`scaladoc.bat`**](bin/3.0/scaladoc.bat) and [**`scala.bat`**](bin/3.0/scala.bat) commands on **Microsoft Windows**.
    > **&#9755;** Starting with version 3.0.2 those batch files are included in the [Scala 3][scala3_lts_releases] software distribution (see [PR#13006](https://github.com/scala/scala3/pull/13006), itself based on [PR#5444][github_PR5444]).

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b c:\opt\scala3-3.3.7\bin</b>
    <a href="https://github.com/scala/scala3/blob/master/dist/bin/common">common</a>
    <a href="bin/3.0/common.bat">common.bat</a>
    <a href="https://github.com/scala/scala3/blob/master/dist/bin/scala">scala</a>
    <a href="bin/3.0/scala.bat">scala.bat</a>
    <a href="https://github.com/scala/scala3/blob/master/dist/bin/scalac">scalac</a>
    <a href="bin/3.0/scalac.bat">scalac.bat</a>
    <a href="https://github.com/scala/scala3/blob/master/dist/bin/scalad">scaladoc</a>
    <a href="bin/3.0/scaladoc.bat">scaladoc.bat</a>
    </pre>

<!-- ## removed on 2018-10-05 ##
    > **NB.** Prior to version 0.9-RC1 the [**`dotr`**](bin/0.9/dotr.bat) command did hang on Windows due to implementation issues with the Dotty [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop). This [issue](https://github.com/scala/scala3/pull/4680) has been fixed by using [JLine 3](https://github.com/jline/jline3) in the REPL.
-->

4. File [**`bin\dotty\build.bat`**](bin/dotty/build.bat) - This batch command generates the [Scala 3][scala3_home] software distribution from the Windows command prompt.

5. File [**`bin\dotty\build.sh`**](bin/dotty/build.sh) - This bash command generates the [Scala 3][scala3_home] software distribution from the [Git Bash][git_bash] command prompt.

6. File [**`examples\*\build.bat`**](examples/dotty-example-project/build.bat) - Finally each example can be built/run using the [**`build.bat`**](examples/dotty-example-project/build.bat) command.<br/>
    > **&#9755;** We favor [**`build.bat`**](examples/dotty-example-project/build.bat) for the following reasons:
    > - It matches user commands executed from the Windows command prompt.
    > - It provides subcommands for working with <a href="https://www.benf.org/other/cfr/">CFR</a>, <a href="https://scalameta.org/scalafmt/">Scalafmt</a>, <a href="https://junit.org/junit4/">JUnit</a> and more.
    > - Code examples are simple (mostly one single source file).
    > - We don't need the [**`sbt`** ][sbt_cli] machinery (eg. [library dependencies][sbt_libs], [sbt server][sbt_server]).

    <pre style="font-size:80%;">
    <b>&gt; <a href="examples/dotty-example-project/build.bat">build</a></b>
    Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
    &nbsp;
      Options:
        -debug           print commands executed by this script
        -explain         set compiler option -explain
        -explain-types   set compiler option -explain-types
        -main:&lt;name&gt;     define main class name (default: Main)
        -print           print IR after compilation phase 'lambdaLift'
        -scala2          use Scala 2 tools
        -scala3          use Scala 3 tools (default)
        -tasty           compile both from source and <a href="https://github.com/scala/scala3/blob/master/tasty/src/dotty/tools/tasty/TastyFormat.scala">TASTy files</a>
        -timer           print the execution time
        -verbose         print progress messages
    &nbsp;
      Subcommands:
        clean            delete generated files
        compile          compile Java/Scala source files
        decompile        decompile generated code with <a href="https://www.benf.org/other/cfr/"><b>CFR</b></a>
        doc              generate HTML documentation
        help             print this help message
        lint             analyze Scala source files with <a href="https://scalameta.org/scalafmt/">Scalafmt</a>
        run[:i]          execute main class (instrumented execution: :i)
        test             execute unit tests with <a href="https://junit.org/junit4/">JUnit</a>
    &nbsp;
      Properties:
      (to be defined in SBT configuration file project\build.properties)
        main.class       alternative to option -main:&lt;name&gt;
        main.args        list of arguments to be passed to main class
    </pre>

## <span id="tools">Optional tools</span> [**&#x25B4;**](#top)

1. Build tools

    Code examples in directories [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) can also be built with the following tools as an alternative to the **`build.bat`** command (see [**`examples\README.md`**](examples/README.md) and [**`myexamples\README.md`**](myexamples/README.md) for more details):

    | Build&nbsp;tool | Build&nbsp;file | Parent&nbsp;file | Usage example |
    |:----------------|:----------------|:-----------------|:--------------|
    | [**`ant.bat`**][apache_ant_cli] | [`build.xml`](examples/enum-Planet/build.xml) | [`build.xml`](examples/build.xml) | **`ant`**`clean compile run` |
    | [**`bazel.exe`**][bazel_cli] | [`BUILD`](examples/enum-Planet/BUILD) | n.a. | **`bazel`**`run :enum-Planet` |
    | [**`cmd.exe`**][cmd_cli] | [`build.bat`](examples/enum-Planet/build.bat) | | `build clean run` |
    | [**`gradle.bat`**][gradle_cli] | [`build.gradle`](examples/enum-Planet/build.gradle) | [`common.gradle`](examples/common.gradle) | **`gradle`**`clean build run` |
    | [**`make.exe`**][gmake_cli] | [`Makefile`](examples/enum-Planet/Makefile) | [`Makefile.inc`](examples/Makefile.inc) | **`make`**`clean run` |
    | [**`mill.bat`**][mill_cli] | [`build.sc`](examples/enum-Planet/build.sc) | [`common.sc`](examples/common.sc) | **`mill -i app`** |
    | [**`mvn.cmd`**][apache_maven_cli] | [`pom.xml`](examples/enum-Planet/pom.xml) | [`pom.xml`](examples/pom.xml) | **`mvn`**`clean compile test` |
    | [**`sbt.bat`**][sbt_cli] | [`build.sbt`](examples/enum-Planet/build.sbt) | n.a. | **`sbt`**`clean compile run` |

2. Decompiler tools

    As an alternative to the standard [**`javap.exe`**][javap_cli] class decompiler one may use **`cfr.bat`** (simply extract [**`bin\cfr-0.152.zip`**](bin/cfr-0.152.zip) to **`c:\opt\`**) which prints [Java source code][java_jls] instead of [Java bytecode][java_bytecode]:

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://www.benf.org/other/cfr/">cfr</a> myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
    /*
     * Decompiled with CFR 0.152.
     */
    <b>package</b> myexamples;
    
    <b>import</b> myexamples.Main$;
    
    <b>public final class</b> Main {
        <b>public static void</b> test01() {
            Main$.MODULE$.test01();
        }
    
        <b>public static void</b> main(String[] arrstring) {
            Main$.MODULE$.main(arrstring);
        }
    
        <b>public static void</b> test02() {
            Main$.MODULE$.test02();
        }
    }
    </pre>

    Here is the console output from command [**`javap.exe`**][javap_cli] with option **`-c`** for the same class file:

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javap.html">javap</a> -c myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
    Compiled from "Main.scala"
    public final class myexamples.Main {
      public static void main(java.lang.String[]);
        Code:
           0: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.getstatic">getstatic</a>     #13                 <span style="color:green;">// Field myexamples/Main$.MODULE$:Lmyexamples/Main$;</span>
           3: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.aload_n">aload_0</a>
           4: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.invokevirtual">invokevirtual</a> #15                 <span style="color:green;">// Method myexamples/Main$.main:([Ljava/lang/String;)V</span>
           7: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.return">return</a>
    
      public static void test02();
        Code:
           0: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.getstatic">getstatic</a>     #13                 <span style="color:green;">// Field myexamples/Main$.MODULE$:Lmyexamples/Main$;</span>
           3: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.invokevirtual">invokevirtual</a> #19                 <span style="color:green;">// Method myexamples/Main$.test02:()V</span>
           6: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.return">return</a>
    
      public static void test01();
        Code:
           0: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.getstatic">getstatic</a>     #13                 <span style="color:green;">// Field myexamples/Main$.MODULE$:Lmyexamples/Main$;</span>
           3: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.invokevirtual">invokevirtual</a> #22                 <span style="color:green;">// Method myexamples/Main$.test01:()V</span>
           6: <a href="https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-6.html#jvms-6.5.return">return</a>
    }
    </pre>

## <span id="examples">Usage examples</span> [**&#x25B4;**](#top)

### **`setenv.bat`**

We execute command [**`setenv.bat`**](setenv.bat) once to setup our development environment; it makes external tools such as [**`bazel.exe`**][bazel_cli], [**`mvn.cmd`**][apache_maven_cli], [**`sbt.bat`**][sbt_cli] and [**`git.exe`**][git_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   javac 17.0.16, scalac 2.13.17, scalac 3.3.7, scalafmt 3.7.17,
   ant 1.10.15, gradle 9.1.0, mvn 3.9.11, sbt 1.11.7, scala-cli 1.9.1,
   mill 1.0.6, bazel 8.4.2, cfr 0.152, make 4.4.1, python 3.11.1,
   jacoco 0.8.14, git 2.51.1, diff 3.12, bash 5.2.37(1)

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> sbt scala-cli</b>
C:\opt\sbt\bin\sbt
C:\opt\sbt\bin\<a href="https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html" ref="external">sbt.bat</a>
C:\opt\scala-cli\<a href="https://scala-cli.virtuslab.org/docs/commands/basics">scala-cli.exe</a>
</pre>

Other development tools such as [**`javac.exe`**][javac_cli] and [**`scalac.bat`**][scalac_cli] are accessible through the corresponding environment variable, e.g. **`JAVA_HOME`** for **`javac.exe`**, **`SCALA_HOME`** resp. **`SCALA3_HOME`** for **`scalac.bat`** and **`PYTHON_HOME`** for **`python.exe`**.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> javac</b>
INFO: Could not find files for the given pattern(s).
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> /r %JAVA_HOME% javac</b>
C:\opt\jdk-temurin-17.0.16_8\bin\javac.exe
&nbsp;
<b>&gt; %JAVA_HOME%\bin\<a href="https://docs.oracle.com/en/java/javase/17/docs/specs/man/javac.html">javac</a> -version</b>
javac 17.0.16
</pre>

Command [**`setenv.bat -verbose`**](setenv.bat) also prints the tool paths and defined environment variables:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   javac 17.0.16, scalac 2.13.17, scalac 3.3.7, scalafmt 3.7.12,
   ant 1.10.15, gradle 9.1.0, mvn 3.9.11, sbt 1.11.7, scala-cli 1.9.1,
   mill 1.0.6, bazel 8.4.2, cfr 0.152, make 3.81, python 3.11.1,
   jacoco 0.8.14, git 2.51.1, diff 3.12, bash 5.2.37(1)
Tool paths:
   C:\opt\jdk-temurin-11.0.21_9\bin\javac.exe
   C:\opt\scala-2.13.17\bin\scalac.bat
   C:\opt\scala3-3.3.7\bin\scalac.bat
   %LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat
   C:\opt\apache-ant\bin\ant.bat
   C:\opt\gradle\bin\gradle.bat
   C:\opt\mill\mill.bat
   C:\opt\apache-maven\bin\mvn.cmd
   C:\opt\sbt\bin\sbt.bat
   C:\opt\scala-cli\scala-cli.exe
   C:\opt\mill\mill.bat
   C:\opt\bazel\bazel.exe
   C:\opt\cfr-0.152\bin\cfr.bat
   C:\opt\make-3.81\bin\make.exe
   C:\opt\Python-3.11.1\python.exe
   C:\opt\jacoco\lib\jacococli.jar
   C:\opt\Git\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
   C:\opt\Git\bin\bash.exe
Environment variables:
   "ANT_HOME=C:\opt\apache-ant"
   "BAZEL_HOME=c:\opt\bazel"
   "CFR_HOME=C:\opt\cfr-0.152"
   "COURSIER_DATA_DIR=%LOCALAPPDATA%\coursier\data"
   "COURSIER_HOME=C:\opt\coursier-2.1.7"
   "GIT_HOME=C:\opt\Git"
   "GRADLE_HOME=C:\opt\gradle"
   "JAVA_HOME=C:\opt\jdk-temurin-17.0.16_8"
   "JAVA17_HOME=C:\opt\jdk-temurin-17.0.16_8"
   "JAVA21_HOME=C:\opt\jdk-temurin-21.0.8_9"
   "JAVAFX_HOME=C:\opt\javafx-sdk-21.0.5"
   "MSVS_HOME=X:"
   "MSYS_HOME=C:\opt\msys64"
   "PYTHON_HOME=C:\opt\Python-3.11.1"
   "SBT_HOME=C:\opt\sbt"
   "SCALA_CLI_HOME=C:\opt\scala-cli"
   "SCALA_HOME=C:\opt\scala-2.13.17"
   "SCALA3_HOME=C:\opt\scala3-3.3.7"
   "SCALA3_NEXT_HOME=C:\opt\scala3-3.7.4"
Path associations:
   I:\: => %USERPROFILE%\workspace-perso\dotty-examples
</pre>

### **`cleanup.bat`**

Command [**`cleanup.bat`**](bin/cleanup.bat) removes the output directories (ie. **`target\`**) from the example projects: 

<pre style="font-size:80%;">
<b>&gt; <a href="bin/cleanup.bat">cleanup</a></b>
Finished to clean up 2 subdirectories in Y:\dotty\cdsexamples
Finished to clean up 16 subdirectories in Y:\dotty\examples
Finished to clean up 12 subdirectories in Y:\dotty\myexamples
</pre>

### **`dirsize.bat {<dir_name>}`**

Command [**`dirsize.bat`**](bin/dirsize.bat) returns the size (in Kb, Mb or Gb) of the specified directory paths:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/dirsize.bat">dirsize</a> examples myexamples c:\opt\scala3-3.3.7 c:\opt\jdk-temurin-17.0.16_8</b>
Size of directory "examples" is 3.9 Mb
Size of directory "myexamples" is 1.2 Mb
Size of directory "c:\opt\scala3-3.3.7" is 35.7 Mb
Size of directory "c:\opt\jdk-temurin-17.0.16_8" is 304.0 Mb
</pre>

### **`getnightly.bat`**

By default command [**`getnightly.bat`**](bin/getnightly.bat) downloads the library files of the latest [Dotty nightly build][dotty_nightly] available from the [Maven Central Repository][maven_lamp] and saves them into directory **`out\nightly\`**.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a></b>
Usage: getnightly { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -debug      print commands executed by this script
    -timer      print total execution time
    -verbose    print download progress
&nbsp;
  Subcommands:
    activate    activate the nightly build library files
    download    download nighty build files and quit (default)
    help        print this help message
    restore     restore the default Scala library files
</pre>

Command [**`getnightly.bat download`**](bin/getnightly.bat) with options **` -verbose`** also displays the download progress:

<pre style="font-size:80%">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a> -verbose download</b>
Delete directory "out\nightly"
Download Scala 3 nightly files from Maven repository
Downloading file scala3-language-server_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 148.9 Kb
Downloading file scala3-compiler_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 20.3 Mb
Downloading file scala3-sbt-bridge-3.5.0-RC1-bin-20240514-7c9aae3-NIGHTLY.jar ... 31.2 Kb
Downloading file scala3-tasty-inspector_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 17.4 Kb
Downloading file scala3-library_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 1.2 Mb
Downloading file scala2-library-tasty-experimental_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 3 Mb
Downloading file scala3-staging_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 40.7 Kb
Downloading file scala3-presentation-compiler_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 1.7 Mb
Downloading file scala3-library_sjs1_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 1.9 Mb
Downloading file scala3-interfaces-3.5.0-RC1-bin-20240514-7c9aae3-NIGHTLY.jar ... 3.9 Kb
Downloading file scala2-library-cc-tasty-experimental_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 3 Mb
Downloading file scaladoc_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 4.7 Mb
Downloading file tasty-core_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar ... 94.5 Kb
Downloading file antlr4-runtime-4.7.2.jar ... 330 Kb
[...]
Downloading file common ... 6 Kb
Downloading file common.bat ... 2.9 Kb
Converting file common.bat to DOS format
Downloading file scala ... 1.8 Kb
Downloading file scala.bat ... 2.6 Kb
Converting file scala.bat to DOS format
Downloading file scalac ... 2.5 Kb
Downloading file scalac.bat ... 3.7 Kb
Converting file scalac.bat to DOS format
Downloading file scaladoc ... 5 Kb
Downloading file scaladoc.bat ... 4.6 Kb
Converting file scaladoc.bat to DOS format
Finished to download 54 files to directory "%LOCALAPPDATA%\Temp\scala3-nightly"
Retrieve revision for hash "3e105f2" from GitHub repository "scala/scala3"
File "%LOCALAPPDATA%\Temp\scala3-nightly\VERSION":
version:=3.6.2-RC1-bin-20240514-7c9aae3-NIGHTLY
revision:=7c9aae3
buildTime:=2024-05-15 23:09:19+02:00
</pre>

Output directory **`%TEMP%\scala3-nightly\`** contains the two subdirectories **`bin\`** and **`lib\`**:

<pre style="font-size:80%">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b %TEMP%\scala3-nightly\bin %TEMP%\scala3-nightly\lib</b>
common
common.bat
scala
scala.bat
scalac
scalac.bat
scaladoc
scaladoc.bat
antlr-runtime-4.7.2.jar
autolink-0.6.0.jar
[...]
scala-asm-9.7.0-scala-1.jar
scala-library-2.13.15.jar
scala2-library-cc-tasty-experimental_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala2-library-tasty-experimental_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-compiler_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-interfaces-3.5.0-RC1-bin-20240514-7c9aae3-NIGHTLY.jar
scala3-language-server_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-library_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-library_sjs1_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-presentation-compiler_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-sbt-bridge-3.6.2-RC1-bin-20240514-7c9aae3-NIGHTLY.jar
scala3-staging_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scala3-tasty-inspector_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
scaladoc_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
snakeyaml-2.0.jar
strftime4j-1.0.6.jar
tasty-core_3.6.2-RC1-bin-20241025-91ef921-NIGHTLY.jar
</pre>
<!--
> **:mag_right:** A few notes about the distributed Java archives:
> - Dotty versions up to `0.18.0` depend on **`scala-library-2.12.8.jar`**; Dotty versions `0.18.1` and newer depend on **`scala-library-2.13.x.jar`**.
> - Starting with Dotty version `0.22.0` package **`dotty.tools.tasty`** is distributed separately in archive **`tast-core_<xxx>.jar`**.
> - Starting with Dotty version `0.28.0` package **`dotty-library_sjs1.x.jar`** is part of the software distribution.<br/>&nbsp;
-->

Concretely, subcommand **`activate`** switches to the nightly build version and subcommand **`restore`** restore the path to the [Scala 3][scala3_home] installation directory.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a> activate</b>
Active Scala 3 installation is 3.6.2-RC1-bin-20241025-91ef921-NIGHTLY (was 3.3.7)

<b>&gt; %SCALA3_HOME%\bin\<a href="bin/3.0/scalac.bat">scalac</a> -version</b>
Scala compiler version 3.6.2-RC1 -- Copyright 2002-2024, LAMP/EPFL

<b>&gt; <a href="bin/getnightly.bat">getnightly</a> restore</b>
Active Scala 3 installation is 3.3.7

<b>&gt; %SCALA3_HOME%\bin\<a href="bin/3.0/scalac.bat">scalac</a> -version</b>
Scala compiler version 3.3.7 -- Copyright 2002-2024, LAMP/EPFL
</pre>

> **:warning:** You need *write access* to the [Scala 3][scala3_home] installation directory (e.g. **`C:\opt\scala3-3.3.7\`** in our case) in order to successfully run the **`activate/reset`** subcommands.

### `searchjars.bat <class_name>`

Command [**`searchjars.bat`**](bin/searchjars.bat) helps us to search for class file names in the following directories: project's **`lib\`** directory (*if present*), Scala's **`lib\`** directory, Java's **`lib\`** directory and Ivy/Maven default local directories.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> -help</b>
Usage: searchjars { &lt;option&gt; | &lt;class_name&gt; }
&nbsp;
  Options:
    -artifact        search in ~\.ivy2 and ~\.m2 directories
    -help            print this help message
    -ivy             search in ~\.ivy directory
    -java            search in Java library directories
    -maven           search in ~\.m2 directory
    -scala           search in Scala library directories
    -verbose         print progress messages
&nbsp;
  Arguments:
    &lt;class_name&gt;     class name
</pre>

For instance we get the following output when passing class name **`System`** to command [**`searchjars.bat`**](bin/searchjars.bat) (class file names are printed with full path and are prefixed with their containing [JAR file][jar_file]):

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> System</b>
Searching for class name System in archive files C:\opt\scala3-3.3.7\lib\*.jar
  jline-reader-3.19.0.jar:org/jline/reader/impl/completer/SystemCompleter.class
  scala-library-2.13.15.jar:scala/sys/SystemProperties$.class
  scala-library-2.13.15.jar:scala/sys/SystemProperties.class
Searching for class name System in archive files C:\opt\scala-2.13.17\lib\*.jar
  jline-3.19.0.jar:org/jline/builtins/SystemRegistryImpl$CommandOutputStream.class
  [...]
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
Searching for class name System in archive files C:\opt\jdk-temurin-17.0.16_8\lib\*.jar
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem$1.class
  [...]
  jrt-fs.jar:jdk/internal/jrtfs/SystemImage$2.class
  jrt-fs.jar:jdk/internal/jrtfs/SystemImage.class
Searching for class name System in archive files c:\opt\javafx-sdk-17.0.16_8\lib\*.jar
  javafx.graphics.jar:com/sun/glass/ui/SystemClipboard.class
  [...]
  javafx.graphics.jar:com/sun/javafx/tk/TKSystemMenu.class
  javafx.web.jar:com/sun/webkit/FileSystem.class
</pre>

Searching for an unknown class name - e.g. **`BinarySearch`** - produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> BinarySearch</b>
Searching for class name BinarySearch in archive files C:\opt\scala3-3.3.7\lib\*.jar
Searching for class name BinarySearch in archive files C:\opt\scala-2.13.17\lib\*.jar
Searching for class name BinarySearch in archive files C:\opt\jdk-temurin-17.0.16_8\lib\*.jar
</pre>

Searching for **`FileSystem`** with option **`-artifact`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> FileSystem -artifact</b>
Searching for class name FileSystem in archive files C:\opt\scala3-3.3.7\lib\*.jar
Searching for class name FileSystem in archive files C:\opt\scala-2.13.17\lib\*.jar
Searching for class name FileSystem in archive files c:\opt\jdk-temurin-17.0.16_8\lib\*.jar
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem$1.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider$1.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider$JrtFsLoader.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider.class
Searching for class name FileSystem in archive files c:\opt\javafx-sdk-17\lib\*.jar
  javafx.web.jar:com/sun/webkit/FileSystem.class
Searching for class name FileSystem in archive files %USERPROFILE%\.ivy2\cache\*.jar
  okhttp-3.14.2.jar:okhttp3/internal/io/FileSystem$1.class
  okhttp-3.14.2.jar:okhttp3/internal/io/FileSystem.class
  ivy-2.3.0-sbt-839fad1cdc07cf6fc81364d74c323867230432ad.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  ivy-2.3.0-sbt-88d6a93d15f9b029958c1c289a8859e8dfe31a19.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  ivy-2.3.0-sbt-fa726854dd30be842ff9e6d2093df6adfe3871f5.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
Searching for class name FileSystem in archive files %USERPROFILE%\.m2\repository\*.jar
  commons-io-2.2.jar:org/apache/commons/io/FileSystemUtils.class
  commons-io-2.5.jar:org/apache/commons/io/FileSystemUtils.class
  commons-io-2.6.jar:org/apache/commons/io/FileSystemUtils.class
  ivy-2.4.0.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  sigar-1.6.4.jar:org/hyperic/sigar/FileSystem.class
  [...]
  stagemonitor-os-0.88.9.jar:org/stagemonitor/os/metrics/FileSystemMetricSet.class
</pre>

### `timeit.bat <cmd_1> { & <cmd_i> }`

Batch file [**`timeit.bat`**](bin/timeit.bat) prints the execution time (`hh:MM:ss` format) of the specified command (possibly given with options and parameters):

<pre style="font-size:80%;">
<b>&gt; <a href="bin/timeit.bat">timeit</a> dir /b</b>
.gitignore
.gradle
build.bat
build.gradle
build.sbt
build.sc
build.xml
pom.xml
project
settings.gradle
src
target
Execution time: 00:00:01
&nbsp;
<b>&gt; <a href="bin/timeit.bat">timeit</a> build clean compile</b>
Execution time: 00:00:08
</pre>

Chaining of commands is also possible. Note that the command separator (either **`&&`** or **`&`**) must be escaped if the command chain is not quoted. For instance:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/timeit.bat">timeit</a> build clean compile ^&^& ant run</b>
...
Execution time: 00:00:11
<b>&gt; <a href="bin/timeit.bat">timeit</a> "build clean compile && ant run"</b>
...
Execution time: 00:00:11
</pre>

> **:mag_right:** The **`&&`** command separator performs error checking - that is, the commands to the right of the **`&&`** command run ***if and only if*** the command to the left of **`&&`** succeeds. The **`&`** command ***does not*** perform error checking - that is, all commands run.

<!--
### `touch.bat`

The [**`touch.bat`**](bin/touch.bat) command


### `updateprojs`

Command [**`updateprojs`**](bin/updateprojs.bat) updates the following software versions:

| Project file | Variable | Example |
| :----------- | :------: | :------ |
| `build.sbt` | `dottyVersion` | `3.3.3` &rarr; `3.3.4` |
| `build.sc` | `scalaVersion` | `3.3.3` &rarr; `3.3.4` |
| `project\build.properties` | `sbt.version` | `1.9.9` &rarr; `1.10.0` |
| `project\plugins.sbt` | `sbt-dotty` | `0.5.4` &rarr; `0.5.5` |

> **:construction:** Currently we have to edit the value pairs (old/new) directly in the batch file.

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; <a href="bin/updateprojs.bat">updateprojs</a></b>
Parent directory: Y:\dotty\examples
   Warning: Could not find file hello-scala\project\plugins.sbt
   Warning: Could not find file UnionTypes_0.4\project\plugins.sbt
   Updated 17 build.sbt files
   Updated 17 project\build.properties files
   Updated 15 project\plugins.sbt files
Parent directory: Y:\dotty\myexamples
   Warning: Could not find file 07_Value_Types\build.sbt
   Warning: Could not find file 07_Value_Types\project\build.properties
   Warning: Could not find file 07_Value_Types\project\plugins.sbt
   Updated 11 build.sbt files
   Updated 11 project\build.properties files
   Updated 11 project\plugins.sbt files
</pre>
-->

### `build.bat`

Batch file [**`build.bat`**](examples/enum-Planet/build.bat) is a basic build script consisting of ~800 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_07">[7](#footnote_07)</sup>.

Running command [**`build`.bat**](examples/enum-Planet/build.bat) with ***no*** option in project [**`examples\enum-Planet`**](examples/enum-Planet/) generates the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="examples/enum-Planet/build.bat">build</a> clean compile run</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on SATURN (5) is 1.0660155388115666
Your weight on VENUS (1) is 0.9049990998410455
Your weight on URANUS (6) is 0.9051271993894251
Your weight on EARTH (2) is 0.9999999999999999
Your weight on NEPTUNE (7) is 1.1383280724696578
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406</pre>

More usage examples are presented in [**`examples\README.md`**](examples/README.md) resp. [**`myexamples\README.md`**](myexamples/README.md)


### `scala.bat`

[Scala REPL][scala_repl] is an interactive tool for evaluating [Scala] expressions. Internally, it executes a source script by wrapping it in a template and then compiling and executing the resulting program.

   > **:warning:** Batch file [**`scala.bat`**](bin/3.0/scala.bat) is based on the bash script [**`scala`**][github_scala] available from the standard [Scala 3 distribution][scala3_lts_releases]. We also have submitted pull request [#5444][github_PR5444] to add that batch file to the Scala 3 distribution.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> scala</b>
C:\opt\scala3-3.3.7\bin\scala
C:\opt\scala3-3.3.7\bin\scala.bat

<b>&gt; <a href="bin/3.0/scala.bat">scala</a> -version</b>
Scala code runner version 3.3.7-RC1 -- Copyright 2002-2024, LAMP/EPFL

<b>&gt; <a href="bin/3.0/scala.bat">scala</a></b>
Starting scala REPL...
scala> :help
The REPL has several commands available:

:help                    print this summary
:load &lt;path&gt;             interpret lines in a file
:quit                    exit the interpreter
:type &lt;expression&gt;       evaluate the type of the given expression
:imports                 show import history
:reset                   reset the repl to its initial state, forgetting all session entries

<b>scala&gt;</b> System.getenv().get("JAVA_HOME")
val res0: String = C:\opt\jdk-temurin-17.0.16_8

<b>scala&gt;</b> System.getenv().get("SCALA3_HOME")
val res1: String = C:\opt\scala3-3.3.7-RC1

<b>scala&gt;</b> :load myexamples/HelloWorld/src/main/scala/HelloWorld.scala
// defined object HelloWorld

<b>scala&gt;</b> HelloWorld.main(Array())
Hello world!

<b>scala&gt;</b>:quit
</pre>

<!-- ===================================================================== -->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Scala 3 LTS versions*** [↩](#anchor_01)  <!-- 2024-02-18 -->

<dl><dd>
<p>The distinction between LTS and Next versions of Scala 3 is presented on the page <a href="https://www.scala-lang.org/blog/2022/08/17/long-term-compatibility-plans.html#the-compatibility-guarantees-in-the-new-model">"Long-term compatibility plans for Scala 3"</a> posted on August 17, 2022.</p>
<p>In particular it makes the following statement : "We suggest <i>end users</i> stick to the LTS version. It will give you the best tooling support and a stable compiler. If you are migrating a bigger project from Scala 2, you should migrate it straight to the newest LTS."</p>
</dd></dl>

<span id="footnote_02">[2]</span> ***Java LTS versions*** [↩](#anchor_02) <!-- 2018-11-18 -->

<dl><dd>
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Current LTS versions are (from <a href="https://www.oracle.com/java/technologies/java-se-support-roadmap.html">Oracle's support roadmap</a>):
</dd>
<dd>
<table>
<tr><th>Java LTS Version</th><th>GA</th><th>End of life</th></tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java25" rel="external">25</a></td>
  <td>September 2025</td>
  <td>September 2033</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java21" rel="external">21</a></td>
  <td>September 2023</td>
  <td>September 2031</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java17" rel="external">17</a></td>
  <td>September 2021</td>
  <td>September 2029</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java11" rel="external">11</a></td>
  <td>September 2018</td>
  <td>September 2026</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java8" rel="external">8</a></td>
  <td> March 2014</td>
  <td>December 2030 <sup>(1)</sup></td>
</tr>
</table>
<div style="font-size:80%;"><sup>(1)</sup> The Extended Support uplift fee will be waived for the period March 2022 - December 2030 for Java SE 8.
</dd>
<dd>
<b>NB.</b> See also <a href="https://www.azul.com/products/azul-support-roadmap/" rel="external">Zulu's support roadmap</a>.
</dd></dl>

<!--======================================================================-->

<span id="footnote_03">[3]</b> ***Using Bazel on Windows*** [↩](#anchor_03)

<dl><dd>
See also the <a href="https://bazel.build/release#support-matrix" rel="external">Support matrix</a> on the <a href="https://bazel.build/" rel="external">Bazel</a> website.

<table>
<tr><th>Bazel LTS Version</th><th>GA</th><th>End of support</th></tr>
<tr>
  <td><a href="https://bazel.build/about/roadmap#bazel-8.0" rel="external">8.0.0</a></td>
  <td>Late 2024</a></td>
  <td>-</td>
</tr>
<tr>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/7.4.0">7.4.0</a></td>
  <td>October 2024</td>
  <td>December 2026</td>
</tr>
<tr>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/7.3.1" rel="external">7.3.1</a></td>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/7.0.0">December 2023</a></td>
  <td>December 2026</td>
</tr>
<tr>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/6.5.0" rel="external">6.5.0</a></td>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/6.0.0">December 2022</a></td>
  <td>December 2025</td>
</tr>
<tr>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/5.4.1" rel="external">5.4.1</a></td>
  <td><a href="https://github.com/bazelbuild/bazel/releases/tag/5.0.0">January 2022</a></td>
  <td>January 2025</td>
</tr>
</table>
</dd>
<dd>
Read the page <a href="https://docs.bazel.build/versions/master/windows.html#build-on-windows" rel="external">Builds on Windows</a> of the <a href="https://www.bazel.build/" rel="external">Bazel website</a> for tips to build with MSVC, Clang, Java or Python on a Windows machine.
</dd>
<dd>
For instance, for Visual Studio 2019, we set variable <b><code>BAZEL_VC</code></b> to the Visual C++ Build Tools installation directory:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1" rel="external">set</a></b> "BAZEL_VC=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC"
</pre>
</dd></dl>

<!--======================================================================-->

<span id="footnote_04">[4]</span> ***JaCoCo and Java support*** [↩](#anchor_04)

<dl><dd>
<table style="font-size:90%;">
<tr>
  <th><a href="https://www.eclemma.org/jacoco/" rel="external">JaCoCo</a> version</th>
  <th>Supported Java version</th>
  <th>Depends on <a href="https://asm.ow2.io/" rel="external">ASM</a></th>
</tr>
<tr>
  <td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.14</a>&nbsp;<i style="font-size:80%;">(March&nbsp;2024)</i></td>
  <td>21 and 22</td>
  <td><a href="https://asm.ow2.io/versions.html">9.7</a></td>
</tr>
<tr>
  <td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.11</a>&nbsp;<i style="font-size:80%;">(Oct&nbsp;2023)</i></td>
  <td>21 and 22</td>
  <td><a href="https://asm.ow2.io/versions.html">9.6</a></td>
</tr>
<tr>
  <td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.10.2</a>&nbsp;<i style="font-size:80%;">(April&nbsp;2023)</i></td>
  <td>19 and 20</td>
  <td><a href="https://asm.ow2.io/versions.html">9.5</a></td>
</tr>
<tr>
  <td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.9</a>&nbsp;<i style="font-size:80%;">(March&nbsp;2023)</i></td>
  <td>19 and 20</td>
  <td><a href="https://asm.ow2.io/versions.html">9.5</a></td>
</tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.8</a> <i style="font-size:80%;">(April 2022)</i></td><td>17 and 18</td><td><a href="https://asm.ow2.io/versions.html">9.2</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.7</a> <i style="font-size:80%;">(May 2021)</i></td><td>15 and 16</td><td><a href="https://asm.ow2.io/versions.html">9.1</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.6</a> <i style="font-size:80%;">(Sept 2020)</i></td><td>14</td><td><a href="https://asm.ow2.io/versions.html">8.2</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.5</a> <i style="font-size:80%;">(Oct 2019)</i></td><td>13</td><td><a href="https://asm.ow2.io/versions.html">7.2</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.4</a> <i style="font-size:80%;">(May 2019)</i></td><td>12</td><td><a href="https://asm.ow2.io/versions.html">7.1</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.3</a> <i style="font-size:80%;">(Jan 2019)</i></td><td>11</td><td><a href="https://asm.ow2.io/versions.html">7.0</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.2</a> <i style="font-size:80%;">(Aug 2018)</i></td><td>&nbsp;</td><td><a href="https://asm.ow2.io/versions.html">6.3.2</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.1</a> <i style="font-size:80%;">(March 2018)</i></td><td>10</td><td>&nbsp;</td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.0</a> <i style="font-size:80%;">(Jan 2018)</i></td><td>9</td><td><a href="https://asm.ow2.io/versions.html">6.0</a></td></tr>
</table>
</dd></dl>

<!--======================================================================-->

<span id="footnote_05">[5]</span> ***Updating Mill*** [↩](#anchor_05) <!-- 2025-10-19 -->

<dl><dd>
Given the following <a href="">Mill</a> installation directory :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/dir" rel="external">dir</a> /b /s c:\opt\mill</b>
c:\opt\mill\mill.bat
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> Script c:\opt\mill\mill.bat</b>
rem Script Version: 1.0.6
</pre>
we download the batch file <a href="https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.0.6/mill-dist-1.0.6-mill.bat"><code>mill-dist-1.0.6-mill.bat</code></a> from the following
<a href="https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.0.6/">1.0.6 distribution page</a>, rename it and overwrite our local file <code>mill.bat</code>.
<pre style="font-size:80%;">
<b>&gt; <a href="https://mill-build.org/mill/cli/flags.html" rel="external">mill</a> --version | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> Mill</b>
Mill Build Tool version 1.0.6
</pre>
</dd></dl>

<!--======================================================================-->

<span id="footnote_06">[6]</span> ***Scala 3 Next*** [↩](#anchor_06) <!-- 2024-09-07 -->

<dl><dd>
The attentive Scala 3 user will have noticed that the size of the <a href="">Scala 3</a> software distribution has increased significantly with versions <a href="https://github.com/scala/scala3/releases/tag/3.5.0" rel="external">3.5.0</a> and newer.
<table>
<tr><th>Scala 3 Version</th><th>TGZ Archive&nbsp;size</th><th>Installation&nbsp;size</th></tr>
<tr><td>3.3.7&nbsp;LTS</td><td>36 MB</td><td>38.8 MB</td></tr>
<tr><td><a href="https://github.com/scala/scala3/releases/tag/3.5.0">3.5.0&nbsp;Next</a</td><td>70 MB</td><td style="color:red;">131 MB</td></tr>
<tr><td><a href="https://github.com/scala/scala3/releases/tag/3.7.0">3.7.0&nbsp;Next</a></td><td>73 MB</td><td style="color:red;">153 MB</td></tr>
</table>
That size increase of the Scala 3 software distribution comes from a big reorganization of its contents :
<ul>
<li><a href="https://github.com/VirtusLab/scala-cli/releases" rel="external"><code>scala-cli</code></a> (91 MB) from <a href="https://scala-cli.virtuslab.org/">VIRTUSLAB</a> is now part of the distribution</li>
<li>directory <code>lib\</code> now contains only 3 JAR files: .</li>
<li>directory <code>maven2\</code> (40 MB) is new; this application specific Maven repository contains the Maven packages Scala 3 depends on.</li>
</ul>
The section <a href="https://docs.oracle.com/en/java/javase/17/docs/specs/jar/jar.html#class-path-attribute">"<b>Class-Path Attribute</b>"</a> of the <a href="https://docs.oracle.com/en/java/javase/17/docs/specs/">Java Platform Specification</a> describes the usage the manifest attribute <code>Class-Path</code>. We present its usage in the manifest file <code>lib\scala.jar\META-INF\MANIFEST.MF</code> :
<pre style="font-size:80%;">
Manifest-Version: 1.0
<a href="https://docs.oracle.com/en/java/javase/17/docs/specs/jar/jar.html#class-path-attribute">Class-Path</a>: ../maven2/org/scala-lang/scala3-interfaces/3.5.0/scala3-in
 terfaces-3.5.0.jar ../maven2/org/scala-lang/scala3-compiler_3/3.5.0/s
 cala3-compiler_3-3.5.0.jar ../maven2/org/scala-lang/scala3-library_3/
 3.5.0/scala3-library_3-3.5.0.jar ../maven2/org/scala-lang/tasty-core_
 3/3.5.0/tasty-core_3-3.5.0.jar ../maven2/org/scala-lang/modules/scala
 -asm/9.7.0-scala-1/scala-asm-9.7.0-scala-1.jar ../maven2/org/scala-sb
 t/compiler-interface/1.9.6/compiler-interface-1.9.6.jar ../maven2/org
 /jline/jline-reader/3.25.1/jline-reader-3.25.1.jar ../maven2/org/jlin
 e/jline-terminal/3.25.1/jline-terminal-3.25.1.jar ../maven2/org/jline
 /jline-terminal-jna/3.25.1/jline-terminal-jna-3.25.1.jar ../maven2/or
 g/scala-lang/scala-library/2.13.15/scala-library-2.13.15.jar ../maven
 2/org/scala-sbt/util-interface/1.9.8/util-interface-1.9.8.jar ../mave
 n2/org/jline/jline-native/3.25.1/jline-native-3.25.1.jar ../maven2/ne
 t/java/dev/jna/jna/5.14.0/jna-5.14.0.jar
 </pre>
</dd></dl>

 <!--======================================================================-->

<span id="footnote_06">[6]</span> ***Downloads*** [↩](#anchor_06)

<dl><dd>
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<strike><a href="https://github.com/lihaoyi/mill/releases">0.12.9-assembly</a> (mill)</strike> <i style="color:darkred;">(see <a href="#footnote_05">Footnote 5</a>)</i>            <strike><i>( 64 MB)</i></strike>
<a href="https://ant.apache.org/bindownload.cgi">apache-ant-1.10.15-bin.zip</a>                         <i>(  9 MB)</i>
<a href="https://maven.apache.org/download.cgi">apache-maven-3.9.11-bin.zip</a>                        <i>( 10 MB)</i>
<a href="https://github.com/bazelbuild/bazel/releases">bazel-8.4.2-windows-x86_64.zip</a>                     <i>( 40 MB)</i>
<a href="https://gradle.org/install/">gradle-9.1.0-bin.zip</a>                               <i>(124 MB)</i>
<a href="https://www.eclemma.org/jacoco/">jacoco-0.8.14.zip</a>                                  <i>(  4 MB)</i>
<a href="https://github.com/AdoptOpenJDK/jitwatch/releases">jitwatch-ui-1.4.9-shaded-win.jar</a>                   <i>( 36 MB)</i>
<a href="http://repo.msys2.org/distrib/x86_64/">msys2-x86_64-20240727.exe</a>                          <i>( 94 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk8&jvmVariant=hotspot">OpenJDK8U-jdk_x64_windows_hotspot_8u442b06.zip</a>     <i>( 99 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk17&jvmVariant=hotspot">OpenJDK17U-jdk_x64_windows_hotspot_17.0.16_8.zip</a>   <i>(188 MB)</i>
<a href="https://adoptium.net/fr/temurin/releases/?variant=openjdk21&jvmVariant=hotspot">OpenJDK21U-jdk_x64_windows_hotspot_21.0.8_9.zip</a>    <i>(191 MB)</i>
<a href="https://gluonhq.com/products/javafx/">openjfx-17.0.14_windows-x64_bin-sdk.zip</a>            <i>( 39 MB)</i>
<a href="https://gluonhq.com/products/javafx/">openjfx-17.0.14_windows-x64_bin-jmods.zip</a>          <i>( 37 MB)</i>
<a href="https://gluonhq.com/products/javafx/">openjfx-21.0.6_windows-x64_bin-sdk.zip</a>             <i>( 39 MB)</i>
<a href="https://gluonhq.com/products/javafx/">openjfx-21.0.6_windows-x64_bin-jmods.zip</a>           <i>( 37 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.51.1-64-bit.7z.exe</a>                   <i>( 60 MB)</i>
<a href="https://github.com/sbt/sbt/releases" rel="external">sbt-1.11.7.zip</a>                                     <i>( 17 MB)</i>
<a href="https://www.scala-lang.org/files/archive/" rel="external">scala-2.13.17.zip</a>                                  <i>( 22 MB)</i>
<a href="https://github.com/VirtusLab/scala-cli/releases" rel="external">scala-cli-x86_64-pc-win32.zip</a>                      <i>( 31 MB)</i>
<a href="https://github.com/scala/scala3/releases/tag/3.3.7">scala3-3.3.7.zip</a>                                   <i>( 34 MB)</i>
<a href="https://github.com/scala/scala3/releases/tag/3.7.4-RC1">scala3-3.7.4-RC1.zip</a>                               <i>(123 MB)</i>
</pre>
</dd></dl>
<!-- scala3: 3.4.2 = 37 MB, 3.5.0 = 131 MB, 3.5.2 = 138 MB -->

<span id="footnote_07">[7]</span> ***PowerShell*** [↩](#anchor_07) <!-- 2018-05-09 -->

<dl><dd> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make <a href="https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6">PowerShell</a> the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[apache_ant]: https://ant.apache.org/
[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_relnotes]: https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.15.html
[apache_ant_scripting]: https://ant.apache.org/manual/using.html "Writing a Simple Buildfile"
[apache_maven]: https://maven.apache.org/download.cgi
[apache_maven_cli]: https://maven.apache.org/ref/current/maven-embedder/cli.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[apache_maven_relnotes]: https://maven.apache.org/docs/3.9.11/release-notes.html
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[bazel_releases]: https://github.com/bazelbuild/bazel/releases
<!--
5.0   -> https://blog.bazel.build/2022/01/19/bazel-5.0.html
5.1   -> https://blog.bazel.build/2022/03/24/bazel-5.1.html
5.2   -> https://blog.bazel.build/2022/06/08/bazel-5.2.html
5.3   -> https://blog.bazel.build/2022/08/23/bazel-5.3.html
6.0   -> https://blog.bazel.build/2022/12/19/bazel-6.0.html
6.4   -> https://github.com/bazelbuild/bazel/releases/tag/6.4.0
7.0   -> https://blog.bazel.build/2023/12/11/bazel-7-release.html
7.1.0 -> https://github.com/bazelbuild/bazel/releases/tag/7.1.0 
7.2.1 -> https://github.com/bazelbuild/bazel/releases/tag/7.2.1
7.3.0 -> https://github.com/bazelbuild/bazel/releases/tag/7.3.0
7.3.1 -> https://github.com/bazelbuild/bazel/releases/tag/7.3.1
7.4.0 -> https://github.com/bazelbuild/bazel/releases/tag/7.4.0
8.0.0 -> https://github.com/bazelbuild/bazel/releases/tag/8.0.0
8.1.0 -> https://github.com/bazelbuild/bazel/releases/tag/8.1.1
8.4.2 -> https://github.com/bazelbuild/bazel/releases/tag/8.4.2
-->
[bazel_relnotes]: https://github.com/bazelbuild/bazel/releases/tag/8.4.2
[bloop_releases]: https://scalacenter.github.io/bloop/
[bloop_relnotes]: https://github.com/scalacenter/bloop/releases/tag/v1.3.4
[cfr_releases]: https://www.benf.org/other/cfr/
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[cp_examples]: https://github.com/michelou/cp-examples#top
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[dafny_examples]: https://github.com/michelou/dafny-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples#top
[dotty]: https://dotty.epfl.ch
[dotty_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[dotty_nightly]: https://search.maven.org/search?q=g:ch.epfl.lamp
[erlang_examples]: https://github.com/michelou/erlang-examples#top
[flix_examples]: https://github.com/michelou/flix-examples#top
[github_scala]: https://github.com/scala/scala3/blob/master/dist/bin/scala
[git_bash]: https://www.atlassian.com/git/tutorials/git-bash
[git_cli]: https://git-scm.com/docs/git
[git_releases]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.51.1.adoc
[github_guides]: https://guides.github.com/
[github_scala_scala3]: https://github.com/scala/scala3
[github_markdown]: https://github.github.com/gfm/
[github_PR5444]: https://github.com/scala/scala3/pull/5444
[gmake_cli]: http://www.glue.umd.edu/lsf-docs/man/gmake.html
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_compatibility]: https://docs.gradle.org/current/release-notes.html#upgrade-instructions
[gradle_install]: https://gradle.org/install/
[gradle_relnotes]: https://docs.gradle.org/8.2/release-notes.html
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[jacoco_changelog]: https://www.jacoco.org/jacoco/trunk/doc/changes.html
[jacoco_downloads]: https://www.eclemma.org/jacoco/
[jar_file]: https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jarGuide.html
[java_bytecode]: https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html
[java_jls]: https://docs.oracle.com/javase/specs/jls/se8/html/index.html
[javac_cli]: https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html
[javafx17_downloads]: https://gluonhq.com/products/javafx/
[javafx17_relnotes]: https://gluonhq.com/products/javafx/openjfx-17-release-notes/
[javafx21_downloads]: https://gluonhq.com/products/javafx/
[javafx21_relnotes]: https://gluonhq.com/products/javafx/openjfx-21-release-notes/
[javap_cli]: https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html
[jitwatch_releases]: https://github.com/AdoptOpenJDK/jitwatch/releases
[jmh]: https://openjdk.java.net/projects/code-tools/jmh/
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[m2_examples]: https://github.com/michelou/m2-examples#top
[make_downloads]: https://sourceforge.net/projects/gnuwin32/files/make/3.81/
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[maven_lamp]: https://search.maven.org/search?q=g:ch.epfl.lamp
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[microsoft_vscode]: https://code.visualstudio.com/
[mill_changelog]: https://github.com/com-lihaoyi/mill/blob/main/changelog.adoc
[mill_cli]: https://com-lihaoyi.github.io/mill/#command-line-tools
[mill_releases]: https://github.com/lihaoyi/mill/releases/
[msys2_changelog]: https://github.com/msys2/setup-msys2/blob/master/CHANGELOG.md
[msys2_releases]: https://github.com/msys2/msys2-installer/releases
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[oracle_openjdk17_api]: https://docs.oracle.com/en/java/javase/17/docs/api/
[oracle_openjdk21]: https://jdk.java.net/21/
[oracle_openjdk21_api]: https://docs.oracle.com/en/java/javase/21/docs/api/
[oracle_openjdk21_relnotes]: https://jdk.java.net/21/release-notes
[rust_examples]: https://github.com/michelou/rust-examples#top
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[sbt_downloads]: https://github.com/sbt/sbt/releases
[sbt_libs]: https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html
[sbt_relnotes]: https://github.com/sbt/sbt/releases/tag/v1.11.7
[sbt_server]: https://www.scala-sbt.org/1.x/docs/sbt-server.html
[scala]: https://www.scala-lang.org/
[scala_api]: https://www.scala-lang.org/files/archive/api/current/
[scala_cli_downloads]: https://github.com/VirtusLab/scala-cli/releases
[scala_cli_relnotes]: https://github.com/VirtusLab/scala-cli/releases/tag/v1.9.1
[scala_releases]: https://www.scala-lang.org/files/archive/
[scala_relnotes]: https://github.com/scala/scala/releases/tag/v2.13.17
[scala_repl]: https://docs.scala-lang.org/overviews/repl/overview.html
[scala_snapshots]: https://scala-ci.typesafe.com/ui/native/scala-pr-validation-snapshots/org/scala-lang
[scala3_home]: https://dotty.epfl.ch
[scala3_lts_releases]: https://github.com/scala/scala3/releases
[scala3_lts_relnotes]: https://github.com/scala/scala3/releases/tag/3.3.7
[scala3_next_releases]: https://github.com/scala/scala3/releases
[scala3_next_relnotes]: https://github.com/scala/scala3/releases/tag/3.7.4-RC1
[scalac_cli]: https://docs.scala-lang.org/overviews/compiler-options/index.html
[semanticdb_guide]: https://scalameta.org/docs/semanticdb/guide.html
[sml_examples]: https://github.com/michelou/sml-examples#top
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
<!--
8u212   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-April/009115.html
8u222   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-July/009840.html
8u232   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html
8u242   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-January/010979.html
8u252   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-April/011559.html
8u262   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-July/012143.html
8u272   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-October/012817.html
8u282   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-January/013337.html
8u292   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-April/013680.html
8u302   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-July/014118.html
8u312   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-October/014373.html
8u321   -> https://www.oracle.com/java/technologies/javase/8u321-relnotes.html
8u322   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2022-January/014522.html
-->
[temurin_openjdk8]: https://adoptium.net/releases.html?variant=openjdk8&jvmVariant=hotspot
[temurin_openjdk8_relnotes]: https://mail.openjdk.java.net/pipermail/jdk8u-dev/2022-January/014522.html
<!--
11.0.3  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-April/000951.html
11.0.4  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-July/001423.html
11.0.5  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-October/002025.html
11.0.6  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-January/002374.html
11.0.7  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-April/003019.html
11.0.8  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-July/003498.html
11.0.9  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-October/004007.html
11.0.10 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-January/004689.html
11.0.11 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-April/005860.html
11.0.12 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-July/006954.html
11.0.13 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-October/009368.html
11.0.14 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2022-January/011643.html
11.0.15 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2022-April/014104.html
11.0.16 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-July/016017.html
11.0.17 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-October/018119.html
11.0.18 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-January/020111.html
11.0.19 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-April/021900.html
11.0.20 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-July/024064.html
11.0.21 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026351.html
11.0.22 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-January/029215.html
11.0.23 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-April/032198.html
11.0.24 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-July/035797.html
11.0.25 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-October/038512.html
11.0.26 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-January/040826.html
11.0.27 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-April/043306.html
11.0.28 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-July/045612.html
-->
[temurin_openjdk11]: https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot
[temurin_openjdk11_bugfixes]: https://www.oracle.com/java/technologies/javase/11-0-24-relnotes.html
[temurin_openjdk11_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-July/035797.html
<!--
17.0.7  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-April/021899.html
17.0.8  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-July/024063.html
17.0.9  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026352.html
17.0.10 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-January/029089.html
17.0.11 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-April/032197.html
17.0.12 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-July/035798.html
17.0.13 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-October/038867.html
17.0.14 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-January/040827.html
17.0.15 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-April/043307.html
17.0.16 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-July/045614.html
-->
[temurin_openjdk17]: https://adoptium.net/temurin/releases?version=17&os=windows&arch=x64&jvmVariant=hotspot
[temurin_openjdk17_bugfixes]: https://www.oracle.com/java/technologies/javase/17-0-16-relnotes.html
[temurin_openjdk17_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-July/045614.html
<!--
See also https://wiki.openjdk.org/display/JDKUpdates/Archived+Releases
21_35   -> https://adoptium.net/fr/temurin/release-notes/?version=jdk-21+35
21.0.1  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026351.html
21.0.2  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-January/029090.html
21.0.3  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-April/032196.html
21.0.4  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-July/035862.html
21.0.5  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-October/038866.html
21.0.6  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-January/040828.html
21.0.7  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-April/043308.html
21.0.8  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-July/045617.html
-->
[temurin_openjdk21]: https://adoptium.net/temurin/releases?version=21&os=windows&arch=x64&jvmVariant=hotspot
[temurin_openjdk21_bugfixes]: https://www.oracle.com/java/technologies/javase/21-0-6-relnotes.html
[temurin_openjdk21_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2025-January/040828.html
<!--
-->
[temurin_openjdk25]: https://adoptium.net/temurin/releases?version=25&os=windows&arch=x64&jvmVariant=hotspot
[temurin_openjdk25_relnotes]: https://jdk.java.net/25/release-notes
<!--
[python_changelog]: https://docs.python.org/3.8/whatsnew/changelog.html#python-3-8-0-final
[python_release]: https://www.python.org/downloads/release/python-380/
-->
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[unix_bash_script]: https://www.gnu.org/software/bash/manual/bash.html
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates
[windows_batch_file]: https://en.wikibooks.org/wiki/Windows_Batch_Scripting
[windows_installer]: https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples#top
[wsl]: https://ubuntu.com/wsl "Ubuntu WSL"
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/ "Everything You Need to Know About Zip Files"

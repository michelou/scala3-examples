# <span id="top">Scala 3 examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:120px;" src="../docs/images/dotty.png" alt="Dotty project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>examples\</code></strong> contains <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> code examples coming from various websites - mostly from the <a href="https://dotty.epfl.ch/" rel="external">Dotty project</a>.
  </td>
  </tr>
</table>

We choose [**`examples\enum-Planet`**](enum-Planet) to demonstrate the usage of the build tools we do support:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\examples\enum-Planet
</pre>

Build tools rely on one or more configuration files to achieve their tasks. In our case we provide the following configuration files for [**`enum-Planet`**](enum-Planet):

| | Build&nbsp;tool               | Build&nbsp;file(s)                    | Parent&nbsp;file(s)                          | Environment(s) |
|-|-------------------------------|---------------------------------------|----------------------------------------------|----------------|
| [**&#9660;**](#ant) | [**`ant.bat`**][apache_ant_cli] | [**`build.xml`**](enum-Planet/build.xml) | [**`build.xml`**](./build.xml), [**`ivy.xml`**](ivy.xml) | Any <sup><b>a)</b></sup> |
| | [**`bazel.exe`**][bazel_cli] | [**`BUILD`**](enum-Planet/BUILD), [**`WORKSPACE`**](enum-Planet/WORKSPACE) | n.a.                                | Any |
| [**&#9660;**](#batch) | [**`cmd.exe`**][cmd_cli] | [**`build.bat`**](enum-Planet/build.bat)<br/>([**`build.properties`**](enum-Planet/project/build.properties)) | [**`cpath.bat`**](./cpath.bat) <sup><b>b)</b></sup>              | Windows only |
| [**&#9660;**](#shell) | [**`sh.exe`**][sh_cli] | [**`build.sh`**](enum-Planet/build.sh)<br/>([**`build.properties`**](enum-Planet/project/build.properties)) |                   | [Cygwin]/[MSYS2]/Unix only |
| [**&#9660;**](#gradle) | [**`gradle.exe`**][gradle_cli] | [**`build.gradle`**](enum-Planet/build.gradle) | [**`common.gradle`**](./common.gradle) | Any |
| [**&#9660;**](#gmake) | [**`make.exe`**][gmake_cli] <sup><b>c)</b></sup> | [**`Makefile`**](enum-Planet/Makefile)   | [**`Makefile.inc`**](./Makefile.inc)         | Any|
| [**&#9660;**](#mill) | [**`mill.bat`**][mill_cli] | [`build.sc`](enum-Planet/build.sc)   | [`common.sc`](./common.sc)               | Any |
| [**&#9660;**](#maven) | [**`mvn.cmd`**][apache_maven_cli] | [`pom.xml`](enum-Planet/pom.xml)     | [`pom.xml`](./pom.xml)                   | Any |
| [**&#9660;**](#sbt) | [**`sbt.bat`**][sbt_cli] | [`build.sbt`](enum-Planet/build.sbt) | n.a.                                         | Any |
| [**&#9660;**](#scala_cli) | [**`scala-cli.exe`**][scala_cli] | | | Any |
<div style="margin:0 10% 0 8px;font-size:80%;">
<b><sup>a)</sup></b> Here "Any" means "tested on Windows, Cygwin, MSYS2 and Unix".<br/>
<b><sup>b)</sup></b> This utility batch file manages <a href="https://maven.apache.org/" rel="external">Maven</a> dependencies and returns the associated Java class path (as environment variable).<br/>
<sup><b>c)</b></sup> Default shell is <code><b>/bin/sh</b></code> as described in the online document <a href="https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html">Choosing the Shell</a>.<br/>
&nbsp;</div>

## <span id="ant">Ant build tool</span>

The Ant build file [**`enum-Planet\build.xml`**](enum-Planet/build.xml) depends on the parent file [**`examples\build.xml`**](build.xml) which provides the macro definition **`dotc`** to compile the [Scala] source files.

> **:mag_right:** Command [**`ant.bat`**][apache_ant_cli] (["Another Neat Tool"][apache_ant_faq]) is a Java-based build tool maintained by the [Apache Software Foundation][apache_history] (tool created in 2000). It works with XML-based configuration files.

Execution of [**`Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) produces the following output ([Ivy][apache_ant_ivy] support is enabled by default):

<pre style="font-size:80%;">
<b>&gt; <a href="https://ant.apache.org/manual/running.html">ant</a> clean run</b>
Buildfile: Y:\examples\enum-Planet\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory Y:\examples\enum-Planet\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>
[ivy:resolve] :: Apache Ivy 2.5.2- 20230817170011 :: https://ant.apache.org/ivy/ ::
[ivy:resolve] :: loading settings :: url = jar:file:/C:/opt/apache-ant/lib/ivy-2.5.2.jar!/org/apache/ivy/core/settings/ivysettings.xml

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: Y:\examples\enum-Planet\target\classes
   [scalac] Compiling 1 source file to Y:\examples\enum-Planet/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Your weight on MERCURY (0) is 0.37775761520093526
     [java] Your weight on VENUS (1) is 0.9049990998410455
     [java] Your weight on EARTH (2) is 0.9999999999999999
     [java] Your weight on MARS (3) is 0.37873718403712886
     [java] Your weight on JUPITER (4) is 2.5305575254957406
     [java] Your weight on SATURN (5) is 1.0660155388115666
     [java] Your weight on URANUS (6) is 0.9051271993894251
     [java] Your weight on NEPTUNE (7) is 1.1383280724696578

BUILD SUCCESSFUL
Total time: 19 seconds
</pre>

> **&#9755;** **Apache Ivy**<br/>
> We observe from task **`init.ivy`** that the [Apache Ivy][apache_ant_ivy] library has been added to the [Ant](https://ant.apache.org/) installation directory. In our case we installed [version 2.5.2][apache_ant_ivy_relnotes] of the [Apache Ivy][apache_ant_ivy] library.
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://curl.haxx.se/docs/manpage.html">curl</a> -sL -o c:\Temp\apache-ivy-2.5.2.zip <a href="https://downloads.apache.org/ant/ivy/2.5.2/">https://www-eu.apache.org/dist/ant/ivy/2.5.2/apache-ivy-2.5.2-bin.zip</a></b>
> <b>&gt; <a href="https://linux.die.net/man/1/unzip">unzip</a> c:\temp\apache-ivy-2.5.2.zip -d c:\opt</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy">copy</a> c:\opt\apache-ivy-2.5.2\ivy-2.5.2.jar c:\opt\apache-ant-1.10.13\lib</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\apache-ant\lib | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> ivy</b>
> 20.10.2019  09:44         1 402 646 ivy-2.5.2.jar
> </pre>

We can set property **`-Duse.local=true`** to use [Scala 3][scala3_home] local installation (*reminder*: in our case environment variable **`SCALA3_HOME`** is set by command **`setenv`**):

<pre style="font-size:80%;">
<b>&gt; <a href="https://ant.apache.org/manual/running.html">ant</a> -Duse.local=true clean run</b>
Buildfile: Y:\examples\enum-Planet\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory Y:\examples\enum-Planet\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>
     [echo] SCALA3_HOME=C:\opt\scala3-3.3.5

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: Y:\examples\enum-Planet\target\classes
    [scalac] Compiling 1 source file to Y:\examples\enum-Planet/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Your weight on MERCURY (0) is 0.37775761520093526
     [java] Your weight on VENUS (1) is 0.9049990998410455
     [java] Your weight on EARTH (2) is 0.9999999999999999
     [java] Your weight on MARS (3) is 0.37873718403712886
     [java] Your weight on JUPITER (4) is 2.5305575254957406
     [java] Your weight on SATURN (5) is 1.0660155388115666
     [java] Your weight on URANUS (6) is 0.9051271993894251
     [java] Your weight on NEPTUNE (7) is 1.1383280724696578

BUILD SUCCESSFUL
Total time: 14 seconds
</pre>


## <span id="batch">Batch command</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

Command [**`build.bat`**](enum-Planet/build.bat) is our basic build tool featuring subcommands **`clean`**, **`compile`**, **`decompile`**, **`doc`**, **`help`**, **`lint`**, **`run`** and **`test`**; the batch file consists of ~790 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_01">[1](#footnote_01)</sup>.

Command [**`build.bat clean run`**](enum-Planet/build.bat) generates the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="enum-Planet/build.bat">build</a> clean run</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

> **:mag_right:** Compilation of the Java/Scala source files is performed only if needed during the build process:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="enum-Planet/build.bat">build</a> clean</b>
> &nbsp;
> <b>&gt; <a href="enum-Planet/build.bat">build</a> compile</b>
> &nbsp;
> <b>&gt; <a href="enum-Planet/build.bat">build</a> -verbose compile</b>
> No action required ("src\main\scala\*.scala")</pre>

Command [**`build -verbose clean run`**](enum-Planet/build.bat) also displays progress messages:

<pre style="font-size:80%;">
<b>&gt; <a href="enum-Planet/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Compile 1 Scala source file to directory "target\classes"
Execute Scala main class Planet
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

Command [**`build -debug clean run`**](enum-Planet/build.bat) also displays internal steps of the build process:

<pre style="font-size:80%;">
<b/>&gt; <a href="enum-Planet/build.bat">build</a> -debug clean run</b>
[build] Properties : _PROJECT_NAME=enum-Planet _PROJECT_VERSION=1.0-SNAPSHOT
[build] Options    : _EXPLAIN=0 _PRINT=0 _SCALA_VERSION=3 _TASTY=0 _TIMER=0 _VERBOSE=0
[build] Subcommands:  clean compile run
[build] Variables  : "CFR_HOME=C:\opt\cfr-0.152"
[build] Variables  : "JAVA_HOME=C:\opt\jdk-temurin-17.0.13_11"
[build] Variables  : "SCALA3_HOME=C:\opt\scala3-3.3.4"
[build] Variables  : "SCALA_HOME=C:\opt\scala-2.13.15"
[build] Variables  : _MAIN_CLASS=Planet _MAIN_ARGS=1
[build] del /s /q Y:\dotty\examples\enum-Planet\target\classes\*.class Y:\dotty\examples\enum-Planet\target\classes\*.hasTasty Y:\dotty\examples\enum-Planet\target\classes\.latest-build
[build] 20180322224754 Y:\dotty\examples\enum-Planet\src\main\scala\Planet.scala
[build] 00000000000000 Y:\dotty\examples\enum-Planet\target\classes\.latest-build
[build] scalac "@Y:\examples\enum-Planet\target\scalac_opts.txt" "@Y:\examples\enum-Planet\target\scalac_sources.txt"
[build] scala -classpath [...];Y:\dotty\examples\enum-Planet\target\classes Planet 1
Your weight on MERCURY is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
[build] _EXITCODE=0</pre>

> **:mag_right:** The above `enum-Planet` example expects 1 argument at execution time.<br/>
> For simplicity the [**`build`**](enum-Planet/build.bat) command currently relies on the property `main.args` defined in file [**`project\build.properties`**](enum-Planet/project/build.properties) (part of the SBT configuration) to specify program arguments.<br/>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> <a href="enum-Planet/project/build.properties">project\build.properties</a></b>
> sbt.version=1.10.6
> &nbsp;
> main.class=Planet
> main.args=1
> </pre>

> **:mag_right:** The output generated with options **`-verbose`** and **`-debug`** are redirected to [stderr][windows_stderr] and can be discarded by adding **`2>NUL`**, e.g.:
> <pre style="font-size:80%;">
> <b>&gt; <a href="enum-Planet/build.bat">build</a> clean run -debug 2>NUL</b>
> Your weight on MERCURY (0) is 0.37775761520093526
> Your weight on SATURN (5) is 1.0660155388115666
> Your weight on VENUS (1) is 0.9049990998410455
> Your weight on URANUS (6) is 0.9051271993894251
> Your weight on EARTH (2) is 0.9999999999999999
> Your weight on NEPTUNE (7) is 1.1383280724696578
> Your weight on MARS (3) is 0.37873718403712886
> Your weight on JUPITER (4) is 2.5305575254957406
> </pre>

Finally, command [**`build -verbose decompile`**](enum-Planet/build.bat) decompiles the generated bytecode with [CFR][cfr_releases]:

<pre style="font-size:80%;">
<b>&gt; <a href="enum-Planet/build.bat">build</a> -verbose decompile</b>
No action required ("src\main\scala\*.scala")
Decompile Java bytecode to directory "target\cfr-sources"
Processing Planet$
Processing Planet
Save decompiled Java source files to "target\cfr-sources_scala3_3.3.5.java"
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b /s target\*.java</b>
Y:\examples\enum-Planet\target\cfr-sources_scala3_3.3.5.java
Y:\examples\enum-Planet\target\cfr-sources\Planet$.java
Y:\examples\enum-Planet\target\cfr-sources\Planet.java
</pre>

If the two Java source files `src\build\cfr-sources_scala<n>_<version>.txt` (*check file*) and `target\cfr-sources_scala<n>_<version>.txt` (*output file*) are present subcommand **`decompile`** also invokes the [`diff`][man1_diff] command to show differences between the check file and the output file:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b src\build</b>
cfr-sources_scala3_3.1.0.java
cfr-sources_scala3_3.2.2.java
cfr-sources_scala3_3.3.0.java
cfr-sources_scala3_3.3.5.java
&nbsp;
<b>&gt; <a href="enum-Planet/build.bat">build</a> -verbose decompile</b>
No action required ("src\main\scala\*.scala")
Decompile Java bytecode to directory "target\cfr-sources"
Save decompiled Java source files to "target\cfr-sources_scala3_3.3.5.java"
Compare output file with check file "src\build\cfr-sources_scala3_3.3.5.java"
</pre>


## <span id="shell">Shell command</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

Bash script [**`build.sh`**](enum-Planet/build.sh) is our basic build tool for Unix environments like [Cygwin], Linux or [MSYS2]; it features subcommands **`clean`**, **`compile`**, **`doc`**, **`help`**, **`lint`** and **`run`**; the Bash script consists of ~500 lines of [Bash] code.

Command [**`sh build.sh clean run`**](enum-Planet/build.sh) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://man7.org/linux/man-pages/man1/sh.1p.html">sh</a> <a href="enum-Planet/build.sh">./build.sh</a> clean run</b>
Mass of earth is 0.1020132025669991
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>


## <span id="gradle">Gradle build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The Gradle build file [**`enum-Planet\build.gradle`**](enum-Planet/build.gradle) depends on the parent file [**`examples\common.gradle`**](common.gradle) which defines the task **`compileDotty`** and manages the task dependencies.

> **:mag_right:** Command [**`gradle`**][gradle_cli] is the official build tool for Android applications. Created in 2007 it replaces XML-based build scripts with a [Groovy][gradle_groovy]-based DSL.

Command **`gradle -q clean run`** produces the following output ([**`Planet.scala`**](enum-Planet/src/main/scala/Planet.scala)):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> -q clean run</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

> **&#9755;** ***Gradle Wrappers***<br/>
> We don't rely on them even if using [Gradle Wrapper][gradle_wrapper] is the  recommended way to execute a <a href="https://gradle.org/">Gradle</a> build.<br/>
> Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of [**`gradle`**][gradle_cli].


## <span id="gmake">Make build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The Make build file [**`enum-Planet\Makefile`**](enum-Planet/Makefile) depends on the parent file [**`examples\Makefile.inc`**](Makefile.inc) which defines common settings (i.e. tool and library paths).

> **:mag_right:** Command [**`make`**][gmake_cli] automatically builds executable programs and libraries from source code by reading files called Makefiles which specify how to derive the target program. [Make] was originally created by Stuart Feldman in April 1976 at Bell Labs.

Command **`make clean run`** produces the following output ([**`Planet.scala`**](enum-Planet/src/main/scala/Planet.scala)):

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> clean run</b>
rm -rf "target"
[ -d "target/classes" ] || mkdir -p "target/classes"
scalac.bat "@target/scalac_opts.txt" "@target/scalac_sources.txt"
scala.bat -classpath "target/classes" Planet 1
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

Command **`make test`** executes the test suite [**`PlanetTest.scala`**](enum-Planet/src/test/scala/PlanetTest.scala) for program [**`Planet.scala`**](enum-Planet/src/main/scala/Planet.scala).

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> test</b>
[ -d "target/test-classes" ] || mkdir -p "target/test-classes"
scalac.bat "@target/scalac_test_opts.txt" "@target/scalac_test_sources.txt"
java.exe -classpath "%USERPROFILE%/.m2/repository/org/scala-lang/scala-library/2.13.15/scala-library-2.13.15.jar;%USERPROFILE%/.m2/repository/org.scala-lang/scala3-library_3/3.3.4/scala3-library_3-3.3..jar;%USERPROFILE%/.m2/repository/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar;%USERPROFILE%/.m2/repository/junit/junit/4.13.2/junit-4.13.2.jar;%USERPROFILE%/.m2/repository/com/novocode/junit-interface/0.11/junit-interface-0.11.jar;target/classes;target/test-classes" org.junit.runner.JUnitCore PlanetTest
JUnit version 4.13.2
..3

OK (2 tests)
</pre>

Command **`make doc`** generates the HTML documentation for program [**`enum-Planet.scala`**](enum-Planet./src/main/scala/enum-Planet.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> doc</b>
[ -d "target/docs" ] || mkdir -p "target/docs"
dotd.bat "@target/scaladoc_opts.txt" "@target/scaladoc_sources.txt"
Compiling (1/1): Planet.scala
[doc info] Generating doc page for: <empty>
[doc info] Generating doc page for: <empty>.Planet
[doc info] Generating doc page for: <empty>.Planet$
[doc info] Generating doc page for: <empty>.Planet
[doc info] Generating doc page for: <empty>.Planet$
[...]
public members with docstrings:    0
protected members with docstrings: 0
private members with docstrings:   0/3 (0%)
</pre>

<!--=======================================================================-->

## <span id="maven">Maven build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The [Maven][apache_maven_about] build file [**`enum-Planet\pom.xml`**](enum-Planet/pom.xml) depends on the parent file [**`../pom.xml`**](pom.xml) which defines common properties <sup id="anchor_02">[2](#footnote_02)</sup> (eg. **`java.version`**, **`scala.version`**).

> **:mag_right:** Command [**`mvn`**][mvn_cli] is a Java-based build tool maintained by the [Apache Software Foundation][apache_foundation]. Created in 2002 it works with XML-based configuration files and provides a way to share JARs across several projects.

Command **` mvn.cmd compile test`** with option **`-debug`** produces additional debug information, including the underlying command lines executed by our [Maven][apache_maven_about] plugin **`scala-maven-plugin`**:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html">mvn</a> -debug compile test | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /c:"[DEBUG]\ [execute]" 2>NUL</b>
[DEBUG] [execute] C:\opt\jdk-temurin-17.0.13_11\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\scala3-3.3.5 \
 -cp C:\opt\scala3-3.3.5\lib\*.jar -Dscala.usejavacp=true  \
 dotty.tools.dotc.Main \
 -classpath Y:\examples\hello-scala\target\classes \
 -d Y:\examples\hello-scala\target\classes \
 Y:\examples\hello-scala\src\main\scala\hello.scala
[DEBUG] [execute] C:\opt\jdk-temurin-17.0.13_11\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\scala3-3.3.5 [...]
[DEBUG] [execute] C:\opt\jdk-temurin-17.0.13_11\bin\java.exe \
 -Xms64m -Xmx1024m -cp C:\opt\scala3-3.3.5\lib\*.jar;\
Y:\examples\hello-scala\target\classes hello
</pre>

> **:mag_right:** The following command outputs the classpath being used by <a href="https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html"><code>mvn</code></a> into the text file `classpath.txt` :
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html" rel="external">mvn</a> dependency:build-classpath -Dmdep.outputFile=classpath.txt</b>
> </pre>
<!-- https://stackoverflow.com/questions/16655010/in-maven-how-output-the-classpath-being-used -->

Command [**`mvn.cmd --quiet clean test`**](enum-Planet/pom.xml) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html" rel="external">mvn</a> --quiet clean test</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html">mvn</a> clean compile package</b>
...
[INFO]
[INFO] --- maven-jar-plugin:3.3.0:jar (default-jar) @ enum-Planet ---
[INFO] Building jar: Y:\examples\enum-Planet\target\enum-Planet-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  9.468 s
[INFO] Finished at: 2019-07-27T19:53:09+01:00
[INFO] ------------------------------------------------------------------------

<b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html" rel="external">java</a> -version 2>&1 | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> version</b>
openjdk version "11.0.19" 2023-04-18

<b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html" rel="external">java</a> -Xbootclasspath/a:"c:\opt\scala3-3.3.5\lib\scala3-library_3-3.3.5.jar;c:\opt\scala3-3.3.5\lib\scala-library-2.13.15.jar" -jar target\enum-Planet-1.0-SNAPSHOT.jar 1</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

> **&#9755;** **Scala Maven Plugin**<br/>
> In the above [Maven][apache_maven_about] configuration file we note the presence of the Maven plugin [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip). In fact the parent file [**`examples\pom.xml`**](pom.xml) depends on [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip), a Maven plugin we developed specifically for this project (see document [`maven-plugins\README.md`](../maven-plugins/README.md)):
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/more" rel="external">more</a> ..\pom.xml</b>
> &lt;?xml version="1.0" encoding="UTF-8"?&gt;
> ...
>     <b>&lt;properties&gt;</b>
>         <b>&lt;project.build.sourceEncoding&gt;</b>UTF-8<b>&lt;/project.build.sourceEncoding&gt;</b>
>         <b>&lt;java.version&gt;</b>1.8<b>&lt;/java.version&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Scala settings --&gt;</i>
>         <b>&lt;scala.version&gt;</b>3.3.4<b>&lt;/scala.version&gt;</b>
>         <b>&lt;scala.local.install&gt;</b>true<b>&lt;/scala.local.install&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Maven plugins --&gt;</i>
>         <b>&lt;scala.maven.version&gt;</b>1.0.0<b>&lt;/scala.maven.version&gt;</b>
>         ...
>     <b>&lt;/properties&gt;</b>
>     <b>&lt;dependencies&gt;</b>
>         <b>&lt;dependency&gt;</b>
>             <b>&lt;groupId&gt;</b>ch.epfl.alumni<b>&lt;/groupId&gt;</b>
>             <b>&lt;artifactId&gt;</b>scala-maven-plugin<b>&lt;/artifactId&gt;</b>
>             <b>&lt;version&gt;</b>${scala.maven.version}<b>&lt;/version&gt;</b>
>         <b>&lt;/dependency&gt;</b>
>         ...
>     <b>&lt;/dependencies&gt;</b>
>
> <b>&lt;/project&gt;</b>
> </pre>
> The plugin is available as [Zip archive][zip_archive] and its installation is deliberately very simple:
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://linux.die.net/man/1/unzip" rel="external">unzip</a> ..\bin\scala-maven-plugin-1.0.zip %USERPROFILE%\.m2\repository\</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f %USERPROFILE%\.m2\repository\ch\epfl\alumni | findstr /v "^[A-Z]"</b>
> \---scala-maven-plugin
>     |   maven-metadata.xml
>     |   maven-metadata.xml.md5
>     |   [..]
>     |
>     \---1.0.1
>             scala-maven-plugin-1.0.1.jar
>             scala-maven-plugin-1.0.1.jar.md5
>             scala-maven-plugin-1.0.1.pom
>             scala-maven-plugin-1.0.1.pom.md5
>             [..]
> </pre>


## <span id="mill">Mill build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The [Mill][mill_cli] build file [**`enum-Planet\build.sc`**](enum-Planet/build.sc) depends on the parent file [**`examples\common.sc`**](common.sc) which defines the common settings.

> **:mag_right:** Command [**`mill`**][mill_cli] is a Scala-based build tool which aims for simplicity to build projects in a fast and predictable manner.

Command [**`mill.bat -i app`**](enum-Planet/build.sc) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.lihaoyi.com/mill/#command-line-tools" rel="external">mill</a> -i app.run 1</b>
[38/38] app.run
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

> **:mag_right:** The user has to execute two `mill` commands to perform a clean build and run the application :
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://www.lihaoyi.com/mill/#command-line-tools" rel="external">mill</a> -i app.clean &amp; <a href="https://www.lihaoyi.com/mill/#command-line-tools" rel="external">mill</a> -i app.run 1</b>
> [1/1] app.clean
> [27/39] app.compile
> [info] compiling 1 Scala source to Y:\examples\enum-Planet\out\app\compile\dest\classes ...
> [info] done compiling
> [39/39] app.run
> Mass of earth is 0.1020132025669991
> Your weight on MERCURY (0) is 0.37775761520093526
> [...]
> </pre>

## <span id="sbt">SBT build tool</span> [**&#x25B4;**](#top)

The SBT build file [**`build.sbt`**](enum-Planet/build.sbt) is written in [Scala] and obeys the [sbt build definitions][sbt_docs_defs].

> **:mag_right:** [Lightbend] provides commercial support for the [**`sbt`**][sbt_cli] build tool.

Command **<code>[sbt.bat](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) -warn clean "run 1"</code>** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html" rel="external">sbt</a> -warn clean "run 1"</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
</pre>

## <span id="scala_cli">scala-cli tool</span> [**&#x25B4;**](#top)

Specifying option `-cli` in command [`build.bat`](./enum-Planet/build.bat) does call [`scala-cli.exe`][scala_cli] with the appropriate options:

<pre style="font-size:80%;">
<b>&gt; <a href="./enum-Planet/build.bat">build</a> -cli -debug run</b>
[build] Properties : _PROJECT_NAME=enum-Planet _PROJECT_VERSION=1.0-SNAPSHOT
[build] Options    : _EXPLAIN=0 _PRINT=0 _SCALA_VERSION=3 _TASTY=0 _TIMER=0 _VERBOSE=0
[build] Subcommands:  compile run
[build] Variables  : "CFR_HOME=C:\opt\cfr-0.152"
[build] Variables  : "JAVA_HOME=C:\opt\jdk-temurin-17.0.13_11"
[build] Variables  : "SCALA_CLI_HOME=c:\opt\scala-cli"
[build] Variables  : "SCALA_HOME=C:\opt\scala-2.13.15"
[build] Variables  : "SCALA3_HOME=C:\opt\scala3-3.3.4"
[build] Variables  : _MAIN_CLASS=Planet _MAIN_ARGS=1
[build] "c:\opt\scala-cli\scala-cli.exe" compile -v -O -deprecation --scala 3 "Y:\examples\enum-Planet\src\main\scala"
Compiling project (Scala 3.3.4, JVM)
Compiled project (Scala 3.3.4, JVM)
[build] "c:\opt\scala-cli\scala-cli.exe" run -v --scala 3 --main-class "Planet" "Y:\examples\enum-Planet\src\main\scala" -- 1
Compiling project (Scala 3.3.4, JVM)
Compiled project (Scala 3.3.4, JVM)
Running C:\opt\jdk-temurin-17.0.13_11\bin\java.exe -cp Y:\examples\enum-Planet\src\main\scala\.scala-build\project_909ac66893\classes\main;C:\Users\michelou\AppData\Local\Coursier\cache\v1\https\repo1.maven.org\maven2\org\scala-lang\scala3-library_3\3.3.4\scala3-library_3-3.3.4.jar;C:\Users\michelou\AppData\Local\Coursier\cache\v1\https\repo1.maven.org\maven2\org\scala-lang\scala-library\2.13.15\scala-library-2.13.15.jar Planet 1
Mass of earth is 0.1020132025669991
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
[build] _EXITCODE=0
</pre>

## <span id="footnotes">Footnotes</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

<span id="footnote_01">[1]</span> ***Batch files and coding conventions*** [↩](#anchor_01)

<dl><dd>
We strive to obey the following coding conventions in our batch files (e.g. <a href="enum-Planet/build.bat"><b><code>enum-Planet\build.bat</code></b></a>) :
</dd>
<dd>
<ul>
<li>We use at most 80 characters per line. In general we would say that 80 characters fit well with 4:3 screens and 100 characters fit well with 16:9 screens (both <a href="https://github.com/databricks/scala-style-guide#line-length" rel="external">Databricks</a> and <a href="https://google.github.io/styleguide/javaguide.html#s4.4-column-limit" rel="external">Google</a> use the convention of 100 characters).</li>
<li>We organize our code in 4 sections: <code>Environment setup</code>, <code>Main</code>, <code>Subroutines</code> and <code>Cleanups</code>.</li>
<li>We write exactly <b><i>one exit instruction</i></b> (label <b><code>end</code></b> in section <b><code>Cleanups</code></b>).</li>
<li>We adopt the following naming conventions: global variables start with character <code>_</code> (shell variables defined in the user environment start with a letter) and local variables (e.g. inside subroutines or <b><code>if/for</code></b> constructs) start with <code>__</code> (two <code>_</code> characters).</li>
</ul>
</dd>
<dd>
<pre style="font-size:80%;">
<b>@echo off</b>
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/setlocal" rel="external">setlocal</a> enabledelayedexpansion</b>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Environment setup</i>
&nbsp;
<b>set</b> _EXITCODE=0
&nbsp;
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call" rel="external">call</a> <span style="color:#9966ff;">:env</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>
&nbsp;
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:props</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>
&nbsp;
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:args</span> %*</b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Main</i>
&nbsp;
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if"><b>if</b></a> <span style="color:#3333ff;">%_CLEAN%</span>==1 (
    <b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> :clean</b>
    <b>if not</b> <span style="color:#3333ff;">!_EXITCODE!</span>==0 <b>goto end</b>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if"><b>if</b></a> <span style="color:#3333ff;">%_COMPILE%</span>==1 (
    <b>call <span style="color:#9966ff;">:compile</span></b>
    <b>if not</b> <span style="color:#3333ff;">!_EXITCODE!</span>==0 <b>goto end</b>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if"><b>if</b></a> <span style="color:#3333ff;">%_LINT%</span>==1 (
    <b>call <span style="color:#9966ff;">:lint</span></b>
    <b>if not</b> <span style="color:#3333ff;">!_EXITCODE!</span>==0 <b>goto end</b>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if"><b>if</b></a> <span style="color:#3333ff;">%_DOC%</span>==1 (
    <b>call <span style="color:#9966ff;">:doc</span></b>
    <b>if not</b> <span style="color:#3333ff;">!_EXITCODE!</span>==0 <b>goto end</b>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if"><b>if</b></a> <span style="color:#3333ff;">%_RUN%</span>==1 (
    <b>call <span style="color:#9966ff;">:run</span></b>
    <b>if not</b> <span style="color:#3333ff;">!_EXITCODE!</span>==0 <b>goto end</b>
)
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> <span style="color:#9966ff;">end</span></b>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Subroutines</i>
&nbsp;
<span style="color:#9966ff;">:env</span>
...<i>(variable initialization, eg. directory paths)</i>...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:props</span>
...<i>(read file build.properties if present)</i>...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:args</span>
...<i>(command line options/subcommands)</i>...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:clean</span>
...<i>(delete generated files/directories)</i>...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:compile</span>
...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:lint</span>
...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:doc</span>
...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
<span style="color:#9966ff;">:run</span>
...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto" rel="external">goto</a> :eof</b>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Cleanups</i>
&nbsp;
<span style="color:#9966ff;">:end</span>
...
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/exit" rel="external"><b>exit</b></a> /b <span style="color:#3333ff;">%_EXITCODE%</span>
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***Useful Maven commands*** [↩](#anchor_02)

<dl><dd>
The following command performs all substitutions for user-defined properties and imports and displays the resulting POM file.
<pre style="font-size:80%;">
<b>&gt; mvn help:effective-pom</b>
</pre>
<i>Source</i> : <a href="https://programmingtechie.com/2020/12/05/complete-maven-tutorial/">Complete Maven Tutorial</a> by Sai Upadhyayula, December 2020.
</dd></dl>

<span id="footnote_02">[3]</span> ***Scala annotation*** `@main` [↩](#anchor_03)

<dl><dd>
<pre style="font-size:80%;">
<b>&gt; <a href="">type</a> src\main\scala\Main.scala</b>
@main
def main = 
  println("Hello")
&nbsp;
<b>&gt; %JAVA_HOME%\bin\<a href="">javap</a> -cp target\classes main</b>
Compiled from "Main.scala"
public final class main {
  public main();
  public static void main(java.lang.String[]);
}
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_faq]: https://ant.apache.org/faq.html#ant-name
[apache_ant_ivy]: https://ant.apache.org/ivy/
[apache_ant_ivy_relnotes]: https://ant.apache.org/ivy/history/2.5.2/release-notes.html
[apache_foundation]: https://maven.apache.org/docs/history.html
[apache_history]: https://ant.apache.org/faq.html#history
[apache_maven_about]: https://maven.apache.org/what-is-maven.html
[apache_maven_cli]: https://maven.apache.org/ref/current/maven-embedder/cli.html
[bash]: https://en.wikipedia.org/wiki/Bash_(Unix_shell)
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[cfr_releases]: https://www.benf.org/other/cfr/
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[cygwin]: https://cygwin.com/install.html
[gmake_cli]: http://www.glue.umd.edu/lsf-docs/man/gmake.html
[gradle_groovy]: https://www.groovy-lang.org/
[gradle_app_plugin]: https://docs.gradle.org/current/userguide/application_plugin.html#header
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_java_plugin]: https://docs.gradle.org/current/userguide/java_plugin.html
[gradle_plugins]: https://docs.gradle.org/current/userguide/plugins.html
[gradle_wrapper]: https://docs.gradle.org/current/userguide/gradle_wrapper.html
[lightbend]: https://www.lightbend.com/
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[make]: https://en.wikipedia.org/wiki/Make_(software)
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[mill_cli]: https://www.lihaoyi.com/mill/#command-line-tools
[mvn_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
[msys2]: https://www.msys2.org/
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[sbt_docs_defs]: https://www.scala-sbt.org/1.0/docs/Basic-Def.html
[scala]: https://www.scala-lang.org/
[scala_cli]: https://scala-cli.virtuslab.org/docs/commands/basics
[scala3_home]: https://dotty.epfl.ch/
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
[windows_stderr]: https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
[zip_archive]: https://www.howtogeek.com/178146/

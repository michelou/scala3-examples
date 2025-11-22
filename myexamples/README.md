# <span id="top">Scala 3 examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:100px;" src="../docs/images/dotty.png" width="100" alt="Dotty project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>myexamples\</code></strong> contains <a href="https://dotty.epfl.ch/" rel="external" title="Scala 3">Scala 3</a> code examples written by myself.
  </td>
  </tr>
</table>

Let's choose example [**`myexamples\HelloWorld`**](HelloWorld) to demonstrate the usage of the build tools we do support:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
W:\myexamples\HelloWorld
</pre>

Build tools rely on one or more configuration files to achieve their tasks. In our case we provide the following configuration files for [**`HelloWorld`**](HelloWorld):

| | Build&nbsp;tool              | Build&nbsp;file(s)                              | Parent file(s)                       | Environment(s) |
|-|-------------------------------|---------------------------------------------------------|--------------------------------------|---------|
| [**&#9660;**](#ant) | [**`ant.bat`**][apache_ant_cli] | [**`build.xml`**](HelloWorld/build.xml)                 | [**`build.xml`**](build.xml), [**`ivy.xml`**](ivy.xml) | Any <sup><b>a)</b></sup> |
| | [**`bazel.exe`**][bazel_cli]    | [**`BUILD`**](HelloWorld/BUILD), **`WORKSPACE`**        | n.a.                                 | Any |
| [**&#9660;**](#batch) | [**`cmd.exe`**][cmd_cli] | [**`build.bat`**](HelloWorld/build.bat)<br/>([**`build.properties`**](HelloWorld/project/build.properties)) |  [**`cpath.bat`**](./cpath.bat) <sup><b>b)</b></sup>        | Windows only |
| [**&#9660;**](#shell) | [**`sh.exe`**][sh_cli] | [**`build.sh`**](HelloWorld/build.sh)<br/>([**`build.properties`**](HelloWorld/project/build.properties)) |         | [Cygwin]/[MSYS2]/Unix only |
| [**&#9660;**](#gradle) | [**`gradle.bat`**][gradle_cli] | [**`build.gradle`**](HelloWorld/build.gradle)           | [**`common.gradle`**](common.gradle) | Any |
| [**&#9660;**](#gmake) | [**`make.exe`**][gmake_cli] | [**`Makefile`**](HelloWorld/Makefile)                   | [**`Makefile.inc`**](Makefile.inc)   | Any |
| [**&#9660;**](#mill) | [**`mill.bat`**][mill_cli] | [**`build.sc`**](HelloWorld/build.sc)                   | [**`common.sc`**](common.sc)         | Any |
| [**&#9660;**](#maven) | [**`mvn.cmd`**][apache_maven_cli] | [**`pom.xml`**](HelloWorld/pom.xml)                     | [**`pom.xml`**](pom.xml)             | Any |
| [**&#9660;**](#sbt) | [**`sbt.bat`**][sbt_cli] | [**`build.sbt`**](HelloWorld/build.sbt)                 | n.a.                                 | Any |
<div style="margin:0 10% 0 8px;font-size:90%;">
<b><sup>a)</sup></b> Here "Any" means "tested on Windows, Cygwin, M2SYS and Unix".<br/>
<b><sup>b)</sup></b> This utility batch file manages <a href="https://maven.apache.org/" rel="external">Maven</a> dependencies and returns the associated Java class path (as environment variable).<br/>&nbsp;</div>


## <span id="ant">Ant build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The Ant build file [**`HelloWorld\build.xml`**](HelloWorld/build.xml) depends on the parent file [**`myexamples\build.xml`**](build.xml) which provides several macro definitions such as **`dotc`**, **`dotd`** and **`cfr`** to process Scala source files.

> **:mag_right:** Command [**`ant`**][apache_ant_cli] (["Another Neat Tool"][apache_ant_faq]) is a Java-based build maintained by the [Apache Software Foundation][apache_ant_history] (tool created in 2000). It works with XML-based configuration files.

Execution of [**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output ([Ivy][apache_ant_ivy] support is enabled by default):

<pre style="font-size:80%;">
<b>&gt; <a href="https://ant.apache.org/manual/running.html#commandline">ant</a> clean run</b>
Buildfile: W:\myexamples\HelloWorld\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\myexamples\HelloWorld\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>
[ivy:resolve] :: Apache Ivy 2.5.2 - 20230817170011 :: https://ant.apache.org/ivy/ ::
[ivy:resolve] :: loading settings :: url = jar:file:/C:/opt/apache-ant-1.10.14/lib/ivy-2.5.2.jar!/org/apache/ivy/core/settings/ivysettings.xml

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: W:\myexamples\HelloWorld\target\classes
   [scalac] Compiling 1 source file to W:\myexamples\HelloWorld/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Hello world!

BUILD SUCCESSFUL
Total time: 3 seconds
</pre>

> **&#9755;** **Apache Ivy**<br/>
> We observe from task **`init.ivy`** that the [Apache Ivy][apache_ant_ivy] library has been added to the [Ant](https://ant.apache.org/) installation directory. In our case we installed [version 2.5.2][apache_ant_ivy_relnotes] of the [Apache Ivy][apache_ant_ivy] library.
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://curl.haxx.se/docs/manual.html">curl</a> -sL -o c:\Temp\apache-ivy-2.5.2.zip https://www-eu.apache.org/dist//ant/ivy/2.5.2/apache-ivy-2.5.2-bin.zip</b>
> <b>&gt; <a href="https://linux.die.net/man/1/unzip">unzip</a> c:\temp\apache-ivy-2.5.2.zip -d c:\opt</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy">copy</a> c:\opt\apache-ivy-2.5.2\ivy-2.5.2.jar c:\opt\apache-ant-1.10.14\lib</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\apache-ant\lib | findstr ivy</b>
> 09/06/2023  11:25 PM         1,405,631 ivy-2.5.2.jar
> </pre>

We can set property **`-Duse.local=true`** to use the Scala 3 local installation (*reminder*: variable **`SCALA3_HOME`** is set by command **`setenv`**):

<pre style="font-size:80%;">
<b>&gt;</b> <a href="https://ant.apache.org/manual/running.html#commandline">ant</a> -Duse.local=true clean run
Buildfile: W:\myexamples\HelloWorld\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\myexamples\HelloWorld\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>
     [echo] SCALA3_HOME=C:\opt\scala3-3.3.4

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: W:\myexamples\HelloWorld\target\classes
   [scalac] Compiling 1 source file to W:\myexamples\HelloWorld/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Hello world!

BUILD SUCCESSFUL
Total time: 14 seconds
</pre>


## <span id="batch">Batch command</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

Batch file [**`build`**](HelloWorld/build.bat) is a basic build tool consisting of ~800 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_01">[1](#footnote_01)</sup> featuring subcommands **`clean`**, **`compile`**, **`decompile`**, **`doc`**, **`help`**, **`lint`** and **`run`**.

Command [**`build clean run`**](HelloWorld/build.bat) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
W:\myexamples\HelloWorld
&nbsp;
<b>&gt; <a href="HelloWorld/build.bat">build</a> clean run</b>
Hello world!
</pre>


## <span id="shell">Shell command</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

Bash script [**`build.sh`**](HelloWorld/build.sh) is our basic build tool for Unix environments like [Cygwin], Linux or [MSYS2]; it features subcommands **`clean`**, **`compile`**, **`doc`**, **`help`**, **`lint`** and **`run`**; our Bash script consists of ~530 lines of [Bash] code.

### <span id="build-git">Git Bash session</span>

Command [**`setenv -bash`**](setenv.bat) starts a [Cygwin] Bash session:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -bash</b>
Tool versions:
   javac 17.0.12, java 17.0.12, scalac 2.13.14, scalac 3.3.4-RC1,
   ant 1.10.14, gradle 8.10, mill 0.11.7, mvn 3.9.8, sbt 1.10.1,
   bazel 7.2.1, cfr 0.152, coursier 2.1.5, make 3.81, python 3.11.1,
   git 2.46.0, diff 3.10, bash 5.2.26(1)-release
&nbsp;
user@host MSYS /w
<b>$ <a href="https://www.man7.org/linux/man-pages/man1/bash.1.html">bash</a> --version | <a href="https://man7.org/linux/man-pages/man1/grep.1.html">grep</a> bash</b>
GNU bash, version 5.2.15(1)-release (x86_64-pc-msys)
&nbsp;
user@host MSYS /w
<b>$ env | <a href="https://man7.org/linux/man-pages/man1/grep.1.html">grep</a> _HOME | <a href="https://man7.org/linux/man-pages/man1/sort.1.html">sort</a></b>
ANT_HOME=C:\opt\apache-ant-1.10.14
[...]
SBT_HOME=C:\opt\sbt
SCALA3_HOME=C:\opt\scala3-3.3.4
SCALA_HOME=C:\opt\scala-2.13.14
</pre>

Command [**`build clean run`**](HelloWorld/build.sh) produces the following output for project [**`HelloWorld`**](./HelloWorld/):

<pre style="font-size:80%;">
user@host MSYS /w
$ cd myexamples/HelloWorld/
&nbsp;
user@host MSYS /w/myexamples/HelloWorld
$ ./<a href="HelloWorld/build.sh">build.sh</a> clean run
Hello world!
</pre>

### <span id="bash-msys2">MSYS2 Bash session</span>

Similarly, command [**`setenv -msys`**](setenv.bat) starts a [MSYS2] Bash session <sup id="anchor_02">[[2]](#footnote_02)</sup>:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -msys</b>
Tool versions:
   javac 17.0.12, java 17.0.12, scalac 2.13.14, scalac 3.3.4-RC1,
   ant 1.10.14, gradle 8.10, mill 0.11.5, mvn 3.9.8, sbt 1.10.1,
   bazel 6.4.0, cfr 0.152, coursier 2.1.5, make 3.81, python 3.11.1,
   git 2.46.0, diff 3.10, bash 5.2.26(1)-release
&nbsp;
<b>$ <a href="https://www.man7.org/linux/man-pages/man1/bash.1.html">bash</a> --version | <a href="https://man7.org/linux/man-pages/man1/grep.1.html">grep</a> bash</b>
GNU bash, version 5.3.26(1)-release (x86_64-pc-msys)
&nbsp;
<b>$ <a href="https://man7.org/linux/man-pages/man1/env.1.html">env</a> | <a href="https://man7.org/linux/man-pages/man1/grep.1.html">grep</a> _HOME | <a href="https://man7.org/linux/man-pages/man1/sort.1.html">sort</a></b>
ANT_HOME=C:\opt\apache-ant-1.10.14
[...]
SBT_HOME=C:\opt\sbt
SCALA3_HOME=C:\opt\scala3-3.3.1
SCALA_HOME=C:\opt\scala-2.13.14
</pre>

Command [**`build clean run`**](HelloWorld/build.sh) produces the following output for project [**`HelloWorld`**](./HelloWorld/):
<pre style="font-size:80%;">
<b>$ <a href="https://man7.org/linux/man-pages/man1/cd.1p.html">cd</a> myexamples/HelloWorld</b>
&nbsp;
<b>$ <a href="HelloWorld/build.sh">./build.sh</a> clean run</b>
Hello world!
</pre>


## <span id="gradle">Gradle build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

Command [**`gradle`**][gradle_cli] is the official build tool for Android applications (tool created in 2007). It replaces XML-based build scripts with a [Groovy][gradle_groovy]-based DSL.

> **&#9755;** ***Gradle Wrappers***<br/>
> We don't rely on them even if using [Gradle Wrapper][gradle_wrapper] is the  recommended way to execute a Gradle build.<br/>
> Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of [**`gradle`**][gradle_cli].

The Gradle build file [**`HelloWorld\build.gradle`**](HelloWorld/build.gradle) looks as follows:

<pre style="font-size:80%;">
<b>plugins</b> {
    id <span style="color:#990000;">"java"</span>
}
&nbsp;
<b>group</b> <span style="color:#990000;">"$appGroup"</span>
<b>version</b> <span style="color:#990000;">"$appVersion"</span>
&nbsp;
<b>description</b> <span style="color:#990000;">"""Gradle example project to build/run Scala 3 applications"""</span>
&nbsp;
<b>apply from</b>: <span style="color:#990000;">"../common.gradle"</span>
&nbsp;
<b>run.doFirst</b> {
    args <span style="color:#990000;">""</span>
}
</pre>

[**`build.gradle`**](HelloWorld/build.gradle) loads properties from file [**`gradle.properties`**](HelloWorld/gradle.properties) and imports code from parent file [**`myexamples\common.gradle`**](common.gradle).

The parent file [**`myexamples\common.gradle`**](common.gradle) defines the task **`compileDotty`** and manages the task dependencies.

<pre style="font-size:80%;">
<i style="color:#009900;">// overrides default "/build"</i>
buildDir file(<span style="color:#990000;">"/target"</span>)

<b>java</b> {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
<b>ext</b> {
    ...
    classesDir = file(<span style="color:#990000;">"${buildDir}/classes"</span>)
    <b>if</b> (dottyLocal?.toBoolean()) {
        dottyHome = System.getenv(<span style="color:#990000;">"SCALA3_HOME"</span>)
        print(<span style="color:#990000;">"SCALA3_HOME=$dottyHome"</span>)
        ...
    }
}
<b>clean.doLast</b> {
    targetDir.deleteDir()
}
<b>task</b> compileDotty(type: JavaExec) {
    <b>dependsOn</b> compileJava
    ...
    main <span style="color:#990000;">"dotty.tools.dotc.Main"</span>
}
<b>compileDotty.doFirst</b> {
    <b>if</b> (!classesDir.exists()) classesDir.mkdirs()
}
<b>build</b> {
    <b>dependsOn</b> compileDotty
}
<b>task</b> run(type: JavaExec) {
    <b>dependsOn</b> build
    ...
    <b>if</b> (mainClassName?.trim()) main mainClassName
    <b>else</b> main <span style="color:#990000;">"Main"</span>
    <b>if</b> (args == null) args <span style="color:#990000;">""</span>
}
...
</pre>

Command **`gradle clean run`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> clean run</b>

&gt; Task :run
Hello world!

BUILD SUCCESSFUL in 4s
7 actionable tasks: 7 executed
</pre>

## <span id="gmake">Make build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The Make build file [**`HelloWorld\Makefile`**](HelloWorld/Makefile) depends on the parent file [**`myexamples\Makefile.inc`**](Makefile.inc) which defines common settings (i.e. tool and library paths).

> **:mag_right:** Command [**`make`**][gmake_cli] is a build tool that automatically builds executable programs and libraries from source code by reading files called Makefiles which specify how to derive the target program. [Make] was originally created by Stuart Feldman in April 1976 at Bell Labs.

Command **`make clean run`** produces the following output ([**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala)):

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> clean run</b>
rm -rf "target"
[ -d "target/classes" ] || mkdir -p "target/classes"
scalac.bat "@target/scalac_opts.txt" "@target/scalac_sources.txt"
scala.bat -classpath "target/classes" myexamples.HelloWorld 2
Hello world!
</pre>

Command **`make test`** executes the test suite [**`HelloWorldTest.scala`**](HelloWorld/src/test/scala/HelloWorldTest.scala) for program [**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala).

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> test</b>
[ -d "target/test-classes" ] || mkdir -p "target/test-classes"
scalac.bat "@target/scalac_test_opts.txt" "@target/scalac_test_sources.txt"
java.exe -classpath "%USERPROFILE%/.m2/repository/org/scala-lang/scala-library/2.13.14/scala-library-2.13.14.jar;%USERPROFILE%/.m2/repository/ch/epfl/lamp/scala3-library_3/3.3.1/scala3-library_3-3.3.1.jar;%USERPROFILE%/.m2/repository/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar;%USERPROFILE%/.m2/repository/junit/junit/4.13.2/junit-4.13.2.jar;%USERPROFILE%/.m2/repository/com/novocode/junit-interface/0.11/junit-interface-0.11.jar;%USERPROFILE%/.m2/repository/org/scalatest/scalatest_2.13/3.2.9/scalatest_2.13-3.2.9.jar;%USERPROFILE%/.m2/repository/org/scalactic/scalactic_2.13/3.2.9/scalactic_2.13-3.2.9.jar;%USERPROFILE%/.m2/repository/org/specs2/specs2-core_2.13/4.11.0/specs2-core_2.13-4.11.0.jar;%USERPROFILE%/.m2/repository/org/specs2/specs2-junit_2.13/4.11.0/specs2-junit_2.13-4.11.0.jar;%USERPROFILE%/.m2/repository/org/specs2/specs2-matcher_2.13/4.11.0/specs2-matcher_2.13-4.11.0.jar;target/classes;target/test-classes" org.junit.runner.JUnitCore myexamples.HelloWorldTest
JUnit version 4.13.2
.
Time: 0.201

OK (1 test)
</pre>

Command **`make test`** generates the HTML documentation for program [**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> doc</b>
[ -d "target/docs" ] || mkdir -p "target/docs"
scalad.bat "@target/scaladoc_opts.txt" "@target/scaladoc_sources.txt"
Compiling (1/1): HelloWorld.scala
[doc info] Generating doc page for: myexamples
[doc info] Generating doc page for: myexamples.HelloWorld$
[doc info] Generating doc page for: myexamples.HelloWorld$
[...]
public members with docstrings:    0
protected members with docstrings: 0
private members with docstrings:   0
</pre>


## <span id="maven">Maven build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The [Maven][apache_maven_about] build file [**`HelloWorld\pom.xml`**](HelloWorld/pom.xml) depends on the parent file [**`myexamples\pom.xml`**](pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**).

> **:mag_right:** Command [**`mvn`**][apache_maven_cli] is a Java-based build tool maintained by the [Apache Software Foundation][apache_maven_history] (tool created in 2002). It works with XML-based configuration files and provides a way to share JARs across several projects.

Command **`mvn clean test`** with option **`-debug`** produces additional debug information, including the underlying command lines executed by our Maven plugin **`scala-maven-plugin`**:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/run.html">mvn</a> -debug clean test | findstr /b /c:"[DEBUG]\ [execute]" 2>NUL</b>
[DEBUG] [execute] C:\opt\jdk-temurin-17.0.12_7\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\scala3-3.3.4 \
 -cp C:\opt\scala3-3.3.4\lib\*.jar -Dscala.usejavacp=true  \
 dotty.tools.dotc.Main \
 -classpath W:\dotty-examples\examples\hello-scala\target\classes \
 -d W:\dotty-examples\examples\hello-scala\target\classes \
 W:\dotty-examples\examples\hello-scala\src\main\scala\hello.scala
[DEBUG] [execute] C:\opt\jdk-temurin-17.0.12_7\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\scala3-3.3.4 [...]
[DEBUG] [execute] C:\opt\jdk-temurin-17.0.12_7\bin\java.exe \
 -Xms64m -Xmx1024m -cp C:\opt\scala3-3.3.4\lib\*.jar;\
W:\dotty-examples\examples\hello-scala\target\classes hello
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output (option **`--quiet`** tells Maven not to display anything other than **`ERROR`** level messages):

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/run.html">mvn</a> --quiet clean test</b>
Hello world!
</pre>

We can also specify phase **`package`** to generate (and maybe execute) the **`HelloWorld`** Java archive:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/run.html">mvn</a> clean package</b>
[INFO] Scanning for projects...
[INFO]
[INFO] --------------------< dotty.myexamples:HelloWorld >---------------------
[INFO] Building HelloWorld 0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[..]
[INFO] --- maven-jar-plugin:3.3.1:jar (default-jar) @ HelloWorld ---
[INFO] Building jar: W:\myexamples\HelloWorld\target\HelloWorld-0.1-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  5.635 s
[INFO] Finished at: 2019-01-31T13:53:22+01:00
[INFO] ------------------------------------------------------------------------
</pre>

> **&#9755;** **Scala Maven Plugin**<br/>
> In the Maven configuration file we note the presence of the Maven plugin [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip). In fact the parent file [**`examples\pom.xml`**](pom.xml) depends on [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip), a Maven plugin we developed specifically for this project:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/more">more</a> ..\pom.xml</b>
> &lt;?xml version="1.0" encoding="UTF-8"?&gt;
> ...
>     <b>&lt;properties&gt;</b>
>         <b>&lt;project.build.sourceEncoding&gt;</b>UTF-8<b>&lt;/project.build.sourceEncoding&gt;</b>
>         <b>&lt;java.version&gt;</b>1.8<b>&lt;/java.version&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Scala settings --&gt;</i>
>         <b>&lt;scala.version&gt;</b>3.3.1<b>&lt;/scala.version&gt;</b>
>         <b>&lt;scala.local.install&gt;</b>true<b>&lt;/scala.local.install&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Maven plugins --&gt;</i>
>         <b>&lt;scala.maven.version&gt;</b>1.0-SNAPSHOT<b>&lt;/scala.maven.version&gt;</b>
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
> The plugin is available as <a href="https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/">Zip archive</a> and its installation is deliberately very simple:
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://linux.die.net/man/1/unzip">unzip</a> ..\bin\scala-maven-plugin-1.0.zip %USERPROFILE%\.m2\repository\</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f %USERPROFILE%\.m2\repository\ch\epfl\alumni | findstr /v "^[A-Z]"</b>
> |   maven-metadata-local.xml
> |
> \---scala-maven-plugin
>     |   maven-metadata-local.xml
>     |
>     \---1.0.0
>             maven-metadata-local.xml
>             scala-maven-plugin-1.0.0.jar
>             scala-maven-plugin-1.0.0.pom
>             _remote.repositories
> </pre>

Finally can check the Java manifest in **`HelloWorld-1.0-SNAPSHOT.jar`**:

<pre style="font-size:80%;">
<b>&gt;</b> <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html">java</a> -Xbootclasspath/a:c:\opt\scala3-3.3.4\lib\scala3-library_3-3.3.4-RC1.jar;^
c:\opt\scala3-3.3.4\lib\scala-library-2.13.14.jar ^
-jar target\HelloWorld-1.0-SNAPSHOT.jar
Hello world!
</pre>

> **:mag_right:** We can use batch script [**`searchjars`**](../bin/searchjars.bat) in case some class is missing in the specified classpath, e.g.
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html">java</a> -Xbootclasspath/a:c:\opt\scala3-3.3.4\lib\scala3-library_3-3.3.4-RC1.jar -jar target\enum-Color-1.0-SNAPSHOT.jar</b>
> Exception in thread "main" java.lang.NoClassDefFoundError: scala/Serializable
>         [...]
>         at Main.main(Main.scala)
> Caused by: java.lang.ClassNotFoundException: scala.Serializable
>         [...]
>         ... 13 more
> 
> <b>&gt; <a href="../bin/searchjars.bat">searchjars</a> Serializable</b>
> Searching for class name Serializable in library files C:\opt\scala3-3.3.4\lib\*.jar
>   jackson-core-2.13.3.jar:com/fasterxml/jackson/core/SerializableString.class
>   [...]
>   scala-library-2.13.14.jar:scala/collection/generic/DefaultSerializable.class
> Searching for class name Serializable in library files C:\opt\scala-2.13.14\lib\*.jar
>   scala-library.jar:scala/collection/generic/DefaultSerializable.class
> Searching for class name Serializable in library files C:\opt\jdk-temurin-17.0.12_7\lib\*.jar
> Searching for class name Serializable in archive files C:\opt\javafx-sdk-17.0.1\lib\*.jar
> </pre>
> Class **`scala.Serializable`** is part of **`C:\opt\scala3-3.3.4\lib\scala-library-2.13.14.jar`**, so let us add it to our classpath !


## <span id="mill">Mill build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The Mill build file [**`build.sc`**](HelloWorld/build.sc) depends on the parent file [**`myexamples\common.sc`**](common.sc) which defines the common settings.
It is a standalone file written in Scala (with direct access to [OS-Lib][os_lib]).

> **:mag_right:** Command [**`mill`**][mill_cli] is a Scala-based build tool which aims for simplicity to build projects in a fast and predictable manner.

Command [**`mill -i app`**](HelloWorld/build.sc) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.lihaoyi.com/mill/#command-line-tools">mill</a> -i app</b>
[38/38] app.run
Hello world!
</pre>


## <span id="sbt">SBT build tool</span> <sup><sub>[**&#9650;**](#top)</sub></sup>

The SBT build file [**`build.sbt`**](HelloWorld/build.sbt) is written in [Scala] and obeys the [sbt build definitions](https://www.scala-sbt.org/1.0/docs/Basic-Def.html).

> **:mag_right:** [Lightbend] provides commercial support for the [**`sbt`**][sbt_cli] build tool.

Command **<code>[sbt](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) -warn clean run</code>** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html">sbt</a> -warn clean run</b>
Hello world!
</pre>

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Batch files and coding conventions*** [↩](#anchor_01)

<dl><dd>
Batch files (e.g. <a href="HelloWorld/build.bat"><b><code>HelloWorld\build.bat</code></b></a>) obey the following coding conventions:

- We use at most 80 characters per line. In general we would say that 80 characters fit well with 4:3 screens and 100 characters fit well with 16:9 screens (both [Databricks](https://github.com/databricks/scala-style-guide#line-length) and [Google](https://google.github.io/styleguide/javaguide.html#s4.4-column-limit) use the convention of 100 characters).
- We organize our code in 4 sections: `Environment setup`, `Main`, `Subroutines` and `Cleanups`.
- We write exactly ***one exit instruction*** (label **`end`** in section **`Cleanups`**).
- We adopt the following naming conventions: global variables start with character `_` (shell variables defined in the user environment start with a letter) and local variables (e.g. inside subroutines or  **`if/for`** constructs) start with `__` (two `_` characters).
</dd>
<dd>
<pre style="font-size:80%;">
<b>@echo off</b>
<b>setlocal enabledelayedexpansion</b>
...
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Environment setup</i>
&nbsp;
<b>set</b> _EXITCODE=0
&nbsp;
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:env</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
&nbsp;
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:props</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
&nbsp;
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:args</span> %*</b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Main</i>
&nbsp;
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if" rel="external"><b>if</b></a> <span style="color:#3333ff;">%_CLEAN%</span>==1 (
    <b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> :clean</b>
    <b>if not</b> !_EXITCODE!==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if" rel="external"><b>if</b></a> <span style="color:#3333ff;">%_COMPILE%</span>==1 (
    <b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:compile</span></b>
    <b>if not</b> !_EXITCODE!==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if" rel="external"><b>if</b></a> <span style="color:#3333ff;">%_DOC%</span>==1 (
    <b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:doc</span></b>
    <b>if not</b> !_EXITCODE!==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
)
<a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/if" rel="external"><b>if</b></a> <span style="color:#3333ff;">%_RUN%</span>==1 (
    <b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call">call</a> <span style="color:#9966ff;">:run</span></b>
    <b>if not</b> <span style="color:#3333ff;">!_EXITCODE!</span>==0 <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto"><b>goto</b></a> <span style="color:#9966ff;">end</span>
)
<b>goto <span style="color:#9966ff;">end</span></b>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Subroutines</i>
&nbsp;
<span style="color:#9966ff;">:env</span>
...<i>(variable initialization, eg. directory paths)</i>...
<b><a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/goto">goto</a> :eof</b>
<span style="color:#9966ff;">:props</span>
...<i>(read file build.properties if present)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:args</span>
...<i>(command line options/subcommands)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:clean</span>
...<i>(delete generated files/directories)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:compile</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:doc</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:run</span>
...
<b>goto :eof</b>
&nbsp;
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Cleanups</i>
&nbsp;
<span style="color:#9966ff;">:end</span>
...
<b><a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/exit">exit</a></b> /b <span style="color:#3333ff;">%_EXITCODE%</span>
</pre>
</dd>
</dl>

<span id="footnote_02">[2]</span> ***MSYS2 Shell options*** [↩](#anchor_02)

<dl><dd>
<pre style="font-size:80%;">
<b>&gt; c:\opt\msys64\<a href="https://www.msys2.org/wiki/Launchers/" rel="external">msys2_shell.cmd</a> --help</b>
Usage:
    msys2_shell.cmd [options] [login shell parameters]
&nbsp;
Options:
    -mingw32 | -mingw64 | -msys[2]   Set shell type
    -defterm | -mintty | -conemu     Set terminal type
    -here                            Use current directory as working
                                     directory
    -where DIRECTORY                 Use specified DIRECTORY as working
                                     directory
    -[use-]full-path                 Use full current PATH variable
                                     instead of trimming to minimal
    -no-start                        Do not use "start" command and
                                     return login shell resulting
                                     errorcode as this batch file
                                     resulting errorcode
    -shell SHELL                     Set login shell
    -help | --help | -? | /?         Display this help and exit

Any parameter that cannot be treated as valid option and all
following parameters are passed as login shell command parameters.
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_faq]: https://ant.apache.org/faq.html#ant-name
[apache_ant_history]: https://ant.apache.org/faq.html#history
[apache_ant_ivy]: https://ant.apache.org/ivy/
[apache_ant_ivy_relnotes]: https://ant.apache.org/ivy/history/2.5.2/release-notes.html
[apache_maven_about]: https://maven.apache.org/what-is-maven.html
[apache_maven_cli]: https://maven.apache.org/ref/3.9.8/maven-embedder/cli.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[bash]: https://en.wikipedia.org/wiki/Bash_(Unix_shell)
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[cygwin]: https://cygwin.com/install.html
[gmake_cli]: http://www.glue.umd.edu/lsf-docs/man/gmake.html
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_groovy]: https://www.groovy-lang.org/
[gradle_java_plugin]: https://docs.gradle.org/current/userguide/java_plugin.html
[gradle_plugins]: https://docs.gradle.org/current/userguide/plugins.html
[gradle_wrapper]: https://docs.gradle.org/current/userguide/gradle_wrapper.html
[lightbend]: https://www.lightbend.com/
[make]: https://www.gnu.org/software/make/
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[mill_cli]: https://www.lihaoyi.com/mill/#command-line-tools
[msys2]: https://www.msys2.org/
[os_lib]: https://github.com/lihaoyi/os-lib
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[scala]: https://www.scala-lang.org/
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html

# <span id="top">SemanticDB examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://scalameta.org/docs/semanticdb/guide.html" rel="external"><img style="border:0;width:120px;" src="https://scalameta.org/img/scalameta.png" alt="Scalameta project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>semanticdb-examples\</code></strong> contains <a href="https://scalameta.org/docs/semanticdb/guide.html" rel="external">SemanticDB</a> code examples coming from various websites - mostly from the <a href="https://scalameta.org/docs/semanticdb/guide.html" rel="external">SemanticDB project</a>.
  </td>
  </tr>
</table>

<!--
https://geirsson.com/assets/scalasphere-2018.pdf
-->
We need to install additional command-line tools in order to work on our code examples.
- [Metac] <sup id="anchor_01">[1](#footnote_01)</sup> &ndash; to generate `.semanticdb` files from `.scala` files.
- [Metap] &ndash; to prettyprint `.semanticdb` files.
- [Protoc] <sup id="anchor_02">[2](#footnote_02)</sup> &ndash; to compile `.proto` files.

> **:mag_right:** The above tools must be installed in two different ways:
> - We need [Coursier] to install the **`metac`** and **`metap`** comand line tools <sup id="anchor_03">[3](#footnote_03)</sup> (no Tgz/Zip archive available).
> - We extract the Zip archive [**`protoc-yy.z-win64.zip`**](https://github.com/protocolbuffers/protobuf/) (available from GitHub project [`protocolbuffers/protobuf`](https://github.com/protocolbuffers/protobuf/releases)) into directory **`C:\opt\protoc-yy.z\`**.

In our case we execute the batch command [**`semanticdb-examples\setenv.bat`**](./setenv.bat) to provide additional settings to our environment :

<pre style="font-size:80%;">
<b>&gt; <a href="./setenv.bat">setenv.bat</a> -verbose</b>
Tool versions:
   java 17.0.9, javac 17.0.9, scalac 3.3.2-RC1,
   protoc 25.1, cs 2.0.13, kotlinc 1.9.22,
   git 2.43.0.windows.1, diff 3.10, bash 5.2.21(1)-release
Tool paths:
   C:\opt\jdk-temurin-17.0.9_9\bin\java.exe
   C:\opt\jdk-temurin-17.0.9_9\bin\javac.exe
   C:\opt\scala3-3.3.2-RC1\bin\scalac.bat
   C:\opt\protoc\bin\protoc.exe
   <a href="">%LOCALAPPDATA%</a>\Coursier\data\bin\cs.bat
   C:\opt\kotlinc-1.9.22\bin\kotlinc.bat
   C:\opt\Git\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
   C:\opt\Git\bin\bash.exe
Environment variables:
   "COURSIER_HOME=C:\opt\coursier-2.1.7"
   "GIT_HOME=C:\opt\Git"
   "JAVA_HOME=C:\opt\jdk-temurin-17.0.9_9"
   "KOTLIN_HOME=C:\opt\kotlinc-1.9.22"
   "PROTOC_HOME=C:\opt\protoc"
Path associations:
   I:\: => %USERPROFILE%\workspace-perso\dotty-examples
</pre>

## <span id="hello">`hello` Example</span>

Command [**`build.bat run`**](hello/build.bat) generates and prettyprints the [SemanticDB](https://scalameta.org/docs/semanticdb/guide.html) data for the Scala program [**`Main.scala`**](hello/src/main/scala/Main.scala) :
<pre style="font-size:80%;">
<b>&gt; <a href="hello/build.bat">build</a> -verbose run</b>
Create semanticdb file
Prettyprint contents of semanticdb files
src/main/scala/Main.scala
&minus;-----------------------
&nbsp;
Summary:
Schema =&gt; SemanticDB v4
Uri =&gt; src/main/scala/Main.scala
Text =&gt; empty
Language =&gt; Scala
Symbols =&gt; 3 entries
Occurrences =&gt; 7 entries

Symbols:
_empty_/Main. => final object Main extends AnyRef { +1 decls }
_empty_/Main.main(). => method main(args: Array[String]): Unit
_empty_/Main.main().(args) => param args: Array[String]

Occurrences:
[0:7..0:11) <= _empty_/Main.
[2:6..2:10) <= _empty_/Main.main().
[2:11..2:15) <= _empty_/Main.main().(args)
[2:17..2:22) => scala/Array#
[2:23..2:29) => scala/Predef.String#
[2:33..2:37) => scala/Unit#
[3:4..3:11) => scala/Predef.println(+1).
</pre>

Similarly command [**`build.bat -lang:java run`**](hello/build.bat) generates and prettyprints the [SemanticDB data](https://scalameta.org/docs/semanticdb/specification.html) for the Java program [**`Main.java`**](hello/src/main/java/Main.java) :

<pre style="font-size:80%;">
<b>&gt; <a href="hello/build.bat">build</a> -lang:java run</b>
Main.java
&minus;--------

Summary:
Schema => SemanticDB v4
Uri => Main.java
Text => empty
Language => Java
Symbols =&gt; 4 entries
Occurrences => 8 entries
&nbsp;
Symbols:
``/Main# => class Main extends Object { +2 decls }
``/Main#`<init>`(). => ctor <init>(): Unit
``/Main#main(). => static method main(private[main] unknown args: Array[String]): Unit
local0 => private[main] unknown args: Array[String]
&nbsp;
Occurrences:
[0:13..0:17) <= ``/Main#
[0:13..0:17) <= ``/Main#`<init>`().
[2:23..2:27) <= ``/Main#main().
[2:28..2:34) => java/lang/String#
[2:37..2:41) <= local0
[3:8..3:14) => java/lang/System#
[3:15..3:18) => java/lang/System#out.
[3:19..3:26) => java/io/PrintStream#println(+8).
</pre>

With tiny code examples such as [**`Main.scala`**](hello/src/main/scala/Main.scala) we could also update the **`PATH`** variable and work with the two commands [**`metac`**](https://github.com/scalameta/scalameta/blob/main/semanticdb/semanticdb3/guide.md#metac) and [**`metap`**](https://github.com/scalameta/scalameta/blob/main/semanticdb/semanticdb3/guide.md#metap) directly :
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> "PATH=%PATH%;%COURSIER_DATA_DIR%\bin;c:\opt\protoc-23.4"</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> metac</b>
<a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%LOCALAPPDATA%</a>\Coursier\data\bin\metac.bat
&nbsp;
<b>&gt; <a href="https://scalameta.org/docs/semanticdb/guide.html#metac">metac</a> -d target\classes src\main\scala\Main.scala</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f target\classes |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [a-z]</b>
│   .latest-build
│
└───META-INF
    └───semanticdb
        └───src
            └───main
                └───scala
                        Main.scala.semanticdb
&nbsp;
<b>&gt; <a href="https://scalameta.org/docs/semanticdb/guide.html#metap">metap</a> target\classes</b>
src/main/scala/Main.scala
&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;
&nbsp;
Summary:
Schema =&gt; SemanticDB v4
Uri =&gt; src/main/scala/Main.scala
Text =&gt; empty
Language =&gt; Scala
Symbols =&gt; 3 entries
Occurrences =&gt; 7 entries
&nbsp;
Symbols:
_empty_/Main. =&gt; final object Main extends AnyRef { +1 decls }
_empty_/Main.main(). =&gt; method main(args: Array[String]): Unit
_empty_/Main.main().(args) =&gt; param args: Array[String]

Occurrences:
[0:7..0:11) &lt;= _empty_/Main.
[1:6..1:10) &lt;= _empty_/Main.main().
[1:11..1:15) &lt;= _empty_/Main.main().(args)
[1:17..1:22) =&gt; scala/Array#
[1:23..1:29) =&gt; scala/Predef.String#
[1:33..1:37) =&gt; scala/Unit#
[2:4..2:11) =&gt; scala/Predef.println(+1).
</pre>

> **:mag_right:** By default command **`metap <classpath>`** prints only the most important parts of the SemanticDB payload (default option is **`-compact`**).

Finally command [**`build.bat -lang:kotlin run`**](hello/build.bat) fails to generate the [SemanticDB data](https://scalameta.org/docs/semanticdb/specification.html) for the Kotlin program [**`Main.kt`**](hello/src/main/kotlin/Main.kt) :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -verbose -lang:kotlin clean run</b>
Delete directory "target"
Create semanticdb file
warning: flag is not supported by this version of the compiler: \
-Xplugin:semanticdb \
-sourceroot:%USERPROFILE%\workspace-perso\dotty-examples\semanticdb-examples\hello\src\main\kotlin \
-targetroot:%USERPROFILE%\workspace-perso\dotty-examples\semanticdb-examples\hello\target\kotlin-classes
Prettyprint contents of semanticdb files
&nbsp;
<b>&gt; C:\opt\kotlinc-1.9.22\bin\kotlinc -version</b>
info: kotlinc-jvm 1.9.22 (JRE 17.0.9+9)
</pre>

<!--=======================================================================-->

## <span id="semanticdb-example">`semanticdb-example`</span> [**&#x25B4;**](#top)

This code example is an updated version of Geirsson's example (May 2018) available from his GitHub project [`olafurpg/semantic-example`](https://github.com/olafurpg/semanticdb-example).

This example is interesting because we programmatically access the generated `.semanticdb` files from the main program [`Main.scala`](semanticdb-example/cli/src/main/scala/tool/Main.scala).

<pre style="font-size:80%;">
<b>&gt; <a href="semanticdb-example/build.bat">build</a> -verbose compile</b>
Generate SemanticDB data for 2 Scala source files into directory "example\target\classes"
Compile 1 Scala source file to directory "cli\target\classes"
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f example\target\classes |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [a-z]</b>
└───META-INF
    └───semanticdb
        └───example
            └───src
                └───main
                    └───scala
                        └───example
                                Domain.scala.semanticdb
                                Example.scala.semanticdb
</pre>

Then we execute the main program and redirect the output to some file, e.g. `output.txt`:

<pre style="font-size:80%;">
<b>&gt; <a href="semanticdb-example/build.bat">build</a> -verbose run > output.txt</b>
No action required ('example\src\main\scala\*.scala')
No action required ('cli\src\main\scala\*.scala')
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/more">more</a> output.txt</b>
W:\semanticdb-examples\semanticdb-example\cli\src\main\scala\tool\Main.scala:28 document.uri: "example/src/main/scala/example/Domain.scala"
range {
  start_line: 8
  start_character: 27
  end_line: 8
  end_character: 33
}
symbol: "scala/Predef.String#"
role: REFERENCE
[...]
range {
  start_line: 8
  start_character: 57
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Scalameta CLI tools*** [↩](#anchor_01)

<dl><dd>
<table style="font-size:90%;">
<tr>
  <th>CLI&nbsp;tool</th>
  <th>Java&nbsp;archive</th>
  <th>Entry&nbsp;point</th>
</tr>
<tr>
  <td><a href="https://scalameta.org/docs/semanticdb/guide.html#metac"><code>metac.bat</code></a></td>
  <td><a href="https://mvnrepository.com/artifact/org.scalameta/scalameta_2.13"><code>scalameta_2.13-X.Y.Z.jar</code></a></td>
  <td><a href="https://github.com/scalameta/scalameta/blob/main/semanticdb/metac/src/main/scala/scala/meta/cli/Metac.scala"><code>scala.meta.cli.Metac</code></a></td>
</tr>
<tr>
  <td><code>metacp.bat</code></td>
  <td><a href="https://mvnrepository.com/artifact/org.scalameta/scalameta_2.13"><code>scalameta_2.13-X.Y.Z.jar</code></a></td>
  <td><a href="https://github.com/scalameta/scalameta/blob/main/semanticdb/metacp/src/main/scala/scala/meta/cli/Metacp.scala"><code>scala.meta.cli.Metacp</code></a></td>
</tr>
<tr>
  <td><a href="https://scalameta.org/docs/semanticdb/guide.html#metap"><code>metap.bat</code></a></td>
  <td><a href="https://mvnrepository.com/artifact/org.scalameta/scalameta_2.13"><code>scalameta_2.13-X.Y.Z.jar</code></a></td>
  <td><a href="https://github.com/scalameta/scalameta/blob/main/semanticdb/metap/src/main/scala/scala/meta/cli/Metap.scala"><code>scala.meta.cli.Metap</code></a></td>
</tr>
</table>
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> /r %COURSIER_DATA_DIR% metac</b>
%LOCALAPPDATA%\Coursier\data\bin\metac.bat
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> **`protoc`** [↩](#anchor_02)

<dl><dd>
<pre style="font-size:80%;">
<b>&gt; c:\opt\protoc\bin\<a href="https://manpages.ubuntu.com/manpages/kinetic/man1/protoc.1.html" rel="external">protoc.exe</a> --version</b>
libprotoc 25.1
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> ***Installation with Coursier*** [↩](#anchor_03)

<dl><dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> cs</b>
C:\opt\coursier-2.1.7\<a href="https://get-coursier.io/docs/cli-overview">cs.exe</a>
&nbsp;
<b>&gt; <a href="https://get-coursier.io/docs/cli-overview">cs</a> install metac metap</b>
https://repo1.maven.org/maven2/io/get-coursier/apps/maven-metadata.xml
  100.0% [##########] 2.0 KiB (18.6 KiB / s)
[...]
https://repo1.maven.org/maven2/org/scalameta/semanticdb-scalac_2.13.11/4.7.8/semanticdb-scalac_2.13.11-4.7.8.jar
  100.0% [##########] 14.6 MiB (1.2 MiB / s)
Wrote metac
[...]
https://repo1.maven.org/maven2/com/thesamet/scalapb/scalapb-runtime_2.13/0.11.11/scalapb-runtime_2.13-0.11.11.jar
  100.0% [##########] 2.3 MiB (1.1 MiB / s)
Wrote metap
Warning: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%LOCALAPPDATA%</a>\Coursier\data\bin is not in your PATH
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[coursier]: https://get-coursier.io/
[metac]: https://scalameta.org/docs/semanticdb/guide.html#metac
[metap]: https://scalameta.org/docs/semanticdb/guide.html#metap
[protoc]: https://github.com/protocolbuffers/protobuf/releases

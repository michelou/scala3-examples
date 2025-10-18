# <span id="top">Blog <i>Rock the JVM</i></span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:120px;" src="../docs/images/dotty.png" alt="Dotty project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>rockthejvm-examples\</code></strong> contains <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> code examples coming from Ciocîrlan's blog <a href="https://blog.rockthejvm.com/" rel="external"><i>Rock The JVM</i></a>.
  </td>
  </tr>
</table>

Code examples presented below can be built/run with the following tools:

| Build tool                    | Build file(s)                    | Parent file(s)                               | Environment(s) |
|-------------------------------|------------------------------------------|----------------------------------------------|---------|
| [**`ant.bat`**][apache_ant_cli]   | [**`build.xml`**](Enums/build.xml) | [**`build.xml`**](./build.xml), [**`ivy.xml`**](ivy.xml) | Any <sup><b>a)</b></sup> |
| [**`cmd.exe`**][cmd_cli] | [**`build.bat`**](Enums/build.bat)<br/>([**`build.properties`**](Enums/project/build.properties)) | [**`cpath.bat`**](./cpath.bat) <sup><b>b)</b></sup>              | Windows only |
| [**`sh.exe`**][sh_cli] | [**`build.sh`**](Enums/build.sh)<br/>([**`build.properties`**](Enums/project/build.properties)) |                   | [Cygwin]/[MSYS2]/Unix only |
| [**`make.exe`**][gmake_cli]       | [`Makefile`](Enums/Makefile)   | [**`Makefile.inc`**](./Makefile.inc)         | Any|
| [**`mvn.cmd`**][apache_maven_cli] | [`pom.xml`](Enums/pom.xml)     | [**`pom.xml`**](./pom.xml)                   | Any |
| [**`sbt.bat`**][sbt_cli]          | [`build.sbt`](Enums/build.sbt) | n.a.                                         | Any |
<div style="margin:0 10% 0 8px;font-size:90%;">
<sup><b>a)</b></sup> Here "Any" means "tested on Windows, Cygwin, MSYS2 and Unix".<br/>
<sup><b>b)</b></sup> This utility batch file manages <a href="https://maven.apache.org/" rel="external">Maven</a> dependencies and returns the associated Java class path (as environment variable).<br/>&nbsp;</div>

## <span id="extension-methods">`ExtensionMethods` Example</span>

Code example `ExtensionMethods` is presented in Ciorcîlan's blog post [**Scala 3: Extension Methods**](https://blog.rockthejvm.com/scala-3-extension-methods/) (April 2021).

<pre style="font-size:80%;">
<b>&gt; <a href="./ExtensionMethods/build.bat">build</a> -verbose run</b>
Compile 1 Scala source file to directory "target\classes"
Execute Scala main class "rockthejvm.Main"
Hi, I'm Daniel, nice to meet you.
t1=Branch(Leaf(a),Leaf(b))
t2=Branch(Leaf(A),Leaf(B))
tree=Branch(Leaf(1),Leaf(2))
three=3
three1=3
</pre>

## <span id="givens">`Givens` Example</span> [**&#x25B4;**](#top)

Code example `Givens` is presented in Ciorcîlan's blog post [**Givens vs. Implicits in Scala 3**](https://blog.rockthejvm.com/givens-vs-implicits/) (November 2020).

<pre style="font-size:80%;">
<b>&gt; <a href="./Givens/build.bat">build</a> -verbose run</b>
Compile 1 Scala source file to directory "target\classes"
Execute Scala main class "rockthejvm.Main"
Hey, I'm Alice. Scala rocks!

Hey, I'm Alice. Scala rocks!
</pre>

## <span id="infix-methods">`InfixMethods` Example</span>

Code example `InfixMethods` is presented in Ciorcîlan's blog post [**Infix Methods in Scala 3**](https://blog.rockthejvm.com/scala-3-infix-methods/) (November 2020).

<pre style="font-size:80%;">
<b>&gt; <a href="./InfixMethods/build.bat">build</a> -verbose run</b>
Compile 1 Scala source file to directory "target\classes"
Execute Scala main class "rockthejvm.Main"
Person(Mary)
Mary likes Forrest Gump
Mary likes Forrest Gump

Person(Mary)
Mary likes Forrest Gump
</pre>

## <span id="enums">`Enums` Example</span> [**&#x25B4;**](#top)

Code example `Enums` is presented in Ciorcîlan's blog post [**Enums in Scala 3**](https://blog.rockthejvm.com/enums-scala-3/) (September 2020).

<pre style="font-size:80%;">
<b>&gt; <a href="./Enums/build.bat">build</a> -verbose run</b>
Compile 1 Scala source file to directory "target\classes"
Execute Scala main class rockthejvm.Main
bitString=4
hexString=4
&nbsp;
first=0
allPermissions=READ WRITE EXEC NONE
fromBits(2)=WRITE
</pre>

## <span id="eta-expansion">`EtaExpansion` Example</span>

Code example `EtaExpansion` is presented in Ciorcîlan's blog post [**Eta-Expansion and Partially Applied Functions in Scala**](https://blog.rockthejvm.com/eta-expansion-and-paf/) (August 2020).

<pre style="font-size:80%;">
<b>&gt; <a href="./EtaExpansion/build.bat">build</a> -verbose run</b>
Compile 1 Scala source file to directory "target\classes"
Execute Scala main class "rockthejvm.Main"
incrementMethod(3)=4
three=3
threeExplicit=3
List(2, 3, 4)
List(3, 4, 5)
ten=10
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_faq]: https://ant.apache.org/faq.html#ant-name
[apache_ant_ivy]: https://ant.apache.org/ivy/
[apache_ant_ivy_relnotes]: https://ant.apache.org/ivy/history/2.5.0/release-notes.html
[apache_foundation]: https://maven.apache.org/docs/history.html
[apache_history]: https://ant.apache.org/faq.html#history
[apache_maven_about]: https://maven.apache.org/what-is-maven.html
[apache_maven_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
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
[scala3_home]: https://dotty.epfl.ch/
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
[windows_stderr]: https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
[zip_archive]: https://www.howtogeek.com/178146/

# <span id="top">OpenJDK and Scala 3 on Windows</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:100px;" src="docs/images/dotty.png" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    <a href="https://openjdk.java.net/faq/" rel="external">OpenJDK</a> is an open-source project initiated by Oracle in 2010. Java 8 is the first LTS version of Java to be released <i>both</i> as a commercial product (<a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html">Oracle Java SE 8 </a>) and as an open-source product (<a href="https://adoptium.net/" rel="external">Temurin OpenJDK 8</a>) <sup id="anchor_01"><a href="#footnote_01">1</a></sup>.<br/>In the following we focus on <a href="https://jdk.java.net/11/" rel="external">OpenJDK 11</a> and <a href="https://jdk.java.net/17/" rel="external">OpenJDK 17</a>, the current LTS version of Java.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Scala 3][scala3_home] on Windows:

- [Running Scala 3 on Windows](README.md)
- [Building Scala 3 on Windows](BUILD.md)
- [Data Sharing and Scala 3 on Windows](CDS.md)
- OpenJDK and Scala 3 on Windows [**&#9660;**](#bottom)

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [Deno][deno_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples], [WiX Toolset][wix_examples] and [Zig][zig_examples] are other topics we are currently monitoring.


## <span id="proj_deps">Project dependencies</span>

This project depends on several external software for the **Microsoft Windows** platform:

- [Corretto OpenJDK 17][corretto_17_downloads] from [Amazon][amazon_aws] ([*release notes*][corretto_17_relnotes]).
- [Dragonwell OpenJDK 17][dragonwell17_downloads] from [Alibaba][alibaba] ([*release notes*][dragonwell17_relnotes]).
- [GraalVM OpenJDK 17][graalvm_downloads] from [Oracle] ([*release notes*][graalvm_relnotes]).
- [Liberica OpenJDK 17][bellsoft17_downloads] from [BellSoft][bellsoft_about] ([*release notes*][bellsoft_relnotes]).
- [Liberica NIK OpenJDK 17][bellsoft_nik_downloads] from [BellSoft][bellsoft_about] ([*release notes*][bellsoft_nik_relnotes]).
- [Microsoft OpenJDK 17][microsoft_downloads] from [Microsoft][microsoft].
- [OpenJ9 OpenJDK 17][openj9_downloads] from [IBM Developer](https://developer.ibm.com/) ([*release notes*][openj9_relnotes]).
- [RedHat OpenJDK 17][redhat_downloads] from [RedHat].
- [SapMachine OpenJDK 17](https://sap.github.io/SapMachine/) from [SAP][sap_home].
- [Temurin OpenJDK 17][temurin11_downloads] from [Eclipse] ([*release notes*][temurin11_relnotes]).
- [Trava OpenJDK 11][trava_downloads] from [Travis](https://travis-ci.com/) ([*release notes*][trava_relnotes]).
- [Zulu OpenJDK 17][azul_downloads] from [Azul Systems][azul_systems] ([*release notes*][azul_relnotes]).

<!--
https://devblogs.microsoft.com/java/announcing-general-availability-of-microsoft-build-of-openjdk/
-->

The above implementations of OpenJDK[&trade;][openjdk_trademark] differ in several ways:

- they are tested and certified for [JCK][openjdk_jck] <sup id="anchor_02">[2](#footnote_02)</sup> compliance excepted for Trava OpenJDK.
- they include different [backports](https://builds.shipilev.net/backports-monitor/) of fixes from OpenJDK 12 or newer (eg. [Corretto][corretto11_patches]).
- they include additional modules (eg. Device IO API on Linux ARMv7) or integrate special tools (eg. HotswapAgent in [Trava](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm)).
- they support different sets of platform architectures (eg. [SapMachine](https://sap.github.io/SapMachine/) x64 only, [BellSoft][bellsoft_relnotes] also Raspberry Pi 2 &amp; 3).


> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**][unix_opt] directory on Unix).

For instance our development environment looks as follows (*November 2025*) <sup id="anchor_03">[3](#footnote_03)</sup>:

<pre style="font-size:80%;">
C:\opt\jdk-bellsoft-11.0.21\              <i>(303 MB)</i>
C:\opt\jdk-bellsoft-17.0.9\               <i>(310 MB)</i>
C:\opt\jdk-bellsoft-21.0.1\               <i>(262 MB)</i>
C:\opt\jdk-bellsoft-nik-java11-22.0.0.2\  <i>(596 MB)</i>
C:\opt\jdk-bellsoft-nik-java17-22.0.0.2\  <i>(657 MB)</i>
C:\opt\jdk-corretto-11.0.20_9\            <i>(293 MB)</i>
C:\opt\jdk-corretto-17.0.9_8\             <i>(299 MB)</i>
C:\opt\jdk-dcevm-11.0.15_1\               <i>(313 MB)</i>
C:\opt\jdk-dragonwell-11.0.20.17_8\       <i>(290 MB)</i>
C:\opt\jdk-dragonwell-17.0.7.0.7_7\       <i>(299 MB)</i>
C:\opt\jdk-graalvm-ce-17.0.8_7.1\         <i>(591 MB)</i>
C:\opt\jdk-graalvm-ce-20.0.2_9.1\         <i>(624 MB)</i>
C:\opt\jdk-graalvm-ce-21-dev_30.1\        <i>(632 MB)</i>
C:\opt\jdk-microsoft-11.0.20_8\           <i>(292 MB)</i>
C:\opt\jdk-microsoft-17.0.9_8\            <i>(300 MB)</i>
C:\opt\jdk-microsoft-21.0.1_12\           <i>(325 MB)</i>
C:\opt\jdk-openj9-11.0.20.1_1\            <i>(326 MB)</i>
C:\opt\jdk-openj9-17.0.8.1_1\             <i>(334 MB)</i>
C:\opt\jdk-redhat-11.0.20.8-1\            <i>(364 MB)</i>
C:\opt\jdk-redhat-17.0.8.0.7-1\           <i>(377 MB)</i>
C:\opt\jdk-sapmachine-11.0.21\            <i>(316 MB)</i>
C:\opt\jdk-sapmachine-17.0.9\             <i>(325 MB)</i>
C:\opt\jdk-sapmachine-21.0.1\             <i>(353 MB)</i>
C:\opt\jdk-temurin-11.0.21_9\             <i>(300 MB)</i>
C:\opt\jdk-temurin-17.0.9_9\              <i>(299 MB)</i>
C:\opt\jdk-temurin-21.0.1_12\             <i>(326 MB)</i>
C:\opt\jdk-zulu-11.0.19-win_x64\          <i>(302 MB)</i>
C:\opt\jdk-zulu-17.0.8-win_x64\           <i>(306 MB)</i>
</pre>
<!-- corretto  : 11.0.8 = 290 MB, 11.0.9 = 292 MB, 11.0.10 = 292 MB -->
<!-- dcevm     : 11.0.8 = 296 MB, 11.0.9 = 296 MB, 11.0.10 = 313 MB-->
<!-- dragonwell: 11.0.11 = 280 MB, 11.0.12 = 290 MB -->
<!-- microsoft : 11.0.11 = 291 MB -->
<!-- sap       : 11.0.8 = 288 MB, 11.0.9 = 315 MB, 11.0.10 = 316 MB -->
<!-- temurin   : 11.0.8 = 297 MB, 11.0.9 = 299 MB, 11.0.10 = 300 MB -->
<!-- zulu      : 11.0.8 = 299 MB, 11.0.9 = 300 MB, 11.0.10 = 301 MB -->

## <span id="build_times">Scala 3 build times</span> [**&#x25B4;**](#top)

We perform a quick comparison of the execution times to build the Scala 3 software distribution available as the following two archive files :
<pre style="font-size:80%;">
dist\target\scala3-3.3.1-RC1-bin-SNAPSHOT.tar.gz
dist\target\scala3-3.3.1-RC1-bin-SNAPSHOT.zip
</pre>

> **:mag_right:** Scala nightly builds are published on Maven as individual Java archive files, e.g.
> - [`scala3-compiler`](https://mvnrepository.com/artifact/org.scala-lang/scala3-compiler) (Scala 3 compiler)
> - [`scala3-library`](https://mvnrepository.com/artifact/org.scala-lang/scala3-library) (Scala 3 library)
> - and so on.

We ideally would run the command [`build archives`](./bin/dotty/build.bat) to generate the above files (presuming all tests were successful).

Unfortunately a few tests still fail on Windows, so need to proceed in two steps, running the command [`build boot & build arch-only`](./bin/dotty/build.bat), in order to achieve our goal. 

Let's compare the build times for Java 8, Java 11 and Java 17 on a Win10 laptop with an i7-8550U (1.8 GHz) processor and 16 Go of memory <sup id="anchor_04">[4](#footnote_04)</sup> (entries come from the log file [`snapshot_log.txt`](./docs/snapshot_log.txt)):

| 8u345 | **Build&nbsp;time** | 11.0.16  | **Build&nbsp;time** | 17.0.4 | **Build&nbsp;time** |
|-----------|---------------------|----------|---------------------|-------|---------------------|
| [Corretto][corretto_8_downloads]<br/>(Amazon) | 27:00</br>27:27 | [Corretto][corretto_11_downloads]<br/>(Amazon) |   30:49<br/>30:42 | [Corretto][corretto_17_downloads]<br/>(Amazon)</span> | n.a. |
| <span style="color:#aaaaaa;">DCEVM<br/>(Trava)</span> | n.a. | [DCEVM][trava_downloads]<br/>(Trava) <a href="#a"><sup><b>a)</b></sup></a> | 31:10<br/>30:28 | <span style="color:#aaaaaa;">DCEVM<br/>(Trava)</span> | n.a.           |
| [Dragonwell][dragonwell8_downloads]<br/>(Alibaba) | 31:54<br/>32:01 | [Dragonwell][dragonwell11_downloads]<br/>(Alibaba) | 30:41<br/>30:44 | [Dragonwell][dragonwell17_downloads]<br/>(Alibaba)</span> | n.a. |
| [GraalVM][graalvm_downloads]<br/>(Oracle) | 26:09<br/>26:11 | [GraalVM][graalvm_downloads]<br/> (Oracle) | 31:34<br/>33:11 | [GraalVM][graalvm_downloads]<br/> (Oracle) | 33:30<br/>&nbsp; |
| [Liberica][bellsoft8_downloads]<br/>(BellSoft) | 25:10<br/>25:41 | [Liberica][bellsoft11_downloads]<br/>(BellSoft) | 31:04<br/>30:33 | [Liberica][bellsoft17_downloads]<br/>(BellSoft) | 29:38<br/>31:17 |
| Liberica NIK<br/>(BellSoft) | n.a. | [Liberica NIK][bellsoft_nik_downloads]<br/>(BellSoft) <a href="#b"><sup><b>b)</b></sup></a> | 31:29 | [Liberica NIK][bellsoft_nik_downloads]<br/>(BellSoft) | <i>todo</i> |
| <span style="color:#aaaaaa;">Microsoft</span> | n.a. | [Microsoft][microsoft_downloads] | 30:16<br/>30:37 | [Microsoft][microsoft_downloads] | 29:41<br/>31:52 |
| [OpenJ9][openj9_downloads]<br/>(IBM) | 33:30<br/>33:47 | [OpenJ9][openj9_downloads]<br/>(IBM) | 39:04<br/>39:17 | [OpenJ9][openj9_downloads]<br/>(IBM) | <i>todo</i> |
| [RedHat][redhat_downloads] | 26:01<br/>26:09 | [RedHat][redhat_downloads] | 30:16<br/>30:51 | [RedHat][redhat_downloads] <a href="#c"><sup><b>c)</b></sup> | <i>todo</i> |
| <span style="color:#aaaaaa;">SapMachine<br/>(SAP)</span> | n.a. | [SapMachine][sapmachine_downloads]<br/>(SAP) | 31:33<br/>30:52 | [SapMachine][sapmachine_downloads]<br/>(SAP) | 28:43<br/>28:27 |
| [Temurin][temurin8_downloads]<br/>(Eclipse) | 25:46<br/>25:47 | [Temurin][temurin11_downloads]<br/>(Eclipse) | 29:59<br/>31:19 | [Temurin][temurin17_downloads]<br/>(Eclipse) | 28:52<br/>29:04 |
| [Zulu][azul_downloads]<br/>(Azul)     | 25:39<br/>25:44 | [Zulu][azul_downloads]<br/>(Azul) | 31:38<br/>30:49 | [Zulu][azul_downloads]<br/>(Azul) | 28:59<br/>28:41 |
<div style="font-size:80%;">
<sup id="a"><b>a)</b></sup> Version 11.0.15 instead of 11.0.16.<br/>
<sup id="b"><b>b)</b></sup> NIK = Native Image Kit.<br/>
<sup id="c"><b>c)</b></sup> Version 17.0.3 instead of 17.0.4.</div>

Here are two observations about the above results :
- Build times are ~10% longer with [OpenJ9 JDK][openj9_downloads] (for Java 8 and Java 11).
- Build times are significantly slower for Java 11 than for Java 8.

<!--
And we get the following build times for Java 11 and Java 8 look on a *slower* Win 10 laptop with an i7-47000MQ (2.4Ghz) processor and 12 Go of memory :

| 11.0.10  | `bootstrap`     | `arch-only`     | **Total**       | 1.8.0_282 | `bootstrap`     | `arch-only`     | **Total**       |
|----------|-----------------|-----------------|-----------------|-----------|-----------------|-----------------|-----------------|
| BellSoft | 42:19<br/>40:17 | 07:25<br/>07:37 | 49:44<br/>47:54 | BellSoft  | 32:69<br/>35:54 | 18:16<br/>04:37 | 51:15<br/>40:31 |
| Corretto | *Failure*       |                 |                 | Corretto  | *Failure*       |                 |                 |
| RedHat   | 46:44<br/>      | 07:24<br/>      | 54:08<br/>      | RedHat    | 32:33<br/>30:38 | 08:04<br/>08:56 | 40:37<br/>39:34 |
| OpenJ9   | 42:04<br/>50:47 | 16:40<br/>07:48 | 58:44<br/>58:35 | OpenJ9    | 38:45<br/>38:45 | 07:03<br/>05.19 | 57:08<br/>44:04 |
| OpenJDK  | 39:54<br/>44:34 | 07:42<br/>03:36 | 47:36<br/>48:10 | OpenJDK   | 32:07<br/>40:09 | 04:01<br/>05:17 | 36:08<br/>45:26 |
| Zulu     | 41:22<br/>      | 07:56<br/>      | 49:18<br/>      | Zulu      | 32:30<br/>32:40 | 06:50<br/>06:55 | 39:20<br/>39:35 |
<div style="font-size:80%;"><sup>(1)</sup>Build failure with "<code>Out of memory</code>" error.<br/>&nbsp;</div>
-->

## <span id="build_errors">Scala 3 build errors</span>

Build errors encountered on MS Windows on July 31, 2021, are :

| Failing&nbsp;tests<br/>&nbsp;&nbsp;&nbsp;JVM 8 | [`ClasspathTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/scripting/ClasspathTests.scala) | [`CompilationTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/dotc/CompilationTests.scala) | [`FromTastyTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/dotc/FromTastyTests.scala) | [`ZipArchiveTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/io/ZipArchiveTest.scala) |
|:-----------------------|:----------------:|:----------------:|:----------------:|:----------------:|
| <a href="https://bell-sw.com/pages/downloads/#/java-8-lts">bellsoft-08</a>   | Failed | OK | Failed | OK |
| <a href="https://github.com/corretto/corretto-8/releases">corretto-08</a>    | Failed | OK | Failed | OK |
| <a href="https://github.com/alibaba/dragonwell8/releases">dragonwell-08</a>  | Failed | OK | Failed | OK |
| <a href="https://adoptopenjdk.net/releases.html?variant=openjdk8&jvmVariant=openj9">openj9-08</a> | Failed | Failed | Failed | Failed |
| <a href="https://adoptopenjdk.net/releases.html?variant=openjdk8&jvmVariant=hotspot">openjdk-08</a> | Failed | OK | Failed | OK |
| <a href="https://developers.redhat.com/products/openjdk/download">redhat-08</a>      | Failed      | OK | Failed | OK |
| <a href="https://www.azul.com/downloads/?version=java-8-lts&package=jdk">zulu-08</a> | Failed      | OK | Failed | OK |

| Failing&nbsp;tests<br/>&nbsp;&nbsp;&nbsp;JVM 11 | [`ClasspathTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/scripting/ClasspathTests.scala) | [`FromTastyTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/dotc/FromTastyTests.scala) |
|:-----------------------|:----------------:|:----------------:|
| <a href="https://bell-sw.com/pages/downloads/#/java-11-lts">bellsoft-11</a>   | Failed | Failed        |
| <a href="https://libericajdk.ru/pages/downloads/native-image-kit/">bellsoft-nik-11</a> | Failed      | Failed        |
| <a href="https://github.com/corretto/corretto-11/releases">corretto-11</a>    | Failed | Failed        | 
| <a href="https://github.com/alibaba/dragonwell11/releases">dragonwell-11</a>  | Failed | Failed        |
| <a href="https://docs.microsoft.com/en-us/java/openjdk/download#openjdk-11">microsoft-11</a>  | Failed | Failed        |
| <a href="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9">openj9-11</a> | Failed      | Failed        | 
| <a href="https://developers.redhat.com/products/openjdk/download">redhat-11</a>      | Failed      | Failed        | 
| <a href="https://github.com/SAP/SapMachine/releases">sapmachine-11</a> | Failed      | Failed        | 
| <a href="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=hotspot">temurin-11</a> | Failed      | Failed        | 
| <a href="https://www.azul.com/downloads/?version=java-11-lts&package=jdk">zulu-11</a> | Failed      | Failed        | 

| Failing&nbsp;tests<br/>&nbsp;&nbsp;&nbsp;JVM 17 | `ClasspathTests` | [`FromTastyTests`](https://github.com/lampepfl/dotty/blob/master/compiler/test/dotty/tools/dotc/FromTastyTests.scala) |
|:-----------------------|:----------------:|:----------------:|
| <a href="https://bell-sw.com/pages/downloads/#/java-17-lts">bellsoft-17</a> | Failed       | Failed    |
| <a href="https://libericajdk.ru/pages/downloads/native-image-kit/">bellsoft-nik-17</a> | Failed       | Failed    |
| <a href="https://docs.microsoft.com/en-us/java/openjdk/download#openjdk-17">microsoft-17</a> | Failed       | Failed     |
| <a href="https://github.com/SAP/SapMachine/releases">sapmachine-17</a> | Failed        | Failed     |
| <a href="https://jdk.java.net/17/">temurin-17</a>  | Failed       | Failed     |
| <a href="https://www.azul.com/downloads/?version=java-17-ea&package=jdk">zulu-17</a> | Failed        | Failed     |

## <span id="data_sharing">Data sharing</span> [**&#x25B4;**](#top)

This section supplements my writing from page [Data Sharing and Scala 3 on Windows](CDS.md).

> **&#9755;** ***Data Sharing and OpenJDK 17***<br/>
> Data sharing is *enabled by default* starting with OpenJDK 17.

An OpenJDK installation contains the file **`<install_dir>\lib\classlist`**. For instance we proceed as follows to check if data sharing is enabled in [Temurin OpenJDK 11][temurin11_downloads] :

1. Command **`java.exe -version`** displays the OpenJDK version amongst other information; in particular, the last output line ends with
   - **`((build 11.0.14+9, mixed mode, sharing)`** if data sharing is enabled
   - **`(build 11.0.14+9, mixed mode)`** otherwise.
2. Command **`java.exe -Xshare:dump`** generates the 17.3 Mb Java shared archive **`<install_dir>\bin\server\classes.jsa`** from file **`<install_dir>\lib\classlist`**.
3. We go back to step 1 to verify that flag  **`sharing`** is present.


### <span id="corretto">Corretto OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-corretto-11.0.17_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.17" 2022-10-18 LTS
OpenJDK Runtime Environment Corretto-11.0.17.8.1 (build 11.0.17+8-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.17.8.1 (build 11.0.17+8-LTS, mixed mode)

<b>&gt; c:\opt\jdk-corretto-11.0.17_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1217
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-corretto-11.0.17_8\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
01.08.2022  23:27        11 272 192 classes.jsa

<b>&gt; c:\opt\jdk-corretto-11.0.17_8\bin\java -version</b>
openjdk version "11.0.17" 2022-10-18 LTS
OpenJDK Runtime Environment Corretto-11.0.16.8.1 (build 11.0.16+8-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.16.8.1 (build 11.0.16+8-LTS, mixed mode, sharing)
</pre>

> **:mag_right:** Amazon provides online documentation specific to Corretto 11 (eg. [change Log][corretto_changes], [patches][corretto11_patches] as well as Youtube videos (eg. Devoxx keynotes by [Arun Gupta][corretto_gupta] and [James Gosling][corretto_gosling]).

### <span id="dragonwell">Dragonwell OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-dragonwell-11.0.16.12_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.16.12" 2022-07-19
OpenJDK Runtime Environment (Alibaba Dragonwell)-11.0.16.12+8-GA (build 11.0.16.12+8)
OpenJDK 64-Bit Server VM (Alibaba Dragonwell)-11.0.16.12+8-GA (build 11.0.16.12+8, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-dragonwell-11.0.16.12_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1241
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-dragonwell-11.0.16.12_8\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
22.05.2022  15:08        17 891 328 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-dragonwell-11.0.16.12_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.16.12" 2022-07-19
OpenJDK Runtime Environment (Alibaba Dragonwell)-11.0.16.12+8-GA (build 11.0.16.12+8)
OpenJDK 64-Bit Server VM (Alibaba Dragonwell)-11.0.16.12+8-GA (build 11.0.16.12+8, mixed mode, sharing)
</pre>

### <span id="graalvm">GraalVM OpenJDK 11</span> [**&#9650;**](#top)

[GraalVM][graalvm_org] is a universal virtual machine supporting the *interaction* between JVM-based languages like Java, Scala, Groovy, Kotlin, Clojure and native languages like C, C++, JavaScript, Python, R, Ruby.

<pre style="font-size:80%;">
<b>&gt; c:\opt\graalvm-ce-java11-22.1.0\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19
OpenJDK Runtime Environment GraalVM CE 22.1.0 (build 11.0.15+10-jvmci-22.1-b06)
OpenJDK 64-Bit Server VM GraalVM CE 22.1.0 (build 11.0.15+10-jvmci-22.1-b06, mixed mode, sharing)
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\graalvm-ce-java11-22.1.0\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
08.05.2022  15:00        17 760 256 classes.jsa
</pre>

We observe that [GraalVM][graalvm_org] is the only OpenJDK implementation to come with class sharing *enabled by default*.


### <span id="liberica">Liberica OpenJDK 11</span> [**&#9650;**](#top)

[Liberica OpenJDK 11][bellsoft11_downloads] is available both as a *"regular"* and as a *"lite"* version (no JavaFX modules, compressed modules). BellSoft currently provides binaries suitable for different hardware and OS combinations, eg. Windows x86_64 and Windows x86.

> **:mag_right:** Bellsoft also offers a <a href="https://libericajdk.ru/pages/liberica-release-notes-native-image-kit-21.2.0/">native image based JDK</a> distributions.

In the following we work with the *"regular"* version of Liberica OpenJDK 11.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-bellsoft-11.0.15\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19 LTS
OpenJDK Runtime Environment (build 11.0.15+10-LTS)
OpenJDK 64-Bit Server VM (build 11.0.15+10-LTS, mixed mode)

<b>&gt; c:\opt\jdk-bellsoft-11.0.15\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1258
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-bellsoft-11.0.15\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
22.05.2022  15:32        18 022 400 classes.jsa

<b>&gt; c:\opt\jdk-bellsoft-11.0.15\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19 LTS
OpenJDK Runtime Environment (build 11.0.15+10-LTS)
OpenJDK 64-Bit Server VM (build 11.0.15+10-LTS, mixed mode, sharing)
</pre>

### <span id="microsoft">Microsoft OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-microsoft-11.0.16_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19 LTS
OpenJDK Runtime Environment Microsoft-32930 (build 11.0.15+10-LTS)
OpenJDK 64-Bit Server VM Microsoft-32930 (build 11.0.15+10-LTS, mixed mode)

<b>&gt; c:\opt\jdk-microsoft-11.0.16_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1220
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-microsoft-11.0.16_8\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
22.05.2022  15:33        17 694 720 classes.jsa

<b>&gt; c:\opt\jdk-microsoft-11.0.16_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.16" 2022-04-19 LTS
OpenJDK Runtime Environment Microsoft-32930 (build 11.0.15+10-LTS)
OpenJDK 64-Bit Server VM Microsoft-32930 (build 11.0.15+10-LTS, mixed mode, sharing)
</pre>


### <span id="openj9">OpenJ9 OpenJDK 11</span> [**&#9650;**](#top)

Compared to the other OpenJDK distributions [OpenJ9 OpenJDK 11][openj9_downloads] provides advanced settings to manage shared data; it uses option [**`-Xshareclasses:<params>`**](https://www.eclipse.org/openj9/docs/xshareclasses/) instead of **`-Xshare:<param>`**.
> **:mag_right:** Execute **`java -Xshareclasses:help`** to list the settings.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-openj9-11.0.16_8\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.16" 2022-07-19
IBM Semeru Runtime Open Edition 11.0.16.0 (build 11.0.16+8)
Eclipse OpenJ9 VM 11.0.16.0 (build openj9-0.33.0, JRE 11 Windows 10 amd64-64-Bit Compressed References 20220804_420 (JIT enabled, AOT enabled)
OpenJ9   - 04a55b45b
OMR      - b58aa2708
JCL      - ab74d97849 based on jdk-11.0.16+8)

[XXXXXXXXXX -Xshareclasses:name=<name> ##########]
</pre>


### <span id="redhat">RedHat OpenJDK 11</span> [**&#x25B4;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-redhat-11.0.15.9-3\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.15+9-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.15+9-LTS, mixed mode)

<b>&gt; c:\opt\jdk-redhat-11.0.15.9-3\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1229
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-redhat-11.0.15.9-3\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
22.05.2022  15:38        17 760 256 classes.jsa

<b>&gt; c:\opt\jdk-redhat-11.0.15.9-3\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.15+9-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.15+9-LTS, mixed mode, sharing)
</pre>


### <span id="sap">SapMachine OpenJDK 11</span> [**&#9650;**](#top)

GitHub project repository is [`SAP/SapMachine`](https://github.com/SAP/SapMachine).

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-sapmachine-11.0.20\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.20-ea" 2023-07-18
OpenJDK Runtime Environment SapMachine (build 11.0.20-ea+4-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.20-ea+4-sapmachine, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.20\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1222
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-sapmachine-11.0.20\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
05/29/2023  10:49 PM        11,337,728 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.20\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.20-ea" 2023-07-18
OpenJDK Runtime Environment SapMachine (build 11.0.20-ea+4-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.20-ea+4-sapmachine, mixed mode, sharing)
</pre>

> **:mag_right:** SAP provides [online documentation](https://github.com/SAP/SapMachine/wiki) specific to SapMachine 11, e.g. [Differences between SapMachine and OpenJDK](https://github.com/SAP/SapMachine/wiki/Differences-between-SapMachine-and-OpenJDK).

> **:mag_right:** SAP blog announcements:
> - [Re-Spin of OpenJDK/SapMachine 11.0.9 release](https://blogs.sap.com/2020/11/13/re-spin-of-openjdk-sapmachine-11.0.9-release/).


### <span id="temurin">Temurin OpenJDK 11</span> [**&#9650;**](#top)

Temurin OpenJDK is the [reference implementation][oracle_openjdk11_project]; the other OpenJDK distributions are derived from it.
<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-temurin-11.0.19_7\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.19" 2023-04-18
OpenJDK Runtime Environment Temurin-11.0.19+7 (build 11.0.19+7)
OpenJDK 64-Bit Server VM Temurin-11.0.19+7 (build 11.0.19+7, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-temurin-11.0.19_7\bin\java -Xshare:dump</b>
[...]
Number of classes 1217
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-temurin-11.0.19_7\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
05/29/2023  10:50 PM        11,272,192 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-temurin-11.0.19_7\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.19" 2023-04-18
OpenJDK Runtime Environment Temurin-11.0.19+7 (build 11.0.19+7)
OpenJDK 64-Bit Server VM Temurin-11.0.19+7 (build 11.0.19+7, mixed mode, sharing)
</pre>


### <span id="trava">Trava OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-dcevm-11.0.15_1\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19
OpenJDK Runtime Environment AdoptOpenJDK-dcevm-11.0.15+1-202204281500 (build 11.0.15+1-202204281500)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK-dcevm-11.0.15+1-202204281500 (build 11.0.15+1-202204281500, mixed mode)

<b>&gt; c:\opt\jdk-dcevm-11.0.15_1\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1221
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-dcevm-11.0.15_1\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
22.05.2022  15:42        18 022 400 classes.jsa

<b>&gt; c:\opt\jdk-dcevm-11.0.15_1\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.15" 2022-04-19
OpenJDK Runtime Environment AdoptOpenJDK-dcevm-11.0.15+1-202204281500 (build 11.0.15+1-202204281500)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK-dcevm-11.0.15+1-202204281500 (build 11.0.15+1-202204281500, mixed mode, sharing)
</pre>

> **:mag_right:** [Trava OpenJDK](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases) is *not intended* to be used as 'main' JDK, since the integrated HotswapAgent is enabled by default and it uses serial GC by default. The default behaviour can be changed as follows:
> <pre style="font-size:80%;">
> <b>&gt; c:\opt\jdk-dcevm-11.0.11_1\bin\java -XX:+DisableHotswapAgent -XX:+UseConcMarkSweepGC -version</b>
> Dynamic Code Evolution 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
> openjdk version "11.0.9" 2020-10-20
> OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+4-202010241925)
> Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.10+4-202010241925, mixed mode, sharing)
> </pre>
> Trava OpenJDK only supports the [serial and CMS garbage collectors](http://karunsubramanian.com/websphere/how-to-choose-the-correct-garbage-collector-java-generational-heap-and-garbage-collection-explained/) (ie. options `-XX:+UseParallelGC` and `-XX:+UseG1GC` are not supported).
> 
> Starting with <i>version 11.0.9</i> of the Trava OpenJDK the compiler option <code>-XX:+DisableHotswapAgent</code> is replaced
> by option <code>-XX:HotswapAgent:&lt;disabled|fatjar|core|external&gt;</code>.


### <span id="zulu">Zulu OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-zulu-11.0.19-win_x64\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.19" 2023-04-18 LTS
OpenJDK Runtime Environment Zulu11.64+19-CA (build 11.0.19+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.64+19-CA (build 11.0.19+7-LTS, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.19-win_x64\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -Xshare:dump</b>
[...]
Number of classes 1223
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-zulu-11.0.19-win_x64\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
05/29/2023  10:52 PM        11,534,336 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.19-win_x64\bin\<a href="https://docs.oracle.com/en/java/javase/11/tools/java.html">java</a> -version</b>
openjdk version "11.0.19" 2023-04-18 LTS
OpenJDK Runtime Environment Zulu11.64+19-CA (build 11.0.19+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.64+19-CA (build 11.0.19+7-LTS, mixed mode, sharing)
</pre>

## <span id="related">Related reading</span> [**&#9650;**](#top)

### 2018

<dl>
  <dt><a href="https://developer.ibm.com/tutorials/j-class-sharing-openj9/">IBM Developer</a>:<a name="ref_03">&nbsp;</a>Class sharing in Eclipse OpenJ9</dt>
  <dd><i>by Ben Corrie, Hang Shao (2018-06-06)</i><br/>Reduce your memory footprint and improve startup performance with the shared class feature.</dd>
</dl>

### 2017

<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/javaone-2017-eclipse-openj9-under-the-hood-of-the-jvm">JavaOne 2017</a>:<a name="ref_02">&nbsp;</a>Eclipse OpenJ9: Under the hood of the JVM</dt>
  <dd><i>by Dan Heidinga (2017-10-10)</i><br/>Dan Heiding presents an updated version of my "OpenJ9: Under the hood of the next open source JVM" that covers where it was open sourced (github.com/eclipse/openj9), how to build it, and then deep dives into the ROM/RAM divide before touching on interpreter, JIT and AOT.</dd>
</dl>

### 2016
<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/j9-under-the-hood-of-the-next-open-source-jvm" rel="external">IBM</a>:<a name="ref_01">&nbsp;</a>OpenJ9: Under the hood of the next open source JVM</dt>
  <dd><i>by Dan Heidinga (2016-09-21)</i><br/>Dan Heidinga gives a description of how bytecodes are loaded into the J9VM and how bytecode execution occurs, plus IBM's plans to open source J9.</dd>
</dl>


## <span id="footnotes">Footnotes</span> [**&#9650;**](#top)

<span id="footnote_01" tooltip="[1]">[1]</span> ***Oracle JDK vs OpenJDK*** [↩](#anchor_01)

<dl><dd>
Oracle's release notes for Java version 11 gives several <a href="https://www.oracle.com/java/technologies/javase/11-relnote-issues.html#Diffs">Differences between Oracle JDK and OpenJDK</a>.
</dd></dl>

<span id="footnote_02" tooltip="[2]">[2]</span> ***JCK Compliance** (2018-04-06)* [↩](#anchor_02)

<dl><dd>
The JCK is a proprietary test suite, <a href="https://openjdk.java.net/groups/conformance/JckAccess/index.html" rel="external">accessible under license from Oracle</a>.<br/>
The role of the JCK is not to determine <i>quality</i>, but rather to provide a binary indication of compatibility with the Java SE specification. As such, the JCK only tests functional behaviour, and only such functional behaviour that is given in the Java specification.<br/><i>(see <a href="https://github.com/AdoptOpenJDK/TSC/issues/19">issue 19</a> from <a href="https://github.com/AdoptOpenJDK/TSC">OpenJDK TSC</a>)</i>
</dd></dl>

<span id="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<dl><dd>
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/alibaba/dragonwell11/releases">Alibaba_Dragonwell_Standard_11.0.19.15.7_x64_windows.zip</a>       <i>(186 MB)</i>
<a href="https://github.com/corretto/corretto-11/releases" rel="external">amazon-corretto-11.0.16.9.1-windows-x64-jdk.zip</a>                <i>(178 MB)</i>
<a href="https://bell-sw.com/pages/downloads/#/java-11-lts">bellsoft-jdk11.0.19+7-windows-amd64.zip</a>                        <i>(186 MB)</i>
<a href="https://libericajdk.ru/pages/downloads/native-image-kit/">bellsoft-liberica-vm-openjdk11.0.19+7-22.3.2+1-windows-amd64.zip</a>  <i>(329 MB)</i>
<a href="https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-22.2.0">graalvm-ce-java11-windows-amd64-22.2.0.zip</a>                     <i>(335 MB)</i>
<a href="https://developer.ibm.com/languages/java/semeru-runtimes/downloads">ibm-semeru-open-jdk_x64_windows_11.0.16_8_openj9-0.33.0.zip</a>    <i>(198 MB)</i>
<a href="https://developers.redhat.com/products/openjdk/download">java-11-openjdk-11.0.16.8-1.windows.redhat.x86_64.zip</a>          <i>(242 MB)</i>
<a href="https://docs.microsoft.com/en-us/java/openjdk/">microsoft-jdk-11.0.19-windows-x64.zip</a>                          <i>(178 MB)</i>
<a href="https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases/latest">Openjdk11u-dcevm-windows-x64.zip</a>                               <i>(187 MB)</i>
<a href="https://adoptium.net/?variant=openjdk11">OpenJDK11U-jdk_x64_windows_hotspot_11.0.17_8.zip</a>               <i>(190 MB)</i>
<a href="https://github.com/SAP/SapMachine/releases/tag/sapmachine-11.0.11" rel="external">sapmachine-jdk-11.0.20-ea.4_windows-x64_bin.zip</a>                <i>(189 MB)</i>
<a href="https://www.azul.com/downloads/zulu-community/?version=java-11-lts" rel="external">zulu11.64.19-ca-jdk11.0.19-win_x64.zip</a>                         <i>(187 MB)</i>
</pre>
</dd></dl>

<span id="footnote_04">[4]</span> ***Snapshot builds*** [↩](#anchor_04)

<dl><dd>
We run the batch file <a href="./bin/dotty/snapshot.bat"><code>snapshot.bat</code></a> (which calls <a href="./bin/dotty/build.bat"><code>build.bat</code></a>) to generate <b>26</b> Scala 3 software distributions based on <b>8</b>, <b>11</b> and <b>17</b> OpenJDK implementations (see also snyk report "<a href="https://snyk.io/jvm-ecosystem-report-2021/">JVM Ecosystem report 2021"</a>).
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b __SNAPSHOT_LOCAL\*.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-bellsoft-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-bellsoft-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-bellsoft-17.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-bellsoft-nik-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-bellsoft-nik-17.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-corretto-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-corretto-17.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-dcevm-11.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-dragonwell-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-dragonwell-11.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-graalvm-ce-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-graalvm-ce-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-graalvm-ce-17.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-microsoft-11.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-microsoft-17.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-openj9-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-openj9-11.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-redhat-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-redhat-11.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-sapmachine-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-sapmachine-17.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-temurin-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-temurin-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-temurin-17.zip</b>
scala3-3.3.1-RC1-bin-SNAPSHOT-zulu-08.zip
scala3-3.3.1-RC1-bin-SNAPSHOT-zulu-11.zip
<b style="color:#BB0066;">scala3-3.3.1-RC1-bin-SNAPSHOT-zulu-17.zip</b>
</pre>
</dd></dl>
<!--
> :mag_right:  By the end of Octobre 2021, 4 organizations offer OpenJDK implementations for Java 8, 11 and 17 :
> - [Azul](https://www.azul.com/) offers [Zulu OpenJDK](https://www.azul.com/downloads/?package=jdk#download-openjdk).
> - [Bellsoft](https://bell-sw.com) offers [Liberica OpenJDK](https://bell-sw.com/pages/downloads/),
> - The [Eclipse Foundation](https://www.eclipse.org/) offers [Temurin OpenJDK](https://adoptium.net/),
> - Oracle offers [GraalVM](https://www.graalvm.org/)
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[alibaba]: https://www.alibabagroup.com/en/global/home
[amazon_aws]: https://aws.amazon.com/
[azul_downloads]: https://www.azul.com/downloads/?package=jdk#download-openjdk
[azul_relnotes]: https://docs.azul.com/core/zulu-openjdk/release-notes.html
[azul_systems]: https://www.azul.com/
[bellsoft_about]: https://bell-sw.com/pages/about
[bellsoft8_downloads]: https://bell-sw.com/pages/downloads/#/java-8-lts
[bellsoft11_downloads]: https://bell-sw.com/pages/downloads/#/java-11-lts
[bellsoft17_downloads]: https://bell-sw.com/pages/downloads/#/java-17-lts
[bellsoft_nik_downloads]: https://libericajdk.ru/pages/downloads/native-image-kit/
[bellsoft_relnotes]: https://bell-sw.com/pages/liberica-release-notes-11.0.12/
[bellsoft_nik_relnotes]: https://libericajdk.ru/pages/liberica-release-notes-native-image-kit-21.2.0/
[corretto_changes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[corretto_gosling]: https://www.youtube.com/watch?v=WuZk23O76Zk
[corretto_gupta]: https://www.youtube.com/watch?v=RLKC5nsiZXU
[corretto11_patches]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/patches.html
[corretto_8_downloads]: https://github.com/corretto/corretto-8/releases
[corretto_11_downloads]: https://github.com/corretto/corretto-11/releases
[corretto_11_relnotes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[corretto_17_downloads]: https://github.com/corretto/corretto-17/releases
[corretto_17_relnotes]: https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/change-log.html
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[dragonwell11_downloads]: https://github.com/alibaba/dragonwell11/releases
[dragonwell11_relnotes]: https://github.com/alibaba/dragonwell11/wiki/Alibaba-Dragonwell-11-Release-Notes#110117
[dragonwell17_downloads]: https://github.com/alibaba/dragonwell17/releases
[dragonwell17_relnotes]: https://github.com/alibaba/dragonwell17/wiki/Alibaba-Dragonwell-17-Release-Notes
[dragonwell8_downloads]: https://github.com/alibaba/dragonwell8/releases
[eclipse]: https://www.eclipse.org/org/foundation/
[flix_examples]: https://github.com/michelou/flix-examples#top
[graalvm_downloads]: https://github.com/graalvm/graalvm-ce-builds/releases
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[graalvm_org]: https://www.graalvm.org/
[graalvm_relnotes]: https://www.graalvm.org/release-notes/21_2/
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[jmh_project]: https://openjdk.java.net/projects/code-tools/jmh/
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[microsoft]: https://docs.microsoft.com/en-us/java/
[microsoft_downloads]: https://docs.microsoft.com/en-us/java/openjdk/download#generally-available-ga-builds
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[openj9_downloads]: https://developer.ibm.com/languages/java/semeru-runtimes/downloads
[openj9_relnotes]: https://github.com/eclipse/openj9/releases/
[openjdk_jck]: https://openjdk.java.net/groups/conformance/JckAccess/
[openjdk_trademark]: https://openjdk.java.net/legal/openjdk-trademark-notice.html
[oracle]: https://www.oracle.com/
[oracle_openjdk11_project]: https://openjdk.java.net/projects/jdk/11/
[redhat]: https://www.redhat.com/
[redhat_downloads]: https://developers.redhat.com/products/openjdk/download/
[rust_examples]: https://github.com/michelou/rust-examples#top
[sapmachine_downloads]: https://github.com/SAP/SapMachine/releases
[sap_home]: https://www.sap.com/
[scala3_home]: https://dotty.epfl.ch/
[scala3_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
[temurin8_downloads]: https://github.com/adoptium/temurin8-binaries
[temurin11_downloads]: https://github.com/adoptium/temurin11-binaries
[temurin11_relnotes]: https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-July/006954.html
[temurin17_downloads]: https://github.com/adoptium/temurin17-binaries
[trava_downloads]: https://github.com/TravaOpenJDK/trava-jdk-11-dcevm
[trava_relnotes]: https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[wix_examples]: https://github.com/michelou/wix-examples#top
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/

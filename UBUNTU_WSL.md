# <span id="top">Playing with Scala 3 in Ubuntu WSL</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:80px;"><a href="https://dotty.epfl.ch/" rel="external"><img src="docs/images/dotty.png" width="80" alt="Flix project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document presents one <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> code example we work on in the <a href="https://ubuntu.com/wsl" rel="external">Ubuntu WSL</a> environment.
  </td>
  </tr>
</table>

> **&#9755;** In the following we assume the [Ubuntu WSL][wsl] <sup id="anchor_01">[1](#footnote_01)</sup> is installed on the user's Windows machine.

We open a Ubuntu terminal and navigate to directory **`dotty-examples/`** which contains our local checkout of the GitHub project [**`dotty-examples`**](https://github.com/michelou/dotty-examples) :
<pre style="font-size:80%;">
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/pwd.1.html" rel="external">pwd</a></b>
/home/michelou
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/cd.1posix.html" rel="external">cd</a> /mnt/c/Users/michelou/workspace-perso/dotty-examples/</b>
</pre>

Then we execute our Bash script [**`setenv.sh`**](./setenv.sh) to set up our Unix environment :

<pre style="font-size:80%;">
<b>$ . <a href="./examples/setenv.sh">./setenv.sh</a></b>
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/which.1.html" rel="external">which</a> bash gradle make mvn</b>
/bin/bash
/opt/gradle/bin/gradle
/usr/bin/make
/opt/apache-maven/bin/mvn
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/env.1.html" rel="external">env</a> | <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/grep.1.html" rel="external">grep</a> _HOME</b>
JAVA_HOME=/opt/jdk-temurin-11
MAVEN_HOME=/opt/apache-maven
SCALA_HOME=/opt/scala-2.13.12
SCALA3_HOME=/opt/scala3-3.3.2-RC1
GRADLE_HOME=/opt/gradle
SBT_HOME=/opt/sbt
ANT_HOME=/opt/apache-ant
</pre>

<!-- https://mirrors.edge.kernel.org/pub/software/scm/git/ -->

> **:mag_right:** We install additional software tools such as [Ant][apache_ant_cli] <sup id="anchor_02">[2](#footnote_02)</sup>, [Gradle][gradle_cli] or [Scala][scala_getting_started] into root directory **`/opt/`**:
> <pre style="font-size:80%;">
> <b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/find.1.html" rel="external">find</a> /opt -maxdepth 1 -type d -print | <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/sort.1.html" rel="external">sort</a> | <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/xargs.1.html" rel="external">xargs</a> -i sh -c 'du -sh {}'</b>
> 44M     /opt/apache-ant
> 9.9M    /opt/apache-maven
> 2.4G    /opt/archives
> 2.2M    /opt/cfr-0.152
> 36M     /opt/flix-0.43.0
> 51M     /opt/git
> 129M    /opt/gradle
> 308M    /opt/jdk-11.0.21_9
> 103M    /opt/ktlint
> 61M     /opt/mill
> 81M     /opt/sbt
> 25M     /opt/scala-2.13.12
> 36M     /opt/scala3-3.3.2-RC1
> 15M     /opt/wabt-1.0.23
> </pre>

And finally we build and run one of our [Scala] code examples, for instance [**`enum-Planet`**](./examples/enum-Planet/), with either a [Bash script][bash_script], a [Ant script][ant_script], a [Gradle script][gradle_script] or a [Make script][make_script] :

<pre style="font-size:80%;">
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/cd.1posix.html" rel="external">cd</a> examples/enum-Planet/</b>
<b>$ <a href="./examples/enum-Planet/build.sh">./build.sh</a> -verbose clean run</b>
Delete directory "target"
Compile 1 Scala source files to directory "target/classes"
Execute Scala main class "Planet"
Mass of earth is 0.1020132025669991
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
&nbsp;
<b>$ <a href="https://ant.apache.org/manual/running.html" rel="external">ant</a> clean run 2>/dev/null | <a href="https://linux.die.net/man/1/awk" rel="external">awk</a> '/^run:$/{n=1}{if(n==1)print}'</b>
run:
     [java] Mass of earth is 0.1020132025669991
     [java] Your weight on MERCURY (0) is 0.37775761520093526
     [java] Your weight on VENUS (1) is 0.9049990998410455
     [java] Your weight on EARTH (2) is 0.9999999999999999
     [java] Your weight on MARS (3) is 0.37873718403712886
     [java] Your weight on JUPITER (4) is 2.5305575254957406
     [java] Your weight on SATURN (5) is 1.0660155388115666
     [java] Your weight on URANUS (6) is 0.9051271993894251
     [java] Your weight on NEPTUNE (7) is 1.1383280724696578
&nbsp;
BUILD SUCCESSFUL
Total time: 9 seconds
&nbsp;
<b>$ <a href="https://docs.gradle.org/current/userguide/command_line_interface.html" rel="external">gradle</a> -q clean run</b>
Mass of earth is 0.1020132025669991
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on VENUS (1) is 0.9049990998410455
Your weight on EARTH (2) is 0.9999999999999999
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406
Your weight on SATURN (5) is 1.0660155388115666
Your weight on URANUS (6) is 0.9051271993894251
Your weight on NEPTUNE (7) is 1.1383280724696578
&nbsp;
<b>$ <a href="https://www.gnu.org/software/make/manual/make.html" rel="external">make</a> clean run</b>
rm -rf "target"
[ -d "target/classes" ] || "mkdir" -p "target/classes"
"/opt/scala3-3.3.2-RC1/bin/scalac" "@target/scalac_opts.txt" "@target/scalac_sources.txt"
"/opt/scala3-3.3.2-RC1/bin/scala" -classpath "target/classes" Planet 1
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

<!--=======================================================================-->
 
## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Updating our packages with*** **`apt`** [↩](#anchor_01)

<dl><dd>
We run command <a href="https://manpages.ubuntu.com/manpages/trusty/man8/apt.8.html" rel="external"><code>apt</code></a> to keep the packages of our <a href="https://ubuntu.com/wsl" rel="external">Ubuntu WSL</a> installation up-to-date :
<pre style="font-size:80%;">
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man1/uname.1.html" rel="external">uname</a> -a</b>
Linux DESKTOP-U9DCNVQ 4.19.128-microsoft-standard #1 SMP Tue Jun 23 12:58:10 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
</pre>

<pre style="font-size:80%;">
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man8/sudo.8.html" rel="external">sudo</a> <a href="https://manpages.ubuntu.com/manpages/bionic/en/man8/apt.8.html" rel="external">apt</a> update</b>
[sudo] password for michelou:
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease
Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
[...]]
Get:23 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [18.1 kB]
Get:24 http://archive.ubuntu.com/ubuntu bionic-backports/universe Translation-en [8668 B]
Fetched 12.6 MB in 12s (1085 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
153 packages can be upgraded. Run 'apt list --upgradable' to see them.
</pre>

<pre style="font-size:80%;">
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man8/sudo.8.html" rel="external">sudo</a> <a href="https://manpages.ubuntu.com/manpages/bionic/en/man8/apt.8.html" rel="external">apt</a> upgrade</b>
Reading package lists... Done
Building dependency tree
Reading state information... Done
Calculating upgrade... Done
The following NEW packages will be installed:
  dbus-user-session
The following packages will be upgraded:
  apport bash bind9-host ca-certificates cloud-init cron curl
  [...]
  vim-runtime vim-tiny xxd xz-utils zlib1g zlib1g-dev
153 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
127 standard security updates
Need to get 419 MB of archives.
After this operation, 60.2 MB of additional disk space will be used.
Do you want to continue? [Y/n]
Get:1 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 bash amd64 4.4.18-2ubuntu1.3 [615 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libc6-dev amd64 2.27-3ubuntu1.6 [2587 kB]
[...]
Get:152 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 unzip amd64 6.0-21ubuntu1.2 [168 kB]
Get:153 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 cloud-init all 22.3.4-0ubuntu1~18.04.1 [510 kB]
Get:154 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 open-vm-tools amd64 2:11.0.5-4ubuntu0.18.04.2 [543 kB]
Fetched 419 MB in 5min 46s (1212 kB/s)
Extracting templates from packages: 100%
Preconfiguring packages ...
(Reading database ... 63334 files and directories currently installed.)
Preparing to unpack .../bash_4.4.18-2ubuntu1.3_amd64.deb ...
Unpacking bash (4.4.18-2ubuntu1.3) over (4.4.18-2ubuntu1.2) ...
Setting up bash (4.4.18-2ubuntu1.3) ...
[...]
Setting up libisccfg160:amd64 (1:9.11.3+dfsg-1ubuntu1.18) ...
Setting up snapd (2.57.5+18.04) ...
Installing new version of config file /etc/apparmor.d/usr.lib.snapd.snap-confine.real ...
Installing new version of config file /etc/profile.d/apps-bin-path.sh ...
Created symlink /etc/systemd/system/multi-user.target.wants/snapd.aa-prompt-listener.service → /lib/systemd/system/snapd.aa-prompt-listener.service.
Setting up dpkg-dev (1.19.0.5ubuntu2.4) ...
Processing triggers for mime-support (3.60ubuntu1) ...
Processing triggers for ureadahead (0.100.0-21) ...
Running hooks in /etc/ca-certificates/update.d...1-2) ...1) ...
Processing triggers for initramfs-tools (0.130ubuntu3.13) ...
done.ssing triggers for ca-certificates (20211016~18.04.1) ...
done.ing certificates in /etc/ssl/certs.../cloud/cloud.cfg ...
</pre>

<span id="footnote_02">[2]</span> ***Modifying our Ant installation*** [↩](#anchor_02)

<dl><dd>
<pre style="font-size:80%;">
<b>$ <a href="https://manpages.ubuntu.com/manpages/bionic/en/man8/sudo.8.html" rel="external">sudo</a> cp /mnt/c/opt/apache-ant/lib/ivy-2.5.2.jar /opt/apache-ant/lib/</b>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[adts]: https://wiki.haskell.org/Algebraic_data_type
[ant_script]: https://ant.apache.org/manual/using.html "Using Apache Ant"
[apache_ant_cli]: https://ant.apache.org/manual/running.html
[bash_script]: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html "Bash - Creating and running a script"
[flix]: https://flix.dev/ "Flix Programming Language"
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html "Gradle Command-Line Interface"
[gradle_script]: https://docs.gradle.org/current/userguide/tutorial_using_tasks.html "Gradle Build Script Basis"
[make_cli]: https://www.gnu.org/software/make/manual/make.html "GNU make"
[make_script]: https://makefiletutorial.com/ "Learn Makefiles"
[scala]: https://www.scala-lang.org/ "The Scala Programming Language"
[scala_getting_started]: https://docs.scala-lang.org/getting-started/ "Scala - Getting started"
[wsl]: https://ubuntu.com/wsl "Ubuntu WSL"

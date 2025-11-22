# <span id="top">GitHub Actions</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="https://github.com/" rel="external"><img style="border:0;width:120px;" src="./docs/images/Octocat.png" alt="GitHub project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This page gathers informations about <a href="https://docs.github.com/en/free-pro-team@latest/actions" rel="external">GitHub Actions</a>, their associated <a href="https://github.com/actions/runner/releases">runners</a> and <a href="https://github.com/actions/virtual-environments" rel="external">virtual environments</a>, in particular the Windows runners.
  </td>
  </tr>
</table>

| Windows       | #CPU   | Memory | Repository |
|---------------|--------|-------:|------------|
| GitHub-hosted | 2&nbsp;CPUs |  8&nbsp;GB  | [**`michelou/dotty`**](https://github.com/lampepfl/dotty/actions) *(fork)* |
| self-hosted   | 4 CPUs | 24 GB  | [**`lampepfl/dotty`**](https://github.com/lampepfl/dotty/actions) |

> **&#9755;** ***Default Windows shell***<br/>
> On October 23, 2019, the default shell for the run step on Windows runners has changed to PowerShell (see [GitHub announcement](https://github.blog/changelog/2019-10-17-github-actions-default-shell-on-windows-runners-is-changing-to-powershell/)).

## <span id="runners">GitHub-hosted runners</span>

[Supported runners and hardware resources][gh_resources]

## <span id="workflows">GitHub workflows</span>

[Ruby](https://github.com/ruby/ruby/tree/master/.github/workflows)

[Rust](https://github.com/rust-lang/rust/tree/master/.github/workflows)


## Tips

[Env Context][gh_env_setup]

[GitHub Actions Tricks](https://rammusxu.github.io/toolkit/snippets/github-action/)

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Preinstalled software*** [↩](#anchor_01)

<dl><dd>
Preinstalled software on a Windows Server is located either in directory <a href="https://docs.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables"><b><code>%ProgramFiles%</code></b></a> or at the root of drive <b><code>C:</code></b>.<br/>Here are two examples:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> "%ProgramFiles%"</b>
&nbsp;
 Volume in drive C is Windows
 Volume Serial Number is F4CD-4404
&nbsp;
 Directory of C:\Program Files
&nbsp;
10/04/2020  01:16 PM    &lt;DIR&gt;          .
10/04/2020  01:16 PM    &lt;DIR&gt;          ..
10/04/2020  08:16 AM    &lt;DIR&gt;          7-Zip
[...]
10/04/2020  11:39 AM    &lt;DIR&gt;          CMake
10/04/2020  10:34 AM    &lt;DIR&gt;          Common Files
10/04/2020  06:22 AM    &lt;DIR&gt;          Docker
10/04/2020  06:44 AM    &lt;DIR&gt;          dotnet
10/04/2020  10:20 AM    &lt;DIR&gt;          Git
[...]
10/04/2020  08:18 AM    &lt;DIR&gt;          Java
[...]
10/04/2020  01:09 PM    &lt;DIR&gt;          MongoDB
10/04/2020  10:37 AM    &lt;DIR&gt;          Mozilla Firefox
10/04/2020  06:15 AM    &lt;DIR&gt;          MSBuild
10/04/2020  08:11 AM    &lt;DIR&gt;          nodejs
10/04/2020  10:17 AM    &lt;DIR&gt;          OpenSSL
10/04/2020  06:11 AM    &lt;DIR&gt;          PackageManagement
10/04/2020  01:03 PM    &lt;DIR&gt;          PostgreSQL
10/04/2020  06:23 AM    &lt;DIR&gt;          PowerShell
10/04/2020  11:40 AM    &lt;DIR&gt;          R
[...]
               0 File(s)              0 bytes
              47 Dir(s)  89,415,794,688 bytes free
</pre>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\tools\php\</b>
&nbsp;
 Volume in drive C is Windows
 Volume Serial Number is F4CD-4404
&nbsp;
 Directory of c:\tools\php
&nbsp;
10/04/2020  10:21 AM    &lt;DIR&gt;          .
10/04/2020  10:21 AM    &lt;DIR&gt;          ..
10/04/2020  10:21 AM               329 composer
11/27/2016  07:09 PM               128 composer.bat
10/04/2020  10:21 AM         1,994,202 composer.phar
09/29/2020  02:20 PM           119,808 deplister.exe
[...]
09/29/2020  02:20 PM           130,560 php.exe
10/04/2020  10:21 AM            74,527 php.ini
09/29/2020  02:20 PM            74,223 php.ini-development
09/29/2020  02:20 PM            74,529 php.ini-production
[...]
09/29/2020  02:20 PM             4,846 README.md
09/29/2020  02:20 PM    &lt;DIR&gt;          sasl2
09/29/2020  02:20 PM             2,220 snapshot.txt
              37 File(s)     54,383,638 bytes
               7 Dir(s)  89,387,798,528 bytes free
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***Environment variables*** [↩](#anchor_02)

<dl><dd>
Here are GitHub-specific environment variables defined in a GitHub-hosted Windows runner (e.g. Windows Server 2019 with <code>runs-on: [windows-latest]</code>). 
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a></b>
[...]
CI=true
[...]
DOTTY_CI_RUN=true
[...]
GITHUB_ACTION=run1
GITHUB_ACTIONS=true
GITHUB_ACTOR=michelou
GITHUB_API_URL=https://api.github.com
GITHUB_BASE_REF=
GITHUB_ENV=D:\a\_temp\_runner_file_commands\set_env_1ae31347-8ec7-4848-b055-addf7aaafa1c
GITHUB_EVENT_NAME=push
GITHUB_EVENT_PATH=D:\a\_temp\_github_workflow\event.json
GITHUB_GRAPHQL_URL=https://api.github.com/graphql
GITHUB_HEAD_REF=
GITHUB_JOB=test_bootstrapped-windows
GITHUB_PATH=D:\a\_temp\_runner_file_commands\add_path_1ae31347-8ec7-4848-b055-addf7aaafa1c
GITHUB_REF=refs/heads/master
GITHUB_REPOSITORY=michelou/dotty
GITHUB_REPOSITORY_OWNER=michelou
GITHUB_RETENTION_DAYS=90
GITHUB_RUN_ID=310464014
GITHUB_RUN_NUMBER=283
GITHUB_SERVER_URL=https://github.com
GITHUB_SHA=98ef325bfb0d37acee19018a42a5621c55209b5a
GITHUB_WORKFLOW=Dotty CI
GITHUB_WORKSPACE=D:\a\dotty\dotty
[...]
ImageOS=win19
ImageVersion=20201004.1
JAVA_HOME=C:\Program Files\Java\jdk8u265-b01
JAVA_HOME_11_X64=C:\Program Files\Java\jdk-11.0.8+10
JAVA_HOME_13_X64=C:\Program Files\Java\jdk-13.0.2+8
JAVA_HOME_7_X64=C:\Program Files\Java\zulu-7-azure-jdk_7.31.0.5-7.0.232-win_x64
JAVA_HOME_8_X64=C:\Program Files\Java\jdk8u265-b01
[...]
NUMBER_OF_PROCESSORS=2
OS=Windows_NT
Path=C:\Users\runneradmin\.dotnet\tools;[...]
PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
[...]
PROCESSOR_ARCHITECTURE=AMD64
[...]
RUNNER_OS=Windows
RUNNER_PERFLOG=C:\actions\perflog
RUNNER_TEMP=D:\a\_temp
RUNNER_TOOL_CACHE=C:/hostedtoolcache/windows
RUNNER_TRACKING_ID=github_3a4ee11e-8eed-4b13-966f-3ed966b498bd
RUNNER_WORKSPACE=D:\a\dotty
SBT_HOME=C:\Program Files (x86)\sbt\
[...]
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[dotty]: https://dotty.epfl.ch/
[gh_env_setup]: https://github.community/t/default-behavior-of-environment-variables-and-the-setup-of-env/18222
[gh_resources]: https://docs.github.com/en/free-pro-team@latest/actions/reference/specifications-for-github-hosted-runners#supported-runners-and-hardware-resources

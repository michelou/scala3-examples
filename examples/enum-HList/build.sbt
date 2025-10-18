val dottyVersion = "3.3.7" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-HList",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    // run / fork := true,
    // javaOptions ++= List("-Xms1024m", "-Xmx1024m", "-XX:ReservedCodeCacheSize=128m", "-Xss2m", "-Dfile.encoding=UTF-8"),
    //
    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
      "com.github.sbt" % "junit-interface" % "0.13.3" % Test
    )
  )

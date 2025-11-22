val scala3Version = "3.3.7" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-Color",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := scala3Version,
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
      "com.github.sbt" % "junit-interface" % "0.13.3" % Test,
      // https://mvnrepository.com/artifact/org.scalacheck/scalacheck
      "org.scalacheck" %% "scalacheck" % "1.19.0" % Test,
      // https://mvnrepository.com/artifact/org.scalatest/scalatest
      "org.scalatest" %% "scalatest" % "3.2.19" % Test
    ),
    wartremoverErrors ++= Warts.all,
    testOptions ++= Seq(
      Tests.Setup(() => println("Setup JUnit tests")),
      Tests.Cleanup(() => println("Cleanup JUnit tests")),
      Tests.Filter(s => s.endsWith("Test"))
    ),
    // receive periodic notifications of tests that have been running longer than 120 seconds
    Test / testOptions += Tests
      .Argument(TestFrameworks.ScalaTest, "-W", "120", "60")
  )

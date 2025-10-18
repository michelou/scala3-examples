val scala3Version = "3.3.7"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Union Types",
    description := "sbt example project to build/run Scala 3 applications",
    organization := "Stéphane Micheloud",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),

    //run / fork := true,
    //javaOptions ++= List("-Xms1024m", "-Xmx1024m", "-XX:ReservedCodeCacheSize=128m", "-Xss2m", "-Dfile.encoding=UTF-8"),

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
      "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
    )
  )

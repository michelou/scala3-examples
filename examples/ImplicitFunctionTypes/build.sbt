val scala3Version = "3.3.8-RC2"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "sbt example project to build/run Scala 3 applications",
    organization := "Stéphane Micheloud",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8"
    ),

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
      "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
    )
  )

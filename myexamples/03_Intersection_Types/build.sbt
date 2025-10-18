val scala3Version = "3.3.7" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
    libraryDependencies += "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
  )

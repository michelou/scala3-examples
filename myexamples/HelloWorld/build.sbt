val dottyVersion = "3.3.7" // = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "Hello World",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8"
    ),

    // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
    libraryDependencies += "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
  )

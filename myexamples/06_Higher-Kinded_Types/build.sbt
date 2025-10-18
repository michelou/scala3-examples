val scala3Version = "3.3.7"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Higher-Kinded Types",
    description := "Example sbt project that compiles using Scala 3",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation"
    ),
    // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
    libraryDependencies += "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
  )

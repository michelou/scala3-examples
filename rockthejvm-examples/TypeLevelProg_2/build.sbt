val scala3Version = "3.3.7"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Type-Level Programming in Scala, Part 2",
    description := "see https://blog.rockthejvm.com/type-level-programming-part-2/",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", 
      "UTF-8",
      "-feature"
    ),
    // resolvers += "Maven Central Server" at "http://central.maven.org/maven2",
    libraryDependencies ++= Seq(
      "org.scala-lang" % "scala-library" % "2.13.17",
      "org.scala-lang" % "scala-reflect" % "2.13.17"
    )
  )

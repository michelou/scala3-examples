val dottyVersion = "3.3.8-RC2"
// val dottyVersion = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "Hello",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    Compile / mainClass := Some("hello.Hello"),
    logLevel := Level.Warn,

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml_2.13
      "org.scala-lang.modules" %% "scala-xml" % "2.4.0"
    ) //.withDottyCompat(scalaVersion.value)
  )

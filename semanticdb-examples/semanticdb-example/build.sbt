ThisBuild / version := "2.13.17"

commands += Command.command("runExample") { s =>
  val dir = classDirectory.in(example, Compile).value
  "example/compile" ::
    s"cli/run $dir" ::
    s
}

lazy val example = project
  .settings(
    addCompilerPlugin(
      // https://mvnrepository.com/artifact/org.scalameta/semanticdb-scalac
      "org.scalameta" % "semanticdb-scalac" % "4.14.0" cross CrossVersion.full),
    scalacOptions += "-Yrangepos"
  )

lazy val cli = project
  .settings(
    // https://mvnrepository.com/artifact/org.scalameta/scalameta
    libraryDependencies += "org.scalameta" %% "scalameta" % "4.14.0"
  )

val scala3Version = "3.3.7" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Modify pipeline plugin",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",

    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),

    artifactName := { (sv: ScalaVersion, module: ModuleID, artifact: Artifact) =>
      // Default: artifact.name + "-" + module.revision + "." + artifact.extension
      "divideByZero." + artifact.extension
    },

    packageOptions += {
      val p = System.getProperties()
      val version = p.getProperty("java.vm.version")
      val vendor = p.getProperty("java.vendor")
      Package.ManifestAttributes("Created-By" -> s"${version} (${vendor})")
    },
    // https://mvnrepository.com/artifact/org.scala-lang/scala3-compiler
    libraryDependencies += "org.scala-lang" %% "scala3-compiler" % "3.3.7",

    // https://mvnrepository.com/artifact/com.novocode/junit-interface
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % Test
  )

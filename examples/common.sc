import mill._, api._, scalalib._

//////////////////////////////////////////////////////////////////////////////
// Project properties

val scalaVersion = "3.3.7"  // "3.3.3", "3.2.2", "3.1.3", "3.0.1", "2.13.11"
val scalacOptions = Seq("-deprecation", "-encoding", "UTF8", "-feature")

val forkArgs = Seq("-Xmx1g")
// val forkEnv = Map("ENV_VAR" -> "hello")

//////////////////////////////////////////////////////////////////////////////
// Project paths

val javaSourcePath = os.pwd / "src" / "main" / "java"
val scalaSourcePath = os.pwd / "src" / "main" / "scala"

//////////////////////////////////////////////////////////////////////////////
// Ivy dependencies

val junitVersion = "4.13.2"
val jupiterVersion = "1.14.0"
val scalatestVersion = "3.2.19"
val specs2Version = "5.7.0"

// https://mvnrepository.com/artifact/junit/junit
val ivyJunit = ivy"org.junit:org.junit:$junitVersion"

// https://mvnrepository.com/artifact/com.github.sbt/junit-interface
val ivyJunitInterface = ivy"com.github.sbt:junit-interface:0.13.3"

// https://mvnrepository.com/artifact/org.apiguardian/apiguardian-api
val ivyApiGuardian = ivy"org.apiguardian:apiguardian-api:1.1.2"

// https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-api
val ivyJunitJupiter = ivy"org.junit.jupiter:junit-jupiter-api:$jupiterVersion"

// https://mvnrepository.com/artifact/org.scalatest/scalatest
val ivyScalatest = ivy"org.scalatest:scalatest_3:$scalatestVersion"

// https://mvnrepository.com/artifact/org.scalactic/scalactic
val ivyScalactic = ivy"org.scalactic:scalactic_3:$scalatestVersion"

// https://mvnrepository.com/artifact/org.specs2/specs2-common
val ivySpecs2Common = ivy"org.specs2:specs2-common_3:$specs2Version"

// https://mvnrepository.com/artifact/org.specs2/specs2-core
val ivySpecs2Core = ivy"org.specs2:specs2-core_3:$specs2Version"

// https://mvnrepository.com/artifact/org.specs2/specs2-junit
val ivySpecs2JUnit = ivy"org.specs2:specs2-junit_3:$specs2Version"

// https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml
val ivyScalaXml = ivy"org.scala-lang.modules:scala-xml_3:2.4.0"

// https://mvnrepository.com/artifact/org.scala-lang.modules/scala-parser-combinators
val ivyScalaParser = ivy"org.scala-lang.modules:scala-parser-combinators_3:2.4.0"

//////////////////////////////////////////////////////////////////////////////
// Helper functions

private var gradleProps: java.util.Properties = null
def getBuildProp(name: String, defaultValue: String, ctx: Ctx): String = {
  if (gradleProps == null) {
    import java.nio.file._
    gradleProps = new java.util.Properties()
    val path = Paths.get("gradle.properties")
    if (Files.isRegularFile(path)) {
      gradleProps.load(Files.newBufferedReader(path))
      ctx.log.debug(s"Path: $path")
      val os = new java.io.ByteArrayOutputStream()
      gradleProps.list(new java.io.PrintStream(os))
      ctx.log.debug(os.toString("UTF8"))
    }
  }
  gradleProps.getProperty(name, defaultValue)
}

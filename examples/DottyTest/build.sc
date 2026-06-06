import mill._, scalalib._
import $file.^.common

object javaApp extends JavaModule {

  def sources = T.sources { common.javaSourcePath }

  def ivyDeps = Agg(
    Dep(org = "org.scala-lang", name="scala3-compiler_3", version="3.3.8-RC2", CrossVersion.empty(false)),
    Dep(org = "junit", name = "junit", version="4.12", CrossVersion.empty(false))
  )

}

object app extends ScalaModule {
  def moduleDeps = Seq(javaApp)

  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass = T.input {
      Some("Main")
  }

  def sources = T.sources { common.scalaSourcePath }

  def ivyDeps = Agg(
    Dep(org = "org.scala-lang", name="scala3-compiler_3", version="3.3.5", CrossVersion.empty(false)),
    Dep(org = "junit", name = "junit", version="4.12", CrossVersion.empty(false))
  )

  def clean() = T.command {
    val path = os.pwd / "out" / "go"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }

}

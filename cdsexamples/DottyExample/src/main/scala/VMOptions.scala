package cdsexamples

import java.lang.management.ManagementFactory
import java.lang.management.RuntimeMXBean

import scala.jdk.CollectionConverters._
import scala.language.implicitConversions

object VMOptions {

  def get: List[String] = {
    val runtimeMxBean = ManagementFactory.getRuntimeMXBean()
    runtimeMxBean.getInputArguments().asScala.toList
  }

  private val sep = System.lineSeparator()+"   "
  // The syntax `x: _*` is no longer supported for vararg splices; use `x*` instead
  // This construct can be rewritten automatically under -rewrite -source 3.4-migration.
  // def asString: String = "VM Options:"+sep+String.join(sep, VMOptions.get: _*)
  def asString: String = "VM Options:"+sep+String.join(sep, VMOptions.get*)

}

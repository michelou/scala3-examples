// adapted from https://blog.rockthejvm.com/givens-vs-implicits/
package rockthejvm

import scala.language.implicitConversions

object scalaTwo:
  case class Person(name: String) {
    def greet: String = s"Hey, I'm $name. Scala rocks!"
  }
  implicit def stringToPerson(s: String): Person = Person(s)

  def main: Unit =
    println("Alice".greet)

object scalaThree:
  case class Person(name: String):
    def greet: String = s"Hey, I'm $name. Scala rocks!"

  given stringToPerson: Conversion[String, Person] = new:
    def apply(s: String): Person = Person(s)

  def main: Unit =
    println("Alice".greet)

@main def Main: Unit =
  scalaTwo.main
  println()
  scalaThree.main

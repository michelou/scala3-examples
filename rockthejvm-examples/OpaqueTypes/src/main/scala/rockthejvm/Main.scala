// adapted from https://blog.rockthejvm.com/scala-3-opaque/
package rockthejvm

object SocialNetwork:
  opaque type Name = String

  object Name:
    def fromString(s: String): Option[Name] =
      if (s.isEmpty || s.charAt(0).isLower) None else Some(s) // simplified

  extension (n: Name)
    def length: Int = n.length

  def main: Unit =
    val name: Option[Name] = Name.fromString("Daniel")
    val nameLength = name.map(_.length)

    println(s"name      =$name")
    println(s"nameLength=$nameLength")

object Graphics:
  opaque type Color = Int // in hex
  opaque type ColorFilter <: Color = Int

  val Red: Color = 0xff000000
  val Green: Color = 0xff0000
  val Blue: Color = 0xff00
  val halfTransparency: ColorFilter = 0x88

@main def Main: Unit =
  SocialNetwork.main
  println()

  import SocialNetwork.Name

  val name: Option[Name] = Name.fromString("Daniel")
  val nameLength = name.map(_.length)

  println(s"name      =$name")
  println(s"nameLength=$nameLength")
  println()

  import Graphics._

  case class Overlay(c: Color)

  // ok, because ColorFilter "extends" Color
  val fadeLayer = Overlay(halfTransparency)
  
  println(s"fadeLayer=$fadeLayer")

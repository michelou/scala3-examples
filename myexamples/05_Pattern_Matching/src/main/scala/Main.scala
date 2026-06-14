package myexamples

object Main {

  trait Animal {
    def legsCount: Int
    override def toString: String = "animal"
  }

  class Cat extends Animal {
    def legsCount = 4
    override def toString: String = "cat"
  }

  class Bird extends Animal {
    def legsCount = 2
    override def toString: String = "bird"
  }

  object Biped {
    def unapply(a: Animal): Boolean = a.legsCount == 2
  }

  def booleanPattern: Unit = {
    val a = new Bird
    val b = a.legsCount
    (a, b) match {
      case (a @ Biped(), _) => println(s"A $a has two legs")
      case (a, _) => println(s"A $a doesn't have two legs")
    }
  }

  class FirstChars(s: String) extends Product {
    def _1 = s.charAt(0)
    def _2 = s.charAt(1)

    // Not used by pattern matching: Product is only used as a marker trait.
    def canEqual(that: Any): Boolean = ???
    def productArity: Int = ???
    def productElement(n: Int): Any = ???
  }

  object FirstChars {
    def unapply(s: String): FirstChars = new FirstChars(s)
  }

  def productPattern: Unit = {
    "Hi!" match {
      case FirstChars(char1, char2) =>
        println(s"First: $char1; Second: $char2")
    }
  }

  object CharList {
    def unapplySeq(s: String): Option[Seq[Char]] = Some(s.toList)
  }

  def seqPattern: Unit = {
    "example" match {
      case CharList(c1, c2, c3, c4, _, _, _) =>
        println(s"$c1,$c2,$c3,$c4")
      case _ =>
        println("Expected *exactly* 7 characters!")
    }
  }

  class Nat(val x: Int) {
    def get: Int = x
    def isEmpty = x < 0
  }

  object Nat {
    def unapply(x: Int): Nat = new Nat(x)
  }

  def nameBasedPattern: Unit = {
    5 match {
      case Nat(n) => println(s"$n is a natural number")
      case _ => ()
    }
  }

  class Person(val name: String, val children: Person*)

  object Person {
    def unapply(p: Person) = Some((p.name, p.children))
  }

  def childCount(p: Person) = p match {
    case Person(_, ns) => ns.length
  }

  def varargPattern: Unit = {
    val xs = List(1, 2, 3, 4)
    xs match {
      // The syntax `x: _*` is no longer supported for vararg splices; use `x*` instead
      // This construct can be rewritten automatically under -rewrite -source 3.4-migration.
      // case List(1, 2, xs: _*) => println(xs) // binds xs
      case List(1, 2, xs*) => println(xs) // binds xs
      case List(1, _*) => // wildcard pattern
      case ys => // for exhaustivity
    }
  }

  def main(args: Array[String]): Unit = {
    booleanPattern
    productPattern
    seqPattern
    nameBasedPattern
    varargPattern
  }

}

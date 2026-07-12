// adapted from https://www.scala-lang.org/2021/02/26/tuples-bring-generic-programming-to-scala-3.html

//import scala.deriving.Mirror
import scala.language.implicitConversions

case class Employee(name: String, number: Int, manager: Boolean)
// case class IceCream(name: String, numCherries: Int, inCone: Boolean)

trait FieldEncoder[A] {
  def encodeField(a: A): String
}
//type Row = List[String]

trait RowEncoder[A] {
  def encodeRow(a: A): List[String] //Row
}
object BaseEncoders {
  //given FieldEncoder[Int] with
  implicit def encodeField(x: Int) = x.toString

  // given FieldEncoder[Boolean] with
  implicit def encodeField(x: Boolean) = if (x) "true" else "false"

  // given FieldEncoder[String] with
  implicit def encodeField(x: String) = x // Ideally, we should also escape commas and double quotes
}

object TupleEncoders {
  // Base case
  // given RowEncoder[EmptyTuple] with
  implicit def encodeRow(empty: ()) =
      List.empty

  // Inductive case
  // given [H: FieldEncoder, T <: Tuple: RowEncoder]: RowEncoder[H *: T] with
  implicit def encodeRow(tuple: H *: T) =
      implicitly[FieldEncoder[H]].encodeField(tuple.head) :: summon[RowEncoder[T]].encodeRow(tuple.tail)
}

object Main {
  def tupleToCsv[X <: Tuple : RowEncoder](tuple: X): List[String] =
    implicitly[RowEncoder[X]].encodeRow(tuple)

  def main(args: Array[String]): Unit = {
    val bob: Employee = Employee("Bob", 42, false)
    val bobTuple: (String, Int, Boolean) = Tuple.fromProductTyped(bob)
    val bobAgain: Employee = summon[Mirror.Of[Employee]].fromProduct(bobTuple)
    println(s"bob=$bob")
    println(s"bobTuple=$bobTuple")
    println(s"bobAgain=$bobAgain")
    println(s"bob == bobAgain = ${bob == bobAgain}")

    // TODO
    //val bobCsv = tupleToCsv(("Bob", 42, false)) // List("Bob", 42, false)
    //println(s"bobCsv=$bobCsv")
  }
}

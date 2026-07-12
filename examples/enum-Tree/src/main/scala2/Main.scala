object TreeEnum extends Enumeration {
  trait Tree[T]
  case object True extends Tree[Boolean]
  case object False extends Tree[Boolean]
  case object Zero extends Tree[Int]
  case class Succ(n: Tree[Int]) extends Tree[Int]
  case class Pred(n: Tree[Int]) extends Tree[Int]
  case class IsZero(n: Tree[Int]) extends Tree[Boolean]
  case class If[T](cond: Tree[Boolean], thenp: Tree[T], elsep: Tree[T]) extends Tree[T]
}

object Main {
  import TreeEnum._

  def eval[T](e: Tree[T]): T = e match {
    case True => true
    case False => false
    case Zero => 0
    case Succ(f) => eval(f) + 1
    case Pred(f) => eval(f) - 1
    case IsZero(f) => eval(f) == 0
    case If(cond, thenp, elsep) => if (eval(cond)) eval(thenp) else eval(elsep)
  }

  val data = If(IsZero(Pred(Succ(Zero))), Succ(Succ(Zero)), Pred(Pred(Zero)))

  def main(args: Array[String]) = {
    println(s"$data --> ${eval(data)}")
  }

}

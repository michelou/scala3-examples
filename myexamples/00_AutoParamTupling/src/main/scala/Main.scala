package myexamples

object Main:

  def test01: Unit =
    val xs: List[String] = List("d", "o", "t", "t", "y")

    xs.map(s => print(s": $s "))
    println()

    xs.zipWithIndex.map((s, i) => print(s"$i: $s "))
    println()

  def test02: Unit =
    val xs: List[(String, Int, Int)] =
      List(("d", 0, -1), ("o", 1, -2), ("t", 2, -3), ("t", 3, -4), ("y", 4, -5))

    xs.map((s, i, j) => print(s"$i,$j: $s "))
    println()

    def f1(s: String, i: Int, j: Int): Unit = print(s"$i,$j: $s ")
    xs.map(f1)
    println()

    def f2(triple: (String, Int, Int)): Unit =
      val (s, i, j) = triple; print(s"$i,$j: $s ")
    xs.map(f2)
    println()

  private def runExample(name: String)(f: => Unit) =
    println(Console.MAGENTA + s"$name example:" + Console.RESET)
    f
    println()

  def main(args: Array[String]): Unit =
    runExample("test01")(test01)
    runExample("test02")(test02)

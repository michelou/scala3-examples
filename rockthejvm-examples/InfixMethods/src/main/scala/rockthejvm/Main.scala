// adapted from https://blog.rockthejvm.com/scala-3-infix-methods/
package rockthejvm

object test1:
  case class Person(name: String):
    def likes(movie: String): String = s"$name likes $movie"

  def main: Unit =
    val mary = Person("Mary")
    val ariasFavMovie = mary.likes("Forrest Gump")
    val marysFavMovie2 = mary likes "Forrest Gump"

    println(mary)
    println(ariasFavMovie)
    println(marysFavMovie2)

object test2:
  case class Person(name: String)

  extension (person: Person)
    infix def likes(movie: String): String = s"${person.name} likes $movie"

  def main: Unit =
    val mary = Person("Mary")
    val marysFavMovie3 = mary likes "Forrest Gump"

    println(mary)
    println(marysFavMovie3)

@main def Main: Unit =
  test1.main
  println()
  test2.main

// adapted from https://blog.rockthejvm.com/scala-3-match-types/
package rockthejvm

def lastDigitOf(number: BigInt): Int = (number % 10).toInt

def lastCharOf(string: String): Char =
  if string.isEmpty then throw new NoSuchElementException
  else string.charAt(string.length - 1)

def lastElemOf[T](list: List[T]): T =
  if list.isEmpty then throw new NoSuchElementException
  else list.last

type ConstituentPartOf[T] = T match
  case BigInt => Int
  case String => Char
  case List[t] => t

val aNumber: ConstituentPartOf[BigInt] = 2
val aCharacter: ConstituentPartOf[String] = 'a'
val anElement: ConstituentPartOf[List[String]] = "Scala"

def lastComponentOf[T](thing: T): ConstituentPartOf[T] = thing match
  case b: BigInt => (b % 10).toInt
  case s: String => 
    if (s.isEmpty) throw new NoSuchElementException
    else s.charAt(s.length - 1)
  case l: List[_] =>
    if (l.isEmpty) throw new NoSuchElementException
    else l.last

@main def Main: Unit =
  val i = lastDigitOf(BigInt(53728573))
  val c = lastCharOf("Scala")
  val e = lastElemOf((1 to 10).toList)

  println(s"lastDigitOf=$i")
  println(s"lastCharOf =$c")
  println(s"lastElemOf =$e")
  println()

  val lastDigit = lastComponentOf(BigInt(53728573)) // 3
  val lastChar = lastComponentOf("Scala") // 'a'
  val lastElement = lastComponentOf((1 to 10).toList) // 10

  println(s"lastDigit  =$lastDigit")
  println(s"lastChar   =$lastChar")
  println(s"lastElement=$lastElement")

import com.typesafe.config.{Config, ConfigFactory}

object Main {

  // --------- example 1 ---------

  given config: Config = ConfigFactory.load()
  given discount: Int = 5

  // single parameter as using 
  def getPrice(using config: Config) =
    config.getInt("price")

  // multiple parameters as using
  def getDiscountedPrice(using discount: Int, config: Config) =
    config.getInt("price") - discount

  // using and no using parameters using currying
  def getTotalPrice(quantity: Int)(using discount: Int, config: Config) = {
    val priceAfterDiscount = config.getInt("price") - discount
    quantity * priceAfterDiscount
  }

  // --------- example 2 ---------

  case class Meters(value: Double)     // represents distance in meters
  case class Kilometers(value: Double) // represents distance in kilometers

  // implicit conversions can be anonymous
  given Conversion[Meters, Kilometers] =
    meters => Kilometers(meters.value / 1000.0)

  // --------- example 3 ---------

  case class Product(name: String)

  extension (product: Product)
    def price: Int = product match {
      case Product("Samsung") => 200
      case Product("LG") => 210
      case _ => 0
    }
    def quantity: Int = 30
    def warrantyInYears: Int = 3

  def main(args: Array[String]): Unit = {

    // --------- example 1 ---------

    println("price: " + getPrice)
    println("discount: " + discount)
    println("discounted price: " + getDiscountedPrice)
    println("total price: " + getTotalPrice(2)) // prints 30

    // --------- example 2 ---------

    println()
    // compiler automatically converts Meters to Kilometers
    val distanceInKilometers: Kilometers = Meters(5000)
    println(distanceInKilometers) // prints Kilometers(5.0)

    // --------- example 3 ---------

    println()
    val samsung = Product("Samsung")
    println("Samsung")
    println("  price   : " + samsung.price)
    println("  quantity: " + samsung.quantity)
    println("  warranty: " + samsung.warrantyInYears + " years")
    val lg = Product("LG")
    println("LG")
    println("  price   : " + lg.price)
    println("  quantity: " + lg.quantity)
    println("  warranty: " + lg.warrantyInYears + " years")
    val unknown = Product("LG")
    println("unknown")
    println("  price   : " + unknown.price)
    println("  quantity: " + unknown.quantity)
    println("  warranty: " + unknown.warrantyInYears + " years")
  }

}

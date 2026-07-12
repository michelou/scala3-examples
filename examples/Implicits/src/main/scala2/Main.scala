import com.typesafe.config.{Config, ConfigFactory}

object Main {

  // --------- example 1 ---------

  implicit val config: Config = ConfigFactory.load()
  implicit val discount: Int = 5

  // single parameter as implicit 
  def getPrice(implicit config: Config) =
    config.getInt("price")

  // multiple parameters as implicits
  def getDiscountedPrice(implicit discount: Int, config: Config) =
    config.getInt("price") - discount

  // implicit and no implicit parameters using currying
  def getTotalPrice(quantity: Int)(implicit discount: Int, config: Config) = {
    val priceAfterDiscount = config.getInt("price") - discount
    quantity * priceAfterDiscount
  }

  // --------- example 2 ---------

  case class Meters(value: Double)     // represents distance in meters
  case class Kilometers(value: Double) // represents distance in kilometers

  // implicit function to convert meters to kilometers
  implicit def metersToKilometers(meters: Meters): Kilometers =
    Kilometers(meters.value / 1000.0)

  // --------- example 3 ---------

  case class Product(name: String)

  case class Price(product: Product) {
    def price: Int = product match {
      case Product("Samsung") => 200
      case Product("LG") => 210
      case _ => 0
    }
  }
  implicit def productToPrice(product: Product): Price =
    Price(product)

  case class Quantity(product: Product) {
    def quantity: Int = 30
  }
  implicit def productToQuantity(product: Product): Quantity =
    Quantity(product)

  case class Warranty(product: Product) {
    def warrantyInYears: Int = 3
  }
  implicit def productToWarranty(product: Product): Warranty =
    Warranty(product)

  def main(args: Array[String]): Unit = {

    // --------- example 1 ---------

    println("price: "+ getPrice) // prints 20
    println("discount: " + discount)
    println("discounted price: " + getDiscountedPrice) // prints 15
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
    val unknown = Product("unknown")
    println("unknown")
    println("  price   : " + unknown.price)
    println("  quantity: " + unknown.quantity)
    println("  warranty: " + unknown.warrantyInYears + " years")
  }

}

// adapted from https://blog.rockthejvm.com/enums-scala-3/
package rockthejvm

enum Permissions:
  case READ, WRITE, EXEC, NONE

val read: Permissions = Permissions.READ

enum PermissionsWithBits(val bits: Int):
  case READ  extends PermissionsWithBits(4) // 100
  case WRITE extends PermissionsWithBits(2) // 010
  case EXEC  extends PermissionsWithBits(1) // 001
  case NONE  extends PermissionsWithBits(0) // 000

  def toHex: String = Integer.toHexString(bits)

object PermissionsWithBits:
  def fromBits(bits: Int): PermissionsWithBits =
    PermissionsWithBits.values
      .find(_.bits == bits)
      .getOrElse(PermissionsWithBits.NONE)

@main def Main: Unit =
  val read2: PermissionsWithBits = PermissionsWithBits.READ
  val bitString = read2.bits
  val hexString = read2.toHex

  println(s"bitString=$bitString")
  println(s"hexString=$hexString")
  println()

  // standard API
  val first = Permissions.READ.ordinal
  val allPermissions = Permissions.values
  val readPermission: Permissions = Permissions.valueOf("READ")

  println(s"first=$first")
  println(s"allPermissions=${allPermissions.mkString(" ")}")
  println(s"fromBits(2)=${PermissionsWithBits.fromBits(2)}")

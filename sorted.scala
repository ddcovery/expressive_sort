import scala.util.Random;

object Main {
  val C_Times = 5
  val C_Millions = 1d :: 1.5d :: 3d :: 6d :: Nil

  def main(args: Array[String]) = 
    C_Millions.foreach( millions => 
      test(C_Times, (millions * 1000000d).toLong ) 
    )

  def sorted( xs:List[Double] ) : List[Double] = 
    xs match {
      case Nil => 
        List()
      case pivot :: rest => 
        sorted( rest.filter( _ < pivot ) ) ++
        List(pivot) ++
        sorted( rest.filter( _ >= pivot ) )
    }

  def generate(size:Long): List[Double] = {
    val random = new Random   
    List.range(0, size).map( _ => random.nextDouble() );    
  }

  def test(times:Long, size:Long) = {
    val avg = List.
      range(0, times).
      map( _ => generate(size)).
      map( xs => measure(() => sorted(xs)) ).
      reduce( (a,b)=>a+b ) / times

    printf("%d,%d\n",size, avg)
  }

  def measure(block: ()=>List[Double]): Long = {
    val t0 = System.nanoTime()
    val result = block()
    // Evaluación requierida para que optimiador de scala no elimine la llamada a block()
    assert(result.head >= -1 );

    (System.nanoTime()-t0) / 1000000;
  }

}
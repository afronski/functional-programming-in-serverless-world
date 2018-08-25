package fp_sls_aws_jvm_scala

import com.amazonaws.services.lambda.runtime.{Context, RequestHandler}

import com.google.gson.Gson

import collection.JavaConverters
import collection.JavaConverters._

class SieveHandler extends RequestHandler[ApiGatewayRequest, ApiGatewayResponse] {

  private def getPrimesUpTo(number: Int): List[Int] = {
    var primes : List[Int] = List()
    var composites : Set[Int] = Set()

    for (i <- 2 until number + 1) {
      if (!composites.contains(i)) {
        primes ::= i
        composites = composites ++ Range(i + i, number + 1, i).toSet
      }
    }

    primes.sorted
  }

  def handleRequest(event: ApiGatewayRequest, context: Context): ApiGatewayResponse = {
    val headers = Map("Content-Type" -> "application/json")
    val query = event.queryStringParameters.asScala

    val number = query.getOrElse("number", "0").toString
    println("Generating primes up to: " + number)

    val primes = getPrimesUpTo(number.toInt)
    val gson = new Gson
    val payload = gson.toJson(JavaConverters.mapAsJavaMap[String, Object](Map("result" -> primes.asJava)))

    ApiGatewayResponse(
      200,
      payload,
      JavaConverters.mapAsJavaMap[String, Object](headers),
      false
    )
  }
}

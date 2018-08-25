package fp_sls_aws_jvm_scala

import com.amazonaws.services.lambda.runtime.{Context, RequestHandler}

import collection.JavaConverters
import collection.JavaConverters._

class EchoHandler extends RequestHandler[ApiGatewayRequest, ApiGatewayResponse] {

  def handleRequest(event: ApiGatewayRequest, context: Context): ApiGatewayResponse = {
    val inputHeaders = event.headers.asScala

    val contentType = inputHeaders.getOrElse("Content-Type", inputHeaders.getOrElse("content-type", "application/json"))
    println("Received content type header value: " + contentType)

    val headers = Map("Content-Type" -> contentType)

    ApiGatewayResponse(
      200,
      event.body,
      JavaConverters.mapAsJavaMap[String, Object](headers),
      false
    )
  }
}

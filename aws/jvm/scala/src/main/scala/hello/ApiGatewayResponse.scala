package fp_sls_aws_jvm_scala

import scala.beans.BeanProperty

case class ApiGatewayResponse(
  @BeanProperty statusCode: Integer,
  @BeanProperty body: String,
  @BeanProperty headers: java.util.Map[String, Object],
  @BeanProperty base64Encoded: Boolean = false)

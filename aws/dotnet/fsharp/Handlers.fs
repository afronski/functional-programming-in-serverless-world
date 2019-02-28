namespace DotNetFSharp

open Amazon.Lambda.APIGatewayEvents
open Amazon.Lambda.Core
open Amazon.Lambda.Serialization.Json

[<assembly:LambdaSerializer(typeof<JsonSerializer>)>]
do ()

module Handlers =
  open System
  open System.IO
  open System.Collections
  open System.Text

  let getPrimes n =
    let sieve = new BitArray((n / 2) + 1, true)
    let result = new ResizeArray<int>(n / 10)
    let upper = int (sqrt (float n))

    if n > 1 then result.Add(2)

    let mutable m = 1

    while 2 * m + 1 <= n do
     if sieve.[m] then
       let k = 2 * m + 1
       if k <= upper then
         let mutable i = m
         while 2 * i < n do sieve.[i] <- false; i <- i + k
       result.Add k
     m <- m + 1

    result

  let echo(request: APIGatewayProxyRequest) =
      let contentType = request.Headers.["Content-Type"]

      let response = APIGatewayProxyResponse()

      printfn "Received content type value from request: %s" contentType

      response.StatusCode <- 200
      response.Headers <- Map.empty.Add("Content-Type", contentType)
      response.Body <- request.Body

      response

  let sieve(request: APIGatewayProxyRequest) =
      let response = APIGatewayProxyResponse()

      response.StatusCode <- 200
      response.Headers <- Map.empty.Add("Content-Type", "application/json")

      let number = request.QueryStringParameters.["number"] |> int

      printfn "Generating prime numbers up to: %i" number

      let primes = getPrimes number

      let serializer = JsonSerializer()
      let stream = new MemoryStream()

      serializer.Serialize(Map.empty.Add("result", primes), stream)
      response.Body <- Encoding.ASCII.GetString(stream.ToArray())

      response

"use strict";

const lambda = require("./output/Lambda");

exports.handler = function(event, context, callback) {
  if (event.path === "/echo") {
    let contentType = "application/json";

    if (!!event.headers) {
      contentType = event.headers["Content-Type"] || event.headers["content-type"];
    }

    callback(null, { statusCode: 200, headers: { "Content-Type": contentType }, body: lambda.echo(event.body) });
  }

  if (event.path === "/sieve") {
    let number = parseInt(event.queryStringParameters.number, 10);
    let payload = JSON.stringify({ result: lambda.sieve(number) });

    console.info("Generating primes up to number: %d", number);

    callback(null, { statusCode: 200, headers: { "Content-Type": "application/json" }, body: payload });
  }
};
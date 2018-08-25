const util = require("util");
const spawn = require("child_process").spawn;

exports.handler = function (event, context, callback) {
  process.env["PATH"] = process.env["PATH"] + ":" + process.env["LAMBDA_TASK_ROOT"];
  process.env["LD_LIBRARY_PATH"] = process.env["LAMBDA_TASK_ROOT"];

  let args = [ "echo", util.format("'%s'", event.body) ];

  if (event.path === "/sieve") {
    args = [ "sieve", util.format("%s", event.queryStringParameters.number) ];
  }

  const main = spawn("./haskell-handler", args, { cwd: process.cwd(), env: process.env, stdio: ["pipe", "pipe", process.stderr] });

  let chunks = [];
  let errorHandled = false;

  main.stdout.on("data", function (chunk) {
    chunks.push(chunk);
  });

  main.stdout.on("end", function () {
    if (!errorHandled) {
      let body = chunks.join("");

      if (event.path === "/echo") {
        let contentType = "application/json";

        if (!!event.headers) {
          contentType = event.headers["Content-Type"] || event.headers["content-type"];
        }

        callback(null, { statusCode: 200, headers: { "Content-Type": contentType }, body: body });
      } else {
        let result = body.split(" ").map(function (element) { return parseInt(element, 10); });
        let payload = JSON.stringify({ result: result });

        callback(null, { statusCode: 200, headers: { "Content-Type": "application/json" }, body: payload });
      }
    }
  })

  main.on("close", function (code) {
    console.info("Child process pipes closed with code %d.", code);
  });

  console.info("Sending arguments to 'haskell-handler': %j", args);
  console.info("'haskell-handler' pid is %d.", main.pid);

  main.on("exit", function (code) {
    callback(null, util.format("Child process exited with code: %d.", code));
  });

  main.on("error", function (err) {
    errorHandled = true;

    console.error(util.format("Error: %s", err));
    callback(err, null);
  });
};
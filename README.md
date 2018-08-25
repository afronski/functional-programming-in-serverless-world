# functional-programming-in-serverless-world

## Motivation

Repository is a foundation for measurements that @afronski presented in the talk with the same title. He has performed it on the following conferences and meet-ups:

- [Lambda Days](http://www.lambdadays.org/lambdadays2018/wojciech-gawronski) (23.02.2018 - *Cracow*, *Poland*).
- [LambdUp](https://www.lambdup.io/agenda.html#talk-wojciech-gawronski) (13.09.2018 - *Prague*, *Czechia*).
- [Serverless UG #3: Warsaw](https://www.meetup.com/ServerlessUGPL/events/250771133) (27.09.2018 - *Warsaw*, *Poland*).
- [Big Data Moscow](https://bigdatadays.ru/wojciech-gawronski) (11.10.2018 - *Moscow*, *Russia*).

Scenarios:

- Package *size*.
- *Cold Start* effect.
- *Latency* distribution.
- *Memory* usage test.

Languages:

- Haskell (*AWS Lambda* via *Node.js* shim).
- F# (*AWS Lambda*, officially support by *Serverless Framework*).
- Scala (*AWS Lambda*, officially support by *Serverless Framework*).
- Clojure (*AWS Lambda* on *JVM*).
- ClojureScript (*AWS Lambda* on *Node.js*).
- BuckleScript (*AWS Lambda* on *Node.js*).
- PureScript (*AWS Lambda* on *Node.js*).

All implementations above do exactly the same thing:

- Expose two handlers - each behind the `POST` *HTTP* method (to avoid caching).
    - `sieve` - Naive implementation for *Sieve of Eratosthenes*.
        - It accepts single argument `number` provided via *query string*.
        - It prints out the log entry that points up to which number we generate *prime numbers*.
        - Each implementation is *tail recursive*.
        - It outputs that number as a `result` field in an outgoing *JSON*.
    - `echo` - Sends the same data as received in the *JSON* request in the *JSON* response.
        - Payload in, payload out - no additional logic, bootstrapping, and so on.
        - It should be as little problematic as possible, in order to measure only *cold-start effect*.

## What about other cloud providers?

As you might noticed, this repository heavily relies on *Serverless Framework* - mostly because of convenience. For both *Azure* and *Google Cloud Platform* there are no templates (neither official, nor community ones) for languages like *F#*, *Clojure*, *Scala* etc.

Because of that, I have skipped that element for now. *Sorry*.

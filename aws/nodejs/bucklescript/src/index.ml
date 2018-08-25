external to_json_string : ('a -> string) = "js_json_stringify"

class type _queryStringParameters = object
  val number : string
end [@bs]
type queryStringParameters = _queryStringParameters Js.t

class type _event = object
  val queryStringParameters : queryStringParameters
  val body : string
end [@bs]
type event = _event Js.t

let echo_handler event _ callback =
  let echo = event##body in
  let response = [%bs.obj { statusCode = 200; body = echo }] in
  let _ = callback Js.null response [@bs] in
  ()

let primes n =
  let is_prime = Array.make n true in
  let limit = truncate(sqrt (float (n - 1))) in
  for i = 2 to limit do
    if is_prime.(i) then
      let j = ref (i * i) in
      while !j < n do
        is_prime.(!j) <- false;
        j := !j + i;
      done
  done;
  is_prime.(0) <- false;
  is_prime.(1) <- false;
  is_prime

let sieve n = match n with
    0 -> Array.make 0 0
  | 1 -> Array.make 0 0
  | _ -> let potential_primes = Array.to_list(primes n) in
         let mapped_primes = List.mapi (fun index value -> if value = false then 0 else index) potential_primes in
         let final_primes = List.filter (fun value -> value <> 0) mapped_primes in
         Array.of_list(final_primes)

let sieve_handler event _ callback =
  Js.log ("Generating primes less than: " ^ event##queryStringParameters##number);

  let n = int_of_string event##queryStringParameters##number in
  let list_of_primes = [%bs.obj sieve n] in
  let proper_list_of_primes = Array.map (fun value -> float_of_int value) list_of_primes in
  let dictionary = Js.Dict.empty () in
    Js.Dict.set dictionary "result" (Js.Json.numberArray proper_list_of_primes);

  let prepared_body = Js.Json.object_ dictionary in
  let serialized_body = Js.Json.stringify(prepared_body) in
  let response = [%bs.obj { statusCode = 200; body = serialized_body }] in
  let _ = callback Js.null response [@bs] in
  ()
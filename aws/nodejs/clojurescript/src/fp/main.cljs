(ns fp.main
  (:require [cljs-lambda.macros :refer-macros [defgateway]]))

(defgateway echo [event ctx]
  {:status  200
   :headers {:content-type (-> event :headers :content-type)}
   :body    (event :body)})

(defn- str->int [str]
  (js/parseInt str 10))

(defgateway sieve [event ctx]
  (let [number (get-in event [:query :number])
        primes (clj->js (primes< (str->int number)))]

    (js/console.info "Generating primes less than %d." number)

    {:status 200
     :headers {:content-type "application/json"}
     :body    (JSON/stringify (clj->js {:result primes}))}))

(defn primes< [n]
  (if (<= n 2)
    ()
    (remove (into #{}
                  (mapcat #(range (* % %) n %))
                  (range 3 (Math/sqrt n) 2))
            (cons 2 (range 3 n 2)))))
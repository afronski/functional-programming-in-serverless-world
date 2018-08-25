(ns fp_sls_clj.main
  (:require [clojure.data.json :as json])
  (:import (com.amazonaws.services.lambda.runtime.events APIGatewayProxyResponseEvent))
  (:gen-class
    :methods [[echo [com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent] com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent]
              [sieve [com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent] com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent]]))

(defn- make-response [response]
  (doto (new APIGatewayProxyResponseEvent)
        (.withStatusCode (Integer. (get response :status)))
        (.withHeaders (get response :headers))
        (.withBody (get response :body))))

(defn- get-content-type [headers]
  (get headers "Content-Type" (get headers "content-type")))

(defn -echo [this event]
  (let [headers (.getHeaders event)]
    (println (format "Provided headers: %s." (json/write-str headers)))

    (make-response {:status  200
                    :headers {"Content-Type" (get-content-type headers)}
                    :body    (.getBody event)})))

(defn- str->int [str]
  (Integer/parseInt (re-find #"\A-?\d+" str)))

(defn- primes< [n]
  (if (<= n 2)
    ()
    (remove (into #{}
                  (mapcat #(range (* % %) n %))
                  (range 3 (Math/sqrt n) 2))
            (cons 2 (range 3 n 2)))))

(defn -sieve [this event]
  (let [query  (.getQueryStringParameters event)
        number (str->int (get query "number" "0"))
        primes (primes< number)]

    (println (format "Generating primes less than %d." number))

    (make-response {:status 200
                    :headers {"Content-Type" "application/json"}
                    :body    (json/write-str {:result primes})})))
(defproject fp_sls_clj "1.0.0"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/data.json "0.2.6"]
                 [com.amazonaws/aws-lambda-java-events "2.0.2"]]

  :source-paths ["src" "src/main/clojure"]

  :aot :all)
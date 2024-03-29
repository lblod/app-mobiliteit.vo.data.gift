(in-package :mu-cl-resources)
;;; BESLUIT-mobiliteit
;;; https://data.vlaanderen.be/doc/applicatieprofiel/besluit-mobiliteit
;;; https://data.vlaanderen.be/doc/applicatieprofiel/verkeersborden/

(define-resource verkeersbordcombinatie ()
  :class (s-prefix "lblodmow:Verkeersbordcombinatie")
  :properties `((:identifier :string ,(s-prefix "dct:identifier"))) ; identifier from irg
  :has-many `((maatregelconcept :via ,(s-prefix "dct:hasPart")
                                 :as "maatregelconcepten"))
  :resource-base (s-url "http://data.lblod.info/verkeersbordcombinaties/")
  :on-path "verkeersbordcombinaties")

(define-resource maatregelconcept ()
  :class (s-prefix "lblodmow:MaatregelConcept")
  :properties `((:beschrijving :string ,(s-prefix "dct:description")))
  :has-one `((verkeersbordcombinatie :via ,(s-prefix "dct:hasPart")
                                     :inverse t
                                     :as "combinaties")
             (verkeersbordconcept :via ,(s-prefix "lblodmow:verkeersbordconcept")
                                  :as "verkeersbordconcept"))
  :resource-base (s-url "http://data.lblod.info/verkeersbordcombinaties/")
  :on-path "maatregelconcepten")
(define-resource afbeelding ()
  :class (s-prefix "foaf:Image")
  :properties `((:filename :string ,(s-prefix "nfo:fileName"))
                (:format :string ,(s-prefix "dct:format"))
                (:size :number ,(s-prefix "nfo:fileSize"))
                (:extension :string ,(s-prefix "dbpedia:fileExtension"))
                (:created :datetime ,(s-prefix "nfo:fileCreated")))
  :has-one `((file :via ,(s-prefix "nie:dataSource")
                   :inverse t
                   :as "download")
             (file-address :via ,(s-prefix "nie:dataSource")
                           :as "data-source"))
  :resource-base (s-url "http://data.lblod.info/files/")
  :features `(no-pagination-defaults include-uri)
  :on-path "images")

(define-resource verkeersbordconcept ()
  :class (s-prefix "mobiliteit:Verkeersbordconcept")
  :properties `((:betekenis :string ,(s-prefix "skos:scopeNote"))
                (:verkeersbordcode :string ,(s-prefix "skos:prefLabel"))
                )
  :has-one `((afbeelding :via  ,(s-prefix "mobiliteit:grafischeWeergave")
                         :as "afbeelding")
             (verkeersbordconcept-status-code :via ,(s-url "http://www.w3.org/2003/06/sw-vocab-status/ns#term_status")
                                         :as "status"))
  :has-many `((verkeersbordcategorie :via ,(s-prefix "org:classification")
                                      :as "categorie")
              (maatregelconcept :via ,(s-prefix "lblodmow:verkeersbordconcept")
                                      :inverse t
                                      :as "maatregelconcepten"))
  :resource-base (s-url "http://data.lblod.info/verkeersbordconcepten/")
  :on-path "verkeersbordconcepten")

(define-resource verkeersbordcategorie ()
  :class (s-prefix "mobiliteit:Verkeersbordcategorie")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((verkeersbordconcept :via ,(s-prefix "org:classification")
                                   :inverse t
                                   :as "verkeersbordconcepten"))
  :resource-base (s-url "http://data.lblod.info/verkeersbordcategorieen/")
  :on-path "verkeersbordcategorieen"
  )

(define-resource verkeersbordconcept-status-code ()
  :class (s-prefix "lblodmow:VerkeersbordconceptStatusCode")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((verkeersbordconcept :via ,(s-url "http://www.w3.org/2003/06/sw-vocab-status/ns#term_status")
                                   :inverse t
                                   :as "verkeersbordconcepten"))
  :resource-base (s-url "http://data.lblod.info/verkeersbordconcept-status-codes/")
  :on-path "verkeersbordconcept-status-codes"
  )

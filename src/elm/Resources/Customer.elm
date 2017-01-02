module Resources.Customer exposing (..)

import Json.Decode as Decode exposing (field)

type alias Customer =
    { id:Int
    , firstName:String}

type SearchField
    = Name
    | Mobile
    | Postcode


customerDecoder:Decode.Decoder (List Customer)
customerDecoder = Decode.list memberDecoder

memberDecoder:Decode.Decoder Customer
memberDecoder =
    Decode.map2 Customer
        (field "id" Decode.int)
        (field "first_name" Decode.string)

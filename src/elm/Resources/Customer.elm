module Resources.Customer exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Api


type alias Customer =
    { id : Int
    , firstName : String
    , lastName : String
    }



--TODO change id to Maybe id and change decoder


empty : Customer
empty =
    { id = -1
    , firstName = ""
    , lastName = ""
    }


type SearchField
    = Name
    | Mobile
    | Postcode


search query msg =
    Api.get ("customer?" ++ query ) customerDecoder msg


customerDecoder : Decode.Decoder (List Customer)
customerDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Customer
memberDecoder =
    Decode.map3 Customer
        (field "id" Decode.int)
        (field "first_name" Decode.string)
        (field "last_name" Decode.string)

module Customer.Customer
    exposing
        ( Customer
        , search
        , SearchField(..)
        )

import Http
import Json.Decode as Decode
import Api


type alias Customer =
    { id : Int
    , firstName : String
    , lastName : String
    }


new : Customer
new =
    { id = 0
    , firstName = ""
    , lastName = ""
    }


type SearchField
    = Name
    | Postcode
    | Mobile


type alias SearchQuery =
    { value : String
    , field : SearchField
    }


search : SearchQuery -> (Result Http.Error (List Customer) -> m) -> Cmd m
search { value, field } msg =
    case field of
        Name ->
            Api.get ("customer?full_name=ilike.*" ++ value ++ "*") customerDecoder msg

        _ ->
            Api.get ("customer?") customerDecoder msg


customerDecoder : Decode.Decoder (List Customer)
customerDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Customer
memberDecoder =
    Decode.map3 Customer
        (Decode.field "id" Decode.int)
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)

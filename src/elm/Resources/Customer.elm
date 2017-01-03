module Resources.Customer exposing (..)

import Http
import Json.Decode as Decode exposing (field)

import Api

type alias Customer =
    { id:Int
    , firstName:String
    , lastName: String
    }

type SearchField
    = Name
    | Mobile
    | Postcode

search query msg =
    let
        {field,value} =
            query
    in
        case field of
            Name ->
                Api.get ("customer?full_name=ilike.*"++value++"*") customerDecoder msg
            _ ->
                Http.get "http://localhost:6464/customers" customerDecoder |> Http.send msg


customerDecoder:Decode.Decoder (List Customer)
customerDecoder = Decode.list memberDecoder

memberDecoder:Decode.Decoder Customer
memberDecoder =
    Decode.map3 Customer
        (field "id" Decode.int)
        (field "first_name" Decode.string)
        (field "last_name" Decode.string)

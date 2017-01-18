module Customer.Customer exposing (..)

import Http
import Json.Decode as Decode
import Api
import Dict as Dict exposing (Dict)
import Validate as Val
import Helpers


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


type ValidationField
    = FirstName
    | LastName


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


valFirstName_ : List (Customer -> List String)
valFirstName_ =
    [ .firstName >> Val.ifBlank "First Name is required."
    ]


valFirstName : Customer -> Maybe String
valFirstName =
    Val.eager
        valFirstName_


validate : Customer -> List String
validate =
    Val.all
        ([ valFirstName_
         ]
            |> List.concat
        )


(=>) =
    (,)


customersToDict : List Customer -> Dict String Customer
customersToDict customers =
    Helpers.resourceToDict (\c -> toString <| .id c) customers

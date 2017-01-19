module Customer.Customer exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Api
import Dict as Dict exposing (Dict)
import Validate as Val
import Helpers
import Context exposing (Context)


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


type alias CustomerValidation =
    { firstName : Maybe String
    , lastName : Maybe String
    }


initCustomerValidation =
    { firstName = Nothing
    , lastName = Nothing
    }


type SearchField
    = Name
    | Postcode
    | Mobile


type alias SearchQuery =
    { value : String
    , field : SearchField
    }


search : Context -> SearchQuery -> (Result Http.Error (List Customer) -> m) -> Cmd m
search context { value, field } msg =
    case field of
        Name ->
            Api.get context.jwt ("customer?full_name=ilike.*" ++ value ++ "*") customerListDecoder msg

        _ ->
            Api.get context.jwt ("customer?") customerListDecoder msg


newCustomer : Context -> Customer -> (Result Http.Error Customer -> msg) -> Cmd msg
newCustomer context customer msg =
    Api.newResource context.jwt "customers" (customerValue customer) customerDecoder msg


customerValue : Customer -> Encode.Value
customerValue customer =
    Encode.object
        [ ( "first_name", Encode.string customer.firstName )
        , ( "last_name", Encode.string customer.lastName )
        ]


customerListDecoder : Decode.Decoder (List Customer)
customerListDecoder =
    Decode.list customerDecoder


customerDecoder : Decode.Decoder Customer
customerDecoder =
    Decode.map3 Customer
        (Decode.field "id" Decode.int)
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)


valFirstName_ : List (Customer -> List String)
valFirstName_ =
    [ .firstName >> Val.ifBlank "First Name is required." ]


valFirstName : Customer -> Maybe String
valFirstName =
    Val.eager valFirstName_


valLastName_ : List (Customer -> List String)
valLastName_ =
    [ .lastName >> Val.ifBlank "Last Name is required." ]


valLastName : Customer -> Maybe String
valLastName =
    Val.eager valLastName_


validate : Customer -> List String
validate =
    Val.all
        ([ valFirstName_
         , valLastName_
         ]
            |> List.concat
        )


validateCustomer : Customer -> CustomerValidation
validateCustomer customer =
    { firstName = valFirstName customer
    , lastName = valLastName customer
    }


customersToDict : List Customer -> Dict String Customer
customersToDict customers =
    Helpers.resourceToDict (\c -> toString <| .id c) customers

module Customer.Customer exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Api
import Dict as Dict exposing (Dict)
import Validate as Val
import Helpers
import Context exposing (Context)
import String


type alias DataUri =
    String


type alias Customer =
    { id : Int
    , firstName : String
    , lastName : String
    , pic : DataUri
    }


type alias CustomerPic =
    { pic : String }


new : Customer
new =
    { id = 0
    , firstName = ""
    , lastName = ""
    , pic = ""
    }


type alias CustomerValidation =
    { firstName : Maybe String
    , lastName : Maybe String
    , pic : Maybe String
    }


initCustomerValidation =
    { firstName = Nothing
    , lastName = Nothing
    , pic = Nothing
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
    let
        select =
            "&select=id,first_name,last_name"
    in
        case field of
            Name ->
                Api.get (Just context.jwt.token) ("customer?full_name=ilike.*" ++ value ++ "*" ++ select) customerListDecoder msg

            _ ->
                Api.get (Just context.jwt.token) ("customer?") customerListDecoder msg


newCustomer : Context -> Customer -> (Result Http.Error Customer -> msg) -> Cmd msg
newCustomer context customer msg =
    Api.newResource (Just context.jwt.token) "customers" (customerValue customer) customerDecoder msg


updateCustomer : Context -> Customer -> (Result Http.Error Customer -> msg) -> Cmd msg
updateCustomer context customer msg =
    Api.updateResource (Just context.jwt.token) "customers" (toString customer.id) (customerValue customer) customerDecoder msg


getCustomerPic : Context -> String -> (Result Http.Error CustomerPic -> msg) -> Cmd msg
getCustomerPic context id msg =
    Api.getSingle (Just context.jwt.token) ("customers?id=eq." ++ id ++ "&select=pic") customerPicDecoder msg


customerValue : Customer -> Encode.Value
customerValue =
    normalize >> customerValue_


normalize : Customer -> Customer
normalize customer =
    { customer
        | firstName = String.toLower customer.firstName
        , lastName = String.toLower customer.lastName
    }


customerValue_ : Customer -> Encode.Value
customerValue_ customer =
    Encode.object
        [ ( "first_name", Encode.string customer.firstName )
        , ( "last_name", Encode.string customer.lastName )
        , ( "pic", Encode.string customer.pic )
        ]


customerListDecoder : Decode.Decoder (List Customer)
customerListDecoder =
    Decode.list customerDecoder


customerDecoder : Decode.Decoder Customer
customerDecoder =
    decode Customer
        |> required "id" Decode.int
        |> required "first_name" Decode.string
        |> required "last_name" Decode.string
        |> optional "pic" Decode.string ""


customerPicDecoder : Decode.Decoder CustomerPic
customerPicDecoder =
    decode CustomerPic
        |> required "pic" Decode.string


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


valPic_ : List (Customer -> List String)
valPic_ =
    [ .pic >> Val.ifBlank "Profile Picture is required." ]


valPic : Customer -> Maybe String
valPic =
    Val.eager valPic_


validate : Customer -> List String
validate =
    Val.all
        ([ valFirstName_
         , valLastName_
         , valPic_
         ]
            |> List.concat
        )


validateCustomer : Customer -> CustomerValidation
validateCustomer customer =
    { firstName = valFirstName customer
    , lastName = valLastName customer
    , pic = valPic customer
    }


customersToDict : List Customer -> Dict String Customer
customersToDict customers =
    Helpers.resourceToDict (\c -> toString <| .id c) customers

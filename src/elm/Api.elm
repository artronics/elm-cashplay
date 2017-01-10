module Api exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode exposing (..)


type alias Url =
    String


type alias Credential =
    { email : String
    , password : String
    }


type alias User =
    { firstName : String
    , lastName : String
    , company : String
    , password : String
    , email : String
    }


type alias JwtToken =
    { token : String
    }


type alias Signup =
    { signup : Maybe String }


baseUrl =
    "http://localhost:6464/"


login : Credential -> (Result Http.Error JwtToken -> msg) -> Cmd msg
login credential msg =
    Http.post (baseUrl ++ "rpc/login") (Http.jsonBody <| credentialValue credential) jwtDecoder
        |> Http.send msg


jwtDecoder : Decode.Decoder JwtToken
jwtDecoder =
    Decode.map JwtToken
        (field "token" Decode.string)


signup : User -> (Result Http.Error Signup -> msg) -> Cmd msg
signup user msg =
    Http.post (baseUrl ++ "rpc/signup") (Http.jsonBody <| userValue user) signupDecoder
        |> Http.send msg


signupDecoder : Decode.Decoder Signup
signupDecoder =
    Decode.map Signup
        (field "signup" (Decode.nullable Decode.string))


userValue : User -> Value
userValue user =
    object
        [ ( "first_name", string user.firstName )
        , ( "last_name", string user.lastName )
        , ( "company", string user.company )
        , ( "email", string user.email )
        , ( "pass", string user.password )
        ]


credentialValue : Credential -> Value
credentialValue cred =
    object
        [ ( "email", string cred.email )
        , ( "pass", string cred.password )
        ]



--get:Url -> Decode.Decoder a -> Result Http.Error a


get url decoder msg =
    Http.get (baseUrl ++ url) decoder |> Http.send msg

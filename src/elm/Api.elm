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


credentialValue : Credential -> Value
credentialValue cred =
    object
        [ ( "email", string cred.email )
        , ( "pass", string cred.password )
        ]


type alias JwtToken =
    { token : String
    }


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



--get:Url -> Decode.Decoder a -> Result Http.Error a


get url decoder msg =
    Http.get (baseUrl ++ url) decoder |> Http.send msg

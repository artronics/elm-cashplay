module Api exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


type alias Url =
    String


type Method
    = Get
    | Post
    | Patch


type Plurality
    = Singular
    | Plural


type alias Credential =
    { email : String
    , password : String
    }


type alias Auth =
    { auth : Credential
    }


type alias User =
    { id : Int
    , firstName : String
    , lastName : String
    , company : String
    , password : String
    , email : String
    }


type alias Me =
    { firstName : String
    , lastName : String
    , email : String
    , company : String
    }


newMe : Me
newMe =
    { firstName = ""
    , lastName = ""
    , email = ""
    , company = ""
    }


meDecoder : Decode.Decoder Me
meDecoder =
    Decode.map4 Me
        (field "first_name" Decode.string)
        (field "last_name" Decode.string)
        (field "email" Decode.string)
        (field "company" Decode.string)


type alias Token =
    String


type alias JwtToken =
    { jwt : Token
    }


type alias Signup =
    { signup : Maybe String }


baseUrl =
    "http://localhost:3000/"


login : Credential -> (Result Http.Error JwtToken -> msg) -> Cmd msg
login credential msg =
    genRequest Post Nothing Plural "user_token" (Just <| authValue credential) jwtDecoder msg


me : Token -> (Result Http.Error Me -> msg) -> Cmd msg
me token msg =
    genRequest Get (Just token) Plural "me" Nothing meDecoder msg


jwtDecoder : Decode.Decoder JwtToken
jwtDecoder =
    Decode.map JwtToken
        (field "jwt" Decode.string)


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
        , ( "password", string user.password )
        ]


credentialValue : Credential -> Value
credentialValue cred =
    object
        [ ( "email", string cred.email )
        , ( "password", string cred.password )
        ]


authValue : Credential -> Value
authValue cred =
    object
        [ ( "auth", credentialValue cred ) ]


get : Maybe Token -> Url -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
get token url decoder msg =
    genRequest Get token Plural url Nothing decoder msg


getSingle : Maybe Token -> Url -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
getSingle token url decoder msg =
    genRequest Get token Singular url Nothing decoder msg


post : Maybe Token -> Url -> Value -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
post token url value decoder msg =
    genRequest Post token Singular url (Just value) decoder msg


postPlural : Maybe Token -> Url -> Value -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
postPlural token url value decoder msg =
    genRequest Post token Plural url (Just value) decoder msg


newResource : Maybe Token -> Url -> Value -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
newResource token url value decoder msg =
    genRequest Post token Singular url (Just value) decoder msg


updateResource : Maybe Token -> Url -> String -> Value -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
updateResource token url id value decoder msg =
    genRequest Patch token Singular (url ++ "?id=eq." ++ id) (Just value) decoder msg


headers : Maybe Token -> Plurality -> List Http.Header
headers token pul =
    let
        p =
            case pul of
                Singular ->
                    Http.header "Accept" "application/vnd.pgrst.object+json"

                Plural ->
                    Http.header "Accept" "application/json"

        h =
            [ Http.header "Accept" "application/json"
            ]
    in
        token
            |> Maybe.map (\t -> (Http.header "Authorization" ("Bearer " ++ t)) :: h)
            |> Maybe.withDefault h


genRequest : Method -> Maybe Token -> Plurality -> Url -> Maybe Value -> Decode.Decoder a -> ((Result Http.Error a -> msg) -> Cmd msg)
genRequest method token pul url body decoder msg =
    let
        method_ =
            case method of
                Get ->
                    "GET"

                Post ->
                    "POST"

                Patch ->
                    "PATCH"
    in
        Http.request
            { method = method_
            , headers = headers token pul
            , url = (baseUrl ++ url)
            , body = body |> Maybe.map (\v -> Http.jsonBody v) |> Maybe.withDefault Http.emptyBody
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }
            |> Http.send msg

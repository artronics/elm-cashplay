module Api exposing (..)

import Http
import Json.Decode as Decode


type alias Url =
    String


baseUrl =
    "http://localhost:6464/"



--get:Url -> Decode.Decoder a -> Result Http.Error a


get url decoder msg =
    Http.get (baseUrl ++ url) decoder |> Http.send msg

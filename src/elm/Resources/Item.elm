module Resources.Item exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Api

type alias Item =
    { id: Int
    , description: String
    }


search msg=
    Api.get "items" itemDecoder msg

itemDecoder:Decode.Decoder (List Item)
itemDecoder =
    Decode.list memberDecoder

memberDecoder: Decode.Decoder Item
memberDecoder =
    Decode.map2 Item
        (field "id" Decode.int)
        (field "description" Decode.string)


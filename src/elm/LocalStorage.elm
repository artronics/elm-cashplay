port module LocalStorage exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode


type alias KeyVal =
    { key : String
    , value : String
    }


keyValValue : KeyVal -> Encode.Value
keyValValue keyVal =
    Encode.object
        [ "key" => Encode.string keyVal.key
        , "value" => Encode.string keyVal.value
        ]


port setLocalStorage : KeyVal -> Cmd msg


port removeLocalStorage : KeyVal -> Cmd msg


(=>) =
    (,)

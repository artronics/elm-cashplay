module Webcam exposing (..)

-- imports are weird for Native modules
-- You import them as you would normal modules
-- but you can't alias them nor expose stuff from them

import Native.Webcam
import Json.Encode as Encode


-- this will be our function which returns a number plus one


config : WebcamConfigValue -> ()
config =
    Native.Webcam.config


type alias WebcamConfigValue =
    Encode.Value


type alias WebcamConfig =
    { id : String
    , width : Int
    , height : Int
    , destWidth : Int
    , destHeight : Int
    }


webcamConfigValue : WebcamConfig -> WebcamConfigValue
webcamConfigValue conf =
    Encode.object
        [ "id" => Encode.string conf.id
        , "width" => Encode.int conf.width
        , "height" => Encode.int conf.height
        , "dest_width" => Encode.int conf.destWidth
        , "dest_height" => Encode.int conf.destHeight
        ]


(=>) =
    (,)

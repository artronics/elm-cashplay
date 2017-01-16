module Views.Elements.Style exposing (..)

import Html exposing (Html, Attribute)
import Css exposing (..)
import Html.Attributes exposing (class, style)


type ElmCss
    = Layout


type Color
    = Default
    | Primary


color : Color -> String
color clr =
    case clr of
        Default ->
            "default"

        Primary ->
            "primary"



--layout : List (Attribute msg)


layout =
    (.) Layout
        []

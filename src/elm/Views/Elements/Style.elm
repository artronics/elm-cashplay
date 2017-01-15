module Views.Elements.Style exposing (..)

import Html exposing (Html, Attribute)
import Css exposing (..)
import Html.Attributes exposing (class, style)


type ElmCss
    = Layout



--layout : List (Attribute msg)


layout =
    (.) Layout
        []

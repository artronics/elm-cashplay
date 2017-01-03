module Components.Breadcrumb exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Options exposing (..)

type alias Model a=
    List
        { header: String
        , subHeader:String
        , active: Bool
        , onActive: a
        }

view: Model a -> Html a
view model =
    div [][p [][text "foo"]]
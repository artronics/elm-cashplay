module Home.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Home.Models exposing (Home)
import Home.Messages exposing (Msg(..))
import Components.Login as Login


view : Home -> Html Msg
view home =
    div []
        [ Html.map LoginMsg <| Login.view home.login ]

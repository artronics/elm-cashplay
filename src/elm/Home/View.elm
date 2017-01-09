module Home.View exposing (view)

import Html exposing (Html, text, p)
import Home.Models exposing (Home)
import Home.Messages exposing (Msg(..))


view : Home -> Html Msg
view home =
    text "home"

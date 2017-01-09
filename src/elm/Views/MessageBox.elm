module Components.MessageBox exposing (..)

import Html exposing (Html, p, text)


view : String -> Html m
view model =
    p [] [ text model ]

module Views.MessageBox exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


view : String -> Html m
view model =
    div [ class "jumbotron art-msg-box row" ]
        [ div [ class "col-xs-6 col-xs-offset-3 " ]
            [ p [ class "text-center" ] [ strong [] [ text model ] ]
            ]
        ]

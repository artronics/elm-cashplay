module Cashplay.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Views.Layout as Layout
import Cashplay.Tab exposing (viewTab)


view : Cashplay -> Html Msg
view cashplay =
    div []
        [ Layout.view
            ( p [] [ text "nav" ]
            , viewTab cashplay
            , p [] [ text "transaction" ]
            )
        ]

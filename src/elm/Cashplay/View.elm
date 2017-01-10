module Cashplay.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Views.Layout as Layout
import Components.Tab as Tab


view : Cashplay -> Html Msg
view cashplay =
    div []
        [ Layout.view
            ( p [] [ text "nav" ]
            , Html.map TabMsg <| Tab.view cashplay.tab
            , p [] [ text "transaction" ]
            )
        ]

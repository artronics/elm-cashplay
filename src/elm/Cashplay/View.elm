module Cashplay.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Views.Layout as Layout
import Cashplay.Tab as Tab
import Customer.View as Customer


view : Cashplay -> Html Msg
view cashplay =
    div []
        [ Layout.view
            ( p [] [ text "nav" ]
            , Tab.view cashplay
            , p [] [ text "transaction" ]
            )
        ]

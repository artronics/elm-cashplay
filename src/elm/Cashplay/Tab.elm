module Cashplay.Tab exposing (..)

import Html exposing (..)
import Material
import Material.Tabs as Tabs
import Material.Options as Options exposing (..)
import Material.Icon as Icon exposing (..)
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Customer.View as CustomerTab


view : Cashplay -> Html Msg
view cashplay =
    Options.div []
        [ Tabs.render Mdl
            [ 0 ]
            cashplay.mdl
            [ Tabs.ripple
            , Tabs.onSelectTab SelectTab
            , Tabs.activeTab cashplay.currentTab
            ]
            [ Tabs.label
                [ Options.center ]
                [ Icon.i "person"
                , Options.span [ css "width" "4px" ] []
                , text "Customer"
                ]
            , Tabs.label
                [ Options.center ]
                [ Icon.i "devices_other"
                , Options.span [ css "width" "4px" ] []
                , text "Item"
                ]
            ]
            [ case cashplay.currentTab of
                0 ->
                    Html.map CustomerTabMsg <| CustomerTab.view cashplay.customerTab

                1 ->
                    text "item"

                _ ->
                    text "new tab... add content"
            ]
        ]

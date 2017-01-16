module Cashplay.Tab exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Cashplay.Models exposing (Cashplay, Tab(..))
import Cashplay.Messages exposing (Msg(..))
import Customer.View as CustomerTab
import Views.Elements.Label exposing (labelIcon)


viewTab : Cashplay -> Html Msg
viewTab cashplay =
    div [ class "art-tab-container" ]
        [ nav [ class "art-tab-bar" ]
            [ ul []
                [ viewTabName cashplay CustomerTab ( "Customrs", "user-o" )
                , viewTabName cashplay ItemTab ( "Items", "mobile" )
                ]
            ]
        , div [ class "art-tab-content" ]
            [ case cashplay.currentTab of
                CustomerTab ->
                    Html.map CustomerTabMsg <| CustomerTab.view cashplay.customerTab

                ItemTab ->
                    text "item tab"
            ]
        ]


viewTabName : Cashplay -> Tab -> ( String, String ) -> Html Msg
viewTabName cashplay tab ( tabName, icon ) =
    li
        [ onClick <| SelectTab tab
        , class
            (if cashplay.currentTab == tab then
                "active"
             else
                ""
            )
        ]
        [ labelIcon tabName icon ]

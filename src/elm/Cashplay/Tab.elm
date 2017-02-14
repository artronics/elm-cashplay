module Cashplay.Tab exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Cashplay.Message exposing (Msg(..))
import Cashplay.Model exposing (Cashplay, Tab(..))
import Elements.Icon as Icon exposing (icon)
import Customer.View as CustomerTab


tabs =
    [ ( CustomerTab, "CUSTOMERS", "user-o" )
    , ( ItemTab, "ITEMS", "laptop" )
    ]


view : Cashplay -> Html Msg
view cashplay =
    div [ class "col" ]
        [ viewTabBar cashplay
        , viewTabContent cashplay
        ]


viewTabBar : Cashplay -> Html Msg
viewTabBar cashplay =
    div [ class "w-100" ]
        [ ul [ class "art-tab d-flex justify-content-center align-items-stretch" ]
            (tabs
                |> List.map
                    (\( msgName, name, iconName ) ->
                        li
                            [ class "p-2 tab-item"
                            , onClick <| ChangeTab msgName
                            , classList [ ( "active", cashplay.currentTab == msgName ) ]
                            ]
                            [ div [ class "d-inline-flex justify-content-center align-items-center" ]
                                [ viewText name iconName ]
                            ]
                    )
            )
        ]


viewText : String -> String -> Html Msg
viewText txt icn =
    p [ class "tab-text" ] [ icon [] icn, text txt ]


viewTabContent : Cashplay -> Html Msg
viewTabContent cashplay =
    case cashplay.currentTab of
        CustomerTab ->
            div [ class "w-100" ] [ Html.map CustomerTabMsg <| CustomerTab.view cashplay.customerTab ]

        ItemTab ->
            div [] [ text "item tab" ]

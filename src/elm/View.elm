module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Messages exposing (Msg(..))
import Shared.Login as Login
import Routing exposing (..)
import Cashplay.View as Cashplay
import Elements.Button as Btn exposing (btn)
import Elements.Icon as Icn exposing (icon)


view : Model -> Html Msg
view model =
    div []
        [ viewNavBar model
        , case model.route of
            Home ->
                div [] [ text "home page" ]

            Login ->
                Html.map LoginMsg <| Login.view model.login

            App ->
                Html.map CashplayMsg <| Cashplay.view model.cashplay

            NotFound ->
                div [] [ text "Not Found" ]
        ]


viewNavBar : Model -> Html Msg
viewNavBar model =
    div [ class "navbar navbar-light navbar-toggleable-md bg-faded" ]
        [ h1 [ class "navbar-brand md-0" ] [ text "Cashplay" ]
        , div [ class "collapse navbar-collapse" ]
            [ ul [ class "navbar-nav mr-auto" ] [ li [ class "nav-item" ] [ a [ class "nav-link" ] [ text "" ] ] ]
            , div [ class "my-2 my-lg-0" ]
                (viewLogLinks model)
            ]
        ]


viewLogLinks : Model -> List (Html Msg)
viewLogLinks model =
    if model.loggedIn then
        [ div [ style [ ( "cursor", "pointer" ) ], onClick Logout ] [ icon [] "sign-out", text " Logout" ]
        ]
    else
        [ a [ href "#login", style [ ( "cursor", "pointer" ) ] ] [ icon [] "sign-in", text " Signin" ]
        ]

module Views.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Views.Elements.Label exposing (labelIcon)


type Info
    = None
    | Loading
    | Success String


type alias Icon =
    String


type alias Title =
    String


type alias Crumb a =
    ( Icon, Title, a )


type alias Action m =
    Int -> Maybe m


type alias Bread a =
    List (Crumb a)


view : Bread a -> (a -> msg) -> a -> Info -> Html msg
view bread msg currentActive info =
    div [ class "art-breadcrumb-container" ]
        [ ul [ class "art-breadcrumb" ]
            ([ viewInfo info ]
                |> List.append
                    (viewCrumb bread msg currentActive)
            )
        ]


viewCrumb : List (Crumb a) -> (a -> msg) -> a -> List (Html msg)
viewCrumb crumbs msg currentActive =
    (crumbs
        |> List.map
            (\( icon, title, view ) ->
                li
                    [ class
                        (if view == currentActive then
                            "active"
                         else
                            ""
                        )
                    ]
                    [ span [ onClick <| msg view ]
                        [ p []
                            [ i [ class <| "fa fa-" ++ icon ] []
                            , text title
                            ]
                        ]
                    ]
            )
    )


viewInfo : Info -> Html m
viewInfo info =
    case info of
        None ->
            span [ class "hidden" ] []

        Loading ->
            span [ class "art-breadcrumb-info loading" ]
                [ i [ class "fa fa-spinner fa-pulse fa-2x fa-fw" ] []
                ]

        Success str ->
            span [ class "art-breadcrumb-info success" ]
                [ i [ class "fa fa-2x fa-fw fa-check" ] [], h5 [] [ text str ] ]

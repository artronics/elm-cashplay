module Views.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material.Icon as Icon
import Material.Options exposing (styled)
import Material.Typography as Typo
import Material.Spinner as Loading


type Info
    = None
    | Loading
    | Success String


type alias Icon =
    String


type alias Title =
    String


type alias Crumb =
    ( Icon, Title )


type alias Action m =
    Int -> Maybe m


type alias Bread =
    List Crumb


view : Bread -> (Int -> m) -> Int -> Info -> Html m
view bread msg currentActive info =
    div [ class "art-breadcrumb-container" ]
        [ ul [ class "art-breadcrumb" ]
            ([ viewInfo info ]
                |> List.append
                    (viewCrumb bread msg currentActive)
            )
        ]


viewCrumb : List Crumb -> (Int -> m) -> Int -> List (Html m)
viewCrumb crumbs msg currentActive =
    (crumbs
        |> List.indexedMap
            (\index ( icon, title ) ->
                li
                    [ class
                        (if index == currentActive then
                            "active"
                         else
                            ""
                        )
                    ]
                    [ span [ onClick <| msg index ]
                        [ Icon.i icon
                        , styled p [ Typo.subhead ] [ text title ]
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
            span [ class "art-breadcrumb-info loading" ] [ Loading.spinner [ Loading.active True ] ]

        Success str ->
            span [ class "art-breadcrumb-info success" ] [ Icon.i "check", styled p [ Typo.subhead ] [ text str ] ]

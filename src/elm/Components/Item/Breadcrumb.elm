module Components.Item.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


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


view : Bread -> (Int -> m) -> Int -> Html m
view bread msg currentActive =
    div []
        [ ul []
            (viewCrumb bread msg currentActive)
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
                    [ span [ onClick <| msg index ] [ text title ] ]
            )
    )

module Views.TableView exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Dict exposing (..)


type alias Icon =
    String


type alias ViewAction m =
    ( Icon, m )


render :
    List String
    -> Dict comparable a
    -> (a -> List (Html m))
    -> (comparable -> List (ViewAction m))
    -> (comparable -> List (Attribute m))
    -> (comparable -> Bool)
    -> Html m
render headers resDict tableData viewActions rowAtr isHover =
    table [ class "table table-hover art-search-table" ]
        [ viewTableHeaders headers
        , tbody []
            (resDict
                |> Dict.map
                    (\key item ->
                        --TODO fix this mess, repeated key as param
                        viewTableRow item tableData (viewActions key) (rowAtr key) (isHover key)
                    )
                |> Dict.values
            )
        ]


viewTableHeaders : List String -> Html m
viewTableHeaders headers =
    thead []
        [ tr []
            (headers
                |> List.map
                    (\header ->
                        td [] [ text header ]
                    )
            )
        ]


viewTableRow :
    a
    -> (a -> List (Html m))
    -> List (ViewAction m)
    -> List (Attribute m)
    -> Bool
    -> Html m
viewTableRow item tableData createActions rowAtr isHover =
    let
        tblData =
            tableData item

        actions =
            [ viewActions createActions isHover ]
    in
        tr (rowAtr)
            (tblData ++ actions)


viewActions : List (ViewAction m) -> Bool -> Html m
viewActions actions show =
    td []
        [ span
            [ class
                (if show then
                    "art-search-results-actions"
                 else
                    "hidden"
                )
            ]
            (actions
                |> List.map
                    (\( icon, msg ) ->
                        span [ onClick <| msg ] [ i [ class <| "fa fa-" ++ icon ] [] ]
                    )
            )
        ]

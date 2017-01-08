module Components.ListView exposing (..)

import Html exposing (Html, text)
import Material
import Material.Options exposing (..)
import Material.Table as Table
import Material.Icon as MdlIcon


--view : Model -> Html Msg


render headers =
    viewTable headers


type alias Id =
    Int


type alias ViewAction m =
    ( Icon, m )


type alias Icon =
    String


type alias Show =
    Bool


type alias TableData m =
    Html m



--viewTable :


viewTable : List String -> List (Html m) -> Html m
viewTable headers rows =
    Table.table [ cs "art-search-table" ]
        [ viewTableHeaders headers
        , Table.tbody []
            rows
        ]


viewTableRows : List (List (Html m)) -> List (Html m)
viewTableRows rows =
    rows
        |> List.indexedMap (\index row -> Table.tr [] row)


viewTableHeaders : List String -> Html m
viewTableHeaders headers =
    Table.thead []
        [ Table.tr []
            (headers
                |> List.map
                    (\header ->
                        Table.td [] [ text header ]
                    )
            )
        ]


viewTableBody : List (List (Html m)) -> Html m
viewTableBody rows =
    Table.tbody []
        (rows
            |> List.indexedMap (\index row -> text "foo")
        )


viewTableRow : Int -> List (Html m) -> Html m
viewTableRow index row =
    Table.tr
        [ cs ""
        ]
        row


viewActions : List (ViewAction m) -> Show -> Html m
viewActions actions show =
    Table.td []
        [ span
            [ cs
                (if show then
                    "art-search-results-actions"
                 else
                    "hidden"
                )
            ]
            (actions
                |> List.map
                    (\( icon, msg ) ->
                        span [ onClick <| msg ] [ MdlIcon.i icon ]
                    )
            )
        ]

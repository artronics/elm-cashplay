module Components.ListView exposing (..)

import Html exposing (Html, text)
import Material
import Material.Options exposing (..)
import Material.Table as Table
import Material.Icon as MdlIcon


type alias Icon =
    String


type alias ViewAction m =
    ( Icon, m )



--render :
--    List String
--    -> List a
--    -> (a -> List (Html m))
--    -> (a -> List (ViewAction m))
--    -> (Int -> List (Property c m))
--    -> Html m


render headers items tableData viewActions rowAtr isHover =
    Table.table [ cs "art-search-table" ]
        [ viewTableHeaders headers
        , Table.tbody []
            (items
                |> List.indexedMap
                    (\index item ->
                        viewTableRow item tableData viewActions (rowAtr index) (isHover index)
                    )
            )
        ]


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



--viewTableRow :
--    a
--    -> (a -> List (Html m))
--    -> (a -> List (ViewAction m))
--    -> List (Property c m)
--    -> Html m


viewTableRow item tableData createActions rowAtr isHover =
    let
        tblData =
            tableData item

        actions =
            [ viewActions (createActions item) isHover ]
    in
        Table.tr (rowAtr)
            (tblData ++ actions)


viewActions : List (ViewAction m) -> Bool -> Html m
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

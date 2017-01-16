module Views.Elements.Select exposing (..)

import Html exposing (..)
import Html.Events exposing (on, targetValue)
import Json.Decode as Json
import Html.Attributes exposing (class, selected, size)
import Dict exposing (Dict)


type Menu a
    = Dict String a


slt : Dict String a -> String -> (String -> msg) -> Html msg
slt items selectedKey lift =
    let
        onSelect =
            on "change"
                (Json.map lift targetValue)
    in
        label [ class "art-select" ]
            [ select [ onSelect, class "form-control" ]
                (items
                    |> Dict.map
                        (\k v ->
                            option
                                [ if k == selectedKey then
                                    selected True
                                  else
                                    selected False
                                ]
                                [ text k ]
                        )
                    |> Dict.values
                )
            ]

module Components.ListView exposing (..)

import Html exposing (Html, text)
import Material
import Material.Options exposing (..)
import Material.Table as Table
import Material.Icon as MdlIcon


type alias Model =
    { hoverIndex : Int
    , mdl : Material.Model
    }


init : Model
init =
    { hoverIndex = -1
    , mdl = Material.model
    }


type Msg
    = Update (Model -> Model)
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update f ->
            ( f model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    text "List view"


type alias Icon =
    String


type alias Show =
    Bool


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


type alias Action m =
    ( Icon, m )


viewActions : List (Action m) -> Show -> Html m
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
                        span [ onClick msg ] [ MdlIcon.i icon ]
                    )
            )
        ]

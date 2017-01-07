module Components.Item.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Dict as Dict exposing (..)
import Material


type alias Model =
    { activeIndex : Int
    , mdl : Material.Model
    }


init : Model
init =
    { activeIndex = 0
    , mdl = Material.model
    }


type Msg
    = Select Int
    | Mdl (Material.Msg Msg)


type alias Icon =
    String


type alias Title =
    String


type alias Crumb =
    ( Icon, Title )


type alias Action =
    String


type alias Bread =
    List ( Int, ( Crumb, Action ) )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Select index ->
            ( { model | activeIndex = index }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Bread -> Html Msg
view model bread =
    div [] [ viewBread model bread ]


viewBread : Model -> Bread -> Html Msg
viewBread model bread =
    let
        sortedBread =
            bread
                |> List.sortBy (\( i, _ ) -> i)
    in
        ul [ class "art-breadcrumb" ] <|
            (viewCrumbs model sortedBread)


viewCrumbs : Model -> List ( Int, ( Crumb, Action ) ) -> List (Html Msg)
viewCrumbs model bread =
    bread
        |> List.map
            (\( index, ( ( icon, title ), action ) ) ->
                (li
                    [ if model.activeIndex == index then
                        class "active"
                      else
                        class ""
                    ]
                    [ span [ onClick <| Select index ]
                        [ p [] [ text title ]
                        ]
                    ]
                )
            )

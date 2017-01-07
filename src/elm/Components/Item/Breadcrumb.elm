module Components.Item.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material


type alias Model =
    { activeIndex : Int
    }


init : Model
init =
    { activeIndex = 0
    }


type Msg
    = Select Int


type alias Icon =
    String


type alias Title =
    String


type alias Crumb =
    ( Icon, Title )


type alias Action m =
    Int -> Maybe m


type alias Bread =
    List ( Int, Crumb )


update : Msg -> Model -> Action m -> ( Model, Cmd Msg, Maybe m )
update msg model action =
    case msg of
        Select index ->
            let
                renderContent =
                    action index
            in
                ( { model | activeIndex = index }, Cmd.none, renderContent )


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


viewCrumbs : Model -> List ( Int, Crumb ) -> List (Html Msg)
viewCrumbs model bread =
    bread
        |> List.map
            (\( index, ( icon, title ) ) ->
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

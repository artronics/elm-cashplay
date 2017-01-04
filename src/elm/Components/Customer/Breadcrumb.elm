module Components.Customer.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

type alias Crumb = List String
type alias Bread = List Crumb

type alias Model =
    { isLoading: Bool
    , activeCrumb : Maybe Int
    }

model: Model
model =
    { isLoading = True
    , activeCrumb = Nothing
    }

type Msg
    = IsLoading Bool
    | Select (Maybe Int)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        IsLoading loading ->
            ({model | isLoading = loading}, Cmd.none)
        Select index ->
            ({model | activeCrumb = index}, Cmd.none)

onCrumbSelect: (Int -> m) -> Html.Attribute (Int -> m)
onCrumbSelect f =
    onClick f

render: Model -> (Int -> m) -> List (Html.Attribute m) -> List (Html m) -> Html m
render model onSelect atr el =
    div atr (
                (view model onSelect)
                ::el
            )

view: Model -> (Int ->m) -> Html m
view model onSelect=
    div []
        [ div [onClick(onSelect 0)][text "kir"]
        , div [onClick(onSelect 1)][text "kos"]
        ]

render_: Model -> Bread -> Html m
render_ model bread=
    div [class "art-breadcrumb-container"]
        [ ul [class "art-breadcrumb"]
            (viewBread bread)
        , p [class "is-loading"][text (toString model.isLoading)]
        ]


viewBread: Bread -> List (Html m)
viewBread bread =
    bread
        |> List.indexedMap (\index crumb -> viewCrumb index crumb)

viewCrumb: Int -> Crumb -> Html m
viewCrumb index crumb =
    li []
        [ span []
            (crumb |> List.map (\line ->
                p [][text line]
            ))
        ]




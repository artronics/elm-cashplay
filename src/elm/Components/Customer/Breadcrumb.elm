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

type alias Container c =
    { c | breadcrumb : Model }

type Msg m
    = OnSelect (Maybe Int)

update: (Msg m -> m) -> (Msg m)->(Container c) ->(Container c, Cmd m)
update lift msg container =
    let
        model =
            .breadcrumb container
        updatedModel =
            update_ lift msg model
    in
        ({container | breadcrumb = updatedModel}, Cmd.none)

update_: (Msg m -> m) -> (Msg m) -> Model -> Model
update_ lift msg model =
    case msg of
        OnSelect index ->
            {model | activeCrumb = index}


selectedCrumb: Maybe Int -> Int -> Html.Attribute m
selectedCrumb i j=
    case i of
        Nothing -> class("")
        Just index ->
            if index==j then class("active") else class ("")

render:  Model -> Bread -> (Int -> m) -> (Int -> Html.Attribute m) -> List (Html.Attribute m) -> List (Html m) -> Html m
render model bread onSelect activeClass atr el =
    (div atr (
                (view model bread onSelect activeClass)
                ::el
            )
    )


view: Model -> Bread -> (Int -> m) -> (Int -> Html.Attribute m) -> Html m
view model bread onSelect activeClass=
    div [class "art-breadcrumb-container"]
        [ ul [class "art-breadcrumb"]
            (viewBread bread onSelect activeClass)
        , p [class "is-loading"][text (toString model.isLoading)]
        ]


viewBread: Bread -> (Int -> m) -> (Int -> Html.Attribute m) -> List (Html m)
viewBread bread onSelect activeClass=
    bread
        |> List.indexedMap (\index crumb -> viewCrumb index crumb onSelect activeClass)

viewCrumb: Int -> Crumb -> (Int -> m) -> (Int -> Html.Attribute m) -> Html m
viewCrumb index crumb onSelect activeClass=
    li [activeClass index]
        [ span [onClick(onSelect index) ]
            (crumb |> List.map (\line ->
                p [][text line]
            ))
        ]




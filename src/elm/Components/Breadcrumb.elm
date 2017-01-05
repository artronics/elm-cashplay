module Components.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material.Options exposing (styled)
import Material.Icon as Icon
import Material.Typography as Typo

type alias Crumb = (Int,List String)
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

render:  Model -> Bread -> (Maybe Int -> m) -> (Int -> Html.Attribute m) -> Html m
render model bread onSelect activeClass =
    div [] [view model bread onSelect activeClass]


view: Model -> Bread -> (Maybe Int -> m) -> (Int -> Html.Attribute m) -> Html m
view model bread onSelect activeClass=
    div [class "art-breadcrumb-container"]
        [ ul [class "art-breadcrumb"]
            (viewBread bread onSelect activeClass)
        , p [class "is-loading"][text (toString model.isLoading)]
        ]


viewBread: Bread -> (Maybe Int -> m) -> (Int -> Html.Attribute m) -> List (Html m)
viewBread bread onSelect activeClass=
    bread
--        |> List.sortBy (\(i,_) -> i)
        |> List.map (\crumb -> viewCrumb crumb onSelect activeClass)

viewCrumb: (Int, List String) -> (Maybe Int -> m) -> (Int -> Html.Attribute m) -> Html m
viewCrumb crumb onSelect activeClass=
    let (index, texts) = crumb
    in
        li [activeClass index]
            [ span [onClick(onSelect (Just index)) ]
                (texts |> List.map (\line ->
                    styled p [Typo.title][text line]
                ))
            ]




module Components.Breadcrumb exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material.Options exposing (styled)
import Material.Icon as Icon
import Material.Typography as Typo
import Material.Spinner as Loading


type alias Model =
    { activeIndex : Int
    , info : Maybe Info
    }


init : Model
init =
    { activeIndex = -1
    , info = Nothing
    }

type Info
    = Loading
    | Success String

type Msg
    = Select Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Select inx ->
            { model | activeIndex = inx }


render : Model -> List ( Bool, ( List String, Html m ) ) -> ( Html Msg, Html m )
render model views =
    let
        ( _, bread ) =
            views |> List.filter (\( b, _ ) -> b) |> List.unzip

        ( crumbs_, contents_ ) =
            bread |> List.unzip

        content =
            contents_
                |> List.indexedMap
                    (\i c ->
                        if model.activeIndex == i then
                            c
                        else
                            span [ class "hidden" ] []
                    )

        crumbs =
            viewBread model crumbs_
    in
        ( div [ class "art-breadcrumb-container" ]
--            [ div []
                [ crumbs
                ]
--            ]
        , div [] content )


viewBread : Model -> List (List String) -> Html Msg
viewBread model crumbs =
    ul [ class "art-breadcrumb" ]<|
        ([ viewInfo model] |> List.append
        (crumbs
            |> List.indexedMap (\inx c -> viewCrumb model inx c)))


viewCrumb : Model -> Int -> List String -> Html Msg
viewCrumb model inx crumb =
    let
        icon =
            Icon.i <| Maybe.withDefault "" <| List.head crumb

        texts =
            Maybe.withDefault [ "" ] <| List.tail crumb
    in
        li
            [ if model.activeIndex == inx then
                class "active"
              else
                class ("")
            ]
            [ span [ onClick (Select inx) ]
                (icon
                    :: (texts
                            |> List.map
                                (\str ->
                                    styled p [ Typo.title ] [ text str ]
                                )
                       )
                )
            ]

viewInfo: Model -> Html m
viewInfo model =
    case model.info of
        Nothing -> span [class "hidden"][]
        Just Loading -> span [class "art-breadcrumb-info loading"][Loading.spinner [Loading.active True]]
        Just (Success str) -> span [class "art-breadcrumb-info success"][ Icon.i "check", styled p [Typo.subhead][text str]]

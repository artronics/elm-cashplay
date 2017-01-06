module Components.SearchBar exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick,onInput)
import Html.Attributes exposing (class)
import Dict exposing (..)
import Material
--import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Menu as MdlMenu exposing (..)
import Regex

import Resources.Customer as ResCus

type alias Model =
    { searchValue : String
    , selectedKey : MenuItem
        --as soon as user select menu we disable auto detection
        --we enable it if input value is ""
    , autoDetection : Bool
    , mdl : Material.Model
    }

init : Model
init =
    { searchValue = ""
    , selectedKey = ""
    , autoDetection = True
    , mdl = Material.model
    }


type alias MenuItem = String
type alias Filter = (String -> MenuItem)
type alias Menu a= Dict MenuItem a
type alias Query = String

type Msg
    = OnSearchInput String
    | Select MenuItem
    | Search
    | Mdl (Material.Msg Msg)


type alias SearchCmd f m= (f -> Query -> Cmd m)

update : Msg -> Model-> Menu f-> Filter -> SearchCmd f m-> ( Model, Cmd m )
update msg model menu filter performSearch=
    case msg of
        OnSearchInput value ->
            let
                menuItem = filter value
            in
                ({model | searchValue = value, selectedKey = menuItem}, Cmd.none)

        Select key ->
            ({model | selectedKey = key}, Cmd.none)

        Search ->
            let
                cmd =
                    menu
                        |> Dict.get model.selectedKey
                        |> Maybe.map (\f -> performSearch f model.searchValue)
                        |> Maybe.withDefault Cmd.none
            in
                (model, cmd)

        Mdl msg_ ->
            let
                (m,_) =
                    Material.update Mdl msg_ model
            in
                (m,Cmd.none)


view : Model -> Menu a-> Html Msg
view model menu=
    div []
        [ viewInput model
        , viewSelectedKey <| model.selectedKey
        , viewMenuItems <| Dict.keys menu
        , button[onClick Search][text "search"]
        , text <| toString model
        ]

viewSelectedKey: String -> Html Msg
viewSelectedKey str =
    p[][text str]

viewInput: Model -> Html Msg
viewInput model =
    input [onInput OnSearchInput][]

viewMenuItems: List MenuItem -> Html Msg
viewMenuItems items =
    div []
         (items
            |> List.map (\item -> p[onClick <| Select item][text item])
         )

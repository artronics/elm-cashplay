module Components.SearchBar exposing (..)

import Html exposing (Html,text,p)
import Dict exposing (..)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Menu as MdlMenu exposing (..)
import Material.Icon as Icon
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

init : MenuItem -> Model
init initMenuItem =
    { searchValue = ""
    , selectedKey = initMenuItem
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

update :  Msg -> Model-> Menu f-> Filter -> SearchCmd f m-> ( Model,Cmd Msg, Cmd m )
update msg model menu filter performSearch=
    case msg of
        OnSearchInput value ->
            let
                autoDetection = if value == "" then True else model.autoDetection
                menuItem = if model.autoDetection == True then filter value else model.selectedKey
            in
                ({model | searchValue = value, selectedKey = menuItem, autoDetection = autoDetection}, Cmd.none, Cmd.none)

        Select key ->
            --Here we also disable auto detection because user click on select menu
            ({model | selectedKey = key, autoDetection = False}, Cmd.none,Cmd.none)

        Search ->
            let
                cmd =
                    menu
                        |> Dict.get model.selectedKey
                        |> Maybe.map (\f -> performSearch f model.searchValue)
                        |> Maybe.withDefault Cmd.none
            in
                (model, Cmd.none,cmd)

        Mdl msg_ ->
            let
                (m,c) =
                    Material.update Mdl msg_ model
            in
                (m,c,Cmd.none)


view : Model -> Menu a-> Html Msg
view model menu=
    div [ cs "art-search-bar" ]
        [ viewInput model
        , p [] [ text "In:" ]
        , viewMenu model  (Dict.keys menu)
        , viewSearchButton model
        ]

viewInput: Model -> Html Msg
viewInput model =
    Textfield.render Mdl
                [ 0 ]
                model.mdl
                [ Textfield.label "Search Customers", Textfield.floatingLabel, Textfield.text_, onInput OnSearchInput ]
                []
viewSearchButton:Model -> Html Msg
viewSearchButton model=
         Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.ripple
            , Button.raised
              --disable button if query is Nothing
            , if model.searchValue == "" then Button.disabled else Button.primary
            , onClick Search
            ]
            [ Icon.i "search", text "Search" ]

viewMenu: Model -> List MenuItem -> Html Msg
viewMenu model items=
    div [ cs "art-customer-search-in" ]
        [ span [] [ text model.selectedKey ]
        , MdlMenu.render Mdl
            [ 1 ]
            model.mdl
            [ MdlMenu.ripple, MdlMenu.bottomLeft, css "display" "inline" ]
            (viewMenuItems items)
        ]
viewMenuItems: List MenuItem -> List (Item Msg)
viewMenuItems items =
         (items
            |> List.map
                (\item ->
                    MdlMenu.Item
                        [ onSelect <|Select item ]
                        [ text item ]
                )
         )

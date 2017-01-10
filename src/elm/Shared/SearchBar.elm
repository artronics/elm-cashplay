module Shared.SearchBar exposing (SearchBar, initSearchBar, Msg, update, view)

import Html exposing (Html, text, p)
import Dict exposing (..)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Menu as MdlMenu exposing (..)
import Material.Icon as Icon
import Regex
import Resources.Customer as ResCus
import Views.Select as Select


type alias SearchBar =
    { searchValue : String
    , selectedKey :
        MenuItem
        --as soon as user select menu we disable auto detection
        --we enable it if input value is ""
    , autoDetection : Bool
    , mdl : Material.Model
    }


initSearchBar : SearchBar
initSearchBar =
    { searchValue = ""
    , selectedKey = "Customer's Name"
    , autoDetection = True
    , mdl = Material.model
    }


type alias MenuItem =
    String


type alias Filter =
    String -> MenuItem


type alias Menu a =
    Dict MenuItem a


type Msg
    = OnSearchInput String
    | Select MenuItem
    | Search
    | Mdl (Material.Msg Msg)


type alias SearchCmd f m =
    f -> String -> Cmd m


update : Msg -> SearchBar -> Filter -> ( SearchBar, Cmd Msg, Maybe String )
update msg model filter =
    case msg of
        OnSearchInput value ->
            let
                autoDetection =
                    if value == "" then
                        True
                    else
                        model.autoDetection

                menuItem =
                    if model.autoDetection == True then
                        filter value
                    else
                        model.selectedKey
            in
                ( { model | searchValue = value, selectedKey = menuItem, autoDetection = autoDetection }, Cmd.none, Nothing )

        Select key ->
            --Here we also disable auto detection because user click on select menu
            ( { model | selectedKey = key, autoDetection = False }, Cmd.none, Nothing )

        Search ->
            --            let
            --                cmd =
            --                    menu
            --                        |> Dict.get model.selectedKey
            --                        |> Maybe.map (\f -> performSearch f model.searchValue)
            --                        |> Maybe.withDefault Cmd.none
            --            in
            ( model, Cmd.none, Just model.searchValue )

        Mdl msg_ ->
            let
                ( m, c ) =
                    Material.update Mdl msg_ model
            in
                ( m, c, Nothing )


view : SearchBar -> Menu a -> Html Msg
view model menu =
    div [ cs "art-search-bar" ]
        [ viewInput model
        , p [] [ text "In:" ]
        , viewMenu model (Dict.keys menu)
        , viewSearchButton model
        ]


viewInput : SearchBar -> Html Msg
viewInput model =
    Textfield.render Mdl
        [ 0 ]
        model.mdl
        [ Textfield.label "Search Customers", Textfield.floatingLabel, Textfield.text_, onInput OnSearchInput ]
        []


viewSearchButton : SearchBar -> Html Msg
viewSearchButton model =
    Button.render Mdl
        [ 2 ]
        model.mdl
        [ Button.ripple
        , Button.raised
          --disable button if query is Nothing
        , if model.searchValue == "" then
            Button.disabled
          else
            Button.primary
        , onClick Search
        ]
        [ Icon.i "search", text "Search" ]


viewMenu : SearchBar -> List MenuItem -> Html Msg
viewMenu model items =
    Select.select Mdl [ 1 ] model.mdl items Select model.selectedKey

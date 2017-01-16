module Shared.SearchBar exposing (SearchBar, initSearchBar, Msg, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (..)
import Html.Events exposing (..)
import Regex
import Views.Select as Select
import Views.Elements.Textfield exposing (txt)
import Views.Elements.Button as Btn exposing (btn)
import Views.Elements.Label exposing (labelIcon)
import Views.Elements.Select exposing (slt)


type alias SearchBar =
    { searchValue : String
    , selectedKey :
        MenuItem
        --as soon as user select menu we disable auto detection
        --we enable it if input value is ""
    , autoDetection : Bool
    }


initSearchBar : SearchBar
initSearchBar =
    { searchValue = ""
    , selectedKey = "Customer's Name"
    , autoDetection = True
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


type alias SearchCmd f m =
    f -> String -> Cmd m


type alias Query a =
    { value : String
    , field : a
    }


update : Msg -> SearchBar -> Filter -> Menu a -> ( SearchBar, Cmd Msg, Maybe (Query a) )
update msg model filter menu =
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
            let
                query =
                    if model.searchValue == "" then
                        Nothing
                    else
                        menu
                            |> Dict.get model.selectedKey
                            |> Maybe.map (\f -> { value = model.searchValue, field = f })
            in
                ( model, Cmd.none, query )


view : SearchBar -> Menu a -> Html Msg
view model menu =
    div [ class "art-search-bar" ]
        [ viewInput model
        , p [] [ text "In:" ]
        , viewMenu model menu
        , viewSearchButton model
        ]


viewInput : SearchBar -> Html Msg
viewInput model =
    txt "search" [ onInput OnSearchInput ] []


viewSearchButton : SearchBar -> Html Msg
viewSearchButton model =
    btn
        [ Btn.primary
        , onClick Search
        , if model.searchValue == "" then
            disabled True
          else
            disabled False
        ]
        [ labelIcon "Search" "search" ]


viewMenu : SearchBar -> Dict String a -> Html Msg
viewMenu model items =
    slt items model.selectedKey Select

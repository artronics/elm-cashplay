module Customer.SearchBar exposing (view, update)

import Html exposing (Html, text)
import Regex
import Dict exposing (Dict)
import Customer.Models exposing (CustomerTab)
import Customer.Customer exposing (..)
import Customer.Messages exposing (Msg(..))
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (search)
import Context exposing (Context)


type alias Query =
    String


type alias MenuItem =
    String


update : SearchBar.Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    let
        ( newSearchBar, cmd, query ) =
            SearchBar.update msg customerTab.searchBar filter menu

        -- an string which is comming from Shared.SearchBar
        searchCmd =
            query
                |> Maybe.map (\q -> search context q OnSearch)
                |> Maybe.withDefault (Cmd.none)

        batchCmd =
            Cmd.batch [ Cmd.map SearchBarMsg cmd, searchCmd ]
    in
        ( { customerTab | searchBar = newSearchBar }, batchCmd )


view : CustomerTab -> Html Msg
view customerTab =
    Html.map SearchBarMsg <| SearchBar.view customerTab.searchBar menu


filter : Query -> MenuItem
filter q =
    searchFieldDisplayName <| searchInMatch q


menu : Dict MenuItem SearchField
menu =
    Dict.fromList
        [ ( "Customer's Name", Name )
        , ( "Mobile Number", Mobile )
        , ( "Postcode", Postcode )
        ]


searchFieldDisplayName : SearchField -> MenuItem
searchFieldDisplayName field =
    case field of
        Name ->
            "Customer's Name"

        Mobile ->
            "Mobile Number"

        Postcode ->
            "Postcode"


searchInMatch : Query -> SearchField
searchInMatch str =
    if Regex.contains (Regex.regex "^\\D*$") str then
        Name
    else if Regex.contains (Regex.regex "^[a-zA-Z](?:[a-zA-Z]?[1-9]? ?[1-9]?[a-zA-Z]{0,2})") str then
        Postcode
    else if Regex.contains (Regex.regex "^07(?:[0-9]{0,9})$") str then
        Mobile
    else
        Name

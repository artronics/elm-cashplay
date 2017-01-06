module Components.Customer.SearchBar exposing (..)

import Html exposing (Html, text, p)
import Html.Attributes exposing (class)
import Http
import Dict as Dict exposing (..)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Menu as Menu exposing (..)
import Regex
import Components.SearchBar as SearchBar
import Resources.Customer as Res


type alias Model =
    { searchBar : SearchBar.Model
    , mdl : Material.Model
    }

init:Model
init =
    { searchBar = SearchBar.init "Customer's Name"
    , mdl = Material.model
    }


type alias Query = String
type alias MenuItem = String

type SearchField
    = Name
    | Postcode
    | Mobile


type Msg
    = SearchBarMsg SearchBar.Msg
    | OnFetchCustomers (Result Http.Error (List Res.Customer) )
    | Mdl (Material.Msg Msg)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchBarMsg msg_->
            let
                (updated,cmd , searchCmd) =
                    SearchBar.update msg_ model.searchBar menu filter performSearch
                batch =
                    Cmd.batch [searchCmd,Cmd.map SearchBarMsg cmd]
            in
                ({model | searchBar = updated}, batch)
        OnFetchCustomers (Ok customers) ->
            (model,Cmd.none)
        OnFetchCustomers _ ->
            (model,Cmd.none)
        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
    div[]
        [ Html.map SearchBarMsg <| SearchBar.view model.searchBar menu
        ]


performSearch: SearchField -> Query -> Cmd Msg
performSearch field q =
    case field of
        Name ->
            Res.search ("full_name=ilike.*"++ q ++"*") OnFetchCustomers
        _ ->
            Res.search "" OnFetchCustomers

filter: Query -> MenuItem
filter q =
    searchFieldDisplayName <| searchInMatch q

menu: Dict MenuItem SearchField
menu =
    Dict.fromList
        [ ("Customer's Name",Name)
        , ("Mobile Number",Mobile)
        , ("Postcode",Postcode)
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

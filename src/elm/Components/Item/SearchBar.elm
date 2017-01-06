module Components.Item.SearchBar exposing (..)
import Html exposing (Html,p,text)
import Http
import Dict as Dict exposing (..)
import Material
import Material.Options exposing (..)
import Material.Menu as Menu
import Components.SearchBar as SearchBar

import Resources.Item as Res

type alias Model =
    { searchBar : SearchBar.Model
    , mdl: Material.Model
    }

init:Model
init =
    { searchBar = SearchBar.init
    , mdl = Material.model
    }

type alias Query = String
type alias MenuItem = String
type SearchField
    = Description
    | Id

type Msg
    = SearchBarMsg SearchBar.Msg
    | OnFetchItems (Result Http.Error (List Res.Item) )
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
        OnFetchItems (Ok items) ->
            (model,Cmd.none)
        OnFetchItems _ ->
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
        Id ->
            Res.search OnFetchItems
        Description ->
            Res.search OnFetchItems

filter: Query -> MenuItem
filter q =
    searchFieldDisplayName <| searchInMatch q

menu: Dict MenuItem SearchField
menu =
    Dict.fromList [("Description",Description),("ID",Id)]

searchFieldDisplayName: SearchField -> MenuItem
searchFieldDisplayName field =
    case field of
        Description -> "Description"
        Id -> "ID"

searchInMatch: Query -> SearchField
searchInMatch q =
    case q of
        "id" -> Id
        _ -> Description

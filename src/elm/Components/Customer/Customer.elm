module Components.Customer.Customer exposing (..)

import Html exposing (Html, text, p)
import Http
import Material
import Material.Elevation as Elev
import Material.Options exposing (..)
import Material.Button as Button
import Material.Icon as Icon
import Components.MessageBox as MsgBox
import Components.Customer.SearchBar as SearchBar
import Components.Breadcrumb as Breadcrumb
import Components.Customer.SearchList as SearchList
import Components.Customer.NewCustomer as NewCustomer
import Components.Customer.ViewCustomer as ViewCustomer
import Resources.Customer as Res
import Components.Customer.SearchBar exposing (Query)

type alias Model =
    { searchBar : SearchBar.Model
    , query : Maybe SearchBar.Query
    , mdl : Material.Model
    }

init:Model
init =
    { searchBar = SearchBar.init
    , query = Nothing
    , mdl = Material.model
    }


type Msg
    = SearchBarMsg SearchBar.Msg
    | Mdl (Material.Msg Msg)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchBarMsg msg_ ->
            -- SearchBar returns a query
            updateSearchBar msg_ model
        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
    div []
        [ Html.map SearchBarMsg (SearchBar.view model.searchBar)]

updateSearchBar: SearchBar.Msg -> Model -> (Model, Cmd Msg)
updateSearchBar msg model =
    let
        (updatedSearchBar, cmd, query) =
            SearchBar.update msg model.searchBar
    in
        ({model | searchBar = updatedSearchBar, query = Just query}, Cmd.map SearchBarMsg cmd)

module Components.Customer.Header exposing (..)

import Html exposing (Html, text,select,option)
import Html.Attributes exposing (class)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Menu as Menu

import Components.Customer.SearchBar as SearchBar
import Components.Select as Select

type alias Model =
    { searchBar: SearchBar.Model
    , mdl:Material.Model
    }

init:Model
init =
    { searchBar = SearchBar.init
    , mdl = Material.model
    }

type Msg
    = SearchBarMsg SearchBar.Msg
    | Mdl (Material.Msg Msg)


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchBarMsg msg_ ->
            let
                (updatedSearchBar, cmd) =
                    SearchBar.update msg_ model.searchBar
            in
                ({model | searchBar = updatedSearchBar}, Cmd.map SearchBarMsg cmd)
        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
        div[]
            [ Html.map SearchBarMsg (SearchBar.view model.searchBar)
            ]


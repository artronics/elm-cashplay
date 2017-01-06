module Components.Item.Item exposing (..)

import Html exposing (Html,p,text)
import Http
import Dict as Dict exposing (..)
import Material
import Material.Options exposing (..)
import Components.Item.SearchBar as SearchBar

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


type Msg
    = SearchBarMsg SearchBar.Msg
    | Mdl (Material.Msg Msg)


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchBarMsg msg_->
            let
                (updated,cmd) =
                    SearchBar.update msg_ model.searchBar
            in
                ({model | searchBar = updated}, Cmd.map SearchBarMsg cmd)
        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
    div[][Html.map SearchBarMsg <| SearchBar.view model.searchBar]


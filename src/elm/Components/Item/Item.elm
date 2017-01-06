module Components.Item.Item exposing (..)

import Html exposing (Html,p,text)
import Http
import Dict as Dict exposing (..)
import Material
import Material.Icon as Icon
import Material.Button as Button
import Material.Elevation as Elev
import Material.Options exposing (..)
import Components.Item.SearchBar as SearchBar

import Material.Menu as Menu
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
    div[Elev.e0, center, cs "art-page-header"]
        [ Html.map SearchBarMsg <| SearchBar.view model.searchBar
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple
            , Button.raised
            , cs "new-button"
            ]
            [ Icon.i "add_to_queue", text "New Item" ]
        ]


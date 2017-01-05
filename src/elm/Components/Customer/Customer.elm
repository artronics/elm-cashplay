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
        [viewHeader model]

viewHeader: Model -> Html Msg
viewHeader model =
    div [ Elev.e0, center, cs "art-page-header" ]
        [ Html.map SearchBarMsg (SearchBar.view model.searchBar)
        , Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.ripple, Button.raised
            --disable button if query is Nothing
            , Maybe.withDefault Button.disabled (Maybe.map (\_ -> Button.primary) model.query)

            ]
            [ Icon.i "search", text "Search" ]
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple, Button.raised, css "margin-left" "50px"]
            [ Icon.i "person_add", text "New Customer" ]
        ]

updateSearchBar: SearchBar.Msg -> Model -> (Model, Cmd Msg)
updateSearchBar msg model =
    let
        (updatedSearchBar, cmd, query) =
            SearchBar.update msg model.searchBar
    in
        ({model | searchBar = updatedSearchBar, query = query}, Cmd.map SearchBarMsg cmd)

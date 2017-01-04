module Components.Customer.Customer exposing (..)

import Html exposing (Html, text, select, option)
import Material
import Material.Elevation as Elev
import Material.Options exposing (..)
import Material.Button as Button
import Material.Icon as Icon
import Components.Customer.SearchBar as SearchBar
import Components.Customer.Breadcrumb as Breadcrumb
import Components.Customer.SearchList as SearchList
import Components.Customer.NewCustomer as NewCustomer
import Resources.Customer as Res


type alias Model =
    { currentView : Maybe View
    , currentCrumb : Maybe Int
    , query : SearchBar.Query
    , searchBar : SearchBar.Model
    , breadcrumb : Breadcrumb.Model
    , searchList : SearchList.Model
    , newCustomer : NewCustomer.Model
    , mdl : Material.Model
    }


init : Model
init =
    { currentView = Nothing
    , currentCrumb = Nothing
    , query = { value = "", field = Res.Name }
    , breadcrumb = Breadcrumb.model
    , searchBar = SearchBar.init
    , searchList = SearchList.init
    , newCustomer = NewCustomer.init
    , mdl = Material.model
    }


type View
    = SearchList SearchBar.Query
    | NewCustomer


type Msg
    = ChangeView View
    | ChangeCrumb (Maybe Int)
    | BreadcrumbMsg (Breadcrumb.Msg Msg)
    | SearchBarMsg SearchBar.Msg
    | SearchListMsg SearchList.Msg
    | NewCustomerMsg NewCustomer.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeView (SearchList query) ->
            let
                ( updatedSearchList, cmd ) =
                    SearchList.search query model.searchList
            in
                ( { model | currentView = Just (SearchList query), searchList = updatedSearchList }, Cmd.map SearchListMsg cmd )

        ChangeView NewCustomer ->
            ( { model | currentView = Just NewCustomer }, Cmd.none )

        ChangeCrumb index ->
            ({model | currentCrumb = index}, Cmd.none)
        BreadcrumbMsg msg_ ->
            Breadcrumb.update BreadcrumbMsg msg_ model
--            let
--                (updatedBread, cmd) =
--                    Breadcrumb.update msg_ model.breadcrumb
--            in
--                ({model | breadcrumb = updatedBread}, Cmd.map BreadcrumbMsg cmd)

        SearchBarMsg msg_ ->
            -- query is what we get from SearchBar
            let
                ( updatedSearchBar, cmd, query ) =
                    SearchBar.update msg_ model.searchBar
            in
                ( { model | searchBar = updatedSearchBar, query = query }, Cmd.map SearchBarMsg cmd )

        SearchListMsg msg_ ->
            let
                ( updatedSearchList, cmd ) =
                    SearchList.update msg_ model.searchList
            in
                ( { model | searchList = updatedSearchList }, Cmd.map SearchListMsg cmd )

        NewCustomerMsg msg_ ->
            let
                ( updatedNewCustomer, cmd ) =
                    NewCustomer.update msg_ model.newCustomer
            in
                ( { model | newCustomer = updatedNewCustomer }, Cmd.map NewCustomerMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , Breadcrumb.render
            model.breadcrumb
            [["foo","bar"],["baz"]]
            ChangeCrumb
            (Breadcrumb.selectedCrumb model.currentCrumb)
            [][text "loo"]
        , div [ Elev.e0,center  ]
            [ viewContent model]
        ]

viewHeader model =
    div [ Elev.e0, center, cs "art-page-header" ]
        [ Html.map SearchBarMsg (SearchBar.view model.searchBar)
        , Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.ripple, Button.raised, Button.primary, onClick (ChangeView (SearchList model.query)) ]
            [ Icon.i "search", text "Search" ]
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple, Button.raised, css "margin-left" "50px", onClick (ChangeView NewCustomer) ]
            [ Icon.i "person_add", text "New Customer" ]
        ]

viewContent model =
    case model.currentView of
        Nothing ->
            div [] [ text "no view selected" ]

        Just view ->
            case view of
                SearchList _->
                    Html.map SearchListMsg (SearchList.view model.searchList)

                NewCustomer ->
                    Html.map NewCustomerMsg (NewCustomer.view model.newCustomer)
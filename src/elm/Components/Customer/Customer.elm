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
    { currentView : Maybe View
    , currentCrumb : Maybe Int
    , query : SearchBar.Query
    , customers : Maybe (List Res.Customer)
    , selectedCustomerForDetails : Maybe Res.Customer
    , searchBar : SearchBar.Model
    , breadcrumb : Breadcrumb.Model
    , searchList : SearchList.Model
    , newCustomer : NewCustomer.Model
    , viewCustomer : ViewCustomer.Model
    , mdl : Material.Model
    }


init : Model
init =
    { currentView = Nothing
    , currentCrumb = Nothing
    , query = { value = "", field = Res.Name }
    , customers = Nothing
    , selectedCustomerForDetails = Nothing
    , breadcrumb = Breadcrumb.model
    , searchBar = SearchBar.init
    , searchList = SearchList.init
    , newCustomer = NewCustomer.init
    , viewCustomer = ViewCustomer.init
    , mdl = Material.model
    }


type View
    = SearchList
    | NewCustomer
    | NetErr Http.Error


type Msg
    = ChangeView View
    | OnFetchCustomers (Result Http.Error (List Res.Customer))
    | ChangeCrumb (Maybe Int)
    | BreadcrumbMsg (Breadcrumb.Msg Msg)
    | SearchBarMsg SearchBar.Msg
    | SearchListMsg SearchList.Msg
    | NewCustomerMsg NewCustomer.Msg
    | ViewCustomerMsg ViewCustomer.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchCustomers (Ok fetchedCustomers) ->
            createSearchList model fetchedCustomers

        OnFetchCustomers (Err err) ->
            ( { model | currentView = Just <| NetErr err }, Cmd.none )

        ChangeView SearchList ->
            -- Only when user click on search button we fire api
            ( { model
                | currentView = Just SearchList
              }
              , fetchCustomers model.query
            )

        ChangeView NewCustomer ->
            ( { model | currentView = Just NewCustomer }, Cmd.none )

        --views like NetErr goes here we don't add any logic for errors just a msg to user
        ChangeView _ ->
            ( model, Cmd.none )

        ChangeCrumb index ->
            ( { model | currentCrumb = index }, Cmd.none )

        BreadcrumbMsg msg_ ->
            Breadcrumb.update BreadcrumbMsg msg_ model

        SearchBarMsg msg_ ->
            -- query is what we get from SearchBar
            let
                ( updatedSearchBar, cmd, query ) =
                    SearchBar.update msg_ model.searchBar
            in
                ( { model | searchBar = updatedSearchBar, query = query }, Cmd.map SearchBarMsg cmd )

        --When user click at actions on SearchList, SearchList dispatch a msg which
        --we match here in order to update ViewCustomer
        SearchListMsg (SearchList.Selected action) ->
            manageSelectedCustomer model action

        SearchListMsg msg_ ->
            let
                updatedSearchList =
                    SearchList.update msg_ model.searchList
            in
                ( { model | searchList = updatedSearchList }, Cmd.none )

        NewCustomerMsg msg_ ->
            let
                ( updatedNewCustomer, cmd ) =
                    NewCustomer.update msg_ model.newCustomer
            in
                ( { model | newCustomer = updatedNewCustomer }, Cmd.map NewCustomerMsg cmd )

        ViewCustomerMsg msg_ ->
            let
                updatedViewCustomer =
                    ViewCustomer.update msg_ model.viewCustomer
            in
                ( { model | viewCustomer = updatedViewCustomer }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

manageSelectedCustomer: Model -> SearchList.SelectionAction -> (Model, Cmd Msg)
manageSelectedCustomer model action =
            let
                updatedSearchList =
                    SearchList.update (SearchList.Selected action) model.searchList
            in
                case action of
                    SearchList.Details customer ->
                        let
                            updatedViewCus =
                                ViewCustomer.update (ViewCustomer.UpdateCustomer (Just customer)) model.viewCustomer
                        in
                            ( { model
                                | viewCustomer = updatedViewCus
                                , searchList = updatedSearchList
                                , selectedCustomerForDetails = Just customer
                                , currentCrumb = Just 1
                              }
                            , Cmd.none
                            )


createSearchList: Model -> List Res.Customer -> (Model, Cmd Msg)
createSearchList model customers=
    let
        searchList =
            model.searchList

        updatedSL =
            { searchList | customers = customers }
    in
        ( { model
            | customers = Just customers
            , searchList = updatedSL
            , currentCrumb = Just 0
            , selectedCustomerForDetails = Nothing
          }
        , Cmd.none
        )


fetchCustomers : Query -> Cmd Msg
fetchCustomers query =
    Res.search query OnFetchCustomers


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , viewBreadcrumb model
        , Html.map ViewCustomerMsg (ViewCustomer.view model.viewCustomer)
        , div [ Elev.e0, center ]
            [ viewContent model ]
        ]

type BreadView
    = SearchResult
    | CustomerDetails

createCrumb: Model -> BreadView -> Breadcrumb.Crumb
createCrumb model view =
    case view of
        SearchResult ->
            (0, ["Search Results"])
        CustomerDetails ->
            (1, [Maybe.withDefault "OOpss" (Maybe.map .firstName model.selectedCustomerForDetails)])

createBread: Model -> BreadView -> Breadcrumb.Bread
createBread model view =
    case view of
        SearchResult ->
            [createCrumb model SearchResult]
        CustomerDetails ->
            [createCrumb model SearchResult, createCrumb model CustomerDetails]
viewBreadcrumb : Model -> Html Msg
viewBreadcrumb model =
    case model.currentView of
        Just SearchList ->
            case model.currentCrumb of
                Just 0 ->
                    viewBreadcrumb_ model (createBread model SearchResult)
                Just 1 ->
                    viewBreadcrumb_ model (createBread model CustomerDetails)
                _ ->
                    span [][]

        Just NewCustomer ->
            p [] [ text "new customer" ]

        _ ->
            span [] []
viewBreadcrumb_ : Model -> Breadcrumb.Bread -> Html Msg
viewBreadcrumb_ model bread =
    Breadcrumb.render model.breadcrumb bread ChangeCrumb (Breadcrumb.selectedCrumb model.currentCrumb)

viewHeader model =
    div [ Elev.e0, center, cs "art-page-header" ]
        [ Html.map SearchBarMsg (SearchBar.view model.searchBar)
        , Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.ripple, Button.raised, Button.primary, onClick (ChangeView SearchList) ]
            [ Icon.i "search", text "Search" ]
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple, Button.raised, css "margin-left" "50px", onClick (ChangeView NewCustomer) ]
            [ Icon.i "person_add", text "New Customer" ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    case model.currentView of
        Nothing ->
            div [] [ text "no view selected" ]

        Just view ->
            case view of
                SearchList ->
                    case model.currentCrumb of
                        Just 0 ->
                            Html.map SearchListMsg (SearchList.view model.searchList)
                        Just 1 ->
                            Html.map ViewCustomerMsg (ViewCustomer.view model.viewCustomer)
                        _ -> span [][]

                NewCustomer ->
                    Html.map NewCustomerMsg (NewCustomer.view model.newCustomer)

                NetErr err ->
                    MsgBox.view <| toString err


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
import Components.Customer.CustomerList as CustomerList
import Components.Customer.NewCustomer as NewCustomer
import Components.Customer.CustomerView as CustomerView
import Resources.Customer as Res
import Components.Customer.SearchBar exposing (Query)

type alias Model =
    { searchBar : SearchBar.Model
    , query : Maybe SearchBar.Query
    , customerList : CustomerList.Model
    , customerView : CustomerView.Model
    , selectedCustomerForDetails : Maybe Res.Customer
    , mdl : Material.Model
    }

init:Model
init =
    { searchBar = SearchBar.init
    , query = Nothing
    , customerList = CustomerList.init
    , customerView = CustomerView.init
    , selectedCustomerForDetails = Nothing
    , mdl = Material.model
    }

type Msg
    = SearchBarMsg SearchBar.Msg
    | PerformSearch
    | OnFetchCustomers (Result Http.Error (List Res.Customer))
    | CustomerListMsg CustomerList.Msg
    | CustomerViewMsg CustomerView.Msg
    | Mdl (Material.Msg Msg)


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        PerformSearch ->
            (model, fetchCustomers model.query)
        OnFetchCustomers (Ok customers) ->
            let customerList = model.customerList
            in
                ({model | customerList = {customerList | customers = Just customers}}, Cmd.none)
        OnFetchCustomers (Err err) ->
            let customerList = model.customerList
            in
                (resetModelView model, Cmd.none)
        SearchBarMsg msg_ ->
            -- SearchBar returns a query
            updateSearchBar msg_ model
        CustomerListMsg msg_ ->
            updateCustomerList msg_ model
        CustomerViewMsg msg_ ->
            updateCustomerView msg_ model
        Mdl msg_ ->
            Material.update Mdl msg_ model

resetModelView: Model -> Model
resetModelView model =
    let
        customerList = model.customerList
        customerView = model.customerView
    in
        { model
          | customerList = {customerList | customers = Nothing}
          , customerView = {customerView | customer = Nothing}
        }

fetchCustomers : Maybe Query -> Cmd Msg
fetchCustomers query =
    query
        |> Maybe.map (\q -> Res.search q OnFetchCustomers )
        |> Maybe.withDefault Cmd.none

--show ViewCustomers if model.customers js Just X
viewCustomers: Model -> Maybe (Html Msg)
viewCustomers model =
    Maybe.map (\_ -> Html.map CustomerListMsg <| CustomerList.view model.customerList) model.customerList.customers

viewCustomerDetails: Model -> Maybe (Html Msg)
viewCustomerDetails model =
    Maybe.map (\_ -> Html.map CustomerViewMsg <| CustomerView.view model.customerView) model.customerView.customer

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
            , onClick PerformSearch
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

updateCustomerList: CustomerList.Msg -> Model -> (Model, Cmd Msg)
updateCustomerList msg model =
    let
        updatedList =
            CustomerList.update msg model.customerList
    in
        case msg of
            CustomerList.Selected (CustomerList.Details customer) ->
                ({model | customerList = updatedList, selectedCustomerForDetails = customer}, Cmd.none)
            _ ->
                ({model | customerList = updatedList}, Cmd.none)

updateCustomerView : CustomerView.Msg -> Model -> (Model, Cmd Msg)
updateCustomerView msg model =
    let
        updated =
            CustomerView.update msg model.customerView
    in
        ({model | customerView = updated},Cmd.none)

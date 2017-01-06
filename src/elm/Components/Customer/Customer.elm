module Components.Customer.Customer exposing (..)

import Html exposing (Html, text, p)
import Http
import Material
import Material.Elevation as Elev
import Material.Options exposing (..)
import Material.Button as Button
import Material.Icon as Icon
import Helpers exposing (maybeToBool)
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
    , breadcrumb : Breadcrumb.Model
    , customerList : CustomerList.Model
    , newCustomer : NewCustomer.Model
    , customerView : CustomerView.Model
    , mdl : Material.Model
    }


init : Model
init =
    { searchBar = SearchBar.init
    , query = Nothing
    , breadcrumb = Breadcrumb.init
    , customerList = CustomerList.init
    , newCustomer = NewCustomer.init
    , customerView = CustomerView.init
    , mdl = Material.model
    }


type Msg
    = SearchBarMsg SearchBar.Msg
    | PerformSearch
    | NewCustomer
    | OnFetchCustomers (Result Http.Error (List Res.Customer))
    | BreadcrumbMsg Breadcrumb.Msg
    | CustomerListMsg CustomerList.Msg
    | NewCustomerMsg NewCustomer.Msg
    | CustomerViewMsg CustomerView.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PerformSearch ->
            let
                initModel =
                    resetModelView model
                breadcrumb = initModel.breadcrumb
            in
                ( {initModel | breadcrumb = {breadcrumb| info = Just <| Breadcrumb.Loading}}, fetchCustomers model.query )

        OnFetchCustomers (Ok customers) ->
            let
                initModel =
                    resetModelView model

                customerList =
                    initModel.customerList

                breadcrumb =
                    initModel.breadcrumb
            in
                ( { initModel
                    | customerList = { customerList | customers = Just customers }
                    , breadcrumb = { breadcrumb | activeIndex = 0 }
                  }
                , Cmd.none
                )

        OnFetchCustomers (Err err) ->
            let
                resetModel =
                    resetModelView model
            in
                ( resetModel, Cmd.none )

        NewCustomer ->
            let
                resetModel =
                    resetModelView model

                breadcrumb =
                    resetModel.breadcrumb

                newCustomer =
                    resetModel.newCustomer
            in
                ( { resetModel
                    | newCustomer = { newCustomer | customer = Just Res.empty }
                    , breadcrumb = { breadcrumb | activeIndex = 0, info = Just <|Breadcrumb.Success "Customer Saved" }
                  }
                , Cmd.none
                )

        BreadcrumbMsg msg_ ->
            let
                updated =
                    Breadcrumb.update msg_ model.breadcrumb
            in
                ( { model | breadcrumb = updated }, Cmd.none )

        SearchBarMsg msg_ ->
            -- SearchBar returns a query
            updateSearchBar msg_ model

        CustomerListMsg msg_ ->
            updateCustomerList msg_ model

        NewCustomerMsg msg_ ->
            updateNewCustomer msg_ model

        CustomerViewMsg msg_ ->
            updateCustomerView msg_ model

        Mdl msg_ ->
            Material.update Mdl msg_ model


resetModelView : Model -> Model
resetModelView model =
    let
        customerList =
            CustomerList.init

        newCustomer =
            NewCustomer.init

        breadcrumb =
            Breadcrumb.init

        customerView =
            CustomerView.init
    in
        { model
            | customerList = customerList
            , newCustomer = newCustomer
            , customerView = customerView
            , breadcrumb = breadcrumb
        }


fetchCustomers : Maybe Query -> Cmd Msg
fetchCustomers query =
    query
        |> Maybe.map (\q -> Res.search q OnFetchCustomers)
        |> Maybe.withDefault Cmd.none


viewBreadCrumbInfo: Model -> ( Bool, ( List String, Html Msg ) )
viewBreadCrumbInfo model =
    ( maybeToBool model.breadcrumb.info
    , ( [ ]
      , span [cs "hidden"][] --we just want to see breadcrumb bar with info. there is no content
      )
    )


--show ViewCustomers if model.customers js Just X


viewCustomers : Model -> ( Bool, ( List String, Html Msg ) )
viewCustomers model =
    ( maybeToBool model.customerList.customers
    , ( [ "search", "Search Results" ]
      , Html.map CustomerListMsg <| CustomerList.view model.customerList
      )
    )


viewCustomerDetails : Model -> ( Bool, ( List String, Html Msg ) )
viewCustomerDetails model =
    let
        -- Nothing should never happen but if it happens then fullName will be "Customer Details"
        firstName =
            model.customerView.customer |> Maybe.map .firstName |> Maybe.withDefault "Customer"

        lastName =
            model.customerView.customer |> Maybe.map .lastName |> Maybe.withDefault "Details"

        fullName =
            firstName ++ " " ++ lastName
    in
        ( maybeToBool model.customerView.customer
        , ( [ "person", fullName ]
          , Html.map CustomerViewMsg <| CustomerView.view model.customerView
          )
        )


viewNewCustomer : Model -> ( Bool, ( List String, Html Msg ) )
viewNewCustomer model =
    let
        -- Nothing should never happen but if it happens then fullName will be "Customer Details"
        firstName =
            model.newCustomer.customer |> Maybe.map .firstName |> Maybe.withDefault "Customer"

        lastName =
            model.newCustomer.customer |> Maybe.map .lastName |> Maybe.withDefault "Details"

        fullName =
            if firstName == "" && lastName == "" then
                "New Customer"
            else
                firstName ++ " " ++ lastName
    in
        ( maybeToBool model.newCustomer.customer
        , ( [ "person_add", fullName ]
          , Html.map NewCustomerMsg <| NewCustomer.view model.newCustomer
          )
        )


view : Model -> Html Msg
view model =
    let
        ( bread_, breadContent ) =
            Breadcrumb.render model.breadcrumb
                [ viewBreadCrumbInfo model
                , viewCustomers model
                , viewCustomerDetails model
                , viewNewCustomer model
                ]

        bread =
            Html.map BreadcrumbMsg bread_
    in
        div []
            [ viewHeader model
            , bread
            , breadContent
            ]


viewHeader : Model -> Html Msg
viewHeader model =
    div [ Elev.e0, center, cs "art-page-header" ]
        [ Html.map SearchBarMsg (SearchBar.view model.searchBar)
        , Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.ripple
            , Button.raised
              --disable button if query is Nothing
            , Maybe.withDefault Button.disabled (Maybe.map (\_ -> Button.primary) model.query)
            , onClick PerformSearch
            ]
            [ Icon.i "search", text "Search" ]
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple
            , Button.raised
            , css "margin-left" "50px"
            , onClick NewCustomer
            ]
            [ Icon.i "person_add", text "New Customer" ]
        ]


updateSearchBar : SearchBar.Msg -> Model -> ( Model, Cmd Msg )
updateSearchBar msg model =
    let
        ( updatedSearchBar, cmd, query ) =
            SearchBar.update msg model.searchBar
    in
        ( { model | searchBar = updatedSearchBar, query = query }, Cmd.map SearchBarMsg cmd )


updateCustomerList : CustomerList.Msg -> Model -> ( Model, Cmd Msg )
updateCustomerList msg model =
    let
        updatedList =
            CustomerList.update msg model.customerList
    in
        case msg of
            CustomerList.Selected (CustomerList.Details customer) ->
                let
                    customerView =
                        CustomerView.init

                    breadcrumb =
                        Breadcrumb.init
                in
                    ( { model
                        | customerList = updatedList
                        , customerView = { customerView | customer = customer }
                        , breadcrumb = { breadcrumb | activeIndex = 1 }
                      }
                    , Cmd.none
                    )

            _ ->
                ( { model | customerList = updatedList }, Cmd.none )


updateNewCustomer : NewCustomer.Msg -> Model -> ( Model, Cmd Msg )
updateNewCustomer msg model =
    let
        updated =
            NewCustomer.update msg model.newCustomer
    in
        ( { model | newCustomer = updated }, Cmd.none )


updateCustomerView : CustomerView.Msg -> Model -> ( Model, Cmd Msg )
updateCustomerView msg model =
    let
        updated =
            CustomerView.update msg model.customerView
    in
        ( { model | customerView = updated }, Cmd.none )

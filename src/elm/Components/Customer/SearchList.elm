module Components.Customer.SearchList exposing (..)

import Html exposing (Html, p, text)
import Http
import Material
import Material.Typography as Typo
import Material.Options exposing (..)
import Material.Card as Card
import Material.Table as Table
import Material.Button as Button
import Material.Icon as Icon
import Components.Customer.SearchBar exposing (Query)
import Resources.Customer as Res exposing (..)
import Components.Breadcrumb as Breadcrumb


type alias Model =
    { query : Query
    , loading : Bool
    , error : Maybe String
    , customers : List Customer
    , currentView : View
    , breadcrumb : Breadcrumb.Model
    , hoverInx : Int
    , mdl : Material.Model
    }


init : Model
init =
    { query = { value = "", field = Res.Name }
    , loading = False
    , error = Nothing
    , customers = []
    , currentView = Results
    , breadcrumb = Breadcrumb.init ( "", "" )
    , hoverInx = -1
    , mdl = Material.model
    }


type Msg
    = Search Query
    | OnFetchCustomers (Result Http.Error (List Customer))
    | CreateView View
    | ChangeView View
    | Update (Model -> Model)
    | BreadcrumbMsg Breadcrumb.Msg
    | Mdl (Material.Msg Msg)


type View
    = Results
    | Details


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            ( { model | query = query }, fetchCustomers query )

        OnFetchCustomers (Ok fetchedCustomers) ->
            let
                ( updatedBread, cmd ) =
                    updateBreadForResults model
            in
                ( { model
                    | customers = fetchedCustomers
                    , error = Nothing
                    , currentView = Results
                    , breadcrumb = updatedBread
                  }
                , Cmd.map BreadcrumbMsg cmd
                )

        OnFetchCustomers (Err error) ->
            ( { model | error = Just "There is a problem with network." }, Cmd.none )

        CreateView Results ->
            -- Results is created during Search
            ( model, Cmd.none )

        CreateView Details ->
            let
                ( updatedBread, cmd ) =
                    createBreadForDetails model
            in
                ( { model | currentView = Details, breadcrumb = updatedBread }, Cmd.map BreadcrumbMsg cmd )

        ChangeView Results ->
            let
                ( updatedBread, cmd ) =
                    updateBreadIndexForResults model
            in
                ( { model | currentView = Results, breadcrumb = updatedBread }, Cmd.map BreadcrumbMsg cmd )

        ChangeView Details ->
            let
                ( updatedBread, cmd ) =
                    updateBreadIndexForDetails model
            in
                ( { model | currentView = Details, breadcrumb = updatedBread }, Cmd.map BreadcrumbMsg cmd )

        Update f ->
            ( f model, Cmd.none )

        BreadcrumbMsg (Breadcrumb.Select index) ->
            let
                (view, updatedBread, cmd) =
                    updateBreadSelect model index
            in
               ({model | currentView = view, breadcrumb = updatedBread}, Cmd.map BreadcrumbMsg cmd)

        BreadcrumbMsg msg_ ->
            let
                ( updatedBread, cmd ) =
                    Breadcrumb.update msg_ model.breadcrumb
            in
                ( { model | breadcrumb = updatedBread }, Cmd.map BreadcrumbMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model


search : Query -> Model -> ( Model, Cmd Msg )
search query model =
    update (Search query) model


fetchCustomers : Query -> Cmd Msg
fetchCustomers query =
    Res.search query OnFetchCustomers


view : Model -> Html Msg
view model =
    div [cs "art-tab-content"]
        [ Html.map BreadcrumbMsg (Breadcrumb.view model.breadcrumb)
        , case model.currentView of
            Results ->
                viewTableOrError model

            Details ->
                customerDetails model
        ]


viewTableOrError model =
    case model.error of
        Nothing ->
            viewTable model

        Just err ->
            div [] [ text err ]


customerDetails model =
    div [] [ text "customer details" ]



-- Add header strings here


tableHeaders : List String
tableHeaders =
    [ "ID", "Name", "View / Add To Receipt" ]


viewTable : Model -> Html Msg
viewTable model =
    Table.table [ cs "art-search-table" ]
        [ Table.thead []
            [ Table.tr []
                (tableHeaders
                    |> List.map
                        (\header ->
                            Table.td [] [ text header ]
                        )
                )
            ]
        , Table.tbody []
            (model.customers
                |> List.indexedMap
                    (\inx customer ->
                        Table.tr
                            [ Update (\m -> { m | hoverInx = inx }) |> onMouseEnter
                            , Update (\m -> { m | hoverInx = -1 }) |> onMouseLeave
                            ]
                            [ Table.td [ Table.numeric ] [ text (toString customer.id) ]
                            , Table.td [] [ text (customer.firstName ++ " " ++ customer.lastName) ]
                              -- This cell is for showing actions buttons (view and add to receipt)
                            , Table.td []
                                [ span
                                    [ cs
                                        (if model.hoverInx == inx then
                                            "art-search-results-actions"
                                         else
                                            "hidden"
                                        )
                                    ]
                                    [ span [ onClick (CreateView Details) ]
                                        [ Icon.i "remove_red_eye" ]
                                    , span []
                                        [ Icon.i "receipt" ]
                                    ]
                                ]
                            ]
                    )
            )
        ]


updateBreadSelect model index =
    let
        (updatedBread,cmd) =
            Breadcrumb.update (Breadcrumb.Update (\m -> {m | activeIndex = index})) model.breadcrumb
        view =
            case index of
                0 ->
                    Results

                1 ->
                    Details

                _ ->
                    Results
    in
        (view, updatedBread, cmd)


createBreadForResults model =
    ( "Search Results", "Foo" )


updateBreadIndexForResults model =
    Breadcrumb.update (Breadcrumb.Select 0) model.breadcrumb


updateBreadForResults model =
    Breadcrumb.update
        (Breadcrumb.Update
            (\_ -> { breads = [ createBreadForResults model ], activeIndex = 0 })
        )
        model.breadcrumb


createBreadForDetails model =
    let
        breadModel =
            { breads = ( "Details", "Bar" ) :: [ createBreadForResults model ], activeIndex = 1 }
    in
        Breadcrumb.update
            (Breadcrumb.Update (\_ -> breadModel))
            model.breadcrumb


updateBreadIndexForDetails model =
    Breadcrumb.update (Breadcrumb.Select 1) model.breadcrumb

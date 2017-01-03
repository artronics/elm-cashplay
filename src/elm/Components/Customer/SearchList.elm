module Components.Customer.SearchList exposing (..)

import Html exposing (Html, text)
import Http
import Material
import Material.Options exposing (..)
import Material.Table as Table
import Material.Button as Button
import Material.Icon as Icon
import Resources.Customer exposing (Customer)
import Components.Customer.SearchBar exposing (Query)
import Resources.Customer as Res exposing (..)


type alias Model =
    { query : Query
    , loading : Bool
    , error : Maybe String
    , customers : List Customer
    , hoverInx : Int
    , mdl : Material.Model
    }


init : Model
init =
    { query = { value = "", field = Res.Name }
    , loading = False
    , error = Nothing
    , customers = []
    , hoverInx = -1
    , mdl = Material.model
    }


type Msg
    = Search Query
    | OnFetchCustomers (Result Http.Error (List Customer))
    | Update (Model -> Model)
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            ( { model | query = query }, fetchCustomers query )

        OnFetchCustomers (Ok fetchedCustomers) ->
            ( { model | customers = fetchedCustomers, error = Nothing }, Cmd.none )

        OnFetchCustomers (Err error) ->
            ( { model | error = Just "There is a problem with network." }, Cmd.none )

        Update f ->
            ( f model, Cmd.none )

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
    div []
        [ case model.error of
            Nothing ->
                viewTable model

            Just err ->
                div [] [ text err ]
        ]



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
                                    [ span []
                                        [ Icon.i "remove_red_eye" ]
                                    , span []
                                        [ Icon.i "receipt" ]
                                    ]
                                ]
                            ]
                    )
            )
        ]

module Components.Customer.SearchList exposing (..)

import Html exposing (Html, text)
import Http
import Material
import Material.Options exposing (..)
import Material.Table as Table

import Resources.Customer exposing (Customer)
import Components.Customer.SearchBar exposing (Query)
import Resources.Customer as Res exposing (..)

type alias Model =
    { query : Query
    , loading: Bool
    , customers: List Customer
    , mdl : Material.Model
    }


init : Model
init =
    { query = {value = "", field = Res.Name}
    , loading = False
    , customers = []
    , mdl = Material.model
    }


type Msg
    = Search Query
    | OnFetchCustomers (Result Http.Error (List Customer))
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            ({model | query=query}, fetchCustomers)
        OnFetchCustomers (Ok fetchedCustomers) ->
            ({model | customers = fetchedCustomers }, Cmd.none)
        OnFetchCustomers (Err error) ->
            (model, Cmd.none)

        Mdl msg_ ->
            Material.update Mdl msg_ model

search: Query -> Model -> (Model, Cmd Msg)
search query model =
    update (Search query) model

fetchCustomers: Cmd Msg
fetchCustomers =
    Http.get "http://localhost:6464/customers" Res.customerDecoder |> Http.send OnFetchCustomers


view : Model -> Html Msg
view model =
    div []
        [viewTable model]

tableHeaders: List String
tableHeaders =
    ["ID", "Name"]

viewTable: Model -> Html Msg
viewTable model =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                (tableHeaders |> List.map (\header ->
                    Table.td [] [text header]
                ))
            ]
        , Table.tbody []
            (model.customers |> List.map (\customer ->
                Table.tr []
                    [ Table.td [Table.numeric] [text (toString customer.id)]
                    , Table.td [] [text (customer.firstName ++ " " ++ customer.lastName)]
                    ]
            ))
        ]
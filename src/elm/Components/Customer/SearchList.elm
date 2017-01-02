module Components.Customer.SearchList exposing (..)

import Html exposing (Html, text)
import Http
import Json.Decode as Decode exposing (field)
import Material
import Material.Options exposing (..)

import Resources.Customer exposing (Customer)
import Components.Customer.SearchBar exposing (Query)
import Resources.Customer as Res

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
    Http.get "http://localhost:6464/customers" customersDecoder |> Http.send OnFetchCustomers

customersDecoder:Decode.Decoder (List Customer)
customersDecoder = Decode.list memberDecoder

memberDecoder:Decode.Decoder Customer
memberDecoder =
    Decode.map2 Customer
        (field "id" Decode.int)
        (field "first_name" Decode.string)


view : Model -> Html Msg
view model =
    div []
        [text (toString model.customers)]
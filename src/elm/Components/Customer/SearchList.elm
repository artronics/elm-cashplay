module Components.Customer.SearchList exposing (..)

import Html exposing (Html, text)
import Material
import Material.Options exposing (..)

import Components.Customer.SearchBar exposing (Query)
import Resources.Customer as Res

type alias Model =
    { query : Query
    , customers: List String
    , mdl : Material.Model
    }


init : Model
init =
    { query = {value = "", field = Res.Name}
    , customers = []
    , mdl = Material.model
    }


type Msg
    = Search Query
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            ({model | customers = ["foo","bar"],query=query}, Cmd.none)
        Mdl msg_ ->
            Material.update Mdl msg_ model

search: Query -> Model -> (Model, Cmd Msg)
search query model =
    update (Search query) model

view : Model -> Html Msg
view model =
    div []
         (List.map (\c -> text c) model.customers)

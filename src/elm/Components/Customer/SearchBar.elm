module Components.Customer.SearchBar exposing (..)

import Html exposing (Html, text)
import Material
import Material.Menu as Menu exposing (..)

type alias Model =
    { selectedCategory: String
    , mdl: Material.Model
    }

type Msg
    = Mdl (Material.Msg Msg)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model.mdl

view: Model -> Html Msg



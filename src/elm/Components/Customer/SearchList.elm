module Components.Customer.SearchList exposing (..)

import Html exposing (Html,text)
import Material
import Material.Options exposing (..)

type alias Model =
    {
      mdl: Material.Model
    }

init:Model
init =
    {
      mdl = Material.model
    }

type Msg
    = Mdl (Material.Msg Msg)

update:Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
    div []
        [text "search list"]
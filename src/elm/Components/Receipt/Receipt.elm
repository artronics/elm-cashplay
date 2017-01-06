module Components.Receipt.Receipt exposing (..)

import Html exposing (Html, text, p)
import Material
import Material.Options exposing (..)
import Resources.Customer as ResCus


type alias Model =
    { customer : Maybe ResCus.Customer
    , mdl : Material.Model
    }


init : Model
init =
    { customer = Nothing
    , mdl = Material.model
    }


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Mdl msg_ ->
            let
                ( m, _ ) =
                    Material.update Mdl msg_ model
            in
                m


view : Model -> Html Msg
view model =
    p [] [ text (model.customer |> Maybe.map .firstName |> Maybe.withDefault "Receiptzz") ]

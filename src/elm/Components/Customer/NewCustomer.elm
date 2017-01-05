module Components.Customer.NewCustomer exposing (..)

import Html exposing (Html, text)
import Material
import Material.Options exposing (..)
import Resources.Customer as Res


type alias Model =
    { customer : Maybe Res.Customer
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
    div []
        [ text "New Customer" ]

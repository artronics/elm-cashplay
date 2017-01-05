module Components.Customer.CustomerView exposing (..)

import Html exposing (Html, text, p)
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
    = UpdateCustomer (Maybe Res.Customer)
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateCustomer customer ->
            { model | customer = customer }

        Mdl msg_ ->
            let
                ( m, _ ) =
                    Material.update Mdl msg_ model
            in
                m


view : Model -> Html Msg
view model =
    div []
        [ case model.customer of
            Nothing ->
                span [] []

            Just customer ->
                text customer.firstName
        ]

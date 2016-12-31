module Components.Receipt exposing (..)

import Html exposing (..)
import Components.Customer.Customer as Customer exposing (Model)


type alias Model =
    { customer : Customer.Customer
    }


init : Model
init =
    { customer = { id = 123, firstName = "no name" }
    }


type Msg
    = AddCustomer Customer.Customer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddCustomer customer ->
            ( { model | customer = customer }, Cmd.none )


addCustomer : Customer.Customer -> Model -> ( Model, Cmd Msg )
addCustomer customer model =
    update (AddCustomer customer) model


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text (toString model.customer.id) ]
        , p [] [ text model.customer.firstName ]
        ]

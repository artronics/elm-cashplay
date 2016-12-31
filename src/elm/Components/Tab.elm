module Components.Tab exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)

import Components.Customer as Customer
type alias Model =
    { current:Tab
    , customer:Customer.Model
    }

init:Model
init =
    { current = Customer
    , customer = Customer.init
    }

type Msg
    = SelectTab Tab
    | CustomerMsg Customer.Msg

type Tab
    = Customer
    | Item

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SelectTab tab ->
            ({model | current = tab}, Cmd.none)

        CustomerMsg subMsg->
            let
                (updatedCustomer, cmd, _) =
                    Customer.update subMsg model.customer
            in
                ({model | customer = updatedCustomer}, Cmd.map CustomerMsg cmd)

view: Model -> Html Msg
view model =
    div []
        [ nav[]
            [ p [onClick (SelectTab Customer)][text "Customer"]
            , p [onClick (SelectTab Item)][text "Item"]
            ]
        , div []
            [
                case model.current of
                    Customer ->
                        Html.map CustomerMsg (Customer.view model.customer)
                    Item ->
                        text "item tab"
            ]
        ]


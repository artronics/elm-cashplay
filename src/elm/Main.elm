module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Material

import Components.Customer as Customer
import Components.Receipt as Receipt
-- MODEL


type alias Model =
    { tab : Tab
    , customer: Customer.Model
    , receipt: Receipt.Model
    , mdl : Material.Model
    }


model : Model
model =
    { tab = Customer
    , customer = Customer.init
    , receipt = Receipt.init
    , mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = NoOp
    | Tab Tab
    | CustomerMsg Customer.Msg
    | ReceiptMsg Receipt.Msg
    | Mdl (Material.Msg Msg)

type Tab
    = Customer
    | Item

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp -> (model, Cmd.none)

        Tab tabName ->
            case tabName of
                Customer ->
                    ({model | tab = Customer}, Cmd.none)
                Item ->
                    ({model | tab = Item}, Cmd.none)

        CustomerMsg subMsg->
            let
                (updatedCustomer, cmd, selectedCustomer) =
                    Customer.update subMsg model.customer
                (updatedReceipt, _) =
                    Receipt.addCustomer selectedCustomer model.receipt
            in
                ({model | customer = updatedCustomer, receipt = updatedReceipt}, Cmd.map CustomerMsg cmd)

        ReceiptMsg subMsg ->
            let
                (updatedReceipt, cmd) =
                    Receipt.update subMsg model.receipt
            in
                ({model | receipt = updatedReceipt}, Cmd.map ReceiptMsg cmd)

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model



view : Model -> Html Msg
view model =
    div[]
    [ nav[]
        [ p [onClick (Tab Customer)][text "Customer"]
        , p [onClick (Tab Item)][text "Item"]
        ]
    , div[]
        [ case model.tab of
            Customer -> Html.map CustomerMsg (Customer.view model.customer)
            Item -> p[][text "umadim item"]
        ]
    , div[]
        [ p [][text "receip"]
        , Html.map ReceiptMsg (Receipt.view model.receipt)
        ]
    ]

main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
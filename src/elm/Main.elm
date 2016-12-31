module Main exposing (..)

import Html exposing (Html, p, text)
import Html.Events exposing (onClick)
import Material
import Material.Options exposing (..)
import Components.Customer as Customer
import Components.Receipt as Receipt
import Components.Tab as Tab


-- MODEL


type alias Model =
    { tab : Tab.Model
    , customer : Customer.Model
    , receipt : Receipt.Model
    , mdl : Material.Model
    }


model : Model
model =
    { tab = Tab.init
    , customer = Customer.init
    , receipt = Receipt.init
    , mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = TabMsg Tab.Msg
    | CustomerMsg Customer.Msg
    | ReceiptMsg Receipt.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabMsg subMsg ->
            let
                ( updatedTab, cmd ) =
                    Tab.update subMsg model.tab
            in
                ( { model | tab = updatedTab }, Cmd.map TabMsg cmd )

        CustomerMsg subMsg ->
            let
                ( updatedCustomer, cmd, selectedCustomer ) =
                    Customer.update subMsg model.customer

                ( updatedReceipt, _ ) =
                    Receipt.addCustomer selectedCustomer model.receipt
            in
                ( { model | customer = updatedCustomer, receipt = updatedReceipt }, Cmd.map CustomerMsg cmd )

        ReceiptMsg subMsg ->
            let
                ( updatedReceipt, cmd ) =
                    Receipt.update subMsg model.receipt
            in
                ( { model | receipt = updatedReceipt }, Cmd.map ReceiptMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html.Html Msg
view model =
    div []
        [ div []
            [ Html.map TabMsg (Tab.view model.tab)
            ]
        , div []
            [ p [] [ text "receip" ]
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

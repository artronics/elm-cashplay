module Main exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Options exposing (..)
import Material.Menu as Menu
import Components.Receipt as Receipt
import Components.Tab as Tab


type alias Model =
    { tab : Tab.Model
    , receipt : Receipt.Model
    , mdl : Material.Model
    }


model : Model
model =
    { tab = Tab.init
    , receipt = Receipt.init
    , mdl = Material.model
    }


type Msg
    = TabMsg Tab.Msg
    | ReceiptMsg Receipt.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabMsg msg_ ->
            let
                ( updatedTab, cmd ) =
                    Tab.update msg_ model.tab
            in
                ( { model | tab = updatedTab }, Cmd.map TabMsg cmd )

        ReceiptMsg msg_ ->
            let
                ( updatedReceipt, cmd ) =
                    Receipt.update msg_ model.receipt
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

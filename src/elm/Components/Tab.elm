module Components.Tab exposing (..)

import Html exposing (..)
import Material
import Material.Tabs as Tabs exposing (..)
import Material.Options as Options exposing (..)
import Material.Icon as Icon exposing (..)
import Components.Customer.Customer as Customer
import Components.Item.Item as Item


type alias Model =
    { current : Tab
    , customer : Customer.Model
    , item : Item.Model
    , mdl : Material.Model
    }


init : Model
init =
    { current = 0
    , customer = Customer.init
    , item = Item.init
    , mdl = Material.model
    }


type Msg
    = SelectTab Tab
    | CustomerMsg Customer.Msg
    | ItemMsg Item.Msg
    | Mdl (Material.Msg Msg)


type alias Tab =
    Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectTab tab ->
            ( { model | current = tab }, Cmd.none )

        CustomerMsg subMsg ->
            let
                ( updatedCustomer, cmd ) =
                    Customer.update subMsg model.customer
            in
                ( { model | customer = updatedCustomer }, Cmd.map CustomerMsg cmd )

        ItemMsg msg_ ->
            let
                (updated, cmd) =
                    Item.update msg_ model.item
            in
                ({model | item = updated}, Cmd.map ItemMsg cmd)
        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    Options.div []
        [ Tabs.render Mdl
            [ 0 ]
            model.mdl
            [ Tabs.ripple
            , Tabs.onSelectTab SelectTab
            , Tabs.activeTab model.current
            ]
            [ Tabs.label
                [ Options.center ]
                [ Icon.i "info_outline"
                , Options.span [ css "width" "4px" ] []
                , text "Customer"
                ]
            , Tabs.label
                [ Options.center ]
                [ Icon.i "code"
                , Options.span [ css "width" "4px" ] []
                , text "Item"
                ]
            ]
            [ case model.current of
                0 ->
                    Html.map CustomerMsg (Customer.view model.customer)

                1 ->
                    Html.map ItemMsg <| Item.view model.item

                _ ->
                    text "foo"
            ]
        ]

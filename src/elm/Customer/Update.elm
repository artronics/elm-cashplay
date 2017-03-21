module Customer.Update exposing (update, subscriptions)

import Customer.Model exposing (CustomerTab)
import Customer.Message exposing (Msg(..))
import Context exposing (Context)
import Customer.NewCustomer as NewCustomer


update : Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    case msg of
        ChangeView view ->
            ( { customerTab | currentView = view }, Cmd.none )

        NewCustomerMsg msg_ ->
            updateNewCustomer msg_ customerTab


subscriptions : CustomerTab -> Sub Msg
subscriptions customerTab =
    Sub.batch
        [ Sub.map NewCustomerMsg <| NewCustomer.subscription customerTab.newCustomer
        ]


updateNewCustomer : NewCustomer.Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
updateNewCustomer msg customerTab =
    let
        ( newNewCustomer, cmd ) =
            NewCustomer.update msg customerTab.newCustomer
    in
        ( { customerTab | newCustomer = newNewCustomer }, Cmd.map NewCustomerMsg cmd )

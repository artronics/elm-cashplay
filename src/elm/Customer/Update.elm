module Customer.Update exposing (update)

import Customer.Model exposing (CustomerTab)
import Customer.Message exposing (Msg(..))
import Context exposing (Context)


update : Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    case msg of
        NoOp ->
            ( customerTab, Cmd.none )

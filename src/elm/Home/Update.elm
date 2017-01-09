module Home.Update exposing (update)

import Home.Models exposing (Home)
import Home.Messages exposing (Msg(..))


update : Msg -> Home -> ( Home, Cmd Msg )
update msg home =
    case msg of
        NoOp ->
            ( home, Cmd.none )

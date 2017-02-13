module Cashplay.Update exposing (update)

import Cashplay.Model exposing (Model)
import Cashplay.Message exposing (Msg(..))
import Context exposing (Context)


update : Msg -> Model -> Context -> ( Model, Cmd Msg )
update msg model context =
    case msg of
        Logout ->
            ( model, Cmd.none )

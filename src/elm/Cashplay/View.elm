module Cashplay.View exposing (view)

import Html exposing (Html, text, p)
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))


view : Cashplay -> Html Msg
view cashplay =
    text "cashplay"

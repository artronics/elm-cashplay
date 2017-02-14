module Cashplay.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Cashplay.Model exposing (Cashplay)
import Cashplay.Message exposing (Msg(..))
import Cashplay.Tab as Tab


view : Cashplay -> Html Msg
view cashplay =
    div [ class "row" ]
        [ Tab.view cashplay ]

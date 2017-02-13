module Cashplay.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Cashplay.Model exposing (Model)
import Cashplay.Message exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        []

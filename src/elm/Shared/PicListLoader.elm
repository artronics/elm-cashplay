module Shared.PicListLoader exposing (Model, Msg, update, init, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode


type alias DataUri =
    Decode.Value


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg, Maybe (List DataUri) )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Nothing )


view : Model -> Html Msg
view model =
    div [] [ text "list of pics" ]

module Main exposing (..)

import Html exposing (..)
import Array exposing (Array)
import Material


-- MODEL


type alias Model =
    { counters : Array Int
    , mdl : Material.Model
    }


model : Model
model =
    { counters = Array.empty
    , mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp -> (model, Cmd.none)

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div[][text "foo"]

main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
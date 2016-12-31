module Components.Customer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String


type alias Customer =
    { id : Int
    , firstName : String
    }


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = AddToReceipt Customer


update : Msg -> Model -> ( Model, Cmd Msg, Customer )
update msg model =
    case msg of
        AddToReceipt customer ->
            ( model, Cmd.none, customer )



-- hello component


view : Model -> Html Msg
view model =
    div []
        [ ul []
            [ li [ onClick (AddToReceipt { id = 1, firstName = "jalal" }) ] [ text "customer 1" ] ]
        ]

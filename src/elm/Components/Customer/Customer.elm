module Components.Customer.Customer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String

import Components.Customer.Header as Header exposing (..)

type alias Customer =
    { id : Int
    , firstName : String
    }


type alias Model =
    { header: Header.Model
    }


init : Model
init =
    { header = Header.init
    }


type Msg
    = HeaderMsg Header.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        HeaderMsg msg_ ->
            let
                (updatedHeader, _) =
                    Header.update msg_ model.header
            in
                {model | header = updatedHeader}


view : Model -> Html Msg
view model =
    div []
        [ Html.map HeaderMsg (Header.view model.header)
        ]

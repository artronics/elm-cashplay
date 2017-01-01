module Components.Customer.Customer exposing (..)

import Html exposing (Html, text)
import Material
import Material.Options exposing (..)
import Material.Menu as Menu

import Components.Customer.Header as Header exposing (..)

type alias Customer =
    { id : Int
    , firstName : String
    }


type alias Model =
    { header: Header.Model
    , mdl: Material.Model
    }


init : Model
init =
    { header = Header.init
    , mdl = Material.model
    }


type Msg
    = HeaderMsg Header.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        HeaderMsg msg_ ->
            let
                (updatedHeader, cmd) =
                    Header.update msg_ model.header
            in
                ({model | header = updatedHeader}, Cmd.map HeaderMsg cmd)

        Mdl msg_ ->
            Material.update Mdl msg_ model

view : Model -> Html Msg
view model =
    div []
        [ Html.map HeaderMsg (Header.view model.header)
        ]

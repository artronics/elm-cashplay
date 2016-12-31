module Components.Customer.Header exposing (..)

import Html exposing (Html, text,select,option)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button

type alias Model =
    { searchValue:String
    , mdl:Material.Model
    }

init:Model
init =
    { searchValue=""
    , mdl = Material.model
    }

type Msg
    = SearchValueChanged String
    | Mdl (Material.Msg Msg)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchValueChanged value ->
            (model, Cmd.none)

        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
    div []
        [ Textfield.render Mdl [0] model.mdl
          [ Textfield.label "Search"
          , Textfield.floatingLabel
          , Textfield.text_
              ]
          []
        , select[][option[][text "foo"]]
        , Button.render Mdl [1] model.mdl
            [ Button.ripple
            , Button.raised
            ]
            [text "Search"]
        ]

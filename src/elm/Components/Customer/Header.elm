module Components.Customer.Header exposing (..)

import Html exposing (Html, text,select,option)
import Html.Attributes exposing (class)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Menu as Menu

import Components.Select as Select

type alias Model =
    { searchValue:String
    , searchIn: List String
    , selectedCategory: String
    , mdl:Material.Model
    }

init:Model
init =
    { searchValue=""
    , searchIn = ["Customer's Name", "Mobile Number"]
    , selectedCategory = "Customer's Name"
    , mdl = Material.model
    }

type Msg
    = SearchValueChanged String
    | Mdl (Material.Msg Msg)
    | Select String


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchValueChanged value ->
            (model, Cmd.none)

        Mdl msg_ ->
            Material.update Mdl msg_ model

        Select selectedCategory ->
            ({model | selectedCategory = selectedCategory}, Cmd.none)

view: Model -> Html Msg
view model =
        div[]
            [ Select.select Select model.searchIn model.selectedCategory Mdl 0 model.mdl
            ]


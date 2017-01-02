module Main exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Options exposing (..)
import Components.Tab as Tab


type alias Model =
    { tab : Tab.Model
    , mdl : Material.Model
    }


model : Model
model =
    { tab = Tab.init
    , mdl = Material.model
    }


type Msg
    = TabMsg Tab.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabMsg msg_ ->
            let
                ( updatedTab, cmd ) =
                    Tab.update msg_ model.tab
            in
                ( { model | tab = updatedTab }, Cmd.map TabMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html.Html Msg
view model =
    div []
        [ div []
            [ Html.map TabMsg (Tab.view model.tab)
            ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }

module Components.Item.List exposing (..)

import Html exposing (Html, text, p)
import Material
import Material.Options exposing (..)
import Components.ListView as ListView
import Resources.Item as Res


type alias Model =
    { listView : ListView.Model
    , mdl : Material.Model
    }


init : Model
init =
    { listView = ListView.init
    , mdl = Material.model
    }


type Msg
    = ListViewMsg ListView.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListViewMsg msg_ ->
            let
                ( updated, cmd ) =
                    ListView.update msg_ model.listView
            in
                ( { model | listView = updated }, Cmd.map ListViewMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> List (List String) -> Html Msg
view model items =
    div []
        (items
            |> List.map (\i -> p [] [ text <| toString i ])
        )

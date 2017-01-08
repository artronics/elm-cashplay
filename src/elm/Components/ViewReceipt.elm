module Components.ViewReceipt exposing (..)

import Html exposing (Html, text, p)
import Dict exposing (Dict)
import Material
import Material.Options exposing (..)
import Material.Table as Table
import Resources.Item as Res
import Components.TableView as TableView


type alias Model =
    { hoveredIndex : String
    , mdl : Material.Model
    }


init : Model
init =
    { hoveredIndex = ""
    , mdl = Material.model
    }


type Msg
    = Update (Model -> Model)
    | ListAction RowAction
    | Mdl (Material.Msg Msg)


type RowAction
    = View String
    | Receipt String


update : Msg -> Model -> (String -> Maybe r) -> ( Model, Cmd Msg, ( Maybe r, Maybe r ) )
update msg model getRes =
    case msg of
        Update f ->
            ( f model, Cmd.none, ( Nothing, Nothing ) )

        ListAction (View msg) ->
            ( model, Cmd.none, ( getRes msg, Nothing ) )

        ListAction (Receipt msg) ->
            ( model, Cmd.none, ( Nothing, getRes msg ) )

        Mdl msg_ ->
            let
                ( m, c ) =
                    Material.update Mdl msg_ model
            in
                ( m, c, ( Nothing, Nothing ) )


isHovered : Model -> String -> Bool
isHovered model key =
    model.hoveredIndex == key


viewActions : String -> List ( String, Msg )
viewActions key =
    [ ( "remove_red_eye", ListAction <| View key ), ( "receipt", ListAction <| Receipt key ) ]



--TODO add type annotation
--Problem is Material Property c m causing type mismatch


hoverAtr key =
    [ onMouseEnter <| Update (\m -> { m | hoveredIndex = key })
    , onMouseLeave <| Update (\m -> { m | hoveredIndex = "" })
    ]


view : Model -> List String -> Dict String r -> (r -> List (Html Msg)) -> Html Msg
view model headers resDict viewRes =
    div []
        [ TableView.render headers resDict viewRes viewActions hoverAtr (isHovered model) ]

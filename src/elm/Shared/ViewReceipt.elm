module Shared.ViewReceipt exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Views.TableView as TableView
import Views.MessageBox as MsgBox


type alias Model =
    { hoveredIndex : String
    }


init : Model
init =
    { hoveredIndex = ""
    }


type Msg
    = Update (Model -> Model)
    | ListAction RowAction


type RowAction
    = View String
    | Receipt String


update : Msg -> Model -> (String -> Maybe r) -> ( Model, ( Maybe r, Maybe r ) )
update msg model getRes =
    case msg of
        Update f ->
            ( f model, ( Nothing, Nothing ) )

        ListAction (View msg) ->
            ( model, ( getRes msg, Nothing ) )

        ListAction (Receipt msg) ->
            ( model, ( Nothing, getRes msg ) )


isHovered : Model -> String -> Bool
isHovered model key =
    model.hoveredIndex == key


viewActions : String -> List ( String, Msg )
viewActions key =
    [ ( "eye", ListAction <| View key ), ( "gbp", ListAction <| Receipt key ) ]


hoverAtr : String -> List (Attribute Msg)
hoverAtr key =
    [ onMouseEnter <| Update (\m -> { m | hoveredIndex = key })
    , onMouseLeave <| Update (\m -> { m | hoveredIndex = "" })
    ]


view : Model -> List String -> Dict String r -> (r -> List (Html Msg)) -> Html Msg
view model headers resDict viewRes =
    div []
        [ if Dict.isEmpty resDict then
            MsgBox.view "No Results found. Please Check search value and Search In options."
          else
            TableView.render headers resDict viewRes viewActions hoverAtr (isHovered model)
        ]

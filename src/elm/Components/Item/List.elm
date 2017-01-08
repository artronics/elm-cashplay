module Components.Item.List exposing (..)

import Html exposing (Html, text, p)
import Material
import Material.Options exposing (..)
import Material.Table as Table
import Resources.Item as Res
import Components.ListView as ListView


type alias Model =
    { hoveredIndex : Int
    , mdl : Material.Model
    }


init : Model
init =
    { hoveredIndex = -1
    , mdl = Material.model
    }


type Msg
    = Update (Model -> Model)
    | ListAction RowAction
    | Mdl (Material.Msg Msg)


type RowAction
    = View Res.Item
    | Receipt Res.Item


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update f ->
            ( f model, Cmd.none )

        ListAction msg ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


tableHeaders : List String
tableHeaders =
    [ "ID", "Description", "View / Add To Receipt" ]



--viewTableRows : List Res.Item -> Html Msg
--viewTableRows items =


tableRows : Model -> List Res.Item -> List (Html Msg)
tableRows model items =
    items
        |> List.indexedMap (\index item -> viewTableRow model index item)


viewTableRow : Model -> Int -> Res.Item -> Html Msg
viewTableRow model index item =
    let
        actionsView item =
            [ ( "remove_red_eye", ListAction <| View item ), ( "receipt", ListAction <| Receipt item ) ]
    in
        --        ListView.viewTableRow index
        Table.tr [ onMouseEnter <| Update (\m -> { m | hoveredIndex = index }) ]
            [ Table.td [] [ text <| toString item.id ]
            , Table.td [] [ text item.description ]
            , ListView.viewActions (actionsView item) (model.hoveredIndex == index)
            ]


view : Model -> List Res.Item -> Html Msg
view model items =
    div []
        [ ListView.render tableHeaders (tableRows model items) ]

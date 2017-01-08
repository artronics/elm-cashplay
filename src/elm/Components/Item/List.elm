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
    Table.tr (hoverAtr index)
        [ ListView.viewActions (viewActions item) (isHovered model index)
        ]


viewTableData : Res.Item -> List (Html Msg)
viewTableData item =
    [ Table.td [] [ text <| toString item.id ]
    , Table.td [] [ text item.description ]
    ]



--viewTableRow_ : Int -> List (Property c Msg)-> List (Html Msg) -> List ( String, Msg ) -> (Int -> Bool) -> Html Msg


viewTableRow_ index atr tableData actions isHovered =
    Table.tr ([] ++ atr)
        ((tableData) :: [ ListView.viewActions actions (isHovered index) ])


isHovered : Model -> Int -> Bool
isHovered model index =
    model.hoveredIndex == index


viewActions : Res.Item -> List ( String, Msg )
viewActions item =
    [ ( "remove_red_eye", ListAction <| View item ), ( "receipt", ListAction <| Receipt item ) ]


hoverAtr : Int -> List (Property c Msg)
hoverAtr index =
    [ onMouseEnter <| Update (\m -> { m | hoveredIndex = index })
    , onMouseLeave <| Update (\m -> { m | hoveredIndex = -1 })
    ]


view : Model -> List Res.Item -> Html Msg
view model items =
    div []
        [ ListView.render tableHeaders (tableRows model items) ]

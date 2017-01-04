module Components.Customer.SearchList exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Typography as Typo
import Material.Options exposing (..)
import Material.Table as Table
import Material.Button as Button
import Material.Icon as Icon
import Resources.Customer as Res exposing (..)


type alias Model =
    { customers : List Customer
    , hoverInx : Int
    , mdl : Material.Model
    }


init : Model
init =
    { customers = []
    , hoverInx = -1
    , mdl = Material.model
    }


type Msg
    = Update (Model -> Model)
    | ShowCustomer Res.Customer
    | Mdl (Material.Msg Msg)



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update f ->
            ( f model, Cmd.none )

        ShowCustomer customer ->
            (model, Cmd.none)

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div [cs "art-tab-content"]
        [ viewTable model
        ]


-- Add header strings here


tableHeaders : List String
tableHeaders =
    [ "ID", "Name", "View / Add To Receipt" ]


viewTable : Model -> Html Msg
viewTable model =
    Table.table [ cs "art-search-table" ]
        [ Table.thead []
            [ Table.tr []
                (tableHeaders
                    |> List.map
                        (\header ->
                            Table.td [] [ text header ]
                        )
                )
            ]
        , Table.tbody []
            (model.customers
                |> List.indexedMap
                    (\inx customer ->
                        Table.tr
                            [ Update (\m -> { m | hoverInx = inx }) |> onMouseEnter
                            , Update (\m -> { m | hoverInx = -1 }) |> onMouseLeave
                            ]
                            [ Table.td [ Table.numeric ] [ text (toString customer.id) ]
                            , Table.td [] [ text (customer.firstName ++ " " ++ customer.lastName) ]
                              -- This cell is for showing actions buttons (view and add to receipt)
                            , Table.td []
                                [ span
                                    [ cs
                                        (if model.hoverInx == inx then
                                            "art-search-results-actions"
                                         else
                                            "hidden"
                                        )
                                    ]
                                    [ span [ onClick (ShowCustomer customer) ]
                                        [ Icon.i "remove_red_eye" ]
                                    , span []
                                        [ Icon.i "receipt" ]
                                    ]
                                ]
                            ]
                    )
            )
        ]

{--
createBreadForResults model =
    ( "Search Results", "","search" )


updateBreadIndexForResults model =
    Breadcrumb.update (Breadcrumb.Select 0) model.breadcrumb


updateBreadForResults model =
    Breadcrumb.update
        (Breadcrumb.Update
            (\_ -> { breads = [ createBreadForResults model ], activeIndex = 0 })
        )
        model.breadcrumb


createBreadForDetails model =
    let
        breadModel =
            { breads = ( "Details", "","person" ) :: [ createBreadForResults model ], activeIndex = 1 }
    in
        Breadcrumb.update
            (Breadcrumb.Update (\_ -> breadModel))
            model.breadcrumb


updateBreadIndexForDetails model =
    Breadcrumb.update (Breadcrumb.Select 1) model.breadcrumb
--}

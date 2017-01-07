module Components.Customer.CustomerList exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Typography as Typo
import Material.Options exposing (..)
import Material.Table as Table
import Material.Button as Button
import Material.Icon as MdlIcon
import Resources.Customer as Res exposing (..)


type alias Model =
    { customers : Maybe (List Customer)
    , hoverInx : Int
    , viewCustomer : Maybe Res.Customer
    , receiptCustomer : Maybe Res.Customer
    , mdl : Material.Model
    }


init : Model
init =
    { customers = Nothing
    , hoverInx = -1
    , viewCustomer = Nothing
    , receiptCustomer = Nothing
    , mdl = Material.model
    }


type Msg
    = Update (Model -> Model)
    | Selected SelectionAction
    | Mdl (Material.Msg Msg)


type SelectionAction
    = Details (Maybe Res.Customer)
    | Receipt (Maybe Res.Customer)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Update f ->
            f model

        Selected (Details customer) ->
            { model | viewCustomer = customer }

        Selected (Receipt customer) ->
            { model | receiptCustomer = customer }

        Mdl msg_ ->
            let
                ( m, _ ) =
                    Material.update Mdl msg_ model
            in
                m


view : Model -> Html Msg
view model =
    div [ cs "art-tab-content" ]
        [ viewTable model
        ]



-- Add header strings here


tableHeaders : List String
tableHeaders =
    [ "ID", "Name", "View / Add To Receipt" ]


viewTable : Model -> Html Msg
viewTable model =
    Table.table [ cs "art-search-table" ]
        [ viewTableHeaders tableHeaders
        , Table.tbody []
            (Maybe.withDefault [] model.customers
                |> List.indexedMap
                    (\inx customer ->
                        Table.tr
                            [ Update (\m -> { m | hoverInx = inx }) |> onMouseEnter
                            , Update (\m -> { m | hoverInx = -1 }) |> onMouseLeave
                            ]
                            [ Table.td [ Table.numeric ] [ text (toString customer.id) ]
                            , Table.td [] [ text (customer.firstName ++ " " ++ customer.lastName) ]
                              -- This cell is for showing actions buttons (view and add to receipt)
                            , viewActions
                                [ ( "remove_red_eye", Selected <| Details (Just customer) )
                                , ( "receipt", Selected <| Receipt (Just customer) )
                                ]
                                (model.hoverInx == inx)
                            ]
                    )
            )
        ]


type alias Icon =
    String


type alias Show =
    Bool


viewTableHeaders : List String -> Html m
viewTableHeaders headers =
    Table.thead []
        [ Table.tr []
            (headers
                |> List.map
                    (\header ->
                        Table.td [] [ text header ]
                    )
            )
        ]


type alias Action m =
    ( Icon, m )


viewActions : List (Action m) -> Show -> Html m
viewActions actions show =
    Table.td []
        [ span
            [ cs
                (if show then
                    "art-search-results-actions"
                 else
                    "hidden"
                )
            ]
            (actions
                |> List.map
                    (\( icon, msg ) ->
                        span [ onClick msg ] [ MdlIcon.i icon ]
                    )
            )
        ]

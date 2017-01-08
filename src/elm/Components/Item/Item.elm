module Components.Item.Item exposing (..)

import Html exposing (Html, p, text)
import Http
import Dict exposing (..)
import Material
import Material.Icon as Icon
import Material.Button as Button
import Material.Elevation as Elev
import Material.Options exposing (..)
import Material.Table as Table
import Components.Item.SearchBar as SearchBar
import Material.Menu as Menu
import Resources.Item as Res
import Components.MessageBox as MsgBox
import Components.Item.Breadcrumb as Breadcrumb
import Components.ViewReceipt as ViewReceipt


type alias Model =
    { currentView : Maybe View
    , fetchedItems : Dict String Res.Item
    , viewItem : Maybe Res.Item
    , netErr : Maybe Http.Error
    , searchBar : SearchBar.Model
    , breadcrumb : Breadcrumb.Model
    , list : ViewReceipt.Model
    , mdl : Material.Model
    }


init : Model
init =
    { currentView = Nothing
    , fetchedItems = Dict.empty
    , viewItem = Nothing
    , netErr = Nothing
    , searchBar = SearchBar.init
    , breadcrumb = Breadcrumb.init
    , list = ViewReceipt.init
    , mdl = Material.model
    }


type Msg
    = SearchBarMsg SearchBar.Msg
    | BreadcrumbMsg Breadcrumb.Msg
    | ViewReceiptMsg ViewReceipt.Msg
    | Mdl (Material.Msg Msg)


type View
    = SearchResults
    | Details
    | NetErr


updateSearchBar : SearchBar.Msg -> Model -> ( Model, Cmd Msg )
updateSearchBar msg model =
    let
        ( updated, cmd, itemsResult ) =
            SearchBar.update msg model.searchBar

        ( netErr, fetchedItem, view ) =
            case itemsResult of
                Just (Ok items) ->
                    ( Nothing, itemsToDict items, Just SearchResults )

                Just (Err err) ->
                    ( Just err, model.fetchedItems, Just NetErr )

                Nothing ->
                    ( model.netErr, model.fetchedItems, Nothing )
    in
        ( { model
            | searchBar = updated
            , fetchedItems = fetchedItem
            , netErr = netErr
            , currentView = view
          }
        , Cmd.map SearchBarMsg cmd
        )


getRes : Dict String Res.Item -> String -> Maybe Res.Item
getRes itemsDict key =
    Dict.get key itemsDict


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchBarMsg msg_ ->
            updateSearchBar msg_ model

        BreadcrumbMsg msg_ ->
            let
                ( updated, cmd, currentView ) =
                    Breadcrumb.update msg_ model.breadcrumb renderCrumbContent
            in
                ( { model | breadcrumb = updated, currentView = currentView }, Cmd.map BreadcrumbMsg cmd )

        ViewReceiptMsg msg_ ->
            let
                ( updated, cmd, ( viewItem, receiptItem ) ) =
                    ViewReceipt.update msg_ model.list (getRes model.fetchedItems)
            in
                ( { model
                    | list = updated
                    , viewItem =
                        if viewItem == Nothing then
                            model.viewItem
                        else
                            viewItem
                    , currentView =
                        if viewItem == Nothing then
                            model.currentView
                        else
                            Just Details
                  }
                , Cmd.map ViewReceiptMsg cmd
                )

        Mdl msg_ ->
            Material.update Mdl msg_ model


tableHeaders : List String
tableHeaders =
    [ "ID", "Description", "View / Add To Receipt" ]


viewTableData : Res.Item -> List (Html m)
viewTableData item =
    [ Table.td [] [ text <| toString item.id ]
    , Table.td [] [ text item.description ]
    ]


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , Html.map BreadcrumbMsg <| Breadcrumb.view model.breadcrumb (bread model)
        , viewBreadcrumbContent model
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div [ Elev.e0, center, cs "art-page-header" ]
        [ Html.map SearchBarMsg <| SearchBar.view model.searchBar
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple
            , Button.raised
            , cs "new-button"
            ]
            [ Icon.i "add_to_queue", text "New Item" ]
        ]


viewBreadcrumbContent : Model -> Html Msg
viewBreadcrumbContent model =
    case model.currentView of
        Just SearchResults ->
            Html.map ViewReceiptMsg <| ViewReceipt.view model.list tableHeaders model.fetchedItems viewTableData

        Just Details ->
            text "fuck details"

        Just NetErr ->
            MsgBox.view "net error"

        Nothing ->
            MsgBox.view "view is nothing"



--These are types from Breadcrumb they are here for reference


type alias Icon =
    String


type alias Title =
    String


type alias Crumb =
    ( Icon, Title )


type alias Action =
    String -> Html Msg


type alias Bread =
    List ( Int, Crumb )


renderCrumbContent : Int -> Maybe View
renderCrumbContent index =
    case index of
        0 ->
            Just SearchResults

        1 ->
            Just Details

        _ ->
            Nothing


bread : Model -> Bread
bread model =
    case model.currentView of
        Nothing ->
            []

        Just NetErr ->
            []

        Just SearchResults ->
            [ searchResultBread ]

        Just Details ->
            searchResultBread :: [ detailsBread model ]


searchResultBread : ( Int, Crumb )
searchResultBread =
    ( 0, ( "search", "Search Results" ) )


detailsBread : Model -> ( Int, Crumb )
detailsBread model =
    let
        title =
            model.viewItem |> Maybe.map (.description) |> Maybe.withDefault "Item Details"
    in
        ( 1, ( "person", title ) )



--    [ ( 0
--      , ( "search", "Search Results" )
--      )
--    , ( 1
--      , ( "person", "customer details" )
--      )
--    ]


resToDict : List a -> (a -> String) -> Dict String a
resToDict res keygen =
    fromList
        (res
            |> List.map (\r -> ( keygen r, r ))
        )


itemsToDict : List Res.Item -> Dict String Res.Item
itemsToDict items =
    resToDict items (\i -> toString <| .id i)

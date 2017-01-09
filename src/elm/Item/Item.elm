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
    , currentCrumb : Int
    , bread : List Crumb
    , fetchedItems : Dict String Res.Item
    , viewItem : Maybe Res.Item
    , netErr : Maybe Http.Error
    , searchBar : SearchBar.Model
    , list : ViewReceipt.Model
    , mdl : Material.Model
    }


init : Model
init =
    { currentView = Nothing
    , currentCrumb = 0
    , bread = []
    , fetchedItems = Dict.empty
    , viewItem = Nothing
    , netErr = Nothing
    , searchBar = SearchBar.init
    , list = ViewReceipt.init
    , mdl = Material.model
    }


type Msg
    = SearchBarMsg SearchBar.Msg
    | SelectCrumb Int
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

        ( netErr, fetchedItem, view, currentCrumb ) =
            case itemsResult of
                Just (Ok items) ->
                    ( Nothing, itemsToDict items, Just SearchResults, 0 )

                Just (Err err) ->
                    ( Just err, model.fetchedItems, Just NetErr, 0 )

                Nothing ->
                    ( model.netErr, model.fetchedItems, model.currentView, model.currentCrumb )

        newModel =
            { model
                | searchBar = updated
                , fetchedItems = fetchedItem
                , netErr = netErr
                , currentCrumb = currentCrumb
                , currentView = view
            }

        bread =
            if itemsResult == Nothing then
                model.bread
            else
                createBread newModel
    in
        ( { newModel | bread = bread }, Cmd.map SearchBarMsg cmd )


updateViewReceipt : ViewReceipt.Msg -> Model -> ( Model, Cmd Msg )
updateViewReceipt msg model =
    let
        ( updated, cmd, ( viewItem, receiptItem ) ) =
            ViewReceipt.update msg model.list (getRes model.fetchedItems)

        ( viewItemModel, currentView, currentCrumb ) =
            if viewItem == Nothing then
                ( model.viewItem, model.currentView, model.currentCrumb )
            else
                ( viewItem, Just Details, 1 )

        newModel =
            { model
                | list = updated
                , viewItem = viewItemModel
                , currentView = currentView
                , currentCrumb = currentCrumb
            }

        --We only create new bread if there is a viewItem from child
        bread =
            if viewItem == Nothing then
                model.bread
            else
                createBread newModel
    in
        ( { newModel | bread = bread }, Cmd.map ViewReceiptMsg cmd )


getRes : Dict String Res.Item -> String -> Maybe Res.Item
getRes itemsDict key =
    Dict.get key itemsDict


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCrumb index ->
            let
                view =
                    changeView model index
            in
                ( { model | currentCrumb = index, currentView = view }, Cmd.none )

        SearchBarMsg msg_ ->
            updateSearchBar msg_ model

        ViewReceiptMsg msg_ ->
            updateViewReceipt msg_ model

        Mdl msg_ ->
            Material.update Mdl msg_ model


changeView : Model -> Int -> Maybe View
changeView model index =
    case model.currentView of
        Nothing ->
            Nothing

        Just SearchResults ->
            case index of
                1 ->
                    Just Details

                _ ->
                    Just SearchResults

        Just Details ->
            case index of
                0 ->
                    Just SearchResults

                _ ->
                    Just Details

        _ ->
            Nothing


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
        , Breadcrumb.view model.bread SelectCrumb model.currentCrumb Breadcrumb.None
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
    List Crumb


createBread : Model -> Bread
createBread model =
    case model.currentView of
        Nothing ->
            []

        Just NetErr ->
            []

        Just SearchResults ->
            [ searchResultBread ]

        Just Details ->
            searchResultBread :: [ detailsBread model ]


searchResultBread : Crumb
searchResultBread =
    ( "search", "Search Results" )


detailsBread : Model -> Crumb
detailsBread model =
    let
        title =
            model.viewItem |> Maybe.map (.description) |> Maybe.withDefault "Item Details"
    in
        ( "person", title )


resToDict : List a -> (a -> String) -> Dict String a
resToDict res keygen =
    fromList
        (res
            |> List.map (\r -> ( keygen r, r ))
        )


itemsToDict : List Res.Item -> Dict String Res.Item
itemsToDict items =
    resToDict items (\i -> toString <| .id i)

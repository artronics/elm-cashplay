module Components.Item.Item exposing (..)

import Html exposing (Html, p, text)
import Http
import Material
import Material.Icon as Icon
import Material.Button as Button
import Material.Elevation as Elev
import Material.Options exposing (..)
import Components.Item.SearchBar as SearchBar
import Material.Menu as Menu
import Resources.Item as Res
import Components.Item.Breadcrumb as Breadcrumb
import Components.Item.List as List


type alias Model =
    { currentView : Maybe View
    , fetchedItems : List Res.Item
    , netErr : Maybe Http.Error
    , searchBar : SearchBar.Model
    , breadcrumb : Breadcrumb.Model
    , list : List.Model
    , mdl : Material.Model
    }


init : Model
init =
    { currentView = Nothing
    , fetchedItems = []
    , netErr = Nothing
    , searchBar = SearchBar.init
    , breadcrumb = Breadcrumb.init
    , list = List.init
    , mdl = Material.model
    }


type Msg
    = SearchBarMsg SearchBar.Msg
    | BreadcrumbMsg Breadcrumb.Msg
    | ListMsg List.Msg
    | Mdl (Material.Msg Msg)


updateSearchBar : SearchBar.Msg -> Model -> ( Model, Cmd Msg )
updateSearchBar msg model =
    let
        ( updated, cmd, itemsResult ) =
            SearchBar.update msg model.searchBar

        ( netErr, fetchedItem ) =
            case itemsResult of
                Just (Ok items) ->
                    ( Nothing, items )

                Just (Err err) ->
                    ( Just err, model.fetchedItems )

                Nothing ->
                    ( model.netErr, model.fetchedItems )
    in
        ( { model
            | searchBar = updated
            , fetchedItems = fetchedItem
            , netErr = netErr
          }
        , Cmd.map SearchBarMsg cmd
        )


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

        ListMsg msg_ ->
            let
                ( updated, cmd ) =
                    List.update msg_ model.list
            in
                ( { model | list = updated }, Cmd.map ListMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , Html.map BreadcrumbMsg <| Breadcrumb.view model.breadcrumb bread
        , viewBreadcrumbContent model.currentView
        , Html.map ListMsg <| List.view model.list <| Res.itemsToList model.fetchedItems
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


viewBreadcrumbContent : Maybe View -> Html Msg
viewBreadcrumbContent view =
    case view of
        Just Search ->
            text "fuck you"

        Just Details ->
            text "fuck details"

        Nothing ->
            text "well i fucked up"



--These are types from Breadcrumb they are here for reference


type alias Icon =
    String


type alias Title =
    String


type alias Crumb =
    ( Icon, Title )


type alias Action =
    String -> Html Msg


type View
    = Search
    | Details


type alias Bread =
    List ( Int, Crumb )


renderCrumbContent : Int -> Maybe View
renderCrumbContent index =
    case index of
        0 ->
            Just Search

        1 ->
            Just Details

        _ ->
            Nothing


bread : Bread
bread =
    [ ( 0
      , ( "search", "Search Results" )
      )
    , ( 1
      , ( "person", "customer details" )
      )
    ]

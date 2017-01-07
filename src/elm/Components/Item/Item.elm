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


type alias Model =
    { currentView : Maybe View
    , searchBar : SearchBar.Model
    , breadcrumb : Breadcrumb.Model
    , mdl : Material.Model
    }


init : Model
init =
    { currentView = Nothing
    , searchBar = SearchBar.init
    , breadcrumb = Breadcrumb.init
    , mdl = Material.model
    }


type Msg
    = SearchBarMsg SearchBar.Msg
    | BreadcrumbMsg Breadcrumb.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchBarMsg msg_ ->
            let
                ( updated, cmd ) =
                    SearchBar.update msg_ model.searchBar
            in
                ( { model | searchBar = updated }, Cmd.map SearchBarMsg cmd )

        BreadcrumbMsg msg_ ->
            let
                ( updated, cmd, currentView ) =
                    Breadcrumb.update msg_ model.breadcrumb renderCrumbContent
            in
                ( { model | breadcrumb = updated, currentView = currentView }, Cmd.map BreadcrumbMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , Html.map BreadcrumbMsg <| Breadcrumb.view model.breadcrumb bread
        , viewBreadcrumbContent model.currentView
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

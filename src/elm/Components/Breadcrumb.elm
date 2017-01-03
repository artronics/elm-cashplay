module Components.Breadcrumb exposing (..)

import Html exposing (Html, p,ul,li, text)
import Html.Events as E
import Html.Attributes as Atr
import Array exposing (Array)
import Material
import Material.Options exposing (..)
import Material.Typography as Typo


type alias Breadcrumb =
    ( String, String )


type alias Model =
    { breads : List Breadcrumb
    , activeIndex : Int
    }


empty : Model
empty =
    { breads = []
    , activeIndex = 0
    }


init : Breadcrumb -> Model
init bread =
    let
        empty_ =
            empty
    in
        { empty_ | breads = [ bread ] }


type Msg
    = Select Int
    | Update (Model -> Model)



--    | SetActive Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Select inx ->
            ( { model | activeIndex = inx }, Cmd.none )

        Update f ->
            ( f model, Cmd.none )


view : Model -> Html Msg
view model =
    ul [Atr.class "art-breadcrumb"]
        (model.breads
            |> List.reverse
            |> List.indexedMap
                (\index ( header, subHeader ) ->
                    viewBread model index header subHeader
                )
        )


viewBread model index header subHeader =
    li [ Atr.class (if model.activeIndex == index then "active" else "")
        , E.onClick (Select index) ]

        [ span[]
            [styled p [Typo.headline] [ text header ]]
        ]

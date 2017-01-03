module Components.Breadcrumb exposing (..)

import Html exposing (Html, p, text)
import Array exposing (Array)
import Material
import Material.Options exposing (..)


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
        { empty_ | breads = [bread] }


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
            (f model, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        (
            model.breads
                |> List.reverse
                |> List.indexedMap
                    (\index (fst, snd) ->
                        viewBread index fst snd
                    )
        )

viewBread index header subHeader =
    div [ onClick (Select index) ]
        [ p [] [ text header ]
        , p [] [ text subHeader ]
        ]

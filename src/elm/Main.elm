module Main exposing (..)

import Html exposing (Html, p, text)
import Material.Options exposing (..)


type alias Model =
    {}


model : Model
model =
    {}


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html.Html Msg
view model =
    div [ cs "art-container" ]
        [ div [ cs "art-header" ] [ p [] [ text "Cashplay" ] ]
        , div [ cs "art-main-row" ]
            [ div [ cs "art-actions" ] [ p [] [ text "Actions" ] ]
            , div [ cs "art-tabs" ]
                [ text "foo" ]
            , div [ cs "art-receipt" ] [ p [] [ text "Receipt" ] ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = subscriptions
        , update = update
        }

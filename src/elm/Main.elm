module Main exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Options exposing (..)
import Components.Login as Login
import Components.Tab as Tab


type alias Model =
    { tab : Tab.Model
    , login : Login.Model
    , mdl : Material.Model
    }


model : Model
model =
    { tab = Tab.init
    , login = Login.init
    , mdl = Material.model
    }


type Msg
    = LoginMsg Login.Msg
    | TabMsg Tab.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginMsg msg_ ->
            let
                ( login, cmd ) =
                    Login.update msg_ model.login
            in
                ( { model | login = login }, Cmd.map LoginMsg cmd )

        TabMsg msg_ ->
            let
                ( updatedTab, cmd ) =
                    Tab.update msg_ model.tab
            in
                ( { model | tab = updatedTab }, Cmd.map TabMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html.Html Msg
view model =
    div [ cs "art-container" ]
        [ div [ cs "art-header" ] [ p [] [ text "Cashplay" ] ]
        , div [ cs "art-main-row" ]
            [ div [ cs "art-actions" ] [ p [] [ text "Actions" ] ]
            , div [ cs "art-tabs" ]
                [ Html.map LoginMsg <| Login.view model.login
                , Html.map TabMsg (Tab.view model.tab)
                ]
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

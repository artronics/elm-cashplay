module Customer.NewCustomer exposing (Model, init, update, subscription, Msg, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Customer.Customer as Customer exposing (Customer)
import Elements.Input as Input exposing (inp)
import Elements.Button as Btn exposing (btn)
import Elements.Icon as Icon exposing (icon)
import Views.Modal as Modal exposing (viewModal)
import Shared.Webcam as Webcam


type alias Model =
    { customer : Customer
    , webcam : Webcam.Model
    }


init : Model
init =
    { customer = Customer.new
    , webcam = Webcam.init
    }


type Msg
    = Update (Customer -> String -> Customer) String
    | Reset
    | DismissCameraModal
    | WebcamMsg Webcam.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( { model | customer = Customer.new }, Cmd.none )

        Update f val ->
            ( { model | customer = f model.customer val }, Cmd.none )

        DismissCameraModal ->
            ( model, Cmd.none )

        WebcamMsg msg_ ->
            updateWebcam msg_ model


subscription : Model -> Sub Msg
subscription model =
    Sub.batch
        [ Sub.map WebcamMsg <| Webcam.subscriptions model.webcam
        ]


updateWebcam : Webcam.Msg -> Model -> ( Model, Cmd Msg )
updateWebcam msg model =
    let
        ( newWebcam, cmd, dataUri ) =
            Webcam.update msg model.webcam

        customer =
            model.customer

        customer_ =
            case dataUri of
                Nothing ->
                    customer

                Just p ->
                    { customer | pic = p }
    in
        ( { model | webcam = newWebcam, customer = customer_ }, Cmd.map WebcamMsg cmd )


view : Model -> Html Msg
view model =
    Html.form [ class "art-new-customer" ]
        [ div [ class "row" ]
            [ div [ class "col" ] [ viewProfilePic model ]
            , div [ class "col" ] <| viewPrimaryForm model
            ]
        , div [ class "row" ]
            [ div [ class "col" ]
                [ text "blew pic" ]
            ]
        , div [ class "row justify-content-end" ]
            [ div [ class "col-2" ]
                [ viewControls model ]
            ]
        ]


viewProfilePic : Model -> Html Msg
viewProfilePic model =
    div [ class "choose-profile-pic" ]
        [ if model.customer.pic == "" then
            div [ class "pic-frame" ] []
          else
            img [ src model.customer.pic ] []
        , div [ class "d-flex justify-content-center align-items-center controls " ]
            [ button
                [ Btn.outlinePrimary
                , type_ "button"
                , attribute "data-toggle" "modal"
                , attribute "data-target" "#camera-modal"
                ]
                [ icon [ Icon.medium ] "camera" ]
            ]
        , div [ class "help-text" ] [ span [] [ text "kir" ] ]
        , viewModal "camera-modal" "Camera" DismissCameraModal (Html.map WebcamMsg <| Webcam.view model.webcam "customer-pic")
        ]


viewPrimaryForm : Model -> List (Html Msg)
viewPrimaryForm model =
    [ inp
        [ value
            (if model.customer.id == 0 then
                "UNKOWN"
             else
                toString model.customer.id
            )
        , class "input-as-label"
          --        , disabled True
        ]
        "ID"
        ""
    , inp
        [ Input.required
        , value model.customer.firstName
        , onInput <| Update (\c val -> { c | firstName = val })
        ]
        "First Name"
        ""
    , inp
        [ Input.required
        , value model.customer.lastName
        , onInput <| Update (\c val -> { c | lastName = val })
        ]
        "Last Name"
        ""
    ]


viewControls : Model -> Html Msg
viewControls model =
    div [ class "d-flex flex-row-reverse controls" ]
        [ btn [ Btn.primary, Btn.submit ] [ text "SAVE" ]
        , btn [ Btn.outlinePrimary, Btn.reset, onClick Reset ] [ text "RESET" ]
        ]

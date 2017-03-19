module Customer.NewCustomer exposing (Model, init, update, Msg, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Customer.Customer as Customer exposing (Customer)
import Elements.Input as Input exposing (inp)
import Elements.Button as Btn exposing (btn)


type alias Model =
    { customer : Customer
    }


init : Model
init =
    { customer = Customer.new
    }


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.form [ class "art-new-customer" ]
        [ div [ class "row" ]
            [ div [ class "col" ] [ viewProfilePic model ]
            , div [ class "col" ]
                [ inp [ Input.required ] "First Name" ""
                , inp [ Input.required ] "Last Name" ""
                ]
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
    div [ class "profile-pic" ] []


viewControls : Model -> Html Msg
viewControls model =
    div [ class "d-flex flex-row-reverse controls" ]
        [ btn [ Btn.primary ] [ text "SAVE" ]
        , btn [ Btn.outlinePrimary, Btn.submit ] [ text "RESET" ]
        ]

module Customer.NewCustomer exposing (Model, init, update, Msg, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
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
    = Update (Customer -> String -> Customer) String
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( { model | customer = Customer.new }, Cmd.none )

        Update f val ->
            ( { model | customer = f model.customer val }, Cmd.none )


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
    div [ class "profile-pic" ] []


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

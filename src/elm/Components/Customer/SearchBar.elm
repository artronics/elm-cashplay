module Components.Customer.SearchBar exposing (..)

import Html exposing (Html, text, p)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Menu as Menu exposing (..)
import Regex

import Resources.Customer

type alias Model =
    { searchValue: String
    , selectedCustomerField: Resources.Customer.SearchField
    --as soon as user select menu we disable auto detection
    --we enable it if input value is ""
    , autoDetection: Bool
    , mdl: Material.Model
    }

init:Model
init =
    { searchValue = ""
    , selectedCustomerField = Resources.Customer.Name
    , autoDetection = True
    , mdl = Material.model
    }

-- add new filters here and view will be match
-- always keep this list sync with all types in SearchField
filters: List Resources.Customer.SearchField
filters =
    [ Resources.Customer.Name
    , Resources.Customer.Postcode
    , Resources.Customer.Mobile
    ]

type Msg
    = OnSearchInput String
    | Select Resources.Customer.SearchField
    | Mdl (Material.Msg Msg)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnSearchInput value ->
            let
                autoDetection =
                    if value == "" then True else model.autoDetection
                selectedCustomerField =
                    if autoDetection then searchInMatch value else model.selectedCustomerField
            in
                ({model |
                    searchValue = value
                    , selectedCustomerField = selectedCustomerField
                    , autoDetection = autoDetection}, Cmd.none)

        Select field ->
            ({model | selectedCustomerField = field, autoDetection = False}, Cmd.none)
        Mdl msg_ ->
            Material.update Mdl msg_ model

view: Model -> Html Msg
view model =
    div [cs "art-search-bar"]
        [ Textfield.render Mdl [0] model.mdl
            [Textfield.label "Search Customers",Textfield.floatingLabel, Textfield.text_, onInput OnSearchInput][]

        , viewMenu model

        , Button.render Mdl [2] model.mdl
            [Button.raised, Button.flat, Button.primary][text "Search"]
        , p [][text (toString model)]
        ]

viewMenu: Model -> Html Msg
viewMenu model =
   div []
    [ span[][text <| searchFieldDisplayName model.selectedCustomerField]
    , Menu.render Mdl [1] model.mdl
        [Menu.ripple, Menu.bottomLeft, css "display" "inline"]
        menuOptions
    ]

menuOptions =
    List.map (\filter -> Menu.Item
        [onSelect (Select filter)][text <| searchFieldDisplayName filter]) filters

searchIn: String -> String
searchIn str =
    searchInMatch str |> searchFieldDisplayName

searchFieldDisplayName: Resources.Customer.SearchField -> String
searchFieldDisplayName field=
    case field of
        Resources.Customer.Name ->
            "Customer's Name"

        Resources.Customer.Mobile ->
            "Mobile Number"

        Resources.Customer.Postcode ->
            "Postcode"

searchInMatch: String -> Resources.Customer.SearchField
searchInMatch str =
        if Regex.contains (Regex.regex "^\\D*$") str then
            Resources.Customer.Name
        else if Regex.contains (Regex.regex "^[a-zA-Z](?:[a-zA-Z]?[1-9]? ?[1-9]?[a-zA-Z]{0,2})") str then
            Resources.Customer.Postcode
        else if Regex.contains (Regex.regex "^07(?:[0-9]{0,9})$") str then
            Resources.Customer.Mobile
        else
            Resources.Customer.Name

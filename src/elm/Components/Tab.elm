module Components.Tab exposing (..)

import Html exposing (..)
import Material
import Material.Tabs as Tabs exposing (..)
import Material.Options as Options exposing (..)
import Material.Icon as Icon exposing (..)


type alias Tab =
    { current : TabIndex
    , mdl : Material.Model
    }


initTab : Tab
initTab =
    { current = 0
    , mdl = Material.model
    }


type Msg
    = SelectTab TabIndex
    | Mdl (Material.Msg Msg)


type alias TabIndex =
    Int


update : Msg -> Tab -> ( Tab, Cmd Msg )
update msg model =
    case msg of
        SelectTab tab ->
            ( { model | current = tab }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Tab -> Html Msg
view model =
    Options.div []
        [ Tabs.render Mdl
            [ 0 ]
            model.mdl
            [ Tabs.ripple
            , Tabs.onSelectTab SelectTab
            , Tabs.activeTab model.current
            ]
            [ Tabs.label
                [ Options.center ]
                [ Icon.i "person"
                , Options.span [ css "width" "4px" ] []
                , text "Customer"
                ]
            , Tabs.label
                [ Options.center ]
                [ Icon.i "devices_other"
                , Options.span [ css "width" "4px" ] []
                , text "Item"
                ]
            ]
            [ case model.current of
                0 ->
                    text "first tab"

                1 ->
                    text "second tab"

                _ ->
                    text "foo"
            ]
        ]

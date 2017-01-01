module Components.Select exposing (..)

import Html exposing (text)
import Material exposing (..)
import Material.Options exposing (..)
import Material.Menu as Menu

select msg items selectedItem mdlMsg mdlIndex mdlModel =
    div []
        [ span [] [text selectedItem]
        , span []
            [ Menu.render mdlMsg [mdlIndex] mdlModel
                [ Menu.ripple, Menu.bottomLeft,css "display" "inline" ]
                (List.map (\item -> Menu.item [Menu.onSelect (msg item)][text item]) items)
            ]
        ]



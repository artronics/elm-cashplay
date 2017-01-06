module Components.Select exposing (..)

import Html exposing (text)
import Material.Options exposing (..)
import Material.Menu as MdlMenu exposing (..)

--Todo This component is just a work around for lack of Select component
select lift index mdl items msg selectedKey=
    div [ cs "art-customer-search-in" ]
        [ span [] [ text selectedKey ]
        , MdlMenu.render lift
            [ 1 ]
            mdl
            [ MdlMenu.ripple, MdlMenu.bottomLeft, css "display" "inline" ]
            (options items msg)
        ]

options items msg=
         (items
            |> List.map
                (\item ->
                    MdlMenu.Item
                        [ onSelect <|msg item ]
                        [ text item ]
                )
         )

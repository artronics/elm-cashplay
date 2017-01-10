module Views.Layout exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)


view : ( Html m, Html m, Html m ) -> Html m
view ( nav, tab, transaction ) =
    div [ cs "art-container" ]
        [ div [ cs "art-header" ]
            [ nav ]
        , div [ cs "art-main-row" ]
            [ div [ cs "art-actions" ] [ p [] [ text "Actions" ] ]
            , div [ cs "art-tabs" ]
                [ tab ]
            , div [ cs "art-receipt" ]
                [ transaction ]
            ]
        ]

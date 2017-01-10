module Customer.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg(..))
import Customer.SearchBar as SearchBar exposing (view)


view : CustomerTab -> Html Msg
view customer =
    div []
        [ SearchBar.view customer ]

module Customer.Update exposing (update)

import Material
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)


update : Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
update msg customer =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ customer

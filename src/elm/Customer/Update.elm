module Customer.Update exposing (update)

import Material
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (Customer)


update : Msg -> Customer -> ( Customer, Cmd Msg )
update msg customer =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ customer

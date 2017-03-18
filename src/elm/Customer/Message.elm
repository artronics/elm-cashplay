module Customer.Message exposing (Msg(..))

import Customer.Model exposing (View)
import Customer.NewCustomer as NewCustomer


type Msg
    = ChangeView View
    | NewCustomerMsg NewCustomer.Msg

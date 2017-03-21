module Customer.Customer exposing (..)


type alias Customer =
    { id : Int
    , firstName : String
    , lastName : String
    , pic : String
    }


new : Customer
new =
    { id = 0
    , firstName = ""
    , lastName = ""
    , pic = ""
    }

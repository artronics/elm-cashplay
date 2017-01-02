module Resources.Customer exposing (..)

type alias Customer =
    { id:Int
    , firstName:String}

type SearchField
    = Name
    | Mobile
    | Postcode
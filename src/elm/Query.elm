module Query exposing (..)

import Regex


type SearchIn
    = CustomerFields


type CustomerFields
    = FullName
    | Postcode
    | MobileNumber


filterDisplayName : CustomerFields -> String
filterDisplayName field =
    case field of
        FullName ->
            "Customer's Name"

        Postcode ->
            "Postcode"

        MobileNumber ->
            "Mobile Number"


searchIn : SearchIn -> String -> CustomerFields
searchIn searchIn str =
    case searchIn of
        CustomerFields ->
            if Regex.contains (Regex.regex "^\\D*$") then
                FullName
            else if Regex.contains (Regex.regex "^[a-zA-Z](?:[a-zA-Z]?[1-9]? ?[1-9]?[a-zA-Z]{0,2})") then
                Postcode
            else if Regex.contains (Regex.regex "^07(?:[0-9]{0,9})$") then
                MobileNumber
            else
                FullName

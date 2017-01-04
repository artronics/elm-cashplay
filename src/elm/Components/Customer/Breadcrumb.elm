module Components.Customer.Breadcrumb exposing (..)

import Html exposing (Html, text, p, li, ul)
import Html.Attributes exposing (class)
import Material.Options exposing (..)

type alias Crumb = List String
type alias Bread = List Crumb

type alias Model =
    { isLoading: Bool
    }

model: Model
model =
    { isLoading = True
    }

render: Model -> Bread -> Html m
render model bread =
    div [cs "art-breadcrumb-container"]
        [ ul [class "art-breadcrumb"]
            (viewBread bread)
        , p [class "is-loading"][text (toString model.isLoading)]
        ]


viewBread: Bread -> List (Html m)
viewBread bread =
    bread
        |> List.map (\crumb -> viewCrumb crumb)

viewCrumb: Crumb -> Html m
viewCrumb crumb =
    li []
        [ span []
            (crumb |> List.map (\line ->
                p [][text line]
            ))
        ]




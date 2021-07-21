module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Decode as Json exposing (Decoder)
import PostgRest as Rest exposing (Attribute, Request, Selection)
import Schema


main =
    Browser.sandbox { init = 0, update = update, view = view }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]


type alias School =
    { id : String
    , name : String
    }


request : Request (List School)
request =
    Rest.readMany Schema.school
        { select = selection
        }


selection : Selection { a | id : Attribute String, name : Attribute String } School
selection =
    Rest.map2 School
        (Rest.field .id)
        (Rest.field .name)

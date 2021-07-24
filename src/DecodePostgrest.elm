module DecodePostgrest exposing (main)

import Browser
import Html exposing (..)
import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Postgrest.Client as P


examples =
    [ ( "http://localhost:3000/todos", [ P.select <| P.attributes [ "id", "task" ] ] )
    , ( "Select with Resources"
      , [ P.select
            [ P.attribute "id"
            , P.attribute "task"
            , P.resource "done"
                [ P.attribute "percentage"
                ]
            ]
        ]
      )
    , ( "Resource With Params"
      , [ P.select
            [ P.attribute "id"
            , P.attribute "task"
            , P.resourceWithParams "grades"
                [ P.order [ P.desc "percentage" ], P.limit 10 ]
                [ P.attribute "percentage"
                ]
            ]
        ]
      )
    , ( "Conditions"
      , [ P.param "student_id" <| P.eq <| P.int 100
        , P.param "grade" <| P.gte <| P.int 90
        , P.or
            [ P.param "self_evaluation" <| P.gte <| P.int 90
            , P.param "self_evaluation" P.null
            ]
        ]
      )
    , ( "In List"
      , [ P.param "name" <| P.inList P.string [ "Chico", "Harpo", "Groucho" ]
        ]
      )
    , ( "Order"
      , [ P.order
            [ P.asc "age" |> P.nullsfirst
            , P.desc "created_at"
            ]
        ]
      )
    , ( "Combine Params"
      , constructParams [ P.limit 100 ]
      )
    ]


defaultParams : P.Params
defaultParams =
    [ P.select <| P.attributes [ "id", "name" ]
    , P.limit 10
    ]


constructParams : P.Params -> P.Params
constructParams =
    P.combineParams defaultParams


type alias Todos =
    { id : Int
    , task : String
    }


type alias Model =
    Maybe Int


type alias Msg =
    Maybe Int


initialModel : Model
initialModel =
    Nothing


todosDecoder : Decoder Todos
todosDecoder =
    Decode.succeed Todos
        |> required "id" int
        |> required "task" string


todosEndpoint : P.Endpoint Todos
todosEndpoint =
    P.endpoint "http://localhost:3000/todos"
        decodeTodos
        { defaultSelect =
            Just
                [ P.attribute "id"
                , P.attribute "task"
                ]
        , defaultOrder =
            Just [ P.asc "task" ]
        }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div []
        (List.map
            (\( desc, example ) ->
                div []
                    [ strong [] [ text <| "## " ++ desc ]
                    , p [] [ text <| "-- " ++ P.toQueryString example ]
                    ]
            )
            examples
        )


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }

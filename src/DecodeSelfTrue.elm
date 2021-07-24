module DecodeSelfTrue exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, bool, field, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)
import PostgRest as Rest exposing (Attribute, Request, Selection)
import Schema exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success (List Todos)


type alias Todos =
    { id : Int
    , done : Bool
    , task : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getTodos )



-- UPDATE


type Msg
    = NextPleace
    | GotTodos (Result Http.Error (List Todos))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextPleace ->
            ( Loading, getTodos )

        GotTodos result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VEIW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "get todos" ]
        , viewModel model
        ]


viewModel : Model -> Html Msg
viewModel model =
    case model of
        Failure ->
            div []
                [ text " not load"
                , button [ onClick NextPleace ] [ text "Load Json Again" ]
                ]

        Loading ->
            text "Loading ..."

        Success dataUrl ->
            div []
                [ button [ onClick NextPleace ] [ text "Load comlete!" ]
                , div [] [ text "json here ...." ]
                , viewTodos dataUrl
                ]


viewTodos : List Todos -> Html Msg
viewTodos todos =
    div []
        [ h3 [] [ text "Todos" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewTodo todos)
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "task" ]
        ]


viewTodo : Todos -> Html Msg
viewTodo todos =
    tr []
        [ td []
            [ text (String.fromInt todos.id) ]
        , td []
            [ text todos.task ]
        ]



-- HTTP


getTodos : Cmd Msg
getTodos =
    Http.get
        { url = "http://localhost:3000/todos"
        , expect = Http.expectJson GotTodos (list todosDecoder)
        }


todosDecoder : Decoder Todos
todosDecoder =
    --  field "id" (field "id" string)
    succeed Todos
        |> required "id" int
        |> required "done" bool
        |> required "task" string

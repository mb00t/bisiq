module DecodeAster exposing (main)

--import Json.Decode exposing (Decoder, bool, field, float, int, list, map5, string, succeed)

import Browser
import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Iso8601
import Json.Decode exposing (Decoder, bool, field, float, int, list, map4, map5, string, succeed)
import Json.Decode.Extra exposing (..)
import Time



--import Json.Decode.Pipeline exposing (optional, required)
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
    | Success (List Asters)


type alias Asters =
    { src : String
    , dcontext : String
    , billsec : Int
    , disposition : String
    , calldate : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getAsters )



-- UPDATE


type Msg
    = NextPleace
    | GotAsters (Result Http.Error (List Asters))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextPleace ->
            ( Loading, getAsters )

        GotAsters result ->
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
        [ h2 [] [ text "Звонки на сегодня" ]
        , viewModel model
        ]


viewModel : Model -> Html Msg
viewModel model =
    case model of
        Failure ->
            div []
                [ text "нет связи"
                , button [ onClick NextPleace ] [ text "Получить список звонков" ]
                ]

        Loading ->
            text "Получение ..."

        Success dataUrl ->
            div []
                [ button [ onClick NextPleace ] [ text "Список получен" ]
                , div [] [ text "вывод списка" ]
                , viewAsters dataUrl
                ]


viewAsters : List Asters -> Html Msg
viewAsters asters =
    div []
        [ h3 [] [ text "Звонки" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewAster asters)
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "номер" ]
        , th []
            [ text "направление" ]
        , th []
            [ text "время разговора" ]
        , th []
            [ text "статус" ]
        , th []
            [ text "дата" ]
        ]


viewAster : Asters -> Html Msg
viewAster asters =
    tr []
        [ td []
            [ text asters.src ]

        --        [ text (String.fromInt asters.id) ]
        , td []
            [ text asters.dcontext ]
        , td []
            [ text (String.fromInt asters.billsec) ]
        , td []
            [ text asters.disposition ]
        , td []
            [ text (Iso8601.fromTime asters.calldate) ]
        ]



-- HTTP


getAsters : Cmd Msg
getAsters =
    Http.get
        { --url = "http://81.163.255.13:8081/astercdr?select=src,dcontext,billsec,disposition,calldate"
          url = "http://81.163.255.13:8081/telephone/astercdr?select=src,dcontext,billsec,disposition,calldate"
        , expect = Http.expectJson GotAsters (list astDecoder)
        }



--astDecoder : Decoder Asters
--astDecoder =
--    succeed Asters
--        |> andMap (field "srs" string)
--        |> andMap (field "dcintext" string)
--        |> andMap (field "billsec" int)
--        |> andMap (field "dispisition" string)
---   |> andMap (field "calldate" datetime)


astDecoder : Decoder Asters
astDecoder =
    map5 Asters
        (field "src" string)
        (field "dcontext" string)
        (field "billsec" int)
        (field "disposition" string)
        (field "calldate" datetime)



--asterDecoder : Decoder Asters
--asterDecoder =
--   succeed Asters
--      |> required "src" string
--     |> required "dcontext" string
--       |> required "billsec" int
--        |> required "disposition" string
--        |> required "calldate" int

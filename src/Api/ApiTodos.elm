module Api.Todos exposing (Todos, TodosID(..), TodosSubmission, decodeUnit, delete, encode, endpoint, getMany, post, primaryKey, todosID)

import Json.Decode exposing (..)
import Json.Encode as JE
import Postgrest.Client as P



-- Optional, but recommended to have a type that
-- represents your primary key.


type TodosID
    = TodosID Int



-- And a way to unwrap it...


todosID : TodosID -> Int
todosID (TodosID id) =
    id



-- Define the record you would fetch back from the server.


type alias Todos =
    { id : TodosID
    , name : String
    }



-- Define a submission record, without the primary key.


type alias TodosSubmission =
    { name : String
    }



-- Decoders are written using Json.Decode


decodeUnit : Decoder Todos
decodeUnit =
    map2 Todos
        (field "id" <| map TodosID int)
        (field "name" string)



-- Encoders are written using Json.Encode


encode : TodosSubmission -> JE.Value
encode todos =
    JE.object
        [ ( "name", JE.string todos.name )
        ]



-- Tell Postgrest.Client the column name of your primary key and
-- how to convert it into a parameter.


primaryKey : P.PrimaryKey TodosID
primaryKey =
    P.primaryKey ( "id", P.int << todosID )



-- Tell Postgrest.Client the URL of the postgrest endpoint and how
-- to decode an individual record from it. Postgrest will combine
-- the decoder with a list decoder automatically when necessary.


endpoint : P.Endpoint Todos
endpoint =
    P.endpoint "http://localhost:300/todos" decodeUnit



-- Fetch many records. If you want to specify parameters use `setParams`


getMany : P.Request (List Todos)
getMany =
    P.getMany endpoint



-- Delete by primary key. This is a convenience function that reduces
-- the likelihood that you delete more than one record by specifying incorrect
-- parameters.


delete : TodosID -> P.Request TodosID
delete =
    P.deleteByPrimaryKey endpoint primaryKey



-- Create a record.


post : TodosSubmission -> P.Request Todos
post =
    P.postOne endpoint << encode

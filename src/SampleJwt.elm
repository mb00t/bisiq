module SampleJWT exposing (Msg(..), cmdExamples, jwt, toCmd)

import Api.Todos as People
import Postgrest.Client as P


jwt : P.JWT
jwt =
    P.jwt "abcdefghijklmnopqrstuvwxyz1234"


type Msg
    = TodosCreated (Result P.Error Todos)
    | PeopleLoaded (Result P.Error (List Todos))
    | TodosDeleted (Result P.Error TodosID)


toCmd =
    P.toCmd jwt


cmdExamples =
    [ People.post
        { name = "Yasujirō Ozu"
        }
        |> P.toCmd jwt TodosCreated
    , People.getMany
        [ P.order [ P.asc "name" ], P.limit 10 ]
        |> toCmd PeopleLoaded
    , Todos.delete todosID
        |> toCmd TodosDeleted
    ]

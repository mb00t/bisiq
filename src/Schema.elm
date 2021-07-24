module Schema exposing (Todo, todo)

import PostgRest exposing (Attribute, Schema, schema, string)


type Todo
    = Todo Todo


todo :
    Schema
        Todo
        { id : Attribute String
        , done : Attribute String
        , task : Attribute String
        }
todo =
    schema "todo"
        { id = string "id"
        , done = string "done"
        , task = string "task"
        }

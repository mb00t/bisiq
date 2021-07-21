module Schema exposing (School, school)

import PostgRest exposing (Attribute, Schema, schema, string)


type School
    = School School


school :
    Schema
        School
        { id : Attribute String
        , name : Attribute String
        }
school =
    schema "schools"
        { id = string "unitid"
        , name = string "instnm"
        }

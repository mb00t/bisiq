-- Deploy sqitch-postgrest-elm:todos_data_paste to pg
-- requires: appshema
 BEGIN;


INSERT INTO api.todos(task)
VALUES ('task3'),
       ('task4'),
       ('task5');


COMMIT;

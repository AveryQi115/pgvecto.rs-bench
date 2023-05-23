CREATE OR REPLACE FUNCTION ARRAY_INTERSECT(anyarray, anyarray)
  RETURNS anyarray
  language sql
as $FUNCTION$
    SELECT ARRAY(
        SELECT UNNEST($1)
        INTERSECT
        SELECT UNNEST($2)
    );
$FUNCTION$;

set enable_seqscan = off;

CREATE INDEX ON train USING ivfflat (embedding vector_l2_ops) WITH (lists = 100);

EXPLAIN ANALYZE SELECT AVG(ARRAY_LENGTH(ARRAY_INTERSECT(answer[:16], ARRAY(
    SELECT train.id
    FROM train
    ORDER BY test.embedding <-> train.embedding
    LIMIT 16
)), 1) / 16::float)
FROM test;

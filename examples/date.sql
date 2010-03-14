-- Examples of date aggregation

CREATE TABLE cases (
  case_no integer PRIMARY KEY
);

CREATE TABLE measures (
  case_no integer REFERENCES cases ON DELETE CASCADE,
  dor date, -- date of rating
  measure numeric
);

INSERT INTO cases (case_no) VALUES
  (1),
  (2),
  (3),
  (4),
  (5);
  
INSERT INTO measures (case_no, dor, measure) VALUES
  (1, date '2006-6-2', 12),
  (1, date '2006-6-2', 13),
  (1, date '2006-7-15', 7),
  (2, date '2007-1-6', 15),
  (3, date '2005-5-19', 8),
  (4, date '2006-6-2', 10),
  (4, NULL, 8),
  (5, NULL, 10),
  (5, NULL, 11);


-- manual aggregation
SELECT case_no,
       (date 'epoch' + avg(extract(epoch FROM dor)) * interval '1 second')::date AS dor_avg,
     avg(measure) as measure_avg
FROM measures
GROUP BY case_no
ORDER BY case_no;

-- use date aggregation function
SELECT case_no,
       avg(dor) as dor_avg,
       avg(measure) as measure_avg
FROM measures
GROUP BY case_no
ORDER BY case_no;
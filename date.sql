---------------------------------
--
-- Aggregation functions for dates.
--
----------------------------------

--
-- Arithmetic average of dates, removing NULL values. 
-- Returns NULL, otherwise
--

--
--            accumulate sum and count     add a date object       
--                                  \             /               
CREATE FUNCTION date_as_epoch_accum(e numeric[], d date) RETURNS numeric[] as $$
BEGIN
  IF d is NULL THEN
    RETURN e; --                                           increment the counter
  ELSE --                                                      /
    RETURN  ARRAY[e[1] + extract(epoch from d)::numeric, e[2] + 1];
  END IF; --                                      \
END; --                                           /
$$ language plpgsql; --                   cast to numeric as epoch returns large values


--
-- Convert accumulated epoch values back into a date
--
CREATE FUNCTION epoch_as_date_avg(e numeric[]) RETURNS date as $$
BEGIN
  IF e[2] = 0 THEN
    return NULL;
  ELSE
    RETURN date 'epoch' + e[1] / e[2] * interval '1 second';
  END IF; --        /           \                      \
END --   start from epoch   add average offset;    epoch is measured in seconds
$$ language plpgsql;--     numeric also ensures
--                          precise calculation  
  
--
-- Polymorphic average function for `date` 
-- 
CREATE AGGREGATE avg(date) (
  sfunc=date_as_epoch_accum,
  stype=numeric[],
  finalfunc=epoch_as_date_avg,
  initcond='{0, 0}'
);
CREATE OR REPLACE PROCEDURE dynamic_object_creation_wrapper() language plpgsql
as
'

declare
rec_cnt int :=0;
lv_starttime timestamp ;
lv_endtime timestamp ;
dynamic_records record;
BEGIN
  lv_starttime :=sysdate;
  raise info ''Process started at %'', lv_starttime;
  FOR dynamic_records IN SELECT DISTINCT ENTITY_NAME FROM BI_EXEC_LOG 
    LOOP	 
	 	     -- Now "dynamic_records" has one record from bi exec log
       Select count(1)  into rec_cnt from  PG_TABLE_DEF where trim(upper(tablename))= trim(upper(dynamic_records.entity_name))
         and  schemaname =''public'';
         if rec_cnt=0 then 
         exit;
         else
       call dynamic_object_creation(dynamic_records.entity_name);
       raise info ''Objects Created % '',dynamic_records.entity_name;
         end if;
       END LOOP;
       lv_endtime:= sysdate;
	   raise info ''Process ended at % '', lv_endtime;
      
EXCEPTION WHEN OTHERS THEN 
				  RAISE exception ''Exception message SQLERRM %'', SQLERRM ;
				  RAISE exception ''Exception message SQLSTATE %'', SQLSTATE;
  

END;
';

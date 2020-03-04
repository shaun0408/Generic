CREATE OR REPLACE PROCEDURE dynamic_object_creation(obj_name in varchar(256)) language plpgsql
as
'
declare
p_table_name varchar(100):= obj_name;
/*v_view_name varchar(100);*/
v_table_name varchar(100);
v_schema_name varchar(50):=''bi_sf_int'';
v_schema_name_stg varchar(50):=''bi_sf_stg'';

Begin
raise info ''Table name is %'',p_table_name;

v_table_name := p_table_name||''_''||to_char(sysdate,''ddmmyyyyhhmiss'');

 RAISE info ''Name of the table %'', v_table_name ;
 
/*v_view_name  := v_table_name||''_v''; 

 RAISE info ''Name of the view %'', v_view_name ; */

execute ''CREATE TABLE '' ||v_schema_name.v_table_name||'' as Select * from ''|| v_schema_name_stg.p_table_name  ;

Raise info ''Table Created'';

/*execute ''create or replace view ''||v_schema_name.v_view_name||'' as Select * from ''|| v_schema_name_stg. v_table_name ; 

Raise info ''View Created'';*/

			EXCEPTION WHEN OTHERS THEN 
				  RAISE exception ''Exception message SQLERRM %'', SQLERRM ;
				  RAISE exception ''Exception message SQLSTATE %'', SQLSTATE;
End;
'


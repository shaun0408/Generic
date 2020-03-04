CREATE OR REPLACE PROCEDURE dynamic_view_creation() language plpgsql
as
'
declare
v_view_name varchar(1000);
dynamic_view record;
lv_endtime timestamp;
v_tablename varchar(255);
v_sql varchar(1000);
v_schemaname varchar(250);
v_sq_user varchar(250);
v_grant   varchar(250);
v_revoke  varchar(250);
v_drop    varchar(250);
v_revoke1 varchar(250);
v_group1 varchar(250);
Begin
for dynamic_view IN select * from bi_view_geo_reg_mapping where VIEW_REQ=''Y''
   LOOP	 
raise info ''Geo selected % '',dynamic_view.geo;
raise info ''Region selected % '',dynamic_view.REGION;



if dynamic_view.FUNCTIONAL_AREA =''SA'' then 
    v_schemaname :=''bi_sf_int'';	
        elsif   dynamic_view.FUNCTIONAL_AREA =''FIN''		
        then 
    v_schemaname :=''bi_fin_int'';
	
end if;  

---------------------------------------------------------------------------------------

   v_tablename  := v_schemaname||''.''||dynamic_view.TABLE_NAME;   
   v_view_name  := v_schemaname||''.''||dynamic_view.VIEWNAME;
----------------------------------------------------------------------------------------   
  
raise info ''Schema name % '',v_schemaname ; 
raise info ''table Name with schema %'',v_tablename;
raise info ''view Name with schema %'',v_view_name; 
-----------------------------------------------------------------------------------------

v_revoke :=''REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ''||'' bi_sf_int ''|| ''from group '' || dynamic_view.DB_USER;

v_revoke1 :=''REVOKE all privileges on schema ''|| v_schemaname||'' from group ''|| dynamic_view.DB_USER;

v_drop  := ''drop group ''|| dynamic_view.DB_USER;

v_sql := ''Create or replace view '' ||v_view_name|| '' as select * from '' ||v_tablename|| '' where GEO =''|| quote_literal(dynamic_view.geo)
           ||''and REGION =''||quote_literal(dynamic_view.REGION);
		   
v_sq_user :=''CREATE group  ''||dynamic_view.DB_USER;

v_group1 :=''grant usage on schema  '' ||v_schemaname || '' to group '' ||dynamic_view.DB_USER;

--v_grant :=''Grant Select on  ''|| v_tablename || '' to group '' ||dynamic_view.DB_USER;

v_grant := ''GRANT SELECT  ON ''|| v_view_name ||'' to group '' ||dynamic_view.DB_USER;
	
--raise info ''Query is %'',	v_revoke1;
--raise info ''Query is %'',v_drop;		
--raise info ''Query is % '',v_revoke;
raise info '' Query is % '',v_sq_user;
raise info '' Query is % '',v_group1; 
raise info '' Query is % '',v_sql;
raise info '' Query is %'',v_grant;

-----execute v_drop;
---execute v_revoke;
--execute v_sq_user;
--execute v_sql;
--execute v_grant;


raise info ''Table selected %'',dynamic_view.TABLE_NAME;
raise info ''View Created %'',v_view_name;

       END LOOP;

       lv_endtime:= sysdate;
	   raise info ''Process ended at % '', lv_endtime;

			EXCEPTION WHEN OTHERS THEN 
				  RAISE exception ''Exception message SQLERRM %'', SQLERRM ;
				  RAISE exception ''Exception message SQLSTATE %'', SQLSTATE;
End;
'
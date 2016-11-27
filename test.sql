select ST_AsGeoJSON(ST_Transform(way,4326)) from osm_roads as R where R.bicycle = 'yes'

select *,ST_AsGeoJSON(ST_Transform(way,4326))::json from osm_roads as R where amenity is not null


SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry FROM osm_point where amenity like 'restaurant' or amenity like 'pub'   ) As f )  As fc;

select row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry FROM osm_roads as R where R.bicycle = 'yes' ) as f ) as fc;

SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type, ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, row_to_json((SELECT l FROM (SELECT osm_id AS feat_id) As l)) As properties FROM osm_roads As l limit 1000 )) As fc



SELECT row_to_json(f) As feature 
     FROM (SELECT 'Feature' As type 
     , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry 
     , row_to_json((SELECT l FROM (SELECT osm_id AS feat_id) As l)) As properties 
     FROM osm_roads As l limit 1000 ) As f;


 select r.name, st_asgeojson(ST_Transform(r.way,4326)), r.amenity from osm_point as r;
 select st_asgeojson(ST_Transform(r.way,4326))from osm_point as r limit 1000;


SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
    , ST_AsGeoJSON(ST_Transform(lg.way,4326))::json As geometry
    , row_to_json((SELECT l FROM (SELECT osm_id, name) As l
      )) As properties
   FROM osm_point As lg limit 10  ) As f )  As fc;



SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features  FROM (SELECT 'Feature' As type    , ST_AsGeoJSON(ST_Transform(lg.way,4326))::json As geometry    , row_to_json((SELECT l FROM (SELECT osm_id, name) As l      )) As properties   FROM osm_point As lg limit 10  ) As f )  As fc;




SELECT *
FROM osm_point
WHERE ST_DistanceSphere(ST_Transform(way,4326), ST_MakePoint(48.1567,17.0333)) <= 300000

select * from osm_point where 
st_intersects (
   osm_point.way,
   ST_Buffer(       
              ST_GeogFromText('POINT(48.04428 17.74779)')
              , 4326
   )
);



-- poradie suradnic: lon , lat

select *,st_distance(way,st_geomfromtext('POINT(17 48)',4326)) as distance 
from osm_point where st_buffer(st_geomfromtext('POINT(17 48)',4326),1000000) 
&& "way"

SELECT ST_Distance(a.way, b.way)
FROM osm_point a, osm_point b

lat = 48.1567
lng = 17.0333

--- vrati 200 bodov, ktore su od zadanych suradnich maximalne 500m vzdialene

SELECT way
FROM osm_point
WHERE ST_DWithin(
  ST_SetSRID(ST_Point(17.03, 48.15), 4326),
  ST_Transform(way, 4326),
  500
)
LIMIT 200;

SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM osm_point where (amenity like 'restaurant' or amenity like 'pub') and (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) < "+search_dist+"  order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) ) As f )  As fc; 

SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17 48)',4326),4326),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),4326))))) As properties FROM osm_roads where osm_roads.bicycle = 'yes'  limit 100  ) As f limit 100 )  As fc; 

--- 
select row_to_json(fc)
from osm_point as z
where ST_DWITHIN(Geography(ST_Transform(z.way,4326)), ST_GeographyFromText('POINT(17.336031 48.863172)'),1000);


select *,ST_AsGeoJSON(ST_Transform(way,4326))::json from osm_point as R where amenity is not null



distance 10 
lat 48.14467064516251
lng 17.127170562744144


---- one select 
SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, row_to_json((osm_id,name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17.127170562744144 48.14467064516251)',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM osm_roads where osm_roads.bicycle = 'yes'  and (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17.127170562744144 48.14467064516251)',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) < 10000000  ) As f  )  As fc; 



-- pozicovna bicyklov
--"bicycle_rental", "bicycle_rental"
Select amenity, name,  ST_AsGeoJSON(ST_Transform(way,4326)) FROM osm_point WHERE amenity = 'bicycle_rental' AND name IS NOT NULL limit 50

--------------SPORTOVISKA
--points> sports centre, playground, picnic table
--polygons> park, pitch, garden, stadium ,swimming pool
select * from osm_point    as P where P.leisure IS NOT NULL limit 50
select * from osm_polygon  as P where P.leisure IS NOT NULL limit 50


SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json(osm_id, name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17.1046 48.13969)',4326),26986), ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)))) As properties FROM osm_point 	where (amenity like 'restaurant' or amenity like 'pub') and 	(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17.1046 48.13969)',4326),26986), ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) < 100  	order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17.1046 48.13969)',4326),26986), ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) ) As f )  As fc; 

-- pokus
SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM 
(SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, 
row_to_json((osm_id,name,
(SELECT ST_Distance(
	ST_Transform(ST_SetSRID(ST_Point(17, 48),4326), 26986),
	ST_Transform(way, 26986)  
	)
))) As properties FROM osm_roads where osm_roads.bicycle = 'yes'  and 
	(SELECT ST_Distance(
		ST_Transform(ST_SetSRID(ST_Point(17, 48),3857), 26986),
		ST_Transform(way,26986)
		)) < 100000  ) As f  )  As fc; 	



--- funkcne
SELECT ST_Distance(gg1, gg2) As spheroid_dist, ST_Distance(gg1, gg2, false) As sphere_dist
FROM (SELECT
	ST_GeogFromText('SRID=4326;POINT(-72.1235 42.3521)') As gg1,
	ST_GeogFromText('SRID=4326;LINESTRING(-72.1260 42.45, -72.123 42.1546)') As gg2
	) As foo  ;


--- 

Select way FROM osm_point WHERE amenity = 'bicycle_rental'

select ST_SetSRID(ST_Point(17.127170562744144, 48.14467064516251),4326); -- using WGS 84
select ST_GeomFromText('POINT(17.127170562744144 48.14467064516251)',4326)
select ST_Transform( ST_GeomFromText('POINT(17.127170562744144 48.14467064516251)',4326),4326)


---ROZDIEL PODLA GOOGLU 2.6 km
---48.14627, 17.0761)
---Marker position: LatLng(48.13969, 17.1046)

select ST_Distance( ST_GeomFromText('POINT(17.1046 48.13969)',4326), ST_GeomFromText('POINT(17.0761 48.14627)',4326))

-- correct in meters
SELECT ST_Distance(	ST_Transform(ST_GeomFromText('POINT(17.1046 48.13969)',4326),3857),
			ST_Transform(ST_GeomFromText('POINT(17.0761 48.14627)', 4326),3857)
		   );

-- same as geometry example but note units in meters - use sphere for slightly faster less accurate
SELECT ST_Distance(gg1, gg2) As spheroid_dist, ST_Distance(gg1, gg2, false) As sphere_dist
FROM (SELECT
	ST_GeogFromText('SRID=4326;POINT(-72.1235 42.3521)') As gg1,
	ST_GeogFromText('SRID=4326;LINESTRING(-72.1260 42.45, -72.123 42.1546)') As gg2
	) As foo  ;

select st_transform(st_setsrid(st_makepoint(0, -181), 4326), 2857);
SELECT ST_Intersection(way, ST_MakeEnvelope(-180, 0, 180, 90, 4326)) from osm_point


	
SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.12966 48.17239)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM osm_point where amenity like 'restaurant' order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.12966 48.17239)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
))) As f ) As fc;

SELECT   ST_Length(line)As uzunluk FROM (SELECT ST_Transform(ST_GeomFromEWKT('SRID=3857;LINESTRING(40.15243 26.41324, 40.1532783333333 26.4139433333333, 40.1532466666667 26.4148533333333, 40.1528816666667 26.4161383333333, 40.1525966666667 26.4171816666667, 40.1522933333333 26.418365, 40.1520566666667 26.4192816666667, 40.151645 26.4205, 40.1513233333333 26.4215516666667, 40.15106 26.4225283333333, 40.1507083333333 26.4238166666667, 40.1504283333333 26.424855, 40.1501483333333 26.4258833333333, 40.14994 26.4269583333333, 40.149825 26.4280783333333, 40.14979 26.4292316666667, 40.1497816666667 26.4303733333333, 40.1497866666667 26.4312166666667, 40.1498166666667 26.432815, 40.1498466666667 26.43411, 40.1498783333333 26.4351533333333, 40.149915 26.4362166666667, 40.1499633333333 26.4375566666667, 40.150025 26.4391066666667, 40.150045 26.4398733333333, 40.15006 26.4403816666667, 40.1500733333333 26.4408866666667, 40.1501216666667 26.44216, 40.1501633333333 26.4432133333333, 40.1502133333333 26.4445783333333, 40.1500616666667 26.4456666666667, 40.1497216666667 26.4467183333333, 40.149375 26.44778, 40.1490316666667 26.44884, 40.1486983333333 26.4499, 40.1483116666667 26.4509366666667, 40.1478266666667 26.4518533333333, 40.14704 26.4522733333333, 40.1459933333333 26.4526933333333, 40.1452 26.4527583333333, 40.1444316666667 26.4525283333333, 40.1434066666667 26.452125, 40.1425233333333 26.451785, 40.1418216666667 26.45151, 40.1408733333333 26.4511483333333, 40.140175 26.4508833333333, 40.139255 26.4505366666667, 40.13835 26.4501966666667, 40.1374766666667 26.44981, 40.13664 26.4493133333333, 40.1360333333333 26.448865, 40.1352583333333 26.44818)'),3857) As line) As foo;


SELECT 
    *
FROM 
    osm_point
WHERE
    ST_Dwithin(way::geography, ST_GeomFromText('POINT(17.1296604 48.172398)',4326), 400)

SELECT * FROM osm_point WHERE ST_DWithin(way::geography,ST_GeomFromEWKT('SRID=4326;POINT(17 48)'), 0.0008);

SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM 
(SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry FROM 
( SELECT * FROM osm_roads 
	WHERE ST_DistanceSphere(
	(ST_Transform(way,4326)), 
	ST_MakePoint(48.1567,17.0333)) <= 300000) as t ) as f ) as fc;

--------------------------------------------
-----
---SELECT VZDIALENOST OD BODU
-----
--------------------------------------------

SELECT row_to_json(fc)
FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
FROM (SELECT 'Feature' As type
, ST_AsGeoJSON(ST_Transform(way,4326))::json AS geometry
, row_to_json((osm_id,name,amenity,(SELECT ST_Distance(
	ST_Transform(ST_GeomFromText('POINT(17.12966 48.17239)',4326),26986),
	ST_Transform(way,26986)
))
)) As properties
FROM osm_point where amenity like 'restaurant' and (SELECT ST_Distance(
	ST_Transform(ST_GeomFromText('POINT(17.12966 48.17239)',4326),26986),
	ST_Transform(way,26986)
) < 1000) limit 10)  As f ) As fc;


---------------------------------------------
-----
----
----
---------------------------------------------
SELECT to_tsquery('english', 'The & Fat & Rats');

create extension unaccent;
create text search configuration sk(copy = simple);
alter text search configuration sk alter mapping for word with unaccent, simple;
create index index_contracts_ft on osm_point using gin(to_tsvector('sk', name ))
  


select * from osm_point where amenity = 'bicycle_rental'	
and to_tsvector('sk', name ) 



select way,name from osm_point where leisure is not null or amenity = 'bicycle_rental' and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"');

SELECT row_to_json(fc) FROM (
	SELECT 'FeatureCollection' as type, array_to_json(array_agg(f)) As features 
	FROM (
		(SELECT 'Feature' as type, ST_AsGeoJSON(way)::json as geometry, row_to_json(osm_id,name,amenity,
			(SELECT * from osm_point WHERE leisure IS NOT NULL or amenity = 'bicycle_rental' and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"') )
		) as properties FROM osm_point
		) 
	) as f
) as fc;




SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM 
(SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,amenity,
(SELECT ST_Distance(
	ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),
	ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM 
	(SELECT ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', '"+search_name+"')) rank, * from osm_point 
	where  (amenity like 'restaurant' or amenity like 'pub') and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"') 
	order by rank desc) as foo  
		order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(way ,26986))) ) As f )  As fc; 



---search on city, and bike rental
SELECT row_to_json(fc) 
FROM ( 
	SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features 
	FROM (
		SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((
			osm_id,name,amenity,(
			SELECT ST_Distance(
			ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),
			ST_Transform(way, 26986)
			)
			))) As properties 
		FROM (
			SELECT ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', '"+search_name+"')) rank, * from osm_point 
			where  (amenity like 'bicycle_rental' or place like 'town' or place like 'city' or place like 'village' or place like 'suburb') and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"') 
			order by rank desc) as foo  
		order by (
		SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),
		ST_Transform(way ,26986))) ) As f )  As fc; 

-- poprad a okolie
select * from osm_point as P
where P.name = 'Poprad'

-- najdenie vsetkych miest  pocet = 377 plus city tak to je dohromady = 395
select * from osm_point as P
where P.place = 'town' or P.place = 'city'
order by name

-- rozdiel medzi dedinou (village) a predmieste (suburb) ? dohromady asi 7032 obci
select * from osm_point as P
where P.place = 'village' or P.place = 'suburb'
order by P.name



----------------- INSERT INTO DB
WITH data AS (SELECT '{ "type": "FeatureCollection",
    "features": [
      { "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
        "properties": {"prop0": "value0"}
        },
      { "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
            ]
          },
        "properties": {
          "prop0": "value0",
          "prop1": 0.0
          }
        },
      { "type": "Feature",
         "geometry": {
           "type": "Polygon",
           "coordinates": [
             [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
               [100.0, 1.0], [100.0, 0.0] ]
             ]
         },
         "properties": {
           "prop0": "value0",
           "prop1": {"this": "that"}
           }
         }
       ]
     }'::json AS fc)

SELECT
  row_number() OVER () AS gid,
  ST_AsText(ST_GeomFromGeoJSON(feat->>'geometry')) AS geom,
  feat->'properties' AS properties
FROM (
  SELECT json_array_elements(fc->'features') AS feat
  FROM data) AS f;

-------- GEOMETRY COLLECTION FROM GEOJSON

--SELECT ST_AsText(ST_Collect(ST_GeomFromGeoJSON(feat->>'geometry')))
--FROM (
--  SELECT json_array_elements('{ ... put JSON here ... }'::json->'features') AS feat
--) AS f;

SELECT ST_AsText(ST_Collect(ST_GeomFromGeoJSON(feat->>'geometry')))
FROM (
  SELECT json_array_elements('{ "type": "FeatureCollection",
    "features": [
      { "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
        "properties": {"prop0": "value0"}
        },
      { "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
            ]
          },
        "properties": {
          "prop0": "value0",
          "prop1": 0.0
          }
        },
      { "type": "Feature",
         "geometry": {
           "type": "Polygon",
           "coordinates": [
             [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
               [100.0, 1.0], [100.0, 0.0] ]
             ]
         },
         "properties": {
           "prop0": "value0",
           "prop1": {"this": "that"}
           }
         }
       ]
     }'::json->'features') AS feat
) AS f;		


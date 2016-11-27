select osm_id, building from osm_polygon limit 50

--way geometry LineString
select * from osm_line limit 10

-- osm_id , housenumber, amenity, way geometry  POINT
select * from osm_point limit 10

-- to iste, ale way geometry typu Geometry, 3857
select * from osm_polygon limit 10

-- boundary, highway, way geometry LineString 3857
select * from osm_roads limit 10

-------------------------------------------
-- kazda tabulka obsahuje tie iste stlpce,
-- ale nie kazda ma vsetko vyplnene
-------------------------------------------

-- jednoduche pretnutie point a line
select * from osm_point as P 
join osm_roads as R on ST_INTERSECTS(P.way, R.way)
where P.osm_id <> R.osm_id
limit 10  

-- analyza
select * from osm_point as P limit 1000

-- body, ktore maju nejaky nazov == 189828
select * from osm_point as P
where P.name <> ''

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


-- najdenie konkretnej dediny (Rabčíce)
select * from osm_point as P
where P.name like 'Rab%'

-- zoradenie miest podla populacie, 10 najludantejsich miest
select P.name, P.population, P.amenity from osm_point as P
where P.population <> '' 
order by (P.population)::int desc

-- ANALYZA obsahuje aj mesta, ktore nie su iba na slovensku

-- rozloha celeho slovenska
select SUM(PL.way_area) As rozlohaSR from osm_polygon AS PL 
where PL.name LIKE 'okres %'

-- vrati vsetky okresy SR a ich rozlohy a geometrie
select * from osm_polygon AS PL
where PL.name LIKE 'okres%' OR PL.name ='Bratislava'

select * from osm_polygon AS PL
where PL.name = 'slovensko' OR PL.name = 'SR'

-- vytiahnutie bodov (10 miest), ktore sa nachadzaju na uzemi SR a su zoradene podla velkosti 
--select P.name, P.place, P.population from osm_point AS P 
select * from osm_point AS P
join  (
select * from osm_polygon AS PL
where PL.name LIKE 'okres %'
) AS PL ON ST_Intersects(P.way,PL.way)
where P.population <> '' AND P.place <> 'village' AND P.place <> 'suburb' --AND P.name <> 'Slovensko'
order by P.population::int desc
limit 10

-- BA aj PP su town/city a maju populaciu... mozno maju zlu geometry... 	
select * from osm_point as P
where p.name = 'Bratislava' or p.name = 'Poprad'

select * from osm_polygon as P
where P.place = 'town' 
limit 10


--- starting----------------
SELECT amenity, name, ST_AsGeoJSON(ST_Transform(way,4326)) FROM osm_point WHERE amenity = 'arts_centre' AND name IS NOT NULL


-- pozicovna bicyklov
--"bicycle_rental", "bicycle_rental"
Select amenity, name,  ST_AsGeoJSON(ST_Transform(way,4326)) FROM osm_point WHERE amenity = 'bicycle_rental' AND name IS NOT NULL limit 50

--------------SPORTOVISKA
--points> sports centre, playground, picnic table
--polygons> park, pitch, garden, stadium ,swimming pool
select * from osm_point    as P where P.leisure IS NOT NULL limit 50
select * from osm_polygon  as P where P.leisure IS NOT NULL limit 50

		   -- dlazba
-- surface ?(asfalt, paved)
select * from osm_roads as R where R.surface IS NOT NULL limit 50


-- cyklochodniky v okoli, iba 152 vysledkov ak riesime povrch
select bicycle, foot, name, ST_AsGeoJSON(ST_Transform(way,4326)) from osm_roads as R where R.bicycle = 'yes' AND R.surface IS NOT NULL
-- 720 ak neriesimi povrch
select bicycle, foot, name, ST_AsGeoJSON(ST_Transform(way,4326)) from osm_roads as R where R.bicycle = 'yes' --AND R.surface IS NOT NULL

--------------------ZADANIE-----------
--- zaznamenavanie tras byciklom
-------------------------------------
          ----1.pamatanie si celej trasy
          --- 2.vypocet dlzky , prevysenia, ...
          --- 3.spatne zobrazenie trasy
          --- 4.hladanie cyklochodnikov, trasy ...
-------------------------------------
-- 1.pamatanie si celej trasy
-- insert into database own way into lineString(strat, begin, timeStamp)


 


 
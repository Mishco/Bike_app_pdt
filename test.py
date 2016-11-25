import psycopg2, urllib, zipfile, os
import psycopg2.extras
import sys
import json
from flask import Flask, render_template
from flask import request,redirect, Response
from flask import jsonify
import db
from geojson import Feature, Point, FeatureCollection

#  Bike application
#
#  zaznamenavanie tras byciklom
#  pamatanie si celej trasy
#  vypocet dlzky
#  spatne zobrazenie trasy
#  hladanie cyklochodnikov(Points), trasy(LineStrings)


dbg = "DEBUG: "
app = Flask(__name__)


#@app.route('/searchOnMap')
#def searchOnMap():
#    return render_template('index.html', myfunction=process)

#@app.route('/', methods=['POST'])
#def my_form_post():
#    text = request.form['fname']
 #   processed_text = text.upper()
 #   print(dbg + ":" + processed_text);
 #   data = {'original': text, 'newText': processed_text}
 #   #return processed_text
 #   return render_template('index.html.bak', data=json.dumps(data))


#@app.route('/manage_game', methods=['POST'])
#def manage_game():
#    start = request.form['action'] == 'Start'
#    game_id = request.form['game_id']
#
#    if start:
#        print(game_id + " true ")
#    else:
#        print(game_id + " false")
#
#   return redirect('index.html.bak')
@app.route('/map/close_place', methods=['GET'])
def api_hello():
    # gjsonLayer.loadURL('/map/close_place?distance='+ $("#custom-handle").html + '&lat=' + lat + '&lng=' + lng);
    cur = db.get_connection()
    _distance = request.args.get('distance')
    lat = request.args.get('lat')
    lng = request.args.get('lng')
    print(lat, lng)
    # lat = lat[:-8]
    # lng = lng[:-8]
    print(lat, lng)
    # km
    # 6371
    distance = int(float(_distance))*1000000
    print(distance)
    #cur.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, row_to_json((osm_id,name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(17 48)',4326),4326),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),4326))))) As properties FROM osm_point  limit 100  ) As f limit 100 )  As fc; ")
    cur.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, row_to_json((osm_id,name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" +str(lng) + " " + str(lat) + ")',4326),4326),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),4326))))) As properties FROM osm_roads where osm_roads.bicycle = 'yes'  and (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),4326),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),4326))) < "+str(distance)+"  ) As f  )  As fc; ")
    rows = cur.fetchall()
    print(rows)
    json_string = json.dumps(rows)
    fixed = json_string[2:]
    fixed = fixed[:-2]
    print(fixed)
    print(dbg + "rows was sent")
    return fixed


##########################################################################################
def connectionToDbs():
    try:
        conn = psycopg2.connect(dbname='osm', host='localhost', port=5432, user='postgres', password='123456789')
    except:
        print("I am unable to connect to the database")
    # basic
    #cur = conn.cursor()
    # access non only numeric, but name of column
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    print(dbg + "Succesfull connect into dbs")
    return cur
##########################################################################################
# not using
def testInsertIntoDBS(cur):
    namedict = ({"first_name": "Joshua", "last_name": "Drake"},
                {"first_name": "Steven", "last_name": "Foo"},
                {"first_name": "David", "last_name": "Bar"})
    cur.executemany("""INSERT INTO bar(first_name,last_name) VALUES (%(first_name)s, %(last_name)s)""", namedict)


##########################################################################################
@app.route('/map/rental', methods=['GET'])
def getBicycleRental():
    # 0.1 degree       | 11.1 km

    _distance = int(float(request.args.get('distance')))*1000
    lat = request.args.get('lat')
    lng = request.args.get('lng')
    cur = db.get_connection()

    cur.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json AS geometry , row_to_json((osm_id,name,amenity,(SELECT ST_Distance( 	ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),26986), 	ST_Transform(way,26986) )))) As properties FROM osm_point where amenity like 'bicycle_rental' and (SELECT ST_Distance(	ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),26986),	ST_Transform(way,26986)) < "+str(_distance)+"))  As f ) As fc;")

    #cur.execute("SELECT row_to_json(fc)FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type, ST_AsGeoJSON(way)::json, row_to_json((osm_id,name,amenity,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),26986),ST_Transform(way,26986))))) As properties FROM osm_point where amenity like 'restaurant' order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),26986),ST_Transform(way,26986))) < "+str(_distance)+") As f ) As fc;")

    #cur.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,"'"addr:housename"'","'"addr:housenumber"'",amenity,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),32647),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),32647 ))))) As properties FROM osm_point where (amenity like 'restaurant' or amenity like 'pub') and (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),32647 ),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),32647 ))) < "+str(_distance)+"  order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),32647 ),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),32647 ))) ) As f )  As fc; ")
    #cur.execute(
    #    " SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(BR.way,4326))::json As geometry, row_to_json((osm_id,name,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),4326),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),4326))))) As properties FROM (Select * FROM osm_point WHERE amenity = 'bicycle_rental') as BR   where (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + str(lng) + " " + str(lat) + ")',4326),4326),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),4326))) < "+str(_distance)+"   ) As f  )  As fc; ")
    rows = cur.fetchall()
    json_string = json.dumps(rows)
    print(dbg + json_string)
    fixed = json_string[2:]
    fixed = fixed[:-2]
    print(dbg + fixed)
    print(dbg + "rows was sent")
    return fixed


##########################################################################################
@app.route('/bike1', methods=['GET'])
def getClosestBicycleWay():
    cur = db.get_connection()
    #cur.execute("select bicycle, foot, name, ST_AsGeoJSON(ST_Transform(way,4326)) from osm_roads as R where R.bicycle = 'yes'")
    #cur.execute("select ST_AsGeoJSON(ST_Transform(way,4326)) from osm_roads as R where R.bicycle = 'yes'")

    # TATO MOZNOST
    cur.execute("select row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry FROM osm_roads as R where R.bicycle = 'yes' ) as f ) as fc;")
  #  cur.execute("SELECT row_to_json(f) As feature FROM (SELECT 'Feature' As type, ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, row_to_json((SELECT l FROM (SELECT osm_id AS feat_id) As l)) As properties FROM osm_roads As l limit 1000 ) As f;")

    #cur.execute("select st_asgeojson(ST_Transform(r.way,4326))from osm_point as r limit 1000;")

    # Find the distance within 1 km of point-of-interest
    # poi = [-124.3, 53.2] # longitude, latitude


    # toto funguje
    #cur.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features  FROM (SELECT 'Feature' As type    , ST_AsGeoJSON(ST_Transform(lg.way,4326))::json As geometry    , row_to_json((SELECT l FROM (SELECT osm_id, name) As l      )) As properties   FROM osm_point As lg limit 10  ) As f )  As fc;")

    rows = cur.fetchall()

    #for row in cur.fetchall():
    #    print(row)

    #for row in rows:
    #    print(" ", row[0], " ", row[2], " ")
    print(rows)

    json_string = json.dumps(rows)
    fixed = json_string[2:]
    fixed = fixed[:-2]

    print(fixed)
    #resp.status_code = 200

    print(dbg + "rows was sent")
    #resp.headers['Link'] = 'http://luisrei.com'

    return fixed
    #return jsonify(result=getBikeTrails(**request.args))


@app.route('/map/search', methods=['GET'])
def searchByName():
    cur = db.get_connection()
    search_name = request.args.get('string')
    lng = request.args.get('lng')
    lat = request.args.get('lat')

    #    cur.execute("select * from osm_point where leisure is not null or amenity = 'bicycle_rental' and to_tsvector('sk', name) @@ to_tsquery('sk', '" + search_name + "');")
    cur.execute("SELECT row_to_json(fc) FROM (	SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features	FROM (		SELECT 'Feature' As type , ST_AsGeoJSON(ST_Transform(way,4326))::json As geometry, row_to_json((			osm_id,name,amenity, place,(			SELECT ST_Distance(			ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),			ST_Transform(way, 26986)			)			))) As properties		FROM (			SELECT ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', '"+search_name+"')) rank, * from osm_point			where (amenity like 'bicycle_rental' or place like 'town' or place like 'city' or place like 'village' or place like 'suburb')  and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"')			order by rank desc) as foo 		order by (		SELECT ST_Distance(		ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),		ST_Transform(way ,26986)))  ) As f )  As fc;")

    rows = cur.fetchall()
    # for row in rows:
    #    print(" ", row['way'], " ", row['name'], " ")

    # result = cur.fetchone()
    # print(result['way'])
    # my_feature = Feature(geometry=Point(result['way']))
    # print(my_feature)
    # featuresCollection = FeatureCollection([my_feature])
    # print(featuresCollection)

    json_string = json.dumps(rows)
    fixed = json_string[2:]
    fixed = fixed[:-2]
    print(fixed)
    return fixed
##########################################################################################
#                                    main function                                       #
##########################################################################################
@app.route("/")  # consider to use more elegant URL in your JS
def main():
    # Initialize 'cur' variable
    # cur = connectionToDbs()

    # testSelectFromDbs(cur)
    # getBicycleRental()
    # getClosestBicycleWay(cur)
    print(dbg + "mapbox")

    return render_template('index.html')
    pass

# open map in external javascript
@app.route("/openMap.js")
def open():
    return render_template('openMap.js')


# end of main function
if __name__ == "__main__":
    app.run()
    #main()
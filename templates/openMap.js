var map;

var layerTerrain;
var layerToner;

function writeSentece(sentence) {
    document.getElementById('fnameRoute').innerHTML = sentence;
}
/*
function openShow() {
  var lat = 48.15254876091117;
  var lng = 17.100111703872677;
  mapboxgl.accessToken = 'pk.eyJ1IjoibWlzaGNvcyIsImEiOiJjaXZkazR4eWgwMDQ2MnltcXBxaTJnanhkIn0.9ChoVM13d8b9YJRFtwJnkg';

  map = new mapboxgl.Map({
    container: 'map', // container id
    style: 'mapbox://styles/mapbox/streets-v9', //stylesheet location
    center: [lng,lat], // starting position
    zoom: 14                  // starting zoom
  });

  var my_position = [lng,lat];

     // create the popup
    var popup = new mapboxgl.Popup({offset:[0, -30]})
        .setText('Actual Position');

    // create DOM element for the marker
    var el = document.createElement('div');
        el.id = 'marker';

    // create the marker
  var currentPosition = new mapboxgl.Marker(el, {offset:[-25, -25]})
        .setLngLat(my_position)
        .setPopup(popup) // sets a popup on this marker
        .addTo(map);


  // Actual position user
  // Add geolocate control to the map.
  map.addControl(new mapboxgl.GeolocateControl());

  map.on('mousemove', function (e) {
    //document.getElementById('info').innerHTML =
    //document.getElementById('infoLong').innerHTML = JSON.stringify(e.lng);

    var obj = JSON.parse( JSON.stringify(e.lngLat) );
        document.getElementById('infoLat').innerHTML = obj.lng;
        document.getElementById('infoLong').innerHTML = obj.lat;
        lat = obj.lat
        lng = obj.lng;
  });
/*
  var gjsonLayer = mapboxgl.featureLayer().addTo(map);


   $("#find_distance").click(function(event) {
    event.preventDefault();
    gjsonLayer.loadURL('/map/close_place?distance='+ $("#range_value").val() + '&lat=' + lat + '&lng=' + lng);
  });
*//*
   map.on('click', function(e) {

        //map.setLayoutProperty("my_position", 'visibility', 'none');

        var obj = JSON.parse( JSON.stringify(e.lngLat) );

        my_position = [obj.lng, obj.lat];
        var el = document.createElement('div');
            el.id = 'marker';
        var my_position=[obj.lng,obj.lat];
        new mapboxgl.Marker(el, {offset:[-25, -25]})
            .setLngLat(my_position)
            .addTo(map);

   });

/*
  var button = document.getElementById('btnSend');
  button.on('click', function(e)
  {
      document.getElementById('inputSearch').innerHTML = "TOTO";
      document.getElementById('infoLong').innerHTML = "NIECO";
  });
*/
/*
  var countOfClicked = 0;
  var c, c2, prevClick;

  map.on('click', function(e) {
        // map.removeChild(Marker)
        // mapboxgl.removeChild(my_position);
        var obj = JSON.parse( JSON.stringify(e.lngLat) );

        if (countOfClicked < 1)
        {
            firstAddLng = obj.lng;
            firstAddLat = obj.lat;

            countOfClicked++;
        } else {
            c = prevClick;
            countOfClicked = 0;
        }
        c2 = obj.lng;
        my_position[c2,c];

        // var obj = JSON.parse( JSON.stringify(e.lngLat) );
        // my_position = [obj.lng,obj.lat];

        var el = document.createElement('div');
            el.id = 'marker';
        var my_position=[obj.lng,obj.lat];
        new mapboxgl.Marker(el, {offset:[-25, -25]})
            .setLngLat(my_position)
            .addTo(map);
  });
*/
/*
  map.on('load', function () {
    map.addSource("points", {
        "type": "geojson",
        "data": {
            "type": "FeatureCollection",
            "features": [{
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [17.05238901390978, 48.163188059745586]
                },
                "properties": {
                    "title": "TEST BOD 1",
                    "icon": "monument"
                }
            }, {
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [17.0414, 48.1776]
                },
                "properties": {
                    "title": "Test bod 2",
                    "icon": "harbor"
                }
            }]
        }
    });

    map.addLayer({
        "id": "points",
        "type": "symbol",
        "source": "points",
        "layout": {
            "icon-image": "{icon}-15",
            "text-field": "{title}",
            "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
            "text-offset": [0, 0.6],
            "text-anchor": "top"
        }
    });




   });
*/

/*
  var touches = touchEvent.touches;
  map.on('click', function(e) {

   // Invoke the appropriate handler depending on the
   // number of touch points.
   switch (e.touches.length) {
     case 1: handle_one_touch(e); break;
     case 2: handle_two_touches(e); break;
     case 3: handle_three_touches(e); break;
     default: console.log("Not supported"); break;
   }
 }, false);

*/


//} // end of function openShow()

function cycle(markers) {
    var i = 0;
    function run() {
        if (++i > markers.length - 1) i = 0;
        map.setView(markers[i].getLatLng(), 12);
        markers[i].openPopup();
        window.setTimeout(run, 3000);
    }
    run();
}
var my_position;
var directions;
function openShow2() {

//  L.mapbox.accessToken = 'pk.eyJ1IjoicGEzayIsImEiOiJjaXR4ZzVuNnkwMDQ1MnNuMjQzZXh2N2w2In0.dju67E08KTofwOCQqYKPbA';
//  moj token
  L.mapbox.accessToken = 'pk.eyJ1IjoibWlzaGNvcyIsImEiOiJjaXZkazR4eWgwMDQ2MnltcXBxaTJnanhkIn0.9ChoVM13d8b9YJRFtwJnkg';
  var current_location_icon = L.mapbox.marker.icon({
    'marker-size': 'large',
    'marker-symbol': 'embassy',
    'marker-color': '#fa0'
  });

  var lat = 48.15254876091117;
  var lng = 17.100111703872677;

  // global value map
  map = L.mapbox.map('map')
      .setView([lat, lng], 14);


  var styleLayer = L.mapbox.styleLayer('mapbox://styles/mapbox/streets-v9')
      .addTo(map);

  var gjsonLayer = L.mapbox.featureLayer().addTo(map);
        gjsonLayer.loadID('mapbox.dark');

  var ResultGjsonLayer = L.mapbox.featureLayer()
  .on('ready',function(e) {
        //map.fitBounds(ResultGjsonLayer.getBounds());
        //map.setView([lat,lng],14);

        var markers = [];
        this.eachLayer(function(marker) {
            marker.bindPopup("<p>" + marker.feature.properties.f2 + "</p>");
            var place = marker.feature.properties.f4;
            // marker for amenity = 'bicycle rental'
            var amenity = marker.feature.properties.f3;
            if(amenity =='bicycle_rental')
            {

                marker.setIcon(L.icon({
                    className: 'my-icon icon-sf', // class name to style
                    html: '&#9733;', // add content inside the marker
                }));

                marker.setIcon(L.mapbox.marker.icon({
                            'marker-color': '#BA1A1A',
                            'marker-symbol': "bicycle",
                            'description': "city or town"
                }));

//                marker.setIcon(L.mapbox.marker.icon({
//                            'marker-color': '#1E90FF',
//                            'description': "city or town",
//                            icon:'icon github'
//                }));

                //stop show other markers
            }
            // marker for cities
            if (place == 'city' || place =='town' )
            {
                marker.setIcon(L.mapbox.marker.icon({
                            'marker-color': '#BA1A1A',
                            'marker-symbol': "city",
                            'description': "city or town"
                }));
            }
            // marker for suburb and village
            if(place =='suburb' || place == 'village')
            {
                marker.setIcon(L.mapbox.marker.icon({
                            'marker-color': '#D2691E',
                            'marker-symbol': "village",
                            'description': "village"
                }));
            }
            markers.push(marker);
        });
        // cycle(markers);
        i=0
        map.setView(markers[i].getLatLng(), 12);
        markers[i].openPopup();


        // Add each marker point to the heatmap.
        ResultGjsonLayer.eachLayer(function(e) {
            // ResultGjsonLayer.addLatLng(e.getLatLng());
            // map.setView([e.latLng.lat, e.latLng.lng], 14);
        });
  })
  .addTo(map);

  //heat = L.heatLayer([], { maxZoom: 12 }).addTo(map);




   my_position = L.marker([lat,lng], {
    icon: current_location_icon
  }).addTo(map);



  // on load
  $("#infoLat").html("Marker position: LatLng(" + (Math.round(lat)*10000 / 10000) + ", " + (Math.round(lng)*10000 / 10000));


  map.on('click', function(e) {
    map.removeLayer(my_position);
    $("#infoLat").html("Marker position: " + e.latlng);
    $("#infoLong").html(Math.round((e.latlng.lng) * 1000 )/1000);
    lat = e.latlng.lat;
    lng = e.latlng.lng;
    my_position = L.marker([e.latlng.lat, e.latlng.lng], {
      icon: current_location_icon
    }).addTo(map);
  });

  map.on('mousemove', function (e) {
        // console.log(e.latlng.lng);
        $("#infoLatMouse").html("Mouse position: " + e.latlng);
        $("#infoLongMouse").html(Math.round((e.latlng.lng) * 10000 )/10000);
  });

  var baseLayers = {
	"Terrain": layerTerrain,
	"Toner": layerToner
  };

  $(document).on('input change', '#slider', function() {
        $('#slider_value').html( $(this).val() );
  });

  $("#btnSend").click(function(event){
    event.preventDefault();
    var searchText = $("#inputSearch").val();
    console.log(searchText)
    ResultGjsonLayer.loadURL('/map/search?string='+$("#inputSearch").val() + '&lat=' + lat + '&lng=' + lng);
  });

  $("#btnBike").click(function(event) {
    event.preventDefault();
    gjsonLayer.loadURL('/map/close_place?distance='+ $("#custom-handle").html() + '&lat=' + lat + '&lng=' + lng);
    gjsonLayer.loadURL('/map/rental?distance='+ $("#custom-handle").html() + '&lat=' + lat + '&lng=' + lng);
  });


  $("#btnRoute").click(function(event) {
    event.preventDefault();
    addMyRoute();
    //  change name of button
    $("btnRoute").attr("value", "OFF");
    map.zoomControl.remove();
  });

  $(checkbox2).click(function() {
    if ($('#checkbox2').is(':checked')) {
        console.log("enable bike trails");
        var res = gjsonLayer.loadURL('/bike1');
    }else {
        /// TO DO
          /// second click...
        ///
    }
  });
  var featureGroup;
  var drawControl;

  $(drawing).click(function()
  {
    if($('#drawing').is(':checked'))
    {
      console.log("Enable drawing");
      featureGroup = L.featureGroup().addTo(map);

      drawControl = new L.Control.Draw({
        edit: {
        featureGroup: featureGroup
        }
      }).addTo(map);

      map.on('draw:created', function(e) {
          featureGroup.addLayer(e.layer);
      });
    }
    else
    {
       // hide drawing control
       console.log("Hide drawing")

       // remove layer and controller
       map.removeLayer(featureGroup);
       map.removeControl(drawControl);
    }
  });

    $("#close").click(function(event) {
        event.preventDefault();
        $('#directions').hide();
        $('#inputs').hide();
        $('#errors').hide();
        $('#routes').hide();
        $('#instructions').hide();
        // add
        L.zoomControl.addTo(map);
    });
    // move the attribution control out of the way
    map.attributionControl.setPosition('bottomleft');

    // create the initial directions object, from which the layer
    // and inputs will pull data.
    directions = L.mapbox.directions();

    var directionsInputControl = L.mapbox.directions.inputControl('inputs', directions)
    .addTo(map);
    var directionsErrorsControl = L.mapbox.directions.errorsControl('errors', directions)
    .addTo(map);
    var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
    .addTo(map);
    var directionsInstructionsControl = L.mapbox.directions.instructionsControl('instructions', directions)
    .addTo(map);

    $('#directions').hide();
    $('#inputs').hide();
    $('#errors').hide();
    $('#routes').hide();
    $('#instructions').hide();
//
//  $("#find_sports").click(function(event) {
//    event.preventDefault();
//    gjsonLayer.loadURL('/map/one_sport?sport='+ $("#sports").val());
//  });

}

function addMyRoute() {
    var directionsLayer = L.mapbox.directions.layer(directions)
        .addTo(map);

    // temporary remove marker
    map.removeLayer(my_position);

    $('#directions').show();
    $('#inputs').show();
    $('#errors').show();
    $('#routes').show();
    $('#instructions').show();

    // remove zoom control
    map.zoomControl.remove();
}


/// Pouzivatel moze pridat do mapy co chce
/// Features:
///
/// prida featury do mapy
var firstTime = 0;
function showFeaturesIntoMap() {
        console.log("add into map terrain features");

        var featureLayer2 = L.mapbox.featureLayer()
            .addTo(map);

    // loads markers from the map `mapbox.dark` on Mapbox,
    // if that map has markers
    //featureLayer2.loadID('mapbox.mapbox-terrain-v2');


        if (firstTime < 1) {
            // replace "toner" here with "terrain" or "watercolor"
            layerTerrain = new L.StamenTileLayer("toner");
            map.addLayer(layerTerrain);
        } else {
            map.addLayer(layerTerrain);
        }
        firstTime++;
}
function hideFeaturesFromMap() {
      map.removeLayer(layerTerrain);
}

/// parameter: round - okruh do akej vzdialnosti od aktualnej pozicie
///                    sa bude pozerat a hladat chodniky
function getBikeTrails() {

    getBikeTrails

//    console.log("receive data from db");
//    var xhr = ("XMLHttpRequest" in window) ? new XMLHttpRequest() : new ActiveXObject("Msxml3.XMLHTTP");
//    xhr.open("GET", 'http://127.0.0.1:5000/bike1', true);
//    xhr.onreadystatechange = function() {
//    if (xhr.readyState === 4)  {
//        var serverResponse = xhr.responseText;
//
//        processingBikeTrails(xhr.responseText)
//      }
//    };
//    xhr.send(null);
}

function processingBikeTrails(theRouteJsonText) {
    //var arr_from_json = JSON.parse( theRouteJsonText );
    //console.log(arr_from_json[0]);



    //var result = theRouteJsonText.substring(1, theRouteJsonText.length-1);
    //var arr_from_json = JSON.parse( theRouteJsonText );
    console.log(theRouteJsonText[1]);




  /* theCoords = {
    "type": "LineString",
    "coordinates": [
        [22.2265242354981,48.9999843586668],
        [22.2279869622752,49.0006090636694]
        ]
    };

    console.log(theCoords);
    */



 /*  map.addSource("route", {
    "type": "geojson",
    "data" : arr_from_json[0]
   });
*/

    map.addSource("route", {
     "type": "geojson",
     "data": {
       "type": "FeatureCollection",
       "features": theRouteJsonText
     }
   });
    map.addLayer({
        "id": "route",
        "type": "line",
        "source": "route",
        "layout": {
            "line-join": "round",
            "line-cap": "round"
        },
        "paint": {
            "line-color": "#888",
            "line-width": 8
        }
    });


  /*  map.addSource('bike-data', {
                type: 'vector',
                url: 'http://127.0.0.1:5000/bike1'
            });
     map.addLayer({
                "id": "bike-data",
                "type": "line",
                "source": "bike-data",
                "source-layer": "contour",
                "layout": {
                    "line-join": "round",
                    "line-cap": "round"
                },
                "paint": {
                    "line-color": "#ff69b4",
                    "line-width": 2
                }
            });
 */

}

function lanesStyle(err, style){

}


/*
function addCurrentPosition() {

// Create a featureLayer that will hold a marker and linestring.
var featureLayer = L.mapbox.featureLayer().addTo(map);
var secondFeatureLayer = L.mapbox.featureLayer().addTo(map);

// 1. Let's create a counter so that we can record the separate clicks
var counter = 0;

// 2. Let's use some variables outside the function scope
var c,
    c2,
    prevClick;

map.on('click', function(ev) {

    // 3. Check if we've yet to click once
    if (counter < 1) {

        // 4. assign current click coordinates to prevClick for later use
        prevClick = ev.latlng;

        // ev.latlng gives us the coordinates of
        // the spot clicked on the map.
        c = ev.latlng;

        counter++;
    } else {
        c = prevClick;
        counter = 0;
    }

    c2 = ev.latlng;

    var geojson = [
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [c.lng, c.lat]
        },
        "properties": {
          "marker-color": "#ff8888"
        }
      },
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [c2.lng, c2.lat]
        },
        "properties": {
          "marker-color": "#ff8888"
        }
      },{
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [c.lng, c.lat],
            [c2.lng, c2.lat]
          ]
        },
        "properties": {
          "stroke": "#000",
          "stroke-opacity": 0.5,
          "stroke-width": 4
        }
      }
    ];

    secondFeatureLayer.setGeoJSON(geojson);

    // Finally, print the distance between these two points
    // on the screen using distanceTo().
    var container = document.getElementById('distance');
    container.innerHTML = (c2.distanceTo(c)).toFixed(0) + 'm';
});


var geolocate = document.getElementById('geolocate');
if (!navigator.geolocation) {
    geolocate.innerHTML = 'Geolocation is not available';
} else {
    geolocate.onclick = function (e) {
        e.preventDefault();
        e.stopPropagation();
        map.locate();
    };
}

// Once we've got a position, zoom and center the map
// on it, and add a single marker.
map.on('locationfound', function(e) {
    map.fitBounds(e.bounds);

    featureLayer.setGeoJSON({
        type: 'Feature',
        geometry: {
            type: 'Point',
            coordinates: [e.latlng.lng, e.latlng.lat]
        },
        properties: {
            'title': 'Here I am!',
            'marker-color': '#ff8888',
            'marker-symbol': 'star'
        }
    });

    // And hide the geolocation button
    geolocate.parentNode.removeChild(geolocate);



});
// If the user chooses not to allow their location
// to be shared, display an error message.
map.on('locationerror', function() {
    geolocate.innerHTML = 'Position could not be found';
});
}
*/


//        var distance = $("#custom-handle").html();
//        console.log(distance);

//        var district_boundary = new L.geoJson();
//        district_boundary.addTo(map);
//
//
//        $.ajax({
//        dataType: "json",
//        url: "/bike1",
//        success: function(data) {
//            $(data.features).each(function(key, data) {
//                district_boundary.addData(data);
//            });
//        }
//        }).error(function() {});
//
//        district_boundary.addTo(map);
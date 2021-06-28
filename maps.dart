import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:covid/aboutUs.dart';
class Maps extends StatefulWidget {


  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller=Completer();

  static const LatLng _center=const LatLng(12.9716,77.5946);
  final Set<Marker> _markers={};
  Marker temp;
  LatLng _lastMapPosition=_center;
  LatLng dragEndPosition;
  MapType _currentMapType =MapType.normal;
  var currentLocation;
  bool toggle=false;
  var peopleLocations;
  String val;
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);


  }


  _onCameraMove(CameraPosition position){

    _lastMapPosition=position.target;


  }


  void initState(){
    super.initState();
    Geolocator().getCurrentPosition().then((currloc){
      setState(() {
        currentLocation=currloc;
        toggle=true;
        populatePeople();
      });

    });
  }


  Widget button(Function function,IconData icon,tag){
    return FloatingActionButton(
      heroTag: tag,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon,size:36.0),
    );
  }


  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType=_currentMapType==MapType.normal?MapType.satellite:MapType.normal;

    });
  }

    Future<String> createAlertDilog(BuildContext context){
     TextEditingController customcontroller=TextEditingController();
      return showDialog(context:context,builder: (context){
        return AlertDialog(
          title: Text("Approximate number of people present and any detail if necessary"),
          content: TextField(
            controller: customcontroller,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
                child:Text('Submit'),
                onPressed: (){
                Navigator.of(context).pop(customcontroller.text.toString());
                },
            )
          ],
        );
      }
      );
    }

  Future<String> createMarkerAdded(BuildContext context){

    return showDialog(context:context,builder: (context){
      return AlertDialog(
        title: Text("Marker Added Successfully!Thanks for contributing."),

        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child:Text('Okay'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
    );
  }


  _onAddMarkerButtonPressed(){

    createAlertDilog(context).then((onValue) {
      setState(() {
        val = onValue;
        _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          draggable: true,
          infoWindow: InfoWindow(
            title:val,


          ),
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: (value){
            setState(() {
              if(value==Null)
                dragEndPosition=LatLng(currentLocation.latitude, currentLocation.longitude);
              else
                dragEndPosition=value;

            });
          }
        ));
      });
    });




  }


  populatePeople()
  {
    peopleLocations=[];
    Firestore.instance.collection('hlmarkers').getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        for(int i=0;i<docs.documents.length;i++)
          {
            peopleLocations.add(docs.documents[i].data);
            initMarker(docs.documents[i].data);

          }

      };
    });

    
  }

  initMarker(peopleLocation)
  {
    setState(() {
      _markers.add(Marker(
          markerId:MarkerId(LatLng(peopleLocation['latlong'].latitude,peopleLocation['latlong'].longitude).toString()),
          position: LatLng(peopleLocation['latlong'].latitude,peopleLocation['latlong'].longitude),
          infoWindow: InfoWindow(
              title: peopleLocation['no'],


          )

        ));

      });

  }


  Future<void> addData(coordinates,no) async {
    print(coordinates);
    Firestore.instance.collection('hlmarkers')
        .add({'latlong':GeoPoint(coordinates.latitude,coordinates.longitude),'no':no})
        .catchError((e) {print(e);});

  }
  _fixlocation()
  { createMarkerAdded(context);
    addData(LatLng(dragEndPosition.latitude,dragEndPosition.longitude),val);

    populatePeople();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Homeless Map',style: TextStyle(fontSize: 18.0)),
      backgroundColor: Colors.blue,
        actions: <Widget>[
         Hero(
            tag:'btn5',
             child:FlatButton.icon(

            icon:Icon(Icons.error,color: Colors.white,),
            label: Text('Help',style: TextStyle(color: Colors.white
            ),),


            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>aboutUs()));


            },
          )),


        ],
      ),
     body:Stack(
       children: <Widget>[Container(height:MediaQuery.of(context).size.height-80.0,
           width:double.infinity,
           child:toggle?
         GoogleMap(
           onMapCreated: _onMapCreated,
           initialCameraPosition: CameraPosition(
               target:LatLng(currentLocation.latitude,currentLocation.longitude),zoom: 6.0 ),
           mapType: _currentMapType,
           markers:_markers,
           onCameraMove: _onCameraMove,
           myLocationEnabled:true,

         ):Center(child:Text('Loading... Please wait'))),
         Padding(
           padding: EdgeInsets.all(16.0),
           child:Align(
             alignment:Alignment.topRight,
             child:Column(
               children: <Widget>[
                 button(_onMapTypeButtonPressed,Icons.map,'1'),
                 SizedBox(height:16.0,),
                 button(_onAddMarkerButtonPressed, Icons.add_location,'2'),
                 SizedBox(height:16.0,),
                 button(_fixlocation, Icons.add_circle,'3')
               ],
             )
           )
         )
       ],
     )
    );
  }
}


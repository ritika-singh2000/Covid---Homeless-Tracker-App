
import 'package:flutter/material.dart';


class aboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Read Me'),
      backgroundColor: Colors.blue,

      ),
      body:SingleChildScrollView(child: Container(child:Column(children:[Text('\n\tPurpose',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold), ),
        Text('The goal behind putting this application into circulation is to help the ones serving the homeless people with food or other basic needs easily find them in this time of distress.'),
        Text('1.Each marker indentifies the location of a group of homeless people.\n\n2.Tap on the marker for more information\n\n3.If you find a homeless person while you are travelling to buy groceries or other needs,'
            'after coming back home open the app press the marker button(Second button floating above Map).\n\n4.Enter the details in the dialog box,once the marker appers in the middle of the screen long press and DRAG it to the exact location where you spotted them.'
            '\n\n5.Then press the \'+\' button(Last button floating on screen) to fix the location.\n\n6.Now this location can be used by someone who is helping those in need.'),
            Text(
            '\n\n7.Please share this application to as many people as possible so that it is used efficienty and make sure you are as accurate as possible while putting markers.'
                '\n\n8.TIP:Zoom into the location before adding the marker for ease of use.',style:TextStyle(fontWeight: FontWeight.bold)),

        Text('Warning',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
        Text(
            '\n\n1.We do not recommend people stopping on the road to mark locations of homeless people.Your safety is the main priority.'
              '\n\n2.Homeless people identified will be helped by the government or organisations with permissions please do not venture out of your homes.On your part just add the location on identifying someone on the road.\n'
            '\n\n3.This app was developed in a very short duration, it might have a few bugs.\n\n5.We are not responsible for any data provided in the app and it might not be completely accurate.'
                '\n\n4.We have not partnered with any organization, we hope someone helping these people will have our App and use the locations plotted by other users'
        ),
        Text('About Us',style:TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold) ),
        Text('We are a group of students from BMSIT who wanted to contribute our part to the society in the fight against Covid-19.We are welcome to suggestions , or any other idea which we can implement to help this society fight Covid-19.\n\n'
            'E:4rleoteam@gmail.com'),
        Text('Stay Home,Stay Safe.',style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.bold))
      ]),padding:EdgeInsets.all(20.0))

    ));

  }
}

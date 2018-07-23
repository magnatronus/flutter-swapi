import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapi/api.dart';
import 'dart:convert';
import 'package:swapi/list.dart';

///
/// Stateful List Widget
/// 
class SwApiHome extends StatefulWidget {
  _SwApiHomeState createState() => _SwApiHomeState();
}

///
/// State for our List
///
class _SwApiHomeState extends State<SwApiHome>{

  SWAPI _api = SWAPI();
  bool firstTime = false;
  List rootList = List();
  final introText = "It looks like this is the first time you have run the app so we are showing some help.\n\n"
  "The next time you start the app this screen should not appear due to the setting of a local shared preference.\n\n"
  "To see this message again just delete the app from the device first.\n\n"
  "Anyway as the button below says....";


  @override
  void initState() {

    super.initState();

    // check if this is first time run
    SharedPreferences.getInstance().then( (prefs) {
      
      // now get our initial list of SWAPI options
      _api.getRoot().then( (result) {
        if(result.statusCode == 200){
          jsonDecode(result.body).forEach( (k, v) {
            rootList.add({'name': k, 'url': v});
          });
        }
        setState(() {
          firstTime = (prefs.getBool("first-time") ?? true);    
        });
      });

    });    
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Star Wars API Demo")
      ),
      body: (firstTime)?showIntro(context):showList(context)
    );

  }

  /// Create our list tile entry
  Widget optionEntry(item) {

    return ListTile(
      leading: Icon(Icons.assignment),
      title: Text(item['name']),
      onTap: () {
        MaterialPageRoute screen = MaterialPageRoute(builder: (context) => ListScreen(item['name'], item['url'], [{'name': "Loading, please wait....", 'loading': true}]));
        Navigator.push(
          context,
          screen,
        );
      },
    );

  }

  /// Create our list of root Options
  Widget showList(BuildContext context){

    return ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) => optionEntry(rootList[index]),
      itemCount: rootList.length,
    );

  }

  /// Return an intro screen for displaying the first time the app is run
  Widget showIntro(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome to the SWAPI API Demo",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0)

          ),
          SizedBox(height:15.0),
          Text(introText),
          SizedBox(height:15.0),
          RaisedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("first-time", false);
              setState(() {
                firstTime = false;               
              });
            },
            child: Text("May the Force be with you"),
          )

        ],
      )
    );

  }

}
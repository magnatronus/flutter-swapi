import 'package:flutter/material.dart';
import 'package:swapi/api.dart';
import 'dart:convert';


class ListScreen extends StatefulWidget {

  final String name;
  final String url;
  final List blank;

  const ListScreen(this.name, this.url, this.blank): super();

  _ListScreenState createState() => _ListScreenState();

}


class _ListScreenState extends State<ListScreen> {

  List data = List();
  SWAPI _api = SWAPI();

  /// Decide what icon to display 
  Icon getListIcon() {
    switch(widget.name){
      case 'people': return Icon(Icons.person);
      case 'planets': return Icon(Icons.public);
      case 'films': return Icon(Icons.local_movies);
      case 'species': return Icon(Icons.android);
      case 'vehicles': return Icon(Icons.motorcycle);
      case 'starships': return Icon(Icons.flight_land);
      default: return Icon(Icons.description);
    }
  }

  /// What is the name of the main title field (films just had to be different)
  String getTitleField() {
    switch(widget.name){
      case 'films': return "title";
      default: return "name";
    }
  }

  @override
  initState(){
    super.initState();

    // Set initial Loading Message
    data = widget.blank;

    // Now Query API for List information
    _api.getRawDataFromURL(widget.url).then( (result) {
      if(result.statusCode==200){
        setState(() {
          data = jsonDecode(result.body)['results'];  
        });
      }
    });

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar( title: Text(widget.name)),
      body: ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) => listEntry(data[index]),
      itemCount: data.length
      )
    );

  }

  Widget listEntry(item){
    
    if(item['loading']!= null){

      return Padding(
        padding: EdgeInsets.all(40.0),
        child: Text(item['name'], textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)
        )
      );

    } else {

      var children = List<ListTile>();
      item.forEach( (k,v){
        bool url = v.toString().indexOf("http") != -1;
        bool date = (k=="created" || k=="edited");
        if(v!=null && !url && !date){
          children.add(ListTile(title: Text('$k: $v')));
        }
      });
      
      return ListTile(
        leading: getListIcon(),
          title: ExpansionTile(
            title: Text(item[getTitleField()]),
            children: children,
          )
      );

    }

  }
}

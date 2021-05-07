import 'dart:io';

import 'saveLoad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'Bulb.dart';
import 'expTile.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> allBulbs = [
  'E10','E11','E12','E14','E17',
  'E26','E27','E39','E40','EX39',
  'GU10','GU24','G4','GU4','GU5.3',
  'GY6.35','GU8','GY8','GY8.6','G9','G12','MINI BI-PIN','MEDIUM BI-PIN','SINGLE BI-PIN','BA15d','BA15s','SC',
];

List<String> allRooms = [
  'Kitchen','Bedroom','Bathroom'
];

List<String> bulbColours = [
  'Daylight','Natural White','Cool White','Warm White','Soft White'
];

List<Bulbs> CurList = [];
List<overviewStats> ovStats = [];

String SelectedRoom = 'Bulb Mate';

var currentList;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchRooms();
  //await clearPrefs();
  runApp(MaterialApp(
    title: "Bulb Mate",
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget{
  HomePage createState()=> HomePage();
}

class HomePage extends State<MainPage>{

  String text = "Bulb Mate";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SelectedRoom),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateNewEntry()),
              );
            }
          )
        ],
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
          child: Column(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  shrinkWrap: true,
                children: <Widget>[
                  DrawerHeader(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: <Color>[Colors.lightBlue, Colors.blueAccent])),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('images/bulb.png',width: 60, height: 60),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Bulb Mate', style: TextStyle(color: Colors.white,fontSize: 20.0),),
                            )
                          ],
                        ),
                      )),
                  //CustomListTile(Icons.add,'Add Room',()=>{}),
                  CustomListTile(Icons.home,'Overview',(){
                    this.setState((){
                      text = "Overview.";
                      SelectedRoom = 'Bulb Mate';
                      currentList = HomeView();
                    });
                    Navigator.of(context).pop();

                  },()=>{}),
                ],
              ),

              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(padding: const EdgeInsets.fromLTRB(0.0, 6.0, 16.0, 9.0),
                            child: IconButton(
                              icon: new Icon(Icons.add_circle,size: 50,color: Colors.blueAccent,),
                              onPressed: () { _displayTextInputDialog(context); },
                            )
                        ),
                      ],
                    ),


              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allRooms.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(Icons.lightbulb, allRooms[index], (){
                        this.setState((){
                          text = allRooms[index];
                          SelectedRoom = text;
                          RoomToList(text);
                          currentList = bulbListView();
                        });
                        Navigator.of(context).pop();
                      },() async{

                        if (await confirm(
                          context,
                          title: Text('Confirm'),
                          content: Text('Would you like to remove ' + allRooms[index] + '?'),
                          textOK: Text('Yes'),
                          textCancel: Text('No'),
                        )) {
                          this.setState((){
                            removeRoom(allRooms[index]);
                            allRooms = allRooms;
                            Route route = MaterialPageRoute(
                                builder: (context) => MainPage());
                            SelectedRoom = 'Bulb Mate';
                            currentList = HomeView();
                            Navigator.push(context, route);
                          });
                        }
                        //Navigator.pop(context);
                      });
                    }),)
            ],
          ),

      ),
      body: currentList ?? HomeView(),
    );
  }
}

class CustomListTile extends StatelessWidget {

  IconData icon;
  String text;
  Function onTap;
  Function longpress;

  CustomListTile(this.icon,this.text,this.onTap,this.longpress);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400))
        ),
        child: InkWell(
          splashColor: Colors.lightBlue,
          onTap: onTap,
          onLongPress: longpress,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


_launchURL(String bulb) async {
  final Uri uri = Uri(
    scheme: 'https',
    path: 'www.amazon.co.uk/s?k=' + bulb,
/*    queryParameters: {
      'name': 'Woolha dot com',
      'about': 'Flutter Dart'
    },*/
  );

  final url = 'https://www.amazon.co.uk/s?k=E10';

  if (await canLaunch(url)) {
    await launch(uri.toString());
  } else {
    print('Could not launch $url');
  }
}

class BuldListTile extends StatelessWidget {

  String imageLoc;
  String Name;
  String Watts;
  String Quantity;
  String Colour;
  Function longPress;
  Function onTap;

  BuldListTile(this.imageLoc,this.Name,this.Watts,this.Colour,this.Quantity,this.longPress,this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))
        ),
        child: InkWell(
          splashColor: Colors.lightBlue,
          onLongPress: longPress,
          onTap: onTap,
          child: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                  Image.asset(imageLoc,width: 60, height: 60),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(Name + "\n" + Watts + "w\n" + Colour + "\nx" + Quantity,style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildOverviewList extends StatelessWidget {

  String Room;
  String Name;
  String Watts;

  BuildOverviewList(this.Room,this.Name,this.Watts);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))
        ),
        child: InkWell(
          splashColor: Colors.lightBlue,
          child: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(Room + ': ' + Name + "  -  " + Watts,style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void RoomToList(String selectedRoom) {
  print('--------------RoomToList------------');
  print('Current List Cleared.');
  print('Selected Room: ' + selectedRoom);
  CurList.clear();
  for (var room in AllRooms) {


    print('-------------');
    print('Loop Room: ' + room.roomname);
    print('Bulbs in room:');
    print(room.bulb.length);
    //print(room.bulb.single.Watts);

    if (room.roomname.compareTo(selectedRoom) == 0) {

      List<Bulbs> allBulbs = [];
      allBulbs.clear();
      allBulbs.addAll(room.bulb);

      for (Bulbs bulb in allBulbs) {
        CurList.add(bulb);
        print('Found Buld Watts: ' + bulb.Watts);

      }
    }
  }
  print('-----------------END----------------');
}

class bulbListView extends StatefulWidget{
  BulbListViewState createState()=> BulbListViewState();
}

class BulbListViewState extends State<bulbListView> {
  @override

  Widget build(BuildContext context) {

    //print(CurList.length);
    return ListView.builder(
      itemCount: CurList.length,
      itemBuilder: (context, index) {
        return BuldListTile('images/' + CurList[index].Name + '.png', CurList[index].Name, CurList[index].Watts, CurList[index].Colour, CurList[index].Amount,() async {
          if (await confirm(
            context,
            title: Text('Confirm'),
            content: Text('Would you like to remove ' + CurList[index].Name + '?'),
            textOK: Text('Yes'),
            textCancel: Text('No'),
          )) {
            CurList.removeAt(index);
            saveList(CurList, SelectedRoom);
            return setState(() {});
          }
          return print('pressedCancel');
        },(){
        //_launchURL(CurList[index].Name);
        });
      },

    );
  }
}

class CreateNewEntry extends StatefulWidget{
  CreateEntry createState()=> CreateEntry();
}

class CreateEntry extends State<CreateNewEntry> {
  String selectedBulb = allBulbs[0];
  String selectedRoom = allRooms[0];
  String selectedColour = bulbColours[0];
  String Watts = '';
  String Amount = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Entry"),
      ),
      body: ListView(
        children: [
          DropdownButton<String>(
            hint: Text('Select Bulb Type'),
            isExpanded: true,
            itemHeight: 80,
            items: allBulbs.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/' + value + '.png',width: 50, height: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(value),
                      ),
                    ],
                  )
              );
            }).toList(),
            value: selectedBulb,
            onChanged: (String newValue) {
              setState(() {
                selectedBulb = newValue;
              });
            },
          ),

          DropdownButton<String>(
            hint: Text('Select Room'),
            isExpanded: true,
            items: allRooms.map((String value) {
              if (SelectedRoom == 'Bulb Mate') {
                selectedRoom =  allRooms[0];
              } else {
                selectedRoom = SelectedRoom;
              }
              return new DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(value),
                      ),
                    ],
                  )
              );
            }).toList(),
            value: selectedRoom,
            onChanged: (String newValue) {
              setState(() {
                selectedRoom = newValue;
                SelectedRoom = newValue;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Bulb Wattage.';
                }
                return null;
              },
              decoration: new InputDecoration(labelText: "Bulb Wattage"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (String newValue) {
                setState(() {
                  Watts = newValue;
                });
              },// Only numbers can be entered
            ),
          ),
          DropdownButton<String>(

            hint: Text('Select Room'),
            isExpanded: true,
            items: bulbColours.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(value),
                      ),
                    ],
                  )
              );
            }).toList(),
            value: selectedColour,
            onChanged: (String newValue) {
              setState(() {
                selectedColour = newValue;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: new InputDecoration(labelText: "Bulb Quantity"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (String newValue) {
                setState(() {
                  Amount = newValue;
                });
              },// Only numbers can be entered
            ),
          ),
          ElevatedButton(onPressed: (){
            if (Watts == null || Watts.isEmpty || Amount == null || Amount.isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Please Enter Bulb Wattage & Amount.')));
            } else {
              //AddBulb(Bulbs(selectedBulb, Watts, selectedColour, Amount),selectedRoom);
              setState(() {
                print('Bulb Added');
                print(selectedBulb + ' - ' + Watts + ' - ' + selectedColour +
                    ' - ' + selectedRoom + ' - ' + Amount);
                RoomToList(selectedRoom);
                CurList.add(Bulbs(selectedBulb, Watts, selectedColour, Amount));
                saveList(CurList, selectedRoom);
                print(selectedRoom);
                //Navigator.pop(context);
                Route route = MaterialPageRoute(
                    builder: (context) => MainPage());
                SelectedRoom = selectedRoom;
                currentList = bulbListView();
                Navigator.push(context, route);
              });
            }
            }, child: Text('Add New Bulb'))
        ],
      )
    );
  }
}

class HomeView extends StatefulWidget{
  HomeViewState createState()=> HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override

  Widget build(BuildContext context) {
    if(ovStats.length < 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Center(
          child: Text(
            "There is nothing here...\n\n\nLets add some bulbs\n\n\nClick the + in the top right corner!",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
          ),
        ),
      );
    } else {
      return ExpansionTileDemo();
    }
    

  }
}

TextEditingController _textFieldController = TextEditingController();

Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Create new room.'),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "Enter Room Name."),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {

      if (_textFieldController.text == null || _textFieldController.text.isEmpty || _textFieldController.text == '' || allRooms.contains(_textFieldController.text)) {
/*      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Enter Room Name.')));*/
      } else {
        addRoom(_textFieldController.text);
        _textFieldController.text = '';
/*        Route route = MaterialPageRoute(
            builder: (context) => MainPage());
        currentList = HomeView();
        Navigator.push(context, route);*/
        Navigator.pop(context);
      }
      }

          ),
        ],
      );
    },
  );
}

removeRoom(String roomName) {
  allRooms.remove(roomName);
  print('Removed: ' + roomName);
  saveRoom();
  print('Saved Rooms');
  saveList([],roomName);
}

addRoom(String roomName) {
  allRooms.add(roomName);
  saveRoom();
}
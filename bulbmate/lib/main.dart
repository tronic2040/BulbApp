import 'dart:convert';

import 'package:bulbmate/saveLoad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import 'Bulb.dart';



List<String> allBulbs = [
  'E10','E11','E12','E14','E17',
  'E26','E27','E39','E40','EX39',
  'GU10','GU24'
];

List<String> allRooms = [
  'Kitchen','Bedroom','Bathroom','Living Room'
];

List<String> bulbColours = [
  'Daylight','Natural White','Cool White','Warm White','Soft White'
];

List<Bulbs> kitchenList = [];
List<Bulbs> bedroomList = [];
List<Bulbs> bathroomList = [];
List<Bulbs> livingRoomList = [];
List<Bulbs> CurList = [];
List<RoomBulbsList> Rooms = [];

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
        child: ListView(
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
            CustomListTile(Icons.lightbulb,'Living Room',(){
              this.setState((){
                text = "Living Room";
                SelectedRoom = text;
                RoomToList(text);
                currentList = bulbListView();
              });
              Navigator.of(context).pop();
            }),
            CustomListTile(Icons.lightbulb,'Kitchen',(){
              this.setState((){
                text = "Kitchen";
                SelectedRoom = text;
                RoomToList(text);
                currentList = bulbListView();
              });
              Navigator.of(context).pop();
            }),
            CustomListTile(Icons.lightbulb,'Bedroom',(){
              this.setState((){
                text = "Bedroom";
                SelectedRoom = text;
                RoomToList(text);
                currentList = bulbListView();
              });
              Navigator.of(context).pop();
            }),
            CustomListTile(Icons.lightbulb,'Bathroom',(){
              this.setState((){
                text = "Bathroom";
                SelectedRoom = text;
                RoomToList(text);
                currentList = bulbListView();
              });
    Navigator.of(context).pop();
    }),
          ],
        ),
      ),
      body: currentList,
    );
  }

}

class CustomListTile extends StatelessWidget {

  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon,this.text,this.onTap);

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

class BuldListTile extends StatelessWidget {

  String imageLoc;
  String Name;
  String Watts;
  String Quantity;
  String Colour;
  Function longPress;

  BuldListTile(this.imageLoc,this.Name,this.Watts,this.Colour,this.Quantity,this.longPress);

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
          onTap: longPress,
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
                      child: Text(Name + "\n" + Watts + "\n" + Colour + "\n" + Quantity,style: TextStyle(fontSize: 16.0),
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

class bulbListView extends StatefulWidget{
  BulbListViewState createState()=> BulbListViewState();
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

class BulbListViewState extends State<bulbListView> {
  @override

  Widget build(BuildContext context) {

    //print(CurList.length);
    return ListView.builder(
      itemCount: CurList.length,
      itemBuilder: (context, index) {
        return BuldListTile('images/bulb.png', CurList[index].Name, CurList[index].Watts, CurList[index].Colour, CurList[index].Amount,() async {
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
        });
      },

    );
  }
}

class BedroomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bedroomList.length,
      itemBuilder: (context, index) {
        return BuldListTile('images/bulb.png', bedroomList[index].Name, bedroomList[index].Watts, bedroomList[index].Colour, bedroomList[index].Amount,()=>{});
      },
    );
  }
}

class BathroomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bathroomList.length,
      itemBuilder: (context, index) {
        return BuldListTile('images/bulb.png', bathroomList[index].Name, bathroomList[index].Watts, bathroomList[index].Colour, bathroomList[index].Amount,()=>{});
      },
    );
  }
}

class LivingRoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: livingRoomList.length,
      itemBuilder: (context, index) {
        return BuldListTile('images/bulb.png', livingRoomList[index].Name, livingRoomList[index].Watts, livingRoomList[index].Colour, livingRoomList[index].Amount,()=>{});
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
                        child: Image.asset('images/bulb.png',width: 50, height: 50),
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
            //itemHeight: 80,

            items: allRooms.map((String value) {
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
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
            //itemHeight: 80,

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


            //AddBulb(Bulbs(selectedBulb, Watts, selectedColour, Amount),selectedRoom);
            setState(() {
              print('Bulb Added');
              print(selectedBulb + ' - ' + Watts +' - ' +  selectedColour +' - ' +  selectedRoom + ' - ' + Amount);
              RoomToList(selectedRoom);
              CurList.add(Bulbs(selectedBulb, Watts, selectedColour, Amount));
              saveList(CurList,selectedRoom);
              print(selectedRoom);
              //Navigator.pop(context);
              Route route = MaterialPageRoute(builder: (context) => MainPage());
              SelectedRoom = selectedRoom;
              currentList = bulbListView();
              Navigator.push(context, route);
            });



            }, child: Text('Add New Bulb'))
        ],
      )
    );
  }
}


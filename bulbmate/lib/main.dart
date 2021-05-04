import 'package:flutter/material.dart';

List<Bulbs> allBulbs = [
  Bulbs('1', '10w', 'Warm White', 'x2'),
  Bulbs('2', '15w', 'Warm White', 'x2'),
  Bulbs('3', '20w', 'Warm White', 'x2'),
  Bulbs('4', '25w', 'Warm White', 'x2'),
];

Bulbs selectedBulb;

void main() {
  runApp(MaterialApp(
    title: "Bulb Mate",
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget{
  HomePage createState()=> HomePage();
}

class HomePage extends State<MainPage>{



  void setSelectedBulb(Bulbs bulb) {
    setState(() => selectedBulb = bulb);
  }

  String text = "Bulb Mate";
  var currentList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
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
            CustomListTile(Icons.lightbulb,'Living Room',()=>{}),
            CustomListTile(Icons.lightbulb,'Kitchen',(){
              this.setState((){
                text = "Kitchen";
                currentList = KitchenList();
              });
              Navigator.of(context).pop();
            }),
            CustomListTile(Icons.lightbulb,'Bedroom',(){
              this.setState((){
                text = "Bedroom";
                currentList = BedroomList();
              });
              Navigator.of(context).pop();
            }),
            CustomListTile(Icons.lightbulb,'Bathroom',()=>{}),
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

  BuldListTile(this.imageLoc,this.Name,this.Watts,this.Colour,this.Quantity);

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
          onTap: ()=>{},
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

class KitchenList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allBulbs.length,
      itemBuilder: (context, index) {
        return BuldListTile('images/bulb.png', allBulbs[index].Name, allBulbs[index].Watts, allBulbs[index].Colour, allBulbs[index].Amount);
      },
    );
  }
}

class BedroomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BuldListTile('images/bulb.png', 'LED', '50W', 'Warm White', 'x1'),
        BuldListTile('images/bulb.png', 'Tube', '25W', 'Cool White', 'x5'),
      ],
    );
  }
}

class Bulbs {
  String Name;
  String Watts;
  String Colour;
  String Amount;

  Bulbs(this.Name, this.Watts, this.Colour, this.Amount);
}

class CreateNewEntry extends StatefulWidget{
  CreateEntry createState()=> CreateEntry();
}

class CreateEntry extends State<CreateNewEntry> {
  Bulbs selectedBulb = allBulbs[1];
  String bulbName = '';
  String Room = '';
  String Watts = '';
  String Amount = '';
  String Colour = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Entry"),
      ),
      body: ListView(
        children: [
          DropdownButton<Bulbs>(
            hint: Text('Select Bulb Type'),
            isExpanded: true,

            items: allBulbs.map((Bulbs value) {
              return new DropdownMenuItem<Bulbs>(
                  value: value,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/bulb.png',width: 60, height: 60),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(value.Name),
                      ),
                    ],
                  )
              );
            }).toList(),
            value: selectedBulb,
            onChanged: (Bulbs newValue) {
              setState(() {
                selectedBulb = newValue;
                bulbName = newValue.Name;
                Room = 'Kitchen';
                Amount = '99';
                Watts = '1000';
                Colour = 'Purkle';
              });
              print(selectedBulb.Name);
            },
          ),
          Text('Room Select -- DropDown'),
          Text('Bulb Select -- DropDown'),
          Text('Wattage'),
          Text('Color -- Dowpdown'),
          ElevatedButton(onPressed: (){
            AddBulb(Bulbs(bulbName, Watts, Colour, Amount));
            print('Bulb Added');
            print(allBulbs);
            }, child: Text('Add New Bulb'))
        ],
      )

    );
  }
}

void AddBulb(Bulbs newBulb) {
  allBulbs.add(newBulb);
}
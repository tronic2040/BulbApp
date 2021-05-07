import 'Bulb.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ExpansionTileDemo extends StatefulWidget {
  @override
  _ExpansionTileDemoState createState() => _ExpansionTileDemoState();
}

String testML = 'Line1\nLine2\nLine3';

class _ExpansionTileDemoState extends State<ExpansionTileDemo> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: ovStats.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildPlayerModelList(ovStats[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPlayerModelList(overviewStats items) {
    return Card(
      child: ExpansionTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,8,0),
              child: Icon(Icons.wb_sunny,color: Colors.lightBlue,),
            ),
            Text(
              items.Room,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Text(
              '(' + items.Count + ' Bulbs)',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,16),
              child: Text(
                items.Bulbs,
                style: TextStyle(fontWeight: FontWeight.w700,height: 2),
              ),
            ),
          )
        ],
      ),
    );
  }
}
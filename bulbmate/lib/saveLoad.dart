import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Bulb.dart';
import 'main.dart';

List<RoomAndName> roomsdata = [];
List<RoomBulbsList> AllRooms = [];
List<Bulbs> oneRoom = [];

readList(String room) async {
  //print('---------readList-------------');
  final prefs = await SharedPreferences.getInstance();
  final key = room;
  final value = prefs.getString(key) ?? '';
  roomsdata.add(RoomAndName(value, room));
}

readRoomNames() async {
  List<String> templist = ['Kitchen','Bedroom','Bathroom'];
  //print('---------readList-------------');
  final prefs = await SharedPreferences.getInstance();
  final key = '!roomnames!';
  final value = prefs.getString(key) ?? '';
  allRooms.clear();
  if (value == '') {
    allRooms = templist;
  } else {
    for (var room in json.decode(value)) {
      allRooms.add(room);
    }
  }
}

fetchRooms() async {
  roomsdata.clear();
  AllRooms.clear();
  await readRoomNames();
  for (var room in allRooms) {
    await readList(room);
  }

  for (var rooms in roomsdata) {
    List<Bulbs> tbl = [];
    tbl.clear();
    print('Room Name: ' + rooms.roomname);
    print('First Bulb: ' + rooms.bulb);

    if (rooms.bulb.length > 3) {
      var roomBulbs = json.decode(rooms.bulb);
      for (var bulb in roomBulbs) {
        print(bulb);
        Bulbs tb = Bulbs.fromJson(bulb);
        tbl.add(tb);
        print(tb.Watts);
      }
    }

    AllRooms.add(RoomBulbsList(tbl,rooms.roomname));
  }
  loadOverviewStats();
}


loadOverviewStats() {
  ovStats.clear();
  String ovRoomName = '';
  String ovCount = '';
  String ovBulbs = '';

  for (var rooms in roomsdata) {
    ovRoomName = '';
    ovCount = '0';
    ovBulbs = '';
    List<Bulbs> tbl = [];
    tbl.clear();

    ovRoomName = rooms.roomname;

    if (rooms.bulb.length > 3) {
      var roomBulbs = json.decode(rooms.bulb);
      for (var bulb in roomBulbs) {
        print(bulb);
        Bulbs tb = Bulbs.fromJson(bulb);
        tbl.add(tb);
        print(tb.Watts);
      }

      ovCount = tbl.length.toString();

      for (Bulbs b in tbl) {
        if (ovBulbs == '') {
          ovBulbs = b.Name + ' - ' + b.Watts + 'w - ' + b.Colour;
        } else {
          ovBulbs =
              ovBulbs + '\n' + b.Name + ' - ' + b.Watts + 'w - ' + b.Colour;
        }
      }
      ovStats.add(overviewStats(ovRoomName, ovCount, ovBulbs));
    }
  }
}


saveList(List<Bulbs> roomList, String roomName) async {
  final prefs = await SharedPreferences.getInstance();
  var key = roomName;
  var value = json.encode(roomList);

  prefs.setString(key, value);
  print('Saved: ' + key);
  print('List: ' + value);
  print('Room: ' + roomName);
  await fetchRooms();
}

void clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  //kitchenList.addAll(json.decode(value));

    prefs.clear();

  print('Data Cleared');
}

saveRoom() async {
  final prefs = await SharedPreferences.getInstance();
  var key = '!roomnames!';
  var value = json.encode(allRooms);
  prefs.setString(key, value);
}
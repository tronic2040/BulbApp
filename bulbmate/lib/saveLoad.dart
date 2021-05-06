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

/*    if (value.length > 2) {

      var roomSearch = json.decode(value);

      oneRoom.clear();
      for (var room in roomSearch) {
        //print('ROOM!! - ' + room.toString());
          oneRoom.add(Bulbs.fromJson(room));
          //print(Bulbs.fromJson(room));
      }
      AllRooms.add(RoomBulbsList(oneRoom, key));

    }

    for (var room in AllRooms) {
      print(room.roomname);
      for (var bulb in room.bulb) {
        print(bulb.Watts);
      }
    }
  print('------------END---------------');*/
}

fetchRooms() async {
  roomsdata.clear();
  AllRooms.clear();
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
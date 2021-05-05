import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Bulb.dart';
import 'main.dart';

List<String> roomsdata = [];
List<RoomBulbsList> AllRooms = [];
List<Bulbs> oneRoom = [];

readList() async {
  final prefs = await SharedPreferences.getInstance();
  //kitchenList.addAll(json.decode(value));

  for (var room in allRooms) {
    var key = room;
    var value = prefs.getString(key) ?? '';
    print('Loaded: ' + room);
    roomsdata.add(value);

    if (value.length > 2) {
      print(json.decode(value));
      var roomSearch = json.decode(value);
      for (var room in roomSearch) {
        var tb = Bulbs.fromJson(room);
        oneRoom.add(tb);
      }
      AllRooms.add(RoomBulbsList(oneRoom,room));
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
}
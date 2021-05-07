class Bulbs {
  String Name;
  String Watts;
  String Colour;
  String Amount;

  Bulbs(this.Name, this.Watts, this.Colour, this.Amount);

  Bulbs.fromJson(Map<String, dynamic> json)
      : Name = json['n'],
        Watts = json['w'],
        Colour = json['c'],
        Amount = json['a'];

  Map<String, dynamic> toJson() {
    return {
      'n': Name,
      'w': Watts,
      'c': Colour,
      'a': Amount,
    };
  }
}

class RoomBulbsList {
  List<Bulbs> bulb;
  String roomname;

  RoomBulbsList(this.bulb, this.roomname);
}

class RoomAndName {
  String bulb;
  String roomname;

  RoomAndName(this.bulb, this.roomname);
}

class overviewStats {
  String Room;
  String Count;
  String Bulbs;

  overviewStats(this.Room,this.Count,this.Bulbs);
}
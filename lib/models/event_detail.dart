class EventDetail {
  String owner;
  String time;
  String date;
  List<dynamic> loggedPlayers;
  String maxPlayers;
  String place;
  String groupName;
  String sportType;

  EventDetail(
    this.owner,
    this.time,
    this.date,
    this.loggedPlayers,
    this.maxPlayers,
    this.place,
    this.groupName,
    this.sportType,
  );
}

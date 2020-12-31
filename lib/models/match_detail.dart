class MatchDetail {
  String owner;
  String time;
  String date;
  Map<String, dynamic> loggedPlayers;
  String maxPlayers;
  String place;
  String groupName;
  String sportType;

  MatchDetail(
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

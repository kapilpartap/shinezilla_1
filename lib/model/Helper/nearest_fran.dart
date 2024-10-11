
class Franchise {
  String? franchId;
  String? date;
  String? startTime;
  String? endTime;

  Franchise({this.franchId, this.date, this.startTime, this.endTime});

  Franchise.fromJson(Map<String, dynamic> json) {
    franchId = json['franch_id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['franch_id'] = this.franchId;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
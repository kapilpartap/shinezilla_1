class UserBookingtime {
  String? time;
  int? timeId;

  UserBookingtime({this.time, this.timeId});

  UserBookingtime.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    timeId = json['time_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['time_id'] = this.timeId;
    return data;
  }
}


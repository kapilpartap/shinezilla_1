class DateAdd {
  String? uniId;
  int? franchId;
  String? date;
  String? month;
  int? day;
  String? dayname;

  DateAdd(
      {this.uniId,
        this.franchId,
        this.date,
        this.month,
        this.day,
        this.dayname});

  DateAdd.fromJson(Map<String, dynamic> json) {
    uniId = json['uni_id'];
    franchId = json['franch_id'];
    date = json['date'];
    month = json['month'];
    day = json['day'];
    dayname = json['dayname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uni_id'] = this.uniId;
    data['franch_id'] = this.franchId;
    data['date'] = this.date;
    data['month'] = this.month;
    data['day'] = this.day;
    data['dayname'] = this.dayname;
    return data;
  }
}

// class DateAdd {
//   String? date;
//   String? uniId;
//   String? month;
//   int? day;
//   String? dayname;
//
//   DateAdd({this.date, this.uniId, this.month, this.day, this.dayname});
//
//   DateAdd.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     uniId = json['uni_id'];
//     month = json['month'];
//     day = json['day'];
//     dayname = json['dayname'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     data['uni_id'] = this.uniId;
//     data['month'] = this.month;
//     data['day'] = this.day;
//     data['dayname'] = this.dayname;
//     return data;
//   }
// }
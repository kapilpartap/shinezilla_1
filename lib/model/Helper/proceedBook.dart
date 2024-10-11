


class ProceedBook {
  int? success;
  String? message;
  Data? data;

  ProceedBook({this.success, this.message, this.data});

  ProceedBook.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? companyStreet;
  String? companyCity;
  String? companyState;
  int? companyPostalCode;
  String? serviceName;
  String? categoryName;
  String? timeTaken;
  String? amount;
  String? googleLocation;
  String? address;
  String? landmark;
  String? scheduleDate;
  String? scheduleTime;
  String? userVehicleInfo;

  Data(
      {this.companyStreet,
        this.companyCity,
        this.companyState,
        this.companyPostalCode,
        this.serviceName,
        this.categoryName,
        this.timeTaken,
        this.amount,
        this.googleLocation,
        this.address,
        this.landmark,
        this.scheduleDate,
        this.scheduleTime,
        this.userVehicleInfo});

  Data.fromJson(Map<String, dynamic> json) {
    companyStreet = json['company_street'];
    companyCity = json['company_city'];
    companyState = json['company_state'];
    companyPostalCode = json['company_postal_code'];
    serviceName = json['service_name'];
    categoryName = json['category_name'];
    timeTaken = json['time_taken'];
    amount = json['amount'];
    googleLocation = json['google_location'];
    address = json['address'];
    landmark = json['landmark'];
    scheduleDate = json['schedule_date'];
    scheduleTime = json['schedule_time'];
    userVehicleInfo = json['user_vehicle_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_street'] = this.companyStreet;
    data['company_city'] = this.companyCity;
    data['company_state'] = this.companyState;
    data['company_postal_code'] = this.companyPostalCode;
    data['service_name'] = this.serviceName;
    data['category_name'] = this.categoryName;
    data['time_taken'] = this.timeTaken;
    data['amount'] = this.amount;
    data['google_location'] = this.googleLocation;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['schedule_date'] = this.scheduleDate;
    data['schedule_time'] = this.scheduleTime;
    data['user_vehicle_info'] = this.userVehicleInfo;
    return data;
  }
}
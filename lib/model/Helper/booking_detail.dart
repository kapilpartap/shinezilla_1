
class BookingDetail {
  String? bookingId;
  int? id;
  String? companyStreet;
  String? companyCity;
  String? companyState;
  int? companyPostalCode;
  String? serviceName;
  String? categoryName;
  String? timeTaken;
  String? amount;
  String? discountAmount;
  String? googleLocation;
  String? address;
  String? landmark;
  String? scheduleDate;
  String? scheduleTime;
  String? userVehicleInfo;

  BookingDetail(
      {this.bookingId,
        this.id,
        this.companyStreet,
        this.companyCity,
        this.companyState,
        this.companyPostalCode,
        this.serviceName,
        this.categoryName,
        this.timeTaken,
        this.amount,
        this.discountAmount,
        this.googleLocation,
        this.address,
        this.landmark,
        this.scheduleDate,
        this.scheduleTime,
        this.userVehicleInfo});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    id = json['id'];
    companyStreet = json['company_street'];
    companyCity = json['company_city'];
    companyState = json['company_state'];
    companyPostalCode = json['company_postal_code'];
    serviceName = json['service_name'];
    categoryName = json['category_name'];
    timeTaken = json['time_taken'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    googleLocation = json['google_location'];
    address = json['address'];
    landmark = json['landmark'];
    scheduleDate = json['schedule_date'];
    scheduleTime = json['schedule_time'];
    userVehicleInfo = json['user_vehicle_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['id'] = this.id;
    data['company_street'] = this.companyStreet;
    data['company_city'] = this.companyCity;
    data['company_state'] = this.companyState;
    data['company_postal_code'] = this.companyPostalCode;
    data['service_name'] = this.serviceName;
    data['category_name'] = this.categoryName;
    data['time_taken'] = this.timeTaken;
    data['amount'] = this.amount;
    data['discount_amount'] = this.discountAmount;
    data['google_location'] = this.googleLocation;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['schedule_date'] = this.scheduleDate;
    data['schedule_time'] = this.scheduleTime;
    data['user_vehicle_info'] = this.userVehicleInfo;
    return data;
  }
}
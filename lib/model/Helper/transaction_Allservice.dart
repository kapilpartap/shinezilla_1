
class TransactionAllService {
  int? id;
  String? userId;
  String? bookingId;
  int? serviceId;
  int? washerId;
  int? franchisesId;
  String? userVehicleInfo;
  String? latitude;
  String? longitude;
  String? googleLocation;
  String? address;
  String? landmark;
  String? scheduleDate;
  String? scheduleTime;
  String? comment;
  String? transactionId;
  String? tnxAmount;
  String? couponDiscount;
  int? tnxStatus;
  int? paymentType;
  String? checksumToken;
  int? status;
  int? delStatus;
  String? createdAt;
  String? updatedAt;
  String? serviceName;
  int? category;
  int? carCat;
  String? serviceLogo;
  String? folder;
  String? feature;
  String? description;
  String? timeTaken;
  int? discount;
  String? amount;
  String? discountAmount;
  String? couponName;
  int? couponDiscountPer;
  String? couponStartDate;
  String? couponEndDate;
  String? payStatus;
  String? bookingStatus;

  TransactionAllService(
      {this.id,
        this.userId,
        this.bookingId,
        this.serviceId,
        this.washerId,
        this.franchisesId,
        this.userVehicleInfo,
        this.latitude,
        this.longitude,
        this.googleLocation,
        this.address,
        this.landmark,
        this.scheduleDate,
        this.scheduleTime,
        this.comment,
        this.transactionId,
        this.tnxAmount,
        this.couponDiscount,
        this.tnxStatus,
        this.paymentType,
        this.checksumToken,
        this.status,
        this.delStatus,
        this.createdAt,
        this.updatedAt,
        this.serviceName,
        this.category,
        this.carCat,
        this.serviceLogo,
        this.folder,
        this.feature,
        this.description,
        this.timeTaken,
        this.discount,
        this.amount,
        this.discountAmount,
        this.couponName,
        this.couponDiscountPer,
        this.couponStartDate,
        this.couponEndDate,
        this.payStatus,
        this.bookingStatus});

  TransactionAllService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    serviceId = json['service_id'];
    washerId = json['washer_id'];
    franchisesId = json['franchises_id'];
    userVehicleInfo = json['user_vehicle_info'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    googleLocation = json['google_location'];
    address = json['address'];
    landmark = json['landmark'];
    scheduleDate = json['schedule_date'];
    scheduleTime = json['schedule_time'];
    comment = json['comment'];
    transactionId = json['transaction_id'];
    tnxAmount = json['tnx_amount'];
    couponDiscount = json['coupon_discount'];
    tnxStatus = json['tnx_status'];
    paymentType = json['payment_type'];
    checksumToken = json['checksum_token'];
    status = json['status'];
    delStatus = json['del_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    serviceName = json['service_name'];
    category = json['category'];
    carCat = json['car_cat'];
    serviceLogo = json['service_logo'];
    folder = json['folder'];
    feature = json['feature'];
    description = json['description'];
    timeTaken = json['time_taken'];
    discount = json['discount'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    couponName = json['coupon_name'];
    couponDiscountPer = json['coupon_discount_per'];
    couponStartDate = json['coupon_start_date'];
    couponEndDate = json['coupon_end_date'];
    payStatus = json['pay_status'];
    bookingStatus = json['booking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['booking_id'] = this.bookingId;
    data['service_id'] = this.serviceId;
    data['washer_id'] = this.washerId;
    data['franchises_id'] = this.franchisesId;
    data['user_vehicle_info'] = this.userVehicleInfo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['google_location'] = this.googleLocation;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['schedule_date'] = this.scheduleDate;
    data['schedule_time'] = this.scheduleTime;
    data['comment'] = this.comment;
    data['transaction_id'] = this.transactionId;
    data['tnx_amount'] = this.tnxAmount;
    data['coupon_discount'] = this.couponDiscount;
    data['tnx_status'] = this.tnxStatus;
    data['payment_type'] = this.paymentType;
    data['checksum_token'] = this.checksumToken;
    data['status'] = this.status;
    data['del_status'] = this.delStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['service_name'] = this.serviceName;
    data['category'] = this.category;
    data['car_cat'] = this.carCat;
    data['service_logo'] = this.serviceLogo;
    data['folder'] = this.folder;
    data['feature'] = this.feature;
    data['description'] = this.description;
    data['time_taken'] = this.timeTaken;
    data['discount'] = this.discount;
    data['amount'] = this.amount;
    data['discount_amount'] = this.discountAmount;
    data['coupon_name'] = this.couponName;
    data['coupon_discount_per'] = this.couponDiscountPer;
    data['coupon_start_date'] = this.couponStartDate;
    data['coupon_end_date'] = this.couponEndDate;
    data['pay_status'] = this.payStatus;
    data['booking_status'] = this.bookingStatus;
    return data;
  }
}


// class TransactionAllService {
//   int? id;
//   String? userId;
//   String? bookingId;
//   int? serviceId;
//   int? washerId;
//   int? franchisesId;
//   String? userVehicleInfo;
//   String? latitude;
//   String? longitude;
//   String? googleLocation;
//   String? address;
//   String? landmark;
//   String? scheduleDate;
//   String? scheduleTime;
//   String? comment;
//   String? transactionId;
//   String? tnxAmount;
//   int? tnxStatus;
//   int? paymentType;
//   String? checksumToken;
//   int? status;
//   int? delStatus;
//   String? createdAt;
//   String? updatedAt;
//   String? serviceName;
//   int? category;
//   int? carCat;
//   String? serviceLogo;
//   String? folder;
//   String? feature;
//   String? description;
//   String? timeTaken;
//   int? discount;
//   String? amount;
//   String? discountAmount;
//   String? payStatus;
//   String? bookingStatus;
//
//   TransactionAllService(
//       {this.id,
//         this.userId,
//         this.bookingId,
//         this.serviceId,
//         this.washerId,
//         this.franchisesId,
//         this.userVehicleInfo,
//         this.latitude,
//         this.longitude,
//         this.googleLocation,
//         this.address,
//         this.landmark,
//         this.scheduleDate,
//         this.scheduleTime,
//         this.comment,
//         this.transactionId,
//         this.tnxAmount,
//         this.tnxStatus,
//         this.paymentType,
//         this.checksumToken,
//         this.status,
//         this.delStatus,
//         this.createdAt,
//         this.updatedAt,
//         this.serviceName,
//         this.category,
//         this.carCat,
//         this.serviceLogo,
//         this.folder,
//         this.feature,
//         this.description,
//         this.timeTaken,
//         this.discount,
//         this.amount,
//         this.discountAmount,
//         this.payStatus,
//         this.bookingStatus});
//
//   TransactionAllService.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     bookingId = json['booking_id'];
//     serviceId = json['service_id'];
//     washerId = json['washer_id'];
//     franchisesId = json['franchises_id'];
//     userVehicleInfo = json['user_vehicle_info'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     googleLocation = json['google_location'];
//     address = json['address'];
//     landmark = json['landmark'];
//     scheduleDate = json['schedule_date'];
//     scheduleTime = json['schedule_time'];
//     comment = json['comment'];
//     transactionId = json['transaction_id'];
//     tnxAmount = json['tnx_amount'];
//     tnxStatus = json['tnx_status'];
//     paymentType = json['payment_type'];
//     checksumToken = json['checksum_token'];
//     status = json['status'];
//     delStatus = json['del_status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     serviceName = json['service_name'];
//     category = json['category'];
//     carCat = json['car_cat'];
//     serviceLogo = json['service_logo'];
//     folder = json['folder'];
//     feature = json['feature'];
//     description = json['description'];
//     timeTaken = json['time_taken'];
//     discount = json['discount'];
//     amount = json['amount'];
//     discountAmount = json['discount_amount'];
//     payStatus = json['pay_status'];
//     bookingStatus = json['booking_status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['booking_id'] = this.bookingId;
//     data['service_id'] = this.serviceId;
//     data['washer_id'] = this.washerId;
//     data['franchises_id'] = this.franchisesId;
//     data['user_vehicle_info'] = this.userVehicleInfo;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['google_location'] = this.googleLocation;
//     data['address'] = this.address;
//     data['landmark'] = this.landmark;
//     data['schedule_date'] = this.scheduleDate;
//     data['schedule_time'] = this.scheduleTime;
//     data['comment'] = this.comment;
//     data['transaction_id'] = this.transactionId;
//     data['tnx_amount'] = this.tnxAmount;
//     data['tnx_status'] = this.tnxStatus;
//     data['payment_type'] = this.paymentType;
//     data['checksum_token'] = this.checksumToken;
//     data['status'] = this.status;
//     data['del_status'] = this.delStatus;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['service_name'] = this.serviceName;
//     data['category'] = this.category;
//     data['car_cat'] = this.carCat;
//     data['service_logo'] = this.serviceLogo;
//     data['folder'] = this.folder;
//     data['feature'] = this.feature;
//     data['description'] = this.description;
//     data['time_taken'] = this.timeTaken;
//     data['discount'] = this.discount;
//     data['amount'] = this.amount;
//     data['discount_amount'] = this.discountAmount;
//     data['pay_status'] = this.payStatus;
//     data['booking_status'] = this.bookingStatus;
//     return data;
//   }
// }

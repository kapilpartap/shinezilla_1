
class CouponFile {
  int? id;
  String? name;
  String? couponCode;
  int? discount;
  int? type;
  String? startDate;
  String? endDate;
  int? totalCoupon;
  int? used;
  String? succMssg;
  String? errorMssg;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? delStatus;

  CouponFile(
      {this.id,
        this.name,
        this.couponCode,
        this.discount,
        this.type,
        this.startDate,
        this.endDate,
        this.totalCoupon,
        this.used,
        this.succMssg,
        this.errorMssg,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.delStatus});

  CouponFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    couponCode = json['coupon_code'];
    discount = json['discount'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalCoupon = json['total_coupon'];
    used = json['used'];
    succMssg = json['succ_mssg'];
    errorMssg = json['error_mssg'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    delStatus = json['del_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['coupon_code'] = this.couponCode;
    data['discount'] = this.discount;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_coupon'] = this.totalCoupon;
    data['used'] = this.used;
    data['succ_mssg'] = this.succMssg;
    data['error_mssg'] = this.errorMssg;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['del_status'] = this.delStatus;
    return data;
  }
}

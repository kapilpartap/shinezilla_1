class CategoriesServicesID {
  int? id;
  String? serviceName;
  int? category;
  String? serviceLogo;
  String? folder;
  String? feature;
  String? description;
  String? timeTaken;
  int? discount;
  String? amount;
  String? discountAmount;
  int? status;
  int? delStatus;
  String? createdAt;
  String? updatedAt;

  CategoriesServicesID(
      {this.id,
        this.serviceName,
        this.category,
        this.serviceLogo,
        this.folder,
        this.feature,
        this.description,
        this.timeTaken,
        this.discount,
        this.amount,
        this.discountAmount,
        this.status,
        this.delStatus,
        this.createdAt,
        this.updatedAt});

  CategoriesServicesID.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    category = json['category'];
    serviceLogo = json['service_logo'];
    folder = json['folder'];
    feature = json['feature'];
    description = json['description'];
    timeTaken = json['time_taken'];
    discount = json['discount'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    status = json['status'];
    delStatus = json['del_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['category'] = this.category;
    data['service_logo'] = this.serviceLogo;
    data['folder'] = this.folder;
    data['feature'] = this.feature;
    data['description'] = this.description;
    data['time_taken'] = this.timeTaken;
    data['discount'] = this.discount;
    data['amount'] = this.amount;
    data['discount_amount'] = this.discountAmount;
    data['status'] = this.status;
    data['del_status'] = this.delStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
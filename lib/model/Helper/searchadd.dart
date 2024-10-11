

class SearchAdd {
  int? id;
  String? serviceName;
  String? feature;
  String? serviceLogo;
  String? folder;
  String? description;
  String? timeTaken;
  String? discount;
  String? amount;
  String? discountAmount;

  SearchAdd(
      {this.id,
        this.serviceName,
        this.feature,
        this.serviceLogo,
        this.folder,
        this.description,
        this.timeTaken,
        this.discount,
        this.amount,
        this.discountAmount});

  SearchAdd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    feature = json['feature'];
    serviceLogo = json['service_logo'];
    folder = json['folder'];
    description = json['description'];
    timeTaken = json['time_taken'];
    discount = json['discount'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['feature'] = this.feature;
    data['service_logo'] = this.serviceLogo;
    data['folder'] = this.folder;
    data['description'] = this.description;
    data['time_taken'] = this.timeTaken;
    data['discount'] = this.discount;
    data['amount'] = this.amount;
    data['discount_amount'] = this.discountAmount;
    return data;
  }
}
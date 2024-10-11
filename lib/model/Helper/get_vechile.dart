

class VechileAdded {
  String? type;
  String? brandName;
  int? status;
  String? model;
  int? id;

  VechileAdded({this.type, this.brandName, this.status, this.model, this.id});

  VechileAdded.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    brandName = json['brand_name'];
    status = json['status'];
    model = json['model'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['brand_name'] = this.brandName;
    data['status'] = this.status;
    data['model'] = this.model;
    data['id'] = this.id;
    return data;
  }
}
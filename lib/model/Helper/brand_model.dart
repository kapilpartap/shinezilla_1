

class BrandModel {
  int? modelId;
  int? brandId;
  String? model;
  String? folder;
  String? brand_logo;

  BrandModel({this.modelId, this.brandId, this.model});

  BrandModel.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    brandId = json['brand_id'];
    model = json['model'];
    folder = json['folder'];
    brand_logo = json['brand_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_id'] = this.modelId;
    data['brand_id'] = this.brandId;
    data['model'] = this.model;
    data['folder'] = this.folder;
    data['brand_logo'] = this.brand_logo;
    return data;
  }
}

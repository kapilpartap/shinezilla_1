class BrandName {
  int? id;
  String? folder;
  String? brandName;
  String? brandLogo;

  BrandName({this.id, this.folder, this.brandName, this.brandLogo});

  BrandName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folder = json['folder'];
    brandName = json['brand_name'];
    brandLogo = json['brand_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['folder'] = this.folder;
    data['brand_name'] = this.brandName;
    data['brand_logo'] = this.brandLogo;
    return data;
  }
}
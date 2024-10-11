

class Categories {
  int? id;
  String? folder;
  String? categoryName;
  String? logo;

  Categories({this.id, this.folder, this.categoryName, this.logo});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folder = json['folder'];
    categoryName = json['category_name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['folder'] = this.folder;
    data['category_name'] = this.categoryName;
    data['logo'] = this.logo;
    return data;
  }
}


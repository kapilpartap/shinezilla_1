

class UpdateTransaction {
  int? success;
  String? message;
  int? id;

  UpdateTransaction({this.success, this.message, this.id});

  UpdateTransaction.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}
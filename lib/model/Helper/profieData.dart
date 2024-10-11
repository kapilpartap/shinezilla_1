

class ProfileData {
  String? username;
  String? lastName;
  String? email;
  String? phoneNo;
  String? postOffice;
  String? city;
  String? pincode;
  String? address;
  String? state;
  String? district;
  String? landmark;

  ProfileData(
      {this.username,
        this.lastName,
        this.email,
        this.phoneNo,
        this.postOffice,
        this.city,
        this.pincode,
        this.address,
        this.state,
        this.district,
        this.landmark});

  ProfileData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNo = json['phone_no'];
    postOffice = json['post_office'];
    city = json['city'];
    pincode = json['pincode'];
    address = json['address'];
    state = json['state'];
    district = json['district'];
    landmark = json['landmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['post_office'] = this.postOffice;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['state'] = this.state;
    data['district'] = this.district;
    data['landmark'] = this.landmark;
    return data;
  }
}
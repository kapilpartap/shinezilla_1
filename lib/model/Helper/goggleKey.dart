
class googleKey {
  String? apiKey;

  googleKey({this.apiKey});

  googleKey.fromJson(Map<String, dynamic> json) {
    apiKey = json['api_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_key'] = this.apiKey;
    return data;
  }
}


class RatingService {
  String? name;
  int? rating;
  String? description;

  RatingService({this.name, this.rating, this.description});

  RatingService.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rating = json['rating'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['description'] = this.description;
    return data;
  }
}






class OffersHelper {
  String? folder;
  String? sliderImage;
  String? sliderText;

  OffersHelper({this.folder, this.sliderImage, this.sliderText});

  OffersHelper.fromJson(Map<String, dynamic> json) {
    folder = json['folder'];
    sliderImage = json['slider_image'];
    sliderText = json['slider_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folder'] = this.folder;
    data['slider_image'] = this.sliderImage;
    data['slider_text'] = this.sliderText;
    return data;
  }
}
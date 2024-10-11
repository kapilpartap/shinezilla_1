

class BannerIG {
  String? bannerFolder;
  String? bannerLogo;

  BannerIG({this.bannerFolder, this.bannerLogo});

  BannerIG.fromJson(Map<String, dynamic> json) {
    bannerFolder = json['banner_folder'];
    bannerLogo = json['banner_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_folder'] = this.bannerFolder;
    data['banner_logo'] = this.bannerLogo;
    return data;
  }
}
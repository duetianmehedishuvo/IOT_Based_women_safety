class WeatherModel {
  WeatherModel({
    this.description,
    this.code,
    this.icon,
  });

  WeatherModel.fromJson(dynamic json) {
    description = json['description'];
    code = json['code'];
    icon = json['icon'];
  }

  String? description;
  num? code;
  String? icon;
}

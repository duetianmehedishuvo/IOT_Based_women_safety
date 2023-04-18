
import 'package:women_safety/data/model/response/weather_model.dart';

class CurrentWeatherModel {
  CurrentWeatherModel({
    this.appTemp,
    this.aqi,
    this.cityName,
    this.clouds,
    this.countryCode,
    this.datetime,
    this.dewpt,
    this.dhi,
    this.dni,
    this.elevAngle,
    this.ghi,
    this.gust,
    this.hAngle,
    this.lat,
    this.lon,
    this.obTime,
    this.pod,
    this.precip,
    this.pres,
    this.rh,
    this.slp,
    this.snow,
    this.solarRad,
    this.sources,
    this.stateCode,
    this.station,
    this.sunrise,
    this.sunset,
    this.temp,
    this.timezone,
    this.ts,
    this.uv,
    this.vis,
    this.weather,
    this.windCdir,
    this.windCdirFull,
    this.windDir,
    this.windSpd,
  });

  CurrentWeatherModel.fromJson(dynamic json) {
    appTemp = json['app_temp'];
    aqi = json['aqi'];
    cityName = json['city_name'];
    clouds = json['clouds'];
    countryCode = json['country_code'];
    datetime = json['datetime'];
    dewpt = json['dewpt'];
    dhi = json['dhi'];
    dni = json['dni'];
    elevAngle = json['elev_angle'];
    ghi = json['ghi'];
    gust = json['gust'];
    hAngle = json['h_angle'];
    lat = json['lat'];
    lon = json['lon'];
    obTime = json['ob_time'];
    pod = json['pod'];
    precip = json['precip'];
    pres = json['pres'];
    rh = json['rh'];
    slp = json['slp'];
    snow = json['snow'];
    solarRad = json['solar_rad'];
    sources = json['sources'] != null ? json['sources'].cast<String>() : [];
    stateCode = json['state_code'];
    station = json['station'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    temp = json['temp'];
    timezone = json['timezone'];
    ts = json['ts'];
    uv = json['uv'];
    vis = json['vis'];
    weather = json['weather'] != null ? WeatherModel.fromJson(json['weather']) : null;
    windCdir = json['wind_cdir'];
    windCdirFull = json['wind_cdir_full'];
    windDir = json['wind_dir'];
    windSpd = json['wind_spd'];
  }

  num? appTemp;
  num? aqi;
  String? cityName;
  num? clouds;
  String? countryCode;
  String? datetime;
  num? dewpt;
  num? dhi;
  num? dni;
  num? elevAngle;
  num? ghi;
  num? gust;
  num? hAngle;
  num? lat;
  num? lon;
  String? obTime;
  String? pod;
  dynamic precip;
  num? pres;
  num? rh;
  num? slp;
  dynamic snow;
  num? solarRad;
  List<String>? sources;
  String? stateCode;
  String? station;
  String? sunrise;
  String? sunset;
  num? temp;
  String? timezone;
  num? ts;
  num? uv;
  num? vis;
  WeatherModel? weather;
  String? windCdir;
  String? windCdirFull;
  num? windDir;
  num? windSpd;
}

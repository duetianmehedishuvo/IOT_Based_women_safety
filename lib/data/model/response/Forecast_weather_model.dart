
import 'package:women_safety/data/model/response/weather_model.dart';

class ForecastWeatherModel {
  ForecastWeatherModel({
    this.appMaxTemp,
    this.appMinTemp,
    this.clouds,
    this.cloudsHi,
    this.cloudsLow,
    this.cloudsMid,
    this.datetime,
    this.dewpt,
    this.highTemp,
    this.lowTemp,
    this.maxDhi,
    this.maxTemp,
    this.minTemp,
    this.moonPhase,
    this.moonPhaseLunation,
    this.moonriseTs,
    this.moonsetTs,
    this.ozone,
    this.pop,
    this.precip,
    this.pres,
    this.rh,
    this.slp,
    this.snow,
    this.snowDepth,
    this.sunriseTs,
    this.sunsetTs,
    this.temp,
    this.ts,
    this.uv,
    this.validDate,
    this.vis,
    this.weather,
    this.windCdir,
    this.windCdirFull,
    this.windDir,
    this.windGustSpd,
    this.windSpd,
  });

  ForecastWeatherModel.fromJson(dynamic json) {
    appMaxTemp = json['app_max_temp'];
    appMinTemp = json['app_min_temp'];
    clouds = json['clouds'];
    cloudsHi = json['clouds_hi'];
    cloudsLow = json['clouds_low'];
    cloudsMid = json['clouds_mid'];
    datetime = json['datetime'];
    dewpt = json['dewpt'];
    highTemp = json['high_temp'];
    lowTemp = json['low_temp'];
    maxDhi = json['max_dhi'];
    maxTemp = json['max_temp'];
    minTemp = json['min_temp'];
    moonPhase = json['moon_phase'];
    moonPhaseLunation = json['moon_phase_lunation'];
    moonriseTs = json['moonrise_ts'];
    moonsetTs = json['moonset_ts'];
    ozone = json['ozone'];
    pop = json['pop'];
    precip = json['precip'];
    pres = json['pres'];
    rh = json['rh'];
    slp = json['slp'];
    snow = json['snow'];
    snowDepth = json['snow_depth'];
    sunriseTs = json['sunrise_ts'];
    sunsetTs = json['sunset_ts'];
    temp = json['temp'];
    ts = json['ts'];
    uv = json['uv'];
    validDate = json['valid_date'];
    vis = json['vis'];
    weather = json['weather'] != null ? WeatherModel.fromJson(json['weather']) : null;
    windCdir = json['wind_cdir'];
    windCdirFull = json['wind_cdir_full'];
    windDir = json['wind_dir'];
    windGustSpd = json['wind_gust_spd'];
    windSpd = json['wind_spd'];
  }

  num? appMaxTemp;
  num? appMinTemp;
  num? clouds;
  num? cloudsHi;
  num? cloudsLow;
  num? cloudsMid;
  String? datetime;
  num? dewpt;
  num? highTemp;
  num? lowTemp;
  dynamic maxDhi;
  num? maxTemp;
  num? minTemp;
  num? moonPhase;
  num? moonPhaseLunation;
  num? moonriseTs;
  num? moonsetTs;
  num? ozone;
  num? pop;
  num? precip;
  num? pres;
  num? rh;
  num? slp;
  num? snow;
  num? snowDepth;
  num? sunriseTs;
  num? sunsetTs;
  num? temp;
  num? ts;
  num? uv;
  String? validDate;
  num? vis;
  WeatherModel? weather;
  String? windCdir;
  String? windCdirFull;
  num? windDir;
  num? windGustSpd;
  num? windSpd;

}

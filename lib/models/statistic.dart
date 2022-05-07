import 'package:country/country.dart';
import 'package:equatable/equatable.dart';

class Statistic extends Equatable {
  final int cases;
  final int deaths;
  final int recovered;
  final int todayCases;
  final int todayDeaths;
  final int todayRecovered;
  final int critical;
  final int active;

  const Statistic({
    required this.cases,
    required this.deaths,
    required this.recovered,
    required this.todayCases,
    required this.todayDeaths,
    required this.todayRecovered,
    required this.critical,
    required this.active,
  });

  Statistic.fromMap(Map<String, dynamic> data)
      : cases = data['cases'],
        deaths = data['deaths'],
        recovered = data['recovered'],
        todayCases = data['todayCases'],
        todayDeaths = data['todayDeaths'],
        todayRecovered = data['todayRecovered'],
        critical = data['critical'],
        active = data['active'];

  Map<String, dynamic> toMap() {
    return {
      'cases': cases,
      'deaths': deaths,
      'recovered': recovered,
      'todayCases': todayCases,
      'todayDeaths': todayDeaths,
      'todayRecovered': todayRecovered,
      'critical': critical,
      'active': active,
    };
  }

  @override
  List<Object?> get props => [
        cases,
        deaths,
        recovered,
        todayCases,
        todayDeaths,
        todayRecovered,
        critical,
        active,
      ];
}

class CountryStatistic extends Statistic {
  final Country country;

  const CountryStatistic({
    required int cases,
    required int deaths,
    required int recovered,
    required int todayCases,
    required int todayDeaths,
    required int todayRecovered,
    required int critical,
    required int active,
    required this.country,
  }) : super(
          cases: cases,
          deaths: deaths,
          recovered: recovered,
          todayCases: todayCases,
          todayDeaths: todayDeaths,
          todayRecovered: todayRecovered,
          critical: critical,
          active: active,
        );

  CountryStatistic.fromMap(
    Map<String, dynamic> data, {
    Country? country,
  })  : country = country ??
            Countries.values.singleWhere(
              (country) => country.isoShortName == data['country'],
            ),
        super.fromMap(data);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'country': country.isoShortName,
    };
  }

  @override
  List<Object?> get props => [
        super.props,
        country.isoShortName,
      ];
}

import 'package:country/country.dart';
import 'package:equatable/equatable.dart';

class Statistic extends Equatable {
  final int totalAffected;
  final int totalDeath;
  final int totalRecovered;

  final int todayAffected;
  final int todayDeath;
  final int todayRecovered;

  int get active => totalAffected - totalRecovered - totalDeath;

  const Statistic({
    required this.totalAffected,
    required this.totalDeath,
    required this.totalRecovered,
    required this.todayAffected,
    required this.todayDeath,
    required this.todayRecovered,
  });

  Statistic.fromMap({
    required Map<String, dynamic> total,
    required Map<String, dynamic> today,
  })  : totalAffected = total['TotalConfirmed'],
        totalDeath = total['TotalDeaths'],
        totalRecovered = total['TotalRecovered'],
        todayAffected = total['TotalConfirmed'],
        todayDeath = total['TotalDeaths'],
        todayRecovered = total['TotalRecovered'];

  Map<String, dynamic> totalToMap() {
    return {
      'TotalConfirmed': totalAffected,
      'TotalDeaths': totalDeath,
      'TotalRecovered': totalRecovered,
    };
  }

  Map<String, dynamic> todayToMap() {
    return {
      'TotalConfirmed': todayAffected,
      'TotalDeaths': todayDeath,
      'TotalRecovered': todayRecovered,
    };
  }

  @override
  List<Object?> get props => [
        totalAffected,
        totalDeath,
        totalRecovered,
        todayAffected,
        todayDeath,
        todayRecovered,
      ];
}

class CountryStatistic extends Statistic {
  final Country country;

  const CountryStatistic({
    required int totalAffected,
    required int totalDeath,
    required int totalRecovered,
    required int todayAffected,
    required int todayDeath,
    required int todayRecovered,
    required this.country,
  }) : super(
    totalAffected: totalAffected,
    totalDeath: totalDeath,
    totalRecovered: totalRecovered,
    todayAffected: todayAffected,
    todayDeath: todayDeath,
    todayRecovered: todayRecovered,
  );

  CountryStatistic.fromMap({
    required Map<String, dynamic> total,
    required Map<String, dynamic> today,
    required this.country,
  }) : super.fromMap(
          total: total,
          today: today,
        );

  @override
  List<Object?> get props => super.props..addAll([country.countryCode]);
}

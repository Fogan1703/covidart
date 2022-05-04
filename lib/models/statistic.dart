import 'package:country/country.dart';
import 'package:equatable/equatable.dart';

class Statistic extends Equatable {
  final Country? country;
  final int affected;
  final int death;
  final int recovered;

  int get active => affected - recovered - death;

  const Statistic({
    required this.country,
    required this.affected,
    required this.death,
    required this.recovered,
  });

  Statistic.fromMap(
    Map<String, dynamic> map, {
    required String? countryCode,
  })  : country = countryCode != null
            ? Countries.values.singleWhere(
                (country) => country.countryCode == countryCode,
              )
            : null,
        affected = map['TotalConfirmed'] ?? map['affected'],
        death = map['TotalDeaths'] ?? map['death'],
        recovered = map['TotalRecovered'] ?? map['recovered'];

  Map<String, dynamic> toMap() {
    return {
      'country': country?.countryCode,
      'affected': affected,
      'death': death,
      'recovered': recovered,
    };
  }

  @override
  List<Object?> get props => [
        country?.countryCode,
        affected,
        death,
        recovered,
        active,
      ];
}

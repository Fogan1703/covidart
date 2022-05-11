import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country/country.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/statistic.dart';

class StatisticCubit extends Cubit<StatisticState> {
  static const String _apiUrl = 'https://disease.sh/v3/covid-19/';

  final SharedPreferences _prefs;

  StatisticCubit._({
    required StatisticState state,
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        super(state);

  factory StatisticCubit({required SharedPreferences prefs}) {
    final stringedData = prefs.getString('data');

    if (stringedData == null) {
      return StatisticCubit._(
        state: StatisticLoading(),
        prefs: prefs,
      );
    }

    final data = jsonDecode(stringedData);

    return StatisticCubit._(
      state: StatisticSuccess(
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(data['lastUpdate']),
        worldStatistic: Statistic.fromMap(data['world']),
        countryStatistic: data['country'] != null
            ? CountryStatistic.fromMap(data['country'])
            : null,
        refreshing: RefreshingStatus.loading,
      ),
      prefs: prefs,
    );
  }

  Future<void> refresh({Country? newCountry}) async {
    final state = this.state;

    if (state is StatisticSuccess) {
      emit(state.copyWithRefreshing(RefreshingStatus.loading));
    } else if (state is StatisticNoConnection) {
      emit(StatisticLoading());
    }

    if (await _getIsConnected()) {
      final worldResponse = await Dio().get(_apiUrl + 'all');

      Response? countryResponse;
      Country? country;

      if (newCountry != null) {
        country = newCountry;
      } else if (state is StatisticSuccess && state.countryStatistic != null) {
        country = state.countryStatistic!.country;
      }

      if (country != null) {
        countryResponse = await Dio().get(
          _apiUrl + 'countries/' + country.isoShortName,
        );
      }

      final newState = StatisticSuccess(
        lastUpdate: DateTime.now(),
        worldStatistic: Statistic.fromMap(worldResponse.data),
        countryStatistic: countryResponse != null
            ? CountryStatistic.fromMap(
                countryResponse.data,
                country: country,
              )
            : null,
        refreshing: RefreshingStatus.refreshed,
      );

      _prefs.setString('data', jsonEncode(newState.toMap()));

      emit(newState);
    } else {
      if (state is StatisticSuccess) {
        emit(state.copyWithRefreshing(RefreshingStatus.noConnection));
      } else {
        emit(StatisticNoConnection());
      }
    }
  }

  static Future<bool> _getIsConnected() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi;
  }
}

abstract class StatisticState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatisticLoading extends StatisticState {}

class StatisticNoConnection extends StatisticState {}

class StatisticSuccess extends StatisticState {
  final DateTime lastUpdate;
  final Statistic worldStatistic;
  final CountryStatistic? countryStatistic;
  final RefreshingStatus refreshing;

  StatisticSuccess({
    required this.lastUpdate,
    required this.worldStatistic,
    required this.countryStatistic,
    required this.refreshing,
  });

  StatisticSuccess copyWithRefreshing(RefreshingStatus refreshing) {
    return StatisticSuccess(
      lastUpdate: lastUpdate,
      worldStatistic: worldStatistic,
      countryStatistic: countryStatistic,
      refreshing: refreshing,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
      'world': worldStatistic.toMap(),
      'country': countryStatistic?.toMap(),
    };
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      lastUpdate,
      worldStatistic,
      countryStatistic,
      refreshing,
    ]);
}

enum RefreshingStatus {
  loading,
  refreshed,
  noConnection,
}

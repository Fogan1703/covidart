import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country/country.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/statistic.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final SharedPreferences _prefs;

  StatisticCubit._({
    required StatisticState state,
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        super(state) {
    refresh();
  }

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
        worldStatistic: Statistic.fromMap(
          total: data['world']['total'],
          today: data['world']['today'],
        ),
        countryStatistic: data['country'] != null
            ? CountryStatistic.fromMap(
                total: data['country']['total'],
                today: data['country']['today'],
                country: Countries.values.singleWhere(
                  (country) =>
                      country.countryCode == data['country']['country'],
                ),
              )
            : null,
        refreshing: RefreshingStatus.loading,
      ),
      prefs: prefs,
    );
  }

  Future<void> refresh() async {
    final state = this.state;

    if (state is StatisticSuccess) {
      emit(state.copyWithRefreshing(RefreshingStatus.loading));
    } else {
      emit(StatisticLoading());
    }

    if (await _getIsConnected()) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final worldTotalResponse = await Dio().get(
        'https://api.covid19api.com/world/total',
      );
      final worldTodayResponse = await Dio().get(
        'https://api.covid19api.com/world'
        '?from=${today.toIso8601String()}&'
        'to=${now.toIso8601String()}',
      );

      late CountryStatistic? countryStatistic;

      if (state is StatisticSuccess && state.countryStatistic != null) {
        final countryCode = state.countryStatistic!.country.countryCode;
        final countryTotalResponse = await Dio().get(
          'https://api.covid19api.com/total/country/$countryCode',
        );
        final countryTodayResponse = await Dio().get(
          'https://api.covid19api.com/total/country/$countryCode'
          '?from=${today.toIso8601String()}&'
          'to=${now.toIso8601String()}',
        );
        countryStatistic = CountryStatistic.fromMap(
          total: countryTotalResponse.data,
          today: countryTodayResponse.data,
          country: state.countryStatistic!.country,
        );
      }

      final newState = StatisticSuccess(
        lastUpdate: DateTime.now(),
        worldStatistic: Statistic.fromMap(
          total: worldTotalResponse.data,
          today: worldTodayResponse.data,
        ),
        countryStatistic: countryStatistic,
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
      'world': {
        'total': worldStatistic.totalToMap(),
        'today': worldStatistic.todayToMap(),
      },
      'country': countryStatistic != null
          ? {
              'country': countryStatistic!.country.countryCode,
              'total': countryStatistic!.totalToMap(),
              'today': countryStatistic!.todayToMap(),
            }
          : null,
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

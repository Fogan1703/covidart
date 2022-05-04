import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
        super(state);

  factory StatisticCubit({required SharedPreferences prefs}) {
    final stringedData = prefs.getString('data');

    if (stringedData == null) {
      return StatisticCubit._(
        state: StatisticLoading(),
        prefs: prefs,
      )..refresh();
    }

    final Map<String, dynamic> data = jsonDecode(stringedData);

    return StatisticCubit._(
      state: StatisticSuccess(
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(data['lastUpdate']),
        worldStatistic: Statistic.fromMap(
          data['worldStatistic'],
          countryCode: null,
        ),
        countryStatistic: data['countryStatistic'] != null
            ? Statistic.fromMap(
                data['countryStatistic'],
                countryCode: data['countryStatistic']['country'],
              )
            : null,
        refreshing: RefreshingStatus.loading,
      ),
      prefs: prefs,
    )..refresh();
  }

  Future<void> refresh() async {
    final state = this.state;

    if (state is StatisticSuccess) {
      emit(state.copyWith(
        refreshing: RefreshingStatus.loading,
      ));
    } else {
      emit(StatisticLoading());
    }

    if (await _getIsConnected()) {
      final response = await Dio().get('https://api.covid19api.com/summary');
      final data = response.data as Map<String, dynamic>;

      final newState = StatisticSuccess(
        lastUpdate: DateTime.now(),
        worldStatistic: Statistic.fromMap(data['Global'], countryCode: null),
        countryStatistic:
            state is StatisticSuccess && state.countryStatistic != null
                ? Statistic.fromMap(
                    data['Global'],
                    countryCode: state.countryStatistic!.country!.countryCode,
                  )
                : null,
        refreshing: RefreshingStatus.refreshed,
      );

      _prefs.setString('data', jsonEncode(newState.toMap()));

      emit(newState);
    } else {
      if (state is StatisticSuccess) {
        emit(state.copyWith(refreshing: RefreshingStatus.noConnection));
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
  final Statistic? countryStatistic;
  final RefreshingStatus refreshing;

  StatisticSuccess({
    required this.lastUpdate,
    required this.worldStatistic,
    required this.countryStatistic,
    required this.refreshing,
  });

  StatisticSuccess copyWith({
    DateTime? lastUpdate,
    Statistic? worldStatistic,
    Statistic? countryStatistic,
    RefreshingStatus? refreshing,
  }) {
    return StatisticSuccess(
      lastUpdate: lastUpdate ?? this.lastUpdate,
      worldStatistic: worldStatistic ?? this.worldStatistic,
      countryStatistic: countryStatistic ?? this.countryStatistic,
      refreshing: refreshing ?? this.refreshing,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
      'worldStatistic': worldStatistic.toMap(),
      'countryStatistic': countryStatistic?.toMap(),
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

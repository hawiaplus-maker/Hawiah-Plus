import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/home/presentation/model/services_model.dart';

import 'home-services-state.dart';

class HomeServicesCubit extends Cubit<HomeServicesState> {
  HomeServicesCubit() : super(HomeServicesInitial());

  ApiResponse _servicesResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get servicesResponse => _servicesResponse;

  ServicesModel? _services;
  ServicesModel? get services => _services;

  Future<void> getServices() async {
    // Renamed to CamelCase from getservices
    _servicesResponse = ApiResponse(state: ResponseState.loading, data: null);
    emit(HomeServicesLoading());

    _servicesResponse =
        await ApiHelper.instance.get(Urls.services, queryParameters: {"best_seller": 1});

    if (_servicesResponse.state == ResponseState.complete && _servicesResponse.data != null) {
      _services = ServicesModel.fromJson(_servicesResponse.data);
      if (_services != null) {
        emit(HomeServicesLoaded(services: _services!, response: _servicesResponse));
      } else {
        emit(HomeServicesError(_servicesResponse));
      }
    } else {
      emit(HomeServicesError(_servicesResponse));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/model/city_model.dart';
import 'package:hawiah_client/features/location/presentation/model/neighborhood_model.dart';

class AddressCubit extends Cubit<AddressState> {
  static AddressCubit get(BuildContext context) => BlocProvider.of(context);

  AddressCubit() : super(AddressInitial());

  changeRebuild() {
    emit(AddressUpdate());
  }

  void initialCitys() {
    _citysResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _citys = [];
    emit(AddressUpdate());
  }

  ApiResponse _citysResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get citysResponse => _citysResponse;
  List<CityModel> _citys = [];
  List<CityModel> get citys => _citys;

  Future<void> getcitys() async {
    _citysResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );

    _citys = [];
    emit(AddressUpdate());
    _citysResponse = await ApiHelper.instance.get(
      Urls.cities,
    );
    if (_citysResponse.state == ResponseState.complete) {
      Iterable iterable = _citysResponse.data['message'];
      _citys = iterable.map((e) => CityModel.fromJson(e)).toList();
      emit(AddressUpdate());
    }
  }

//====================== neighborhoods

  void initialNeighborhoods() {
    _neighborhoodsResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _neighborhoods = [];
    emit(AddressUpdate());
  }

  ApiResponse _neighborhoodsResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get neighborhoodsResponse => _neighborhoodsResponse;
  List<NeighborhoodModel> _neighborhoods = [];
  List<NeighborhoodModel> get neighborhoods => _neighborhoods;

  Future<void> getneighborhoods(int id) async {
    _neighborhoodsResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _neighborhoods = [];
    emit(AddressUpdate());
    _neighborhoodsResponse = await ApiHelper.instance.get(
      Urls.neighborhoodsByCity(id),
    );
    if (_neighborhoodsResponse.state == ResponseState.complete) {
      Iterable iterable = _neighborhoodsResponse.data['message'];
      _neighborhoods =
          iterable.map((e) => NeighborhoodModel.fromJson(e)).toList();
      emit(AddressUpdate());
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/home/presentation/model/slider_model.dart';

import 'home-sliders-state.dart';

class HomeSlidersCubit extends Cubit<HomeSlidersState> {
  HomeSlidersCubit() : super(HomeSlidersInitial());

  ApiResponse _homeSlidersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get homeSlidersResponse => _homeSlidersResponse;

  List<SliderModel> _homeSliders = [];
  List<SliderModel> get homeSliders => _homeSliders;

  Future<void> getHomeSliders() async {
    _homeSlidersResponse = ApiResponse(state: ResponseState.loading, data: null);
    emit(HomeSlidersLoading());

    _homeSlidersResponse = await ApiHelper.instance.get(Urls.sliders);

    if (_homeSlidersResponse.state == ResponseState.complete && _homeSlidersResponse.data != null) {
      Iterable iterable = _homeSlidersResponse.data['data'];
      _homeSliders = iterable.map((e) => SliderModel.fromJson(e)).toList();
      emit(HomeSlidersLoaded(sliders: _homeSliders, response: _homeSlidersResponse));
    } else {
      emit(HomeSlidersError(_homeSlidersResponse));
    }
  }
}

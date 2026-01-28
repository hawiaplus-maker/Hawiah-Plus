import 'package:equatable/equatable.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/features/home/presentation/model/slider_model.dart';

abstract class HomeSlidersState extends Equatable {
  const HomeSlidersState();

  @override
  List<Object> get props => [];
}

class HomeSlidersInitial extends HomeSlidersState {}

class HomeSlidersLoading extends HomeSlidersState {}

class HomeSlidersLoaded extends HomeSlidersState {
  final List<SliderModel> sliders;
  final ApiResponse response;

  const HomeSlidersLoaded({required this.sliders, required this.response});

  @override
  List<Object> get props => [sliders, response];
}

class HomeSlidersError extends HomeSlidersState {
  final ApiResponse response;
  const HomeSlidersError(this.response);

  @override
  List<Object> get props => [response];
}

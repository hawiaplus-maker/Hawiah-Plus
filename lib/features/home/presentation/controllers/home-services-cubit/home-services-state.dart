import 'package:equatable/equatable.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/features/home/presentation/model/services_model.dart';

abstract class HomeServicesState extends Equatable {
  const HomeServicesState();

  @override
  List<Object> get props => [];
}

class HomeServicesInitial extends HomeServicesState {}

class HomeServicesLoading extends HomeServicesState {}

class HomeServicesLoaded extends HomeServicesState {
  final ServicesModel services;
  final ApiResponse response;

  const HomeServicesLoaded({required this.services, required this.response});

  @override
  List<Object> get props => [services, response];
}

class HomeServicesError extends HomeServicesState {
  final ApiResponse response;
  const HomeServicesError(this.response);

  @override
  List<Object> get props => [response];
}

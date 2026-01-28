import 'package:equatable/equatable.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';

abstract class HomeCategoriesState extends Equatable {
  const HomeCategoriesState();

  @override
  List<Object> get props => [];
}

class HomeCategoriesInitial extends HomeCategoriesState {}

class HomeCategoriesLoading extends HomeCategoriesState {}

class HomeCategoriesLoaded extends HomeCategoriesState {
  final List<SingleCategoryModel> categories;
  final ApiResponse response;

  const HomeCategoriesLoaded({required this.categories, required this.response});

  @override
  List<Object> get props => [categories, response];
}

class HomeCategoriesError extends HomeCategoriesState {
  final ApiResponse response;
  const HomeCategoriesError(this.response);

  @override
  List<Object> get props => [response];
}

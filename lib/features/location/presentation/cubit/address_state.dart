import 'package:hawiah_client/features/location/presentation/model/city_model.dart';
import 'package:hawiah_client/features/location/presentation/model/neighborhood_model.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressUpdate extends AddressState {}

class AddressLoading extends AddressState {}

class AddressCitiesLoaded extends AddressState {
  final List<CityModel> cities;
  AddressCitiesLoaded(this.cities);
}

class AddressNeighborhoodsLoaded extends AddressState {
  final List<NeighborhoodModel> neighborhoods;
  AddressNeighborhoodsLoaded(this.neighborhoods);
}

class AddressDataLoaded extends AddressState {
  final List<CityModel> cities;
  final List<NeighborhoodModel>? neighborhoods;
  
  AddressDataLoaded({
    required this.cities,
    this.neighborhoods,
  });
}

class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}

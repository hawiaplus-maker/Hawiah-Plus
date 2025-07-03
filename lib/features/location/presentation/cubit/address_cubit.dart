import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  static AddressCubit get(BuildContext context) => BlocProvider.of(context);

  AddressCubit() : super(AddressInitial());
  String? languageSelected;

  changeRebuild() {
    emit(AddressUpdate());
  }

  }

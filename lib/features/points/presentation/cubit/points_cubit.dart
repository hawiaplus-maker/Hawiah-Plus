import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  PointsCubit() : super(PointsInitial());
}

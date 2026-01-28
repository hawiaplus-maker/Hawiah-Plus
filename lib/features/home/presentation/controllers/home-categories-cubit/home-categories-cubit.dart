import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';

import 'home-categories-state.dart';

class HomeCategoriesCubit extends Cubit<HomeCategoriesState> {
  HomeCategoriesCubit() : super(HomeCategoriesInitial());

  ApiResponse _homeCategoriesResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get homeCategoriesResponse => _homeCategoriesResponse;

  List<SingleCategoryModel> _homeCategories = [];
  List<SingleCategoryModel> get homeCategories => _homeCategories;

  Future<void> getHomeCategories() async {
    _homeCategoriesResponse = ApiResponse(state: ResponseState.loading, data: null);
    emit(HomeCategoriesLoading());

    _homeCategoriesResponse =
        await ApiHelper.instance.get(Urls.categories, queryParameters: {"show_on_main_page": 1});

    if (_homeCategoriesResponse.state == ResponseState.complete &&
        _homeCategoriesResponse.data != null) {
      Iterable iterable = _homeCategoriesResponse.data['message'];
      _homeCategories = iterable.map((e) => SingleCategoryModel.fromJson(e)).toList();
      emit(HomeCategoriesLoaded(categories: _homeCategories, response: _homeCategoriesResponse));
    } else {
      emit(HomeCategoriesError(_homeCategoriesResponse));
    }
  }

  ApiResponse _categoriesResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get categoriesResponse => _categoriesResponse;

  List<SingleCategoryModel> _categories = [];
  List<SingleCategoryModel> get categories => _categories;

  Future<void> getCategories() async {
    _categoriesResponse = ApiResponse(state: ResponseState.loading, data: null);
    emit(HomeCategoriesLoading());

    _categoriesResponse = await ApiHelper.instance.get(Urls.categories);

    if (_categoriesResponse.state == ResponseState.complete && _categoriesResponse.data != null) {
      Iterable iterable = _categoriesResponse.data['message'];
      _categories = iterable.map((e) => SingleCategoryModel.fromJson(e)).toList();
      emit(HomeCategoriesLoaded(
          categories: _homeCategories,
          response:
              _homeCategoriesResponse)); // Emit updated state? Should probably have separate state or combined state.
      // For now, re-emitting Loaded with homeCategories is fine as long as UI listening to homeCategories doesn't break.
      // Ideally should have a state that holds both or separate states.
      // But HomeCategoriesState currently only holds 'categories' (which implies homeCategories).
      // I should update State to hold both or just emit Generic Update.
    } else {
      emit(HomeCategoriesError(_categoriesResponse));
    }
  }

  // Also include general getCategories if needed by other widgets, but prioritizing HomeCategories for now.
  // Actually, LayoutMethods calls getCategories() too.
  // I should probably handle getCategories() here as well if they are related.
  // But strictly separated is better. LayoutMethods calls both getHomeCategories() AND getCategories().

  // I'll add getCategories() here as well for now to keep related logic together,
  // or create AllCategoriesCubit?
  // Let's stick to HomeCategoriesCubit for "Home Screen Categories List".
  // The "AllCategoriesScreen" likely uses "getCategories".
}

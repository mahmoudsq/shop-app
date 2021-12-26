import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/medules/categories/categories_screen.dart';
import 'package:shopapp/medules/favorites/favorites_screen.dart';
import 'package:shopapp/medules/products/products_screen.dart';
import 'package:shopapp/medules/settings/setting_screen.dart';
import 'package:shopapp/moedls/categories_model.dart';
import 'package:shopapp/moedls/change_favorites_model.dart';
import 'package:shopapp/moedls/favorites_model.dart';
import 'package:shopapp/moedls/home_model.dart';
import 'package:shopapp/moedls/login_model.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/end_point.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    const CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  late final Map<int,bool> favorites = {};
  Future<void> getHomeData()async {
    emit(ShopLoadingHomeDataState());
    try{
      var result = await DioHelper.getData(url: HOME,token: token);
      homeModel = HomeModel.fromJson(result.data);

      for (var element in homeModel!.data!.products!) {
        favorites.addAll({element.id: element.inFavorites});
      }
      debugPrint(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }catch(e){
      emit(ShopErrorHomeDataState());
    }
/*     DioHelper.getData(url: HOME,token: token).then((value) async{
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel.data!.banners.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((e){
      emit(ShopErrorHomeDataState());
    });*/
  }

  CategoriesModel? categoriesModel;
  Future<void> getCategories() async{
    emit(ShopLoadingCategoriesState());
    try{
      var result = await DioHelper.getData(url: GET_CATEGORIES);
      categoriesModel = CategoriesModel.fromJson(result.data);
      emit(ShopSuccessCategoriesState());
    }catch(e){
      emit(ShopErrorCategoriesState());
    }

    /*DioHelper.getData(url: GET_CATEGORIES).then((value)async{
      categoriesModel =  CategoriesModel.fromJson(value.data);
      printFullText(categoriesModel.data!.toString());
      emit(ShopSuccessCategoriesState());
    }).catchError((e){
      emit(ShopErrorCategoriesState());
    });*/
  }

  late final ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId){
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(url: FAVORITES,token: token ,data: {'product_id' : productId}).then((value){
      changeFavoritesModel= ChangeFavoritesModel.fromJson(value.data);
      //debugPrint(changeFavoritesModel.message);
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
      if(!changeFavoritesModel.status){
        favorites[productId] = !favorites[productId]!;
      }else{
        getFavorites();
      }
      emit(ShopChangeFavoritesState());
    }).catchError((e){
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites(){
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(url: FAVORITES,token: token).then((value){
      //print(token);
      favoritesModel = FavoritesModel.fromJson(value.data);
      //debugPrint('getFavorites ' + value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((e){
      debugPrint('getFavorites ' + e.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name);

      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

}
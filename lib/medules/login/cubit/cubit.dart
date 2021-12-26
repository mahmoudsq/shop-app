import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/medules/login/cubit/states.dart';
import 'package:shopapp/moedls/login_model.dart';
import 'package:shopapp/shared/network/end_point.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginState> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel shopLoginModel;

  void userLogin({required email, required password}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: LOGIN, data: {'email': email, 'password': password}).then((value) {
          debugPrint(value.data.toString());
          shopLoginModel = ShopLoginModel.fromJson(value.data);
          emit(ShopLoginSuccessState(shopLoginModel));
    }).catchError((e){
      emit(ShopLoginErrorState(e.toString()));
      debugPrint(e.toString());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined :  Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
}

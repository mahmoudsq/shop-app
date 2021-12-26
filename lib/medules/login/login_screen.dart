import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/shop_layout.dart';
import 'package:shopapp/medules/login/cubit/cubit.dart';
import 'package:shopapp/medules/register/register_screen.dart';
import 'package:shopapp/shared/components/componants.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';

import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginState>(
        listener: (context, state) {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status){
              showToast(context: context,globalKey: globalKey,text: state.loginModel.message ?? 'Success'
                  ,color:  Colors.green);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value){
                token = state.loginModel.data!.token;
                navigateAndFinish(context, const ShopLayout());
              });
            }else{
              showToast(context: context,globalKey: globalKey,text: state.loginModel.message ?? 'Error'
                  ,color: Colors.red);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPress: (){
                            ShopLoginCubit.get(context).changePasswordVisibility();
                          },
                          onSubmit: (value){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        state is !ShopLoginLoadingState ? defaultButton(
                          function: (){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          text: 'Login',
                          isUpperCase: true,
                        ) : const Center(child: CircularProgressIndicator(),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(
                                  context, RegisterScreen(),);
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

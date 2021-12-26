import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/shop_layout.dart';
import 'package:shopapp/medules/login/login_screen.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/cubit/app_cubit.dart';
import 'package:shopapp/shared/cubit/states.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';
import 'package:shopapp/shared/styles/themes.dart';
import 'medules/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;

  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding') ;
  token = CacheHelper.getData(key: 'token');

  if(onBoarding != null){
    if(token != null){
      widget = const ShopLayout();
    }else{
      widget = LoginScreen();
    }
  }else{
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isDark,required this.startWidget}) : super(key: key);
  final bool isDark;
  final Widget startWidget;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) =>
          ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData()
        ),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}

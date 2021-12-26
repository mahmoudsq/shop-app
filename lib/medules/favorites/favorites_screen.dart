import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/shared/components/componants.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key? key}) : super(key: key);
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        if(state is ShopLoadingGetFavoritesState){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else{
          return Scaffold(
            key: globalKey,
            body: cubit.favoritesModel == null ? const Center(child: Text('No Favorites Items'),)
                : ListView.separated(
              itemBuilder: (context, index) =>
                  buildListProduct(cubit.favoritesModel!.data!.data[index].product, context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: cubit.favoritesModel!.data!.data.length,
            ),
          );
        }
      },
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/cubit/cubit.dart';
import 'package:shopapp/layout/cubit/states.dart';
import 'package:shopapp/moedls/categories_model.dart';
import 'package:shopapp/moedls/home_model.dart';
import 'package:shopapp/shared/components/componants.dart';
import 'package:shopapp/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesState){
          if(!state.model.status){
            showToast(context: context, globalKey: globalKey,
                text: state.model.message, color: Colors.red);
          }
        }
        if( state is ShopErrorChangeFavoritesState){
          showToast(context: context, globalKey: globalKey,
              text: 'error', color: Colors.red);
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        if(cubit.homeModel == null || cubit.categoriesModel == null){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else{
          return Scaffold(
            key: globalKey,
            body: productsBuilder(
                cubit.homeModel, cubit.categoriesModel, context),
          );
        }
 /*       if (state is ShopLoadingHomeDataState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ShopLoadingCategoriesState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return productsBuilder(
              cubit.homeModel, cubit.categoriesModel, context);
        }*/
        /*return (ShopCubit.get(context).homeModel == null &&
            ShopCubit.get(context).categoriesModel == null)
            ? const Center(
                child: CircularProgressIndicator(),)
            : productsBuilder(ShopCubit.get(context).homeModel!,ShopCubit.get(context).categoriesModel!);*/
      },
    );
  }

  Widget productsBuilder(HomeModel? homeModel, CategoriesModel? categoriesModel,
          BuildContext context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: homeModel!.data!.banners!
                  .map((e) => Image(
                        image: NetworkImage(e.image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 300,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      itemBuilder: (context, index) =>
                          buildCategoryItem(categoriesModel!.data!.data[index]),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 20,
                      ),
                      itemCount: categoriesModel!.data!.data.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1 / 1.5,
                children: List.generate(
                    homeModel.data!.products!.length,
                    (index) => buildGirdProduct(
                        homeModel.data!.products![index], context)),
              ),
            )
          ],
        ),
      );

  Widget buildCategoryItem(DataModel dataModel) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(dataModel.image!),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
            width: 100,
            child: Text(
              dataModel.name!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      );

  Widget buildGirdProduct(ProductModel productModel, BuildContext context) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(productModel.image),
                  width: double.infinity,
                  //fit: BoxFit.fitWidth,
                  height: 200,
                ),
                productModel.discount != 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        color: Colors.red,
                        child: Text(
                          'Discount'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(
                    productModel.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, height: 1.2),
                  ),
                  Row(
                    children: [
                      Text(
                        productModel.price.round().toString(),
                        style:
                            const TextStyle(fontSize: 12, color: defaultColor),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      productModel.discount != 0
                          ? Text(
                              productModel.oldPrice.round().toString(),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            )
                          : const Text(''),
                      const Spacer(),
                      IconButton(
                        onPressed: () => ShopCubit.get(context).changeFavorites(productModel.id),
                        icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: ShopCubit.get(context).favorites[productModel.id]!
                                ? defaultColor : Colors.grey,
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

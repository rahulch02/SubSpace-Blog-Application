import 'package:blog_app/features/favourites/bloc/favourites_bloc.dart';
import 'package:blog_app/features/home/models/blog_product_data.dart';
import 'package:flutter/material.dart';
// import '../bloc/home_bloc.dart';

class FavouritesTile extends StatelessWidget {
  final FavouritesBloc favouritesBloc = FavouritesBloc();
  final BlogDataModel blogDataModel;
  FavouritesTile({super.key, required this.blogDataModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(offset: Offset(3, 3), blurRadius: 5, color: Colors.grey)
          ]),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        blogDataModel.imageUrl,
                      ),
                      fit: BoxFit.cover)),
              height: 200,
              width: double.maxFinite,
            ),
            const SizedBox(height: 5),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 300,
                    child: Text(
                      blogDataModel.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      favouritesBloc.add(FavouritesRemoveBlogEvent(
                          blogDataModel: blogDataModel));
                    },
                  )
                ],
              ),
            ),
            Container(
              child: const Text('Sample Blog Description'),
            ),
            const SizedBox(height: 5),
          ]),
    );
  }
}

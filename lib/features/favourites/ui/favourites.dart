import 'package:blog_app/features/favourites/bloc/favourites_bloc.dart';
import 'package:blog_app/features/favourites/ui/favourites_tile.dart';
import 'package:blog_app/features/home/ui/blog_page.dart';
import 'package:blog_app/features/home/ui/blog_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final FavouritesBloc favouritesBloc = FavouritesBloc();

  @override
  void initState() {
    favouritesBloc.add(FavouritesInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavouritesBloc, FavouritesState>(
      bloc: favouritesBloc,
      listenWhen: (previous, current) => current is FavouritesActionState,
      buildWhen: (previous, current) => current is! FavouritesActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case FavouritesSuccessState:
            final successState = state as FavouritesSuccessState;
            print('Rebuilt Favourites Page');
            print(successState.favouriteBlogs.length);
            return Scaffold(
              appBar: AppBar(title: Text('Favourite Blogs')),
              body: ListView.builder(
                  itemCount: successState.favouriteBlogs.length,
                  itemBuilder: (context, index) => InkWell(
                        child: FavouritesTile(
                            blogDataModel: successState.favouriteBlogs[index]),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlogPage(
                                  blogDataModel:
                                      successState.favouriteBlogs[index])));
                        },
                      )),
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}

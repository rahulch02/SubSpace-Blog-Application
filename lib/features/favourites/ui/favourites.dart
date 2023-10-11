import 'package:blog_app/features/favourites/bloc/favourites_bloc.dart';
import 'package:blog_app/features/favourites/ui/favourites_tile.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Pages'),
        centerTitle: true,
      ),
      body: BlocConsumer<FavouritesBloc, FavouritesState>(
        bloc: favouritesBloc,
        listenWhen: (previous, current) => current is FavouritesActionState,
        buildWhen: (previous, current) =>
            current is! FavouritesActionState ||
            previous is! FavouritesActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case FavouritesSuccessState:
              final successState = state as FavouritesSuccessState;
              print('Rebuilt Favourites Page');
              print(successState.favouriteBlogs.length);
              return ListView.builder(
                  itemCount: successState.favouriteBlogs.length,
                  itemBuilder: (context, index) => FavouritesTile(
                      blogDataModel: successState.favouriteBlogs[index]));
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}

import 'package:blog_app/data/favourite_blogs.dart';
import 'package:blog_app/features/favourites/ui/favourites.dart';
import 'package:blog_app/features/home/bloc/home_bloc.dart';
import 'package:blog_app/features/home/ui/blog_tile.dart';
import 'package:blog_app/features/home/ui/home_loaded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc homebloc = HomeBloc();

  @override
  void initState() {
    homebloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homebloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is NavigateToWishListActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Favourites()));
        } else if (state is HomeFavouriteBlogActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Blog Added!'),
          ));
        } else if (state is HomeErrorState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Failed to Fetch Blogs'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Reason: ${state.message}\nPress OK to retry!'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          homebloc.add(HomeInitialEvent());
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
              barrierDismissible: false);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));

          case HomeLoadingSuccessState:
            final successState = state as HomeLoadingSuccessState;

            return HomeLoaded(
              bloc: homebloc,
              successState: successState,
            );

          case HomeErrorState:
            return const Scaffold(
              body: Center(child: Text('Error')),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}

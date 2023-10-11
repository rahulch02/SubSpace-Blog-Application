import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_app/data/favourite_blogs.dart';
import 'package:blog_app/database/sql_helper.dart';
import 'package:blog_app/features/home/models/blog_product_data.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../data/blog_data.dart';
import '../../../network/fetch_blog_data.dart';

part 'home_event.dart';
part 'home_state.dart';

void refreshBlogDb() async {
  await SQLHelper.deleteBlogs();
  blogPages.forEach((element) async {
    await SQLHelper.createBlog(
        element['title'], element['image_url'], element['id']);
  });
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    FutureOr<void> homeFavouritesNavigateEvent(
        HomeFavouritesNavigateEvent event, Emitter<HomeState> emitter) {
      print('Wishlist clicked!');
      emit(NavigateToWishListActionState());
    }

    FutureOr<void> homeInitialEvent(
        HomeInitialEvent event, Emitter<HomeState> emit) async {
      emit(HomeLoadingState());

      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          List<List<Map<String, dynamic>>> res = await fetchBlogs();
          if (res[0].isNotEmpty && res.length == 2) {
            blogPages = res[0];
            refreshBlogDb();
            emit(HomeLoadingSuccessState(
                blogs: blogPages
                    .map((element) => BlogDataModel(
                        id: element['id'],
                        name: element['title'],
                        // description: element['description'],
                        imageUrl: element['image_url']))
                    .toList()));
          } else if (res.length == 2) {
            emit(HomeErrorState(message: res[1][0]['string']));
          } else {
            emit(HomeErrorState(message: res[0][0]['string']));
          }
        }
      } on SocketException catch (_) {
        blogPages = await SQLHelper.getBlogs();
        print(blogPages);
        blogPages = blogPages
            .map((element) => {
                  'id': element['blogid'],
                  'title': element['title'],
                  'image_url': element['imageurl']
                })
            .toList();
        emit(HomeLoadingSuccessState(
            blogs: blogPages
                .map((element) => BlogDataModel(
                    id: element['id'],
                    name: element['title'],
                    // description: element['description'],
                    imageUrl: element['image_url']))
                .toList()));
      }
    }

    FutureOr<void> homeProductFavouritesButtonClickedEvent(
        HomeBlogFavouritesButtonClickedEvent event, Emitter<HomeState> emit) {
      print('Favourited');
      if (!favouriteBlogs.any((element) => element == event.clickedBlog)) {
        favouriteBlogs.add(event.clickedBlog);
      } else {
        favouriteBlogs.remove(event.clickedBlog);
      }
      emit(HomeLoadingSuccessState(
          blogs: blogPages
              .map((element) => BlogDataModel(
                  id: element['id'],
                  name: element['title'],
                  // description: element['description'],
                  imageUrl: element['image_url']))
              .toList()));
    }

    FutureOr<void> homeBlogClickedEvent(
        HomeBlogClickedEvent event, Emitter<HomeState> emitter) async {
      emit(NavigateToBlogActionState(blogDataModel: event.clickedBlog));
    }

    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeBlogFavouritesButtonClickedEvent>(
        homeProductFavouritesButtonClickedEvent);
    on<HomeFavouritesNavigateEvent>(homeFavouritesNavigateEvent);
    on<HomeBlogClickedEvent>(homeBlogClickedEvent);
  }
}

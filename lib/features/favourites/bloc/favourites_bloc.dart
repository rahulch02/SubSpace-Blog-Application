import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_app/data/favourite_blogs.dart';
import 'package:blog_app/features/home/models/blog_product_data.dart';
import 'package:meta/meta.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc() : super(FavouritesInitial()) {
    FutureOr<void> favouriteInitialEvent(
        FavouritesInitialEvent event, Emitter<FavouritesState> emitter) {
      emit(FavouritesSuccessState(favouriteBlogs: favouriteBlogs));
    }

    FutureOr<void> favouritesRemoveEvent(
        FavouritesRemoveBlogEvent event, Emitter<FavouritesState> emitter) {
      favouriteBlogs.remove(event.blogDataModel);
      emit(FavouritesSuccessState(favouriteBlogs: favouriteBlogs));
    }

    on<FavouritesRemoveBlogEvent>(favouritesRemoveEvent);
    on<FavouritesInitialEvent>(favouriteInitialEvent);
  }
}

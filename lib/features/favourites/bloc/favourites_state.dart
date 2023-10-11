part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesState {}

abstract class FavouritesActionState extends FavouritesState {}

final class FavouritesInitial extends FavouritesState {}

final class FavouritesSuccessState extends FavouritesState {
  final List<BlogDataModel> favouriteBlogs;

  FavouritesSuccessState({required this.favouriteBlogs});
}

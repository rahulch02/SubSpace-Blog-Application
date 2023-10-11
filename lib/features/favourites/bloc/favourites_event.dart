part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent {}

class FavouritesInitialEvent extends FavouritesEvent {}

class FavouritesRemoveBlogEvent extends FavouritesEvent {
  final BlogDataModel blogDataModel;

  FavouritesRemoveBlogEvent({required this.blogDataModel});
}

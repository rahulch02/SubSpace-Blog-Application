part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeBlogFavouritesButtonClickedEvent extends HomeEvent {
  final BlogDataModel clickedBlog;

  HomeBlogFavouritesButtonClickedEvent({required this.clickedBlog});
}

class HomeFavouritesNavigateEvent extends HomeEvent {}

class HomeBlogClickedEvent extends HomeEvent {
  final BlogDataModel clickedBlog;

  HomeBlogClickedEvent({required this.clickedBlog});
}

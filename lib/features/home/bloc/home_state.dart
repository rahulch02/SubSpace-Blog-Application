part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadingSuccessState extends HomeState {
  final List<BlogDataModel> blogs;
  HomeLoadingSuccessState({required this.blogs});
}

class HomeErrorState extends HomeActionState {
  final String message;

  HomeErrorState({required this.message});
}

class NavigateToWishListActionState extends HomeActionState {}

class HomeFavouriteBlogActionState extends HomeActionState {}

class NavigateToBlogActionState extends HomeActionState {
  final BlogDataModel blogDataModel;

  NavigateToBlogActionState({required this.blogDataModel});
}

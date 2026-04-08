


import 'package:movies_app/features/home/home_tab/data/models/movie_model.dart' show MovieModel;

abstract class BrowseState {}

class BrowseInitial extends BrowseState {}
class BrowseLoading extends BrowseState {}
class BrowseSuccess extends BrowseState {
  final List<MovieModel> movies;
  final String selectedGenre;
  BrowseSuccess(this.movies, this.selectedGenre);
}
class BrowseError extends BrowseState {
  final String message;
  BrowseError(this.message);
}
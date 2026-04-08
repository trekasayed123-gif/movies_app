abstract class BrowseEvent {}

class GetMoviesByGenreEvent extends BrowseEvent {
  final String genre;
  GetMoviesByGenreEvent(this.genre);
}
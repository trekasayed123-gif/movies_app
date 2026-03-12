abstract class SearchEvent {}
class ExecuteSearchEvent extends SearchEvent {
  final String query;
  ExecuteSearchEvent(this.query);
}
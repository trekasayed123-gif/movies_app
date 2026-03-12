import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/home/home_tab/domain/repo/home_repo.dart';
import 'package:movies_app/features/home/search_tab/presentation/view_model/search_event.dart' show SearchEvent, ExecuteSearchEvent;
import 'package:movies_app/features/home/search_tab/presentation/view_model/search_state.dart' show SearchState, SearchInitial, SearchLoading, SearchSuccess, SearchError;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepo homeRepo;
  SearchBloc(this.homeRepo) : super(SearchInitial()) {
    on<ExecuteSearchEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final movies = await homeRepo.fetchMovies(query: event.query);
        emit(SearchSuccess(movies));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
}
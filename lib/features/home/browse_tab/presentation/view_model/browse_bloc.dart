import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/home/browse_tab/presentation/view_model/browse_event..dart' show GetMoviesByGenreEvent, BrowseEvent;
import '../../../home_tab/domain/repo/home_repo.dart';

import 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final HomeRepo homeRepo;

  BrowseBloc(this.homeRepo) : super(BrowseInitial()) {
    on<GetMoviesByGenreEvent>((event, emit) async {
      emit(BrowseLoading());
      try {
        final movies = await homeRepo.fetchMovies(genre: event.genre, query: '' );
        emit(BrowseSuccess(movies, event.genre));
      } catch (e) {
        emit(BrowseError(e.toString()));
      }
    });
  }
}
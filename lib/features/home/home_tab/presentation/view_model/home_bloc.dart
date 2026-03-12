import 'package:flutter_bloc/flutter_bloc.dart'; // هذا هو السطر الناقص الأساسي
import 'package:movies_app/features/home/home_tab/domain/repo/home_repo.dart';
import 'package:movies_app/features/home/home_tab/presentation/view_model/home_event.dart';
import 'package:movies_app/features/home/home_tab/presentation/view_model/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo homeRepo;

  HomeBloc(this.homeRepo) : super(HomeInitial()) {
    on<GetMoviesEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final movies = await homeRepo.fetchMovies(genre: '', query: '' );
        emit(HomeSuccess(movies));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}

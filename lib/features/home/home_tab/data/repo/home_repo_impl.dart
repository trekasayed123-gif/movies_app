import 'package:dio/dio.dart';
import 'package:movies_app/config/api/end_points.dart';
import 'package:movies_app/features/home/home_tab/data/models/movie_model.dart';
import 'package:movies_app/features/home/home_tab/domain/repo/home_repo.dart';


class HomeRepoImpl implements HomeRepo {
  final Dio dio = Dio();
  @override
  Future<List<MovieModel>> fetchMovies({required String genre, required String query}) async {
    var response = await dio.get(
      EndPoints.listMovies,
      // التعديل هنا: إضافة queryParameters لإرسال الكلمة للسيرفر
      queryParameters: {
        if (query.isNotEmpty) 'query_term': query,
        if (genre.isNotEmpty) 'genre': genre,
      },
    );

    List<MovieModel> movies = [];
    if (response.data['data']['movies'] != null) {
      for (var movie in response.data['data']['movies']) {
        movies.add(MovieModel.fromJson(movie));
      }
    }
    return movies;
  }



}
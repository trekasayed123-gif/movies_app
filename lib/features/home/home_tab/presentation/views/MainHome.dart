import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/home/home_tab/data/repo/home_repo_impl.dart';
import 'package:movies_app/features/home/home_tab/presentation/view_model/home_bloc.dart';
import 'package:movies_app/features/home/home_tab/presentation/view_model/home_event.dart';
import 'package:movies_app/features/home/home_tab/presentation/widget/category_row.dart';
import 'package:movies_app/features/home/home_tab/presentation/widget/horizontal_movies_list.dart';
import 'package:movies_app/features/home/home_tab/presentation/widget/movie_carousel.dart';

import '../view_model/home_state.dart';

import 'package:movies_app/features/home/home_tab/presentation/widget/category_row.dart';
import 'package:movies_app/features/home/home_tab/presentation/widget/horizontal_movies_list.dart';
import 'package:movies_app/features/home/home_tab/presentation/widget/movie_carousel.dart';

class MainHomeTab extends StatelessWidget {
  const MainHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (context) => HomeBloc(HomeRepoImpl())..add(GetMoviesEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is HomeSuccess) {
            return Stack(
              children: [
                _buildBackground(state.movies[0].mediumCoverImage),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
                      Center(
                          child: Image.asset(AppImages.AvailableNow,
                              height: 80.h)),
                      MovieCarousel(movies: state.movies),

                      SizedBox(height: 20.h),
                      Center(
                          child: Image.asset(AppImages.WatchNowText,
                              height: 100.h)),
                      const CategoryRow(title: 'Popular Movies'),

                      HorizontalMoviesList(movies: state.movies),

                      const CategoryRow(title: 'Top Rated Movies'),
                      HorizontalMoviesList(
                          movies: state.movies.reversed.toList()),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is HomeError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBackground(String imageUrl) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.2,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

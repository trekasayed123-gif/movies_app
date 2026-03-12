import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/core/utils/app_icons.dart';
import 'package:movies_app/core/utils/app_styles.dart';

import 'package:movies_app/features/home/home_tab/data/repo/home_repo_impl.dart';
import 'package:movies_app/features/home/search_tab/presentation/view_model/search_bloc.dart';
import 'package:movies_app/features/home/search_tab/presentation/view_model/search_event.dart';
import 'package:movies_app/features/home/search_tab/presentation/view_model/search_state.dart';
import 'package:movies_app/features/movie_details/presentation/views/MovieDetailsScreen.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(HomeRepoImpl())..add(ExecuteSearchEvent("")),
      child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: AppColors.black, // تم استخدام AppColors
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),


                      TextField(
                        onChanged: (value) {
                          context.read<SearchBloc>().add(ExecuteSearchEvent(value));
                        },
                        style: AppStyles.white16400, // تم استخدام AppStyles
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: AppStyles.white14400.copyWith(color: Colors.grey),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Image.asset(
                              IconsAssets.searchIcon,
                              color: AppColors.white,
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                          fillColor: AppColors.gray,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Expanded(
                        child: BlocBuilder<SearchBloc, SearchState>(
                          builder: (context, state) {
                            if (state is SearchLoading) {
                              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                            }
                            if (state is SearchSuccess) {
                              if (state.movies.isEmpty) {
                                return Center(
                                    child: Text(
                                      "No movies found",
                                      style: AppStyles.white20400, // تم استخدام AppStyles
                                    ));
                              }
                              return GridView.builder(
                                padding: EdgeInsets.only(bottom: 20.h),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  mainAxisSpacing: 15.h,
                                  crossAxisSpacing: 15.w,
                                ),
                                itemCount: state.movies.length,
                                itemBuilder: (context, index) {
                                  final movie = state.movies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MovieDetailsScreen(movieId: movie.id),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            movie.mediumCoverImage,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                                    color: AppColors.gray,
                                                    child: Icon(Icons.broken_image, color: AppColors.white)
                                                ),
                                          ),

                                          Positioned(
                                            top: 10.h,
                                            left: 10.w,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.black.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    movie.rating.toString(),
                                                    style: AppStyles.white14400.copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Image.asset(
                                                    IconsAssets.rateIcon, // تم استخدام IconsAssets للتقييم
                                                    width: 16.w,
                                                    height: 16.h,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            if (state is SearchError) {
                              return Center(child: Text(state.message, style: TextStyle(color: AppColors.red)));
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
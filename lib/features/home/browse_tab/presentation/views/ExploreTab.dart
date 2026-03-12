import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/core/utils/app_styles.dart';
import 'package:movies_app/features/home/browse_tab/presentation/view_model/browse_event..dart';
import 'package:movies_app/features/home/home_tab/data/repo/home_repo_impl.dart';
import 'package:movies_app/features/home/search_tab/presentation/widgets/MovieCard.dart';
import '../view_model/browse_bloc.dart';

import '../view_model/browse_state.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  final List<String> genres = const [
    "Action", "Adventure", "Animation", "Biography", "Comedy", "Crime", "Drama", "Family"
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // نبدأ بجلب أفلام الأكشن كافتراض
      create: (context) => BrowseBloc(HomeRepoImpl())..add(GetMoviesByGenreEvent("Action")),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // 1. القائمة العلوية للتصنيفات
              SizedBox(
                height: 45.h,
                child: BlocBuilder<BrowseBloc, BrowseState>(
                  builder: (context, state) {
                    String selected = (state is BrowseSuccess) ? state.selectedGenre : "Action";
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        bool isSelected = genres[index] == selected;
                        return _buildGenreButton(context, genres[index], isSelected);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              // 2. شبكة الأفلام المفلترة
              Expanded(
                child: BlocBuilder<BrowseBloc, BrowseState>(
                  builder: (context, state) {
                    if (state is BrowseLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    } else if (state is BrowseSuccess) {
                      return GridView.builder(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h,
                        ),
                        itemCount: state.movies.length,
                        itemBuilder: (context, index) => MovieCard(movie: state.movies[index]),
                      );
                    } else if (state is BrowseError) {
                      return Center(child: Text(state.message, style: AppStyles.white14400));
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

  Widget _buildGenreButton(BuildContext context, String title, bool isSelected) {
    return GestureDetector(
      onTap: () => context.read<BrowseBloc>().add(GetMoviesByGenreEvent(title)),
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppStyles.white16400.copyWith(
            color: isSelected ? Colors.black : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
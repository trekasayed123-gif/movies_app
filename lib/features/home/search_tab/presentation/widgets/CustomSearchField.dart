import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/core/utils/app_icons.dart' show IconsAssets;
import 'package:movies_app/core/utils/app_styles.dart';

import 'package:movies_app/features/home/search_tab/presentation/view_model/search_bloc.dart';
import 'package:movies_app/features/home/search_tab/presentation/view_model/search_event.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        // بنبعت الحدث للـ Bloc مباشرة
        context.read<SearchBloc>().add(ExecuteSearchEvent(value));
        // بننادي على onChanged عشان نعمل setState في الصفحة الأساسية (عشان أيقونة الـ clear)
        onChanged();
      },
      style: AppStyles.white16400,
      decoration: InputDecoration(
        hintText: "Search Movies...",
        hintStyle: AppStyles.white14400.copyWith(color: Colors.grey),
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: Image.asset(
            IconsAssets.searchIcon,
            color: AppColors.white,
            width: 20.w,
            height: 20.h,
          ),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear, color: AppColors.white),
          onPressed: () {
            controller.clear();
            context.read<SearchBloc>().add(ExecuteSearchEvent(""));
            onChanged();
          },
        )
            : null,
        fillColor: AppColors.gray,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

import 'package:final_nuntius/core/shared_widgets/text_form_field.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  const SearchTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cubit = SearchCubit.get(context);
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
          previous != current &&
          (current == const SearchState.onChangeSearchTextFieldLoading() ||
              current == const SearchState.onChangeSearchTextField()),
      builder: (context, state) => CustomTextField(
        hintText: 'search now..',
        controller: controller,
        inputType: TextInputType.text,
        prefixIcon: IconBroken.Search,
        suffixIcon: cubit.searchController!.text.isNotEmpty
            ? GestureDetector(
                onTap: () => cubit.clearSearchTextField(),
                child: Icon(
                  Icons.close,
                  size: AppSize.s18,
                  color: AppColors.red,
                ),
              )
            : null,
        onChange: (value) => cubit.onChangeSearchTextField(value: value),
      ),
    );
  }
}

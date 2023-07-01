import 'package:final_nuntius/core/shared_widgets/back_button.dart';
import 'package:final_nuntius/core/shared_widgets/no_items_founded.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/search/cubit/search_cubit.dart';
import 'package:final_nuntius/features/search/presentation/widgets/search_result.dart';
import 'package:final_nuntius/features/search/presentation/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchCubit searchCubit;
  @override
  void initState() {
    searchCubit = SearchCubit.get(context);
    searchCubit.initSearch(context: context);
    super.initState();
  }

  @override
  void dispose() {
    searchCubit.disposeSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        SearchCubit cubit = SearchCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                top: AppHeight.h8,
                right: AppWidth.w10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CustomBackButton(),
                      Expanded(
                        child: SearchTextField(
                          controller: cubit.searchController!,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: cubit.searchController!.text.isEmpty
                        ? const NoItemsFounded(
                            icon: IconBroken.Search,
                            text: 'search now for your friends.',
                          )
                        : cubit.searchResult.isEmpty
                            ? const NoItemsFounded(
                                icon: IconBroken.User1,
                                text: 'there is no matching results.',
                              )
                            : SearchResult(searchResult: cubit.searchResult),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

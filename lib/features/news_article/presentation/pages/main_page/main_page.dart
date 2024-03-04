import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/core/constants/screen_padding.dart';
import 'package:news_app/features/news_article/presentation/pages/article_detail_page.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/components/main_app_bar.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/components/main_body_view.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/components/main_loading_list_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../../core/constants/ui_constants.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/entities/category.dart';
import '../../blocs/main/main_bloc.dart';
import '../../widgets/article_item_widget.dart';
import '../../widgets/loading_failed_widget.dart';
import '../../widgets/loading_list_widget.dart';
import '../../widgets/loading_widget.dart';
import '../article_list_page.dart';
import '../category_list_page.dart';
import '../search_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.sp), child: const MainAppBar()),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MainBloc>().add(const MainEvent.fetchArticles());
        },
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return state.when(
                loading: () => const MainLoadingListWidget(),
                fetched: (articles) => articles.isNotEmpty
                    ? MainBodyView(articles: articles)
                    : SizedBox.fromSize(),
                error: (_) => LoadingFailedWidget(
                      onRetry: () {
                        context
                            .read<MainBloc>()
                            .add(const MainEvent.fetchArticles());
                      },
                    ));
          },
        ),
      ),
    );
  }
}

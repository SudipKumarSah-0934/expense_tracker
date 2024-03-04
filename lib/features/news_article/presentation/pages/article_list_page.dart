import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/features/news_article/presentation/widgets/loading_failed_widget.dart';

import '../../../../core/constants/ui_constants.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/category.dart';
import '../blocs/list/list_bloc.dart';
import '../widgets/article_item_widget.dart';
import '../widgets/loading_list_widget.dart';
import 'search_page.dart';

class ArticleListPage extends StatefulWidget {
  static const routeName = '/articleList';

  final Category category;
  const ArticleListPage({Key? key, this.category = Category.GENERAL})
      : super(key: key);

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  final ScrollController _scrollController = ScrollController();
  late final ListBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<ListBloc>();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_isBottom) {
      _bloc.add(ListEvent.fetchList(widget.category));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.sp),
          child: _Appbar(category: widget.category)),
      body: RefreshIndicator(
        onRefresh: () async {
          _bloc.add(ListEvent.refreshList(widget.category));
        },
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state.articles.isNotEmpty) {
              return _ArticleListWidget(
                category: widget.category,
                articles: state.articles,
                hasMaxReached: state.hasMaxReached,
                scrollController: _scrollController,
              );
            } else {
              switch (state.status) {
                case ListStatus.loading:
                  return const LoadingListWidget();
                case ListStatus.failed:
                  return LoadingFailedWidget(
                    onRetry: () {
                      _bloc.add(ListEvent.refreshList(widget.category));
                    },
                  );
                default:
                  return SizedBox.fromSize();
              }
            }
          },
        ),
      ),
    );
  }
}

class _Appbar extends StatelessWidget {
  const _Appbar({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: 60.sp,
      title: CustomText(
        text: '${category.title} News',
        isBold: true,
        textColor: greenColor,
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.search),
          onPressed: () {
            Navigator.pushNamed(context, SearchPage.routeName);
          },
        )
      ],
    );
  }
}

class _ArticleListWidget extends StatelessWidget {
  final Category category;
  final List<Article> articles;
  final bool hasMaxReached;
  final ScrollController scrollController;
  const _ArticleListWidget(
      {Key? key,
      required this.category,
      required this.articles,
      required this.hasMaxReached,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        itemCount: hasMaxReached ? articles.length : articles.length + 1,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemBuilder: (context, index) {
          return index < articles.length
              ? ArticleItemWidget(
                  key: ValueKey(articles[index].title),
                  article: articles[index])
              : _LoadingItemWidget(
                  category: category,
                );
        });
  }
}

class _LoadingItemWidget extends StatelessWidget {
  final Category category;
  const _LoadingItemWidget({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case ListStatus.failed:
            return Container(
              padding:  EdgeInsets.all(DEFAULT_PADDING),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text('Loading failed'),
                  TextButton(
                      onPressed: () {
                        context
                            .read<ListBloc>()
                            .add(ListEvent.fetchList(category));
                      },
                      child: const Text('Retry'))
                ],
              ),
            );
          default:
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: SizedBox(
                  height: 35.h,
                  width: 35.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.8,
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}

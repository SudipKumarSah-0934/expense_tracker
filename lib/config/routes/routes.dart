import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/authentication/presentation/pages/forget_password_page.dart';
import 'package:news_app/features/authentication/presentation/pages/login_page.dart';
import 'package:news_app/features/authentication/presentation/pages/registration_page.dart';
import 'package:news_app/features/news_article/domain/entities/article.dart';
import 'package:news_app/features/news_article/domain/entities/category.dart';
import 'package:news_app/features/news_article/presentation/blocs/list/list_bloc.dart';
import 'package:news_app/features/news_article/presentation/blocs/search/search_bloc.dart';
import 'package:news_app/features/news_article/presentation/pages/article_detail_page.dart';
import 'package:news_app/features/news_article/presentation/pages/article_list_page.dart';
import 'package:news_app/features/news_article/presentation/pages/category_list_page.dart';
import 'package:news_app/features/news_article/presentation/pages/search_page.dart';
import 'package:news_app/injection_container.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    if (settings.name == CategoryListPage.routeName) {
      return MaterialPageRoute(builder: (_) => const CategoryListPage());
    } else if (settings.name == ArticleListPage.routeName) {
      final category = settings.arguments as Category? ?? Category.GENERAL;
      return MaterialPageRoute(builder: (_) {
        return BlocProvider(
          create: (context) =>
              sl.get<ListBloc>()..add(ListEvent.fetchList(category)),
          child: ArticleListPage(category: category),
        );
      });
    } else if (settings.name == ArticleDetailPage.routeName) {
      final article = settings.arguments as Article;
      return MaterialPageRoute(builder: (_) {
        return ArticleDetailPage(article: article);
      });
    } else if (settings.name == SearchPage.routeName) {
      return MaterialPageRoute(builder: (_) {
        return BlocProvider(
          create: (context) => sl.get<SearchBloc>(),
          child: const SearchPage(),
        );
      });
    } else if (settings.name == RegistrationPage.routeName) {
      return MaterialPageRoute(builder: (_) {
        return const RegistrationPage();
      });
    } else if (settings.name == ForgetPassPage.routeName) {
      return MaterialPageRoute(builder: (_) {
        return const ForgetPassPage();
      });
    } else if (settings.name == LoginPage.routeName) {
      return MaterialPageRoute(builder: (_) {
        return const LoginPage();
      });
    } else {
      assert(false, 'Need to implement ${settings.name}');
      return onGenerateRoutes(settings);
    }
  }
}

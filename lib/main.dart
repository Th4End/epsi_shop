import 'package:epsi_shop/article.dart';
import 'package:epsi_shop/page/cart.dart';
import 'package:epsi_shop/page/cart_page.dart';
import 'package:epsi_shop/page/detail_article_page.dart';
import 'package:epsi_shop/page/liste_article_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final router = GoRouter(
      routes: [
        GoRoute(
            path: "/",
          builder: (ctx, state)=>ListeArticlePage(),
          routes: [
            GoRoute(
                path: "detail",
              builder: (ctx, state)=> DetailArticlePage(article: state.extra as Article),
            ),
            GoRoute(
              path: "cart",
              builder: (ctx, state)=>const CartPage(),
            )
          ]
        )
      ]);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> Cart(),
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
        ),
      ),
    );
  }
}


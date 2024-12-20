import 'dart:convert';

import 'package:epsi_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:epsi_shop/article.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class ListeArticlePage extends StatelessWidget {
  final article = Article(
      "Sac à dos ",
      "Pour emporter des choses",
      89.95,
      "https://cluse.com/cdn/shop/files/CX04403_frontal.jpg?v=1723798776&width=540",
      "Weareable"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('epsi_shop'),
        actions: [
          IconButton(
            onPressed: (){
              context.go('/cart');
          },
            icon: Badge(
              label: Text(context.watch<Cart>().getAll().length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Article>>(
          future: fetchListArticle(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListArticle(listArticle: snapshot.data!);
            } else if(snapshot.hasError){
             return Text(snapshot.error.toString());
            }else{
            return const CircularProgressIndicator();
            }
          }
      ),

    );
  }

  Future<List<Article>> fetchListArticle() async {
    //Récupérer les données depuis fakestore api
    final res = await get(Uri.parse("https://fakestoreapi.com/products"));
    if (res.statusCode == 200) {
      //Les transformer en Liste d'articles
      print("réponse ${res.body}");
      final listMapArticles = jsonDecode(res.body) as List<dynamic>;
      return listMapArticles
          .map((map) =>
          Article(map["title"], map["description"], map["price"],
              map["image"], map["category"]))
          .toList();
    }
    //Les renvoyer
    return <Article>[];
  }
}

class ListArticle extends StatelessWidget {
  final List<Article> listArticle;
  const ListArticle({
    super.key,
    required this.listArticle
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listArticle.length,
      itemBuilder: (ctx, index) =>
          ListTile(
              onTap: () => ctx.go("/detail", extra: listArticle[index]),
              leading: Image.network(
                listArticle[index].image,
                height: 80,
                width: 80,
              ),
              title: Text(listArticle[index].nom)
          ),
    );
  }
}
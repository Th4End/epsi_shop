import 'dart:io';
import 'package:epsi_shop/article.dart';
import 'package:epsi_shop/main.dart';
import 'package:epsi_shop/page/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';


class DetailArticlePage extends StatelessWidget {
  DetailArticlePage({super.key, required this.article});
  final article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Détail"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
          ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)
                ),
                color: Colors.black,
                border: Border.all(width: 2, ),
              ),
              child: Image.network(
                article.image,
                height: 300,
                //width: MediaQuery.of(context).size.width,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.nom,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(article.prixEuro(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Catégorie: ${article.categorie}",
                      style: Theme.of(context).textTheme.titleMedium
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                article.description,
                textAlign: TextAlign.start,
              ),
            ),
            OutlinedButton(
                onPressed: (){
                  context.read<Cart>().add(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${article.nom} ajouté au panier'))
                  );
                },
                child: Text("add to cart")
            )
          ],
        ),
      ),
    );
  }
  Future<bool> await5Seconds()async{
    Future.delayed(const Duration(seconds: 5));
    return true;
  }
}
import 'package:epsi_shop/article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final _listArticles = <Article>[];

  void add(Article article) {
    _listArticles.add(article);
    notifyListeners();
  }

  void remove(Article article) {
    _listArticles.remove(article);
    notifyListeners();
  }

  List<Article> getAll() => _listArticles;

  // Ajout de la méthode clear pour vider le panier
  void clear() {
    _listArticles.clear();
    notifyListeners();
  }
}

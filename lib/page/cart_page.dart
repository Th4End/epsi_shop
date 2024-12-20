import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/article.dart';
import 'package:epsi_shop/page/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour convertir les données en JSON

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération de l'objet Cart via Provider
    final cart = context.watch<Cart>();
    // Liste des articles dans le panier
    final articles = cart.getAll();

    // Calcul du montant total HT
    double totalHT = 0;
    for (var article in articles) {
      totalHT += article.prix;
    }
    // Calcul du montant total TTC (20%)
    double totalTTC = totalHT * 1.2;

    // Fonction pour envoyer les informations de paiement
    Future<void> proceedToPayment() async {
      try {
        final response = await http.post(
          Uri.parse('https://ptsv3.com/t/EPSISHOPC2/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'articles': articles.map((article) => {
              'name': article.nom,
              'price': article.prix,
            }).toList(),
            'total': totalTTC,
            'currency': 'EUR',
          }),
        ).timeout(const Duration(seconds: 10));  // Timeout de 10 secondes

        if (response.statusCode == 200) {
          // Paiement réussi, vider le panier
          cart.clear();

          // Afficher un message de succès et rediriger l'utilisateur vers la liste des articles
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Paiement réussi'),
              content: const Text('Le paiement a été effectué avec succès !'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                    Navigator.of(context).pushReplacementNamed('/ListArticlePage'); // Redirection vers la liste des articles
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          throw Exception('Échec du paiement');
        }
      } catch (e) {
        // Log l'erreur pour déboguer
        print("Erreur de requête : $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erreur'),
            content: Text('Une erreur est survenue lors du paiement : $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Panier - Total: ${totalTTC.toStringAsFixed(2)} €"),
      ),
      body: Builder(
        builder: (context) {
          if (articles.isEmpty) {
            return const Center(
              child: Text(
                "Votre Panier est vide",
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (ctx, index) {
                final article = articles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      article.image,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(article.nom),
                    subtitle: Text(article.prixEuro()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cart.remove(article);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      // Ajout du bouton "Procéder au paiement"
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: proceedToPayment, // Appel à la fonction de paiement
          child: const Text("Procéder au paiement"),
        ),
      ),
    );
  }
}

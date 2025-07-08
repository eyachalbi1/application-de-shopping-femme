import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  int _selectedIndex = 0;
  List<Product> cart = [];
  List<Product> favorites = [];

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }
  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }
    });
  }

  bool isFavorite(Product product) => favorites.contains(product);

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      ProductListPage(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
        addToCart: addToCart,
        cartCount: cart.length,
        goToCart: () => setState(() => _selectedIndex = 2),
        toggleFavorite: toggleFavorite,
        isFavorite: isFavorite,
      ),
      FavoritesPage(favorites: favorites),
      CartPage(cart: cart),
      AccountPage()
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.pink[50],
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

List<Product> products = [
  Product(name: 'Rouge à lèvres', price: 20.0, imageUrl: 'assets/images/rouge_m1.jpg'),
  Product(name: 'mascara', price: 35.0, imageUrl: 'assets/images/mascara.jpg'),
  Product(name: 'blush', price: 40.0, imageUrl: 'assets/images/blush.jpg'),
  Product(name: 'palette', price: 60.0, imageUrl: 'assets/images/palette_4.jpg'),
];

class ProductListPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final Function(Product) addToCart;
  final Function(Product) toggleFavorite;
  final Function(Product) isFavorite;
  final int cartCount;
  final VoidCallback goToCart;

  ProductListPage({
    required this.toggleTheme,
    required this.isDarkMode,
    required this.addToCart,
    required this.toggleFavorite,
    required this.isFavorite,
    required this.cartCount,
    required this.goToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFFFCE4EC),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.jpg', height: 30, width: 30),
            SizedBox(width: 10),
            Text('Beauté Shop'),
            Spacer(),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: toggleTheme,
            ),
            Stack(
              children: [
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: goToCart),
                if (cartCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('$cartCount',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.pink[300],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/ground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text('Nos Produits',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink[800])),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.pink[100]!, Colors.pink[200]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                child: Stack(
                                  children: [
                                    Image.asset(product.imageUrl, fit: BoxFit.cover, width: double.infinity),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite(product)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () => toggleFavorite(product),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${product.price.toStringAsFixed(2)} TND',
                                      style: TextStyle(color: Colors.pink[900])),
                                  SizedBox(height: 6),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () => addToCart(product),
                                      child: Text('Ajouter'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pinkAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Product> favorites;

  FavoritesPage({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoris'), backgroundColor: Colors.pink[300]),
      backgroundColor: Color.fromARGB(255, 240, 107, 163),
      body: favorites.isEmpty
          ? Center(child: Text('Aucun produit favori 😢'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.asset(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product.name),
                    trailing: Text('${product.price.toStringAsFixed(2)} TND'),
                  ),
                );
              },
            ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cart;

  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: Text('Votre Panier'), backgroundColor: const Color.fromARGB(255, 216, 78, 124)),
      backgroundColor: Color.fromARGB(255, 240, 107, 163),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(child: Text('Votre panier est vide'))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(product.name),
                          trailing: Text('${product.price.toStringAsFixed(2)} TND'),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Total : ${total.toStringAsFixed(2)} TND',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text('Payer en ligne'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Paiement effectué avec succès! 🎉')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon Compte'), backgroundColor: Colors.pink[300]),
      backgroundColor: Color.fromARGB(255, 250, 132, 173),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Inscription', style: TextStyle(fontSize: 24, color: Colors.pink[800])),
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nom')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Merci $name pour votre inscription 💖')),
                  );
                },
                child: Text('S’inscrire'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              ),
              SizedBox(height: 40),
              Text('Témoignages', style: TextStyle(fontSize: 22, color: Colors.pink[800])),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.pink),
                  title: Text('Sarra B.'),
                  subtitle: Text('J’adore cette boutique, produits de qualité !'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.pink),
                  title: Text('Maya T.'),
                  subtitle: Text('Livraison rapide et service client top 💄'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:flutter_dish/screens/welcome_screen.dart';
import 'package:flutter_dish/widgets/cart_button.dart';

import '../helpers/cart_helper.dart';
import '../models/order.dart';
import '/widgets/nearby_restaurants.dart';
import '/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children:   [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/test.webp"),
                        fit: BoxFit.cover),
                  ),
                  accountName: Text("khalil el kadih",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  accountEmail: Text("khalil@gmail.com"),
                  currentAccountPictureSize: Size.square(99),
                  currentAccountPicture: CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage("assets/images/me.jpg")),
                ),

                ListTile(
                    title: Text("Home"),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false,
                      );
                    }
                ),

                ListTile(
                    title: Text("My products"),
                    leading: Icon(Icons.add_shopping_cart),
                    onTap: () async {
                      final cart = await CartHelper.instance.queryAllRows();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
                      );
  }
                ),

                ListTile(
                    title: Text("About"),
                    leading: Icon(Icons.help_center),
                    onTap: () { }
                ),

                ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) =>WelcomeScreen()),
                          (route) => false,
                    );}
                ),

              ],
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text("Developed by khalil el kadih © 2023",
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('OneTimeDining'),
        centerTitle: true,
        actions: [CartButton()],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    width: 0.8,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.clear, color: Colors.grey),
                ),
                hintText: 'Search Food or Restaurants',
              ),
            ),
          ),

          // TODO: for Recent Orders
          // const RecentOrders(),

          // TODO: for Nearby Restaurants
          const NearbyRestaurants(),
        ],
      ),
    );
  }

  void navigateToCartScreen(BuildContext context, List<Order> cart) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
    );
  }
}

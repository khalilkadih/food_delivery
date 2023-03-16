import 'package:flutter/material.dart';

import '../helpers/cart_helper.dart';
import '../models/order.dart';
import '/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final cart = await CartHelper.instance.queryAllRows();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
        );
      },
      icon: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.shopping_cart),
          FutureBuilder<List<Order>>(
            future: CartHelper.instance.queryAllRows(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.hasData) {
                final cartCount = snapshot.data!.length;
                return Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}

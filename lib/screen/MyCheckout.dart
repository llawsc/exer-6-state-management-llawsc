import 'package:flutter/material.dart';
import '../model/Item.dart';
import 'package:provider/provider.dart';
import "../provider/shoppingcart_provider.dart";

//Checkout Screen
class MyCheckout extends StatelessWidget {
  const MyCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Item Details"),
          const Divider(height: 1, color: Colors.black),
          checkoutItems(context),
        ],
      ),
    );
  }

  //widget that details the items added by the user
  Widget checkoutItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    //checks first if empty or not
    return products.isEmpty
        ? const Text('No items to checkout!')
        : Expanded(
            child: Column(
            children: [
              //item details
              Flexible(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(Icons.food_bank),
                      title: Text(products[index].name),
                      trailing: Text(
                        products[index].price.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: Colors.black),
              //Total cost of the items
              computeCost(),
              //Confirms the payment of the items and returns to the catalog page
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Payment Successful!"),
                    duration: Duration(seconds: 1, milliseconds: 100),
                  ));
                  context.read<ShoppingCart>().removeAll();
                  Navigator.pushNamed(context, "/products");
                },
                child: const Text("Pay Now!"),
              ),
            ],
          ));
  }

  //widget used to get the total cost of the items (to improve performance issues)
  Widget computeCost() {
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
      return Text("Total Cost to Pay: ${cart.cartTotal}");
    });
  }
}

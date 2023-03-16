import 'package:flutter/material.dart';

import '../helpers/food_helper.dart';
import '../helpers/restaurant_helper.dart';
import '../models/food.dart';
import '/models/restaurant.dart';
import '/screens/restaurant_screen.dart';
import '/widgets/rating_stars.dart';

class NearbyRestaurants extends StatelessWidget {
  const NearbyRestaurants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // TODO: title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'List of Restaurant',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // TODO: list of nearby restaurants
        FutureBuilder<List<Restaurant>>(
          future: RestaurantHelper.instance.queryAllRows().then(
              (rows) => rows.map((row) => Restaurant.fromMap(row)).toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<Restaurant> restaurants = snapshot.data!;
              List<Widget> restaurantList = restaurants.map((thisRestaurant) {
                return GestureDetector(
                  onTap: () async {
                    print("thisRestaurant: $thisRestaurant");
                    if (thisRestaurant != null && thisRestaurant.id != null) {
                      List<Food> foods = await FoodHelper.instance
                          .queryFoodsByRestaurantId(thisRestaurant.id!);
                      Restaurant updatedRestaurant = Restaurant(
                        id: thisRestaurant.id,
                        name: thisRestaurant.name,
                        address: thisRestaurant.address,
                        rating: thisRestaurant.rating,
                        imageUrl: thisRestaurant.imageUrl,
                        menu: foods,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantScreen(restaurant: updatedRestaurant),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(width: 1.0, color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Hero(
                            tag: thisRestaurant.imageUrl!,
                            child: Image.asset(
                              thisRestaurant.imageUrl!,
                              height: 150.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  thisRestaurant.name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                RatingStars(thisRestaurant.rating!),
                                const SizedBox(height: 4.0),
                                Text(
                                  thisRestaurant.address!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                const Text(
                                  '0.2 miles away',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList();
              return Column(children: restaurantList);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}

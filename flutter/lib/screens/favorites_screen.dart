import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_shop/services/providers/all_favorites.dart';
import 'package:mobile_shop/widgets/bottom_nav_bar.dart';

import '../models/laptop.dart';
import '../models/mobile.dart';
import '../utils/method_utils.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  Map<String, dynamic> specs = {};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(parentContext: context),
        body: _buildPropertyList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildImage(dynamic item) {
    print(item.toString());
    print('item image: ${item.image}');
    return Hero(
      tag: item.id ?? "tag",
      child: SizedBox(
        height: 145,
        width: 145,
        child: item.image == null || item.image.isEmpty
            ? placeHolderAssetWidget()
            : Image.asset(
                'assets/images/${item.image}',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  _buildPropertyInfo(dynamic item) {
    if (item is Laptop) {
      specs = {
        "storage": item.storage,
        "ram": "${item.ram}",
        "core": item.core,
      };
    } else if (item is Mobile) {
      specs = {
        "Memory": "${item.storage} by ${item.ram}",
        "Front Camera": "${item.cameraFront} MP",
        "Back Camera": "${item.cameraBack} MP",
        "Battery": "${item.battery} mAh",
      };
      //item.image = "s8.jpg";
    }
    List<Widget> subWidgets = [];

    var priceStr = item.price.round().toString();
    priceStr = '${priceStr.substring(0, 2)},${priceStr.substring(2)}';
    priceStr += " Birr";

    subWidgets = [
      Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
        child: Text(
          item.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ...specs.entries.take(2).map(
        (entry) {
          int len = max(entry.key.length, entry.value.length);
          print("${entry.key}:${entry.value}");
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 30,
              width: len * 25.0,
              child: Text(
                "${entry.key}: ${entry.value}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          );
        },
      ),
      SizedBox(
        width: double.infinity,
        child: Text(
          priceStr,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: subWidgets,
    );
  }

  _buildPropertyList() {
    final favList = ref.watch(allFavProvider);
    if (favList.isEmpty) {
      return const Center(
        child: Text(
          "No Favorites yet :)",
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      itemCount: favList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = favList[index];
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => PropertyDetails(
            //       item: rentModel,
            //     ),
            //   ),
            // );
          },
          child: Card(
            margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: SizedBox(
              height: 145,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    child: _buildImage(item),
                  ),
                  Expanded(
                    child: _buildPropertyInfo(item),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_shop/widgets/dyamic_grid.dart';
import 'package:mobile_shop/widgets/elementary_item.dart';
import 'package:mobile_shop/widgets/laptop_item.dart';

import '../models/laptop.dart';
import '../models/mobile.dart';
import '../services/providers/product_providers.dart';
import '../utils/constants.dart';
import '../widgets/special_item.dart';
import 'bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Size size = const Size(0, 0);
  int current = 0;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(parentContext: context),
      body: SafeArea(
        child: SizedBox(
          height: size.height * .98,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: size.width * .8,
                    child: const SearchBar(
                      hintText: "Search Products",
                      padding: WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.all(10.0),
                      ),
                      trailing: [
                        Icon(Icons.search),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                ),

                //buildSpecialView(context, _mobileList),
                buildCategoryTabs(),
                buildGridView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildCategoryTabs() {
    List<String> categories = ['Mobiles', 'Laptops'];

    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => FilledButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(mainRed),
          ),
          onPressed: () {
            setState(() {
              current = index;
            });
          },
          child: Text(categories[index]),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
      ),
    );
  }

  Widget buildGrids(
      AsyncValue<List<Mobile>> mobs, AsyncValue<List<Laptop>> laptops) {
    var mobileLength = mobs.asData?.value.length ?? 0;
    var laptopLength = laptops.asData?.value.length ?? 0;
    Widget? finalWidget;

    if (current == 0) {
      finalWidget = mobs.when(
        data: (mobs) {
          return SizedBox(
            height: size.height * .7,
            child: DynamicGrid(
              aspRatio: {
                'width': size.width.round(),
                'height': size.height.round()
              },
              itemcount: mobileLength,
              itemBuilder: (context, index) {
                return ElementaryMobileItem(mobile: mobs[index]);
              },
            ),
          );
        },
        error: (error, stacktrace) => const Center(),
        loading: () => const Center(child: CircularProgressIndicator()),
      );
    } else if (current == 1) {
      finalWidget = laptops.when(
        data: (laptops) {
          return SizedBox(
            height: size.height * .7,
            child: DynamicGrid(
              aspRatio: {
                'width': size.width.round(),
                'height': size.height.round()
              },
              itemcount: laptopLength,
              itemBuilder: (context, index) {
                return ElementaryLaptopItem(laptop: laptops[index]);
              },
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      );
    }
    return finalWidget!;
  }

  buildGridView(BuildContext context) {
    final mobs = ref.watch(mobilesProvider);
    final laptops = ref.watch(laptopsProvider);

    return SizedBox(
      height: size.height * .8,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: buildGrids(mobs, laptops),
      ),
    );
  }

  buildSpecialView(BuildContext context, List<Mobile> phonesList) {
    return Container(
      //height: MediaQuery.of(context).size.height * .6,
      height: 220,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: phonesList.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {},
            child: SpecialMobileItem(mobile: phonesList[index]),
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 15),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(mobilesProvider);
    ref.watch(laptopsProvider);
  }

  @override
  void initState() {
    super.initState();
  }
}

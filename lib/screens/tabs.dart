import 'package:flutter/material.dart';

import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/screens/filters.dart';

import 'package:meals_app/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _selectPageIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _onSetScreen(String screen) async {
    Navigator.of(context).pop();
    if (screen == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(currentFilters: _selectedFilters),
        ),
      );
      if (result != null) {
        setState(() {
          _selectedFilters = result;
        });
        // Update the Riverpod provider
        final notifier = ref.read(filtersProvider.notifier);
        result.forEach((filter, isActive) {
          notifier.setFilter(filter, isActive);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(availableMeals: availableMeals);
    String activePageTitle = "Pick you category";

    if (_selectedPageIndex == 1) {
      final favouriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(meals: favouriteMeals);
      activePageTitle = "Favourites";
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _onSetScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _selectPageIndex(index);
        },
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}

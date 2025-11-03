import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  String? _error;
  var _isLoading = true;
  void _loadItems() async {
    final url = Uri.https(
      'flutter-shopping-list-96126-default-rtdb.europe-west1.firebasedatabase.app',
      'shopping-list.json',
    );
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
        _isLoading = false;

      });

    }
    for (final item in listData.entries) {
      final categoryTitle = item.value['category'];
      final category = categories.entries.firstWhere(
        (cat) => cat.value.title == categoryTitle,
      );
     loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: int.parse(item.value['quantity']),
          category: category.value,
        ),
      );


    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });

  }


  void _addItem() async {
     final newItem =await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);

    });

  }
  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  @override
  Widget build(BuildContext context) {
    Widget content =Center(
      child: Text(
        'No items added yet.',
        style: TextStyle(fontSize: 20,
          color: Colors.white70,
        ),
      ),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
     else
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,

    );
  }
}

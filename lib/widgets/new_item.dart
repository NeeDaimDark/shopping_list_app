import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';



class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https('flutter-shopping-list-96126-default-rtdb.europe-west1.firebasedatabase.app','shopping-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',},
        body:  json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity.toString(),
          'category': _selectedCategory.title,
        },
        ),
      );
      final Map<String,dynamic> responseData = json.decode(response.body);

      /**/
      if (!context.mounted) {
        return;
      }
        Navigator.of(context).pop(
            GroceryItem(
              id: responseData['name'],
              name: _enteredName,
              quantity: _enteredQuantity,
              category: _selectedCategory ,
            )
        );
      }

  }
  void _resetForm(){
    _formKey.currentState!.reset();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
         padding: const EdgeInsets.all(12.0),
         child: Form(
          key: _formKey,
           child: Column(
             children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value){
                  if(value==null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length>50) {
                    return 'Must be between 1 and 50 characters long.';
                  }
                  return null;
                  },
                onSaved: (value){
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(value==null ||
                            value.isEmpty ||
                            int.tryParse(value)==null ||
                            int.parse(value)<=0) {
                          return 'Must be a valid positive number.';
                        }
                        return null;
                        },
                      onSaved: (value){
                        _enteredQuantity = int.parse(value!);
                      }
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items:  [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  category.value.title[0].toUpperCase()+category.value.title.substring(1),
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value){
                        setState(() {
                          _selectedCategory = value!;
                        });
                        },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending ? null:_resetForm,
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending? null:_saveItem,
                    child: _isSending? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    ) :const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}

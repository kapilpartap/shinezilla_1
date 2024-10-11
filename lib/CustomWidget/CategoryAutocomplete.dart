import 'package:carwash/model/Helper/categoriesServices.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart'; // For asynchronous operations



class CategoryAutocomplete extends StatelessWidget {
  final List<CategoriesServices> categories; // Assuming Category is your data model
  final Function(CategoriesServices) onSelected;

  CategoryAutocomplete({required this.categories, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<CategoriesServices>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        }
        return categories.where((category) =>
            category.serviceName!.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (CategoriesServices category) {
        onSelected(category);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onChanged: (String value) {
            // Trigger rebuild to update options
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            labelText: 'Category',
            hintText: 'Type to search...',
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<CategoriesServices> onSelected, Iterable<CategoriesServices> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final CategoriesServices category = options.elementAt(index);
                  return ListTile(
                    title: Text(category.serviceName!),
                    onTap: () {
                      onSelected(category);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

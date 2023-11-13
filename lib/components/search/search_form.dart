import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  final List<String> _options = const <String>[
    'New York',
    'Tokyo',
    'Manila',
    'Seoul'
  ];

  void handleIconTap() {
    print('Searched');
  }

  void handleSelect(String selection) {
    print('You selected $selection');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _options.where((option) => option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.white, // autocomplete background color
                elevation: 4.0,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: Colors.black, // autocomplete color
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: handleSelect,
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.deepOrangeAccent,
                    width: 2.5,
                  ),
                ),
                hintText: "Search for a City/Country",
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: GestureDetector(
                  onTap: handleIconTap,
                  child: const Icon(Icons.search),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

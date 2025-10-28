import 'package:flutter/material.dart';

class SearchFeildWidget extends StatelessWidget {
  final TextEditingController searchFieldController;
  final String hint;
  final VoidCallback? onSearchIconTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final Color? fillColor;

  const SearchFeildWidget({
    super.key,
    required this.searchFieldController,
    this.hint = "Enter Something",
    this.onSearchIconTap,
    this.onChanged,
    this.onSubmitted,
    this.fillColor = const Color.fromARGB(255, 242, 239, 239),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchFieldController,
      onChanged: (value) {
        onChanged?.call(value);
      },
      onSubmitted: (value) {
        onSubmitted?.call();
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: fillColor,
        suffixIcon: InkWell(
          onTap: () {
            onSearchIconTap?.call();
          },

          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.search, color: Colors.white),
          ),
        ),
        // contentPadding: EdgeInsets.symmetric(
        //   horizontal: 10,
        //   vertical: 10,
        // ),
        border: InputBorder.none,
        hintText: hint,
      ),
    );
  }
}

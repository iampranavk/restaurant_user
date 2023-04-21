import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        suffixIcon: const Icon(
          Icons.settings_input_component,
          color: Colors.black,
        ),
        labelText: 'Search',
        labelStyle: GoogleFonts.piazzolla(
          textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black,
              ),
        ),
        fillColor: const Color(0xFFD9D9D9),
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Constants {
  Widget createTextField(
      {required String title,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      bool enabled = true,
      bool isPassword = false}) {
    bool hide = true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(builder: (ctx, setState) {
          return TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword ? hide : false,
            enabled: enabled,
            style: TextStyle(fontSize: 18, color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              suffixIcon: isPassword
                  ? IconButton(
                      iconSize: 22,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          hide = !hide;
                        });
                      },
                      icon: Icon(hide
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined))
                  : null,
              hintText: title,
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
            ),
          );
        }),
      ),
    );
  }
}

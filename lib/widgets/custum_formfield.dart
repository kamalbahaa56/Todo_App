import 'package:flutter/material.dart';
Widget CustomFormFiled({
 required TextEditingController Controller ,
  required TextInputType type ,
  required FormFieldValidator<String>? validator ,
  required String Lable,
  required IconData PreFixIcon ,
   GestureTapCallback? onTap,
}) => TextFormField(
      controller:Controller ,
      keyboardType:type ,
      validator: validator,
      onTap:onTap ,
      decoration: InputDecoration(
        label: Text(Lable),
        border: OutlineInputBorder(),
        prefixIcon: Icon(PreFixIcon) , 
      ),
          );
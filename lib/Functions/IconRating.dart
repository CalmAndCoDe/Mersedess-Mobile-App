import 'package:flutter/material.dart';


class IconRate {
  rate(BuildContext context ,  int rating ,double size) {
    List<Widget> icons = List.generate(5, (index) {
      if (index >= rating) {
        return Icon(Icons.star_border,color: Theme.of(context).textTheme.body2.color,size: size,);
      } else {
        return Icon(Icons.star,color: Theme.of(context).textTheme.body2.color,size: size,);
      }
    });

    return Row(children: icons.toList(),crossAxisAlignment: CrossAxisAlignment.start,);
  }
}
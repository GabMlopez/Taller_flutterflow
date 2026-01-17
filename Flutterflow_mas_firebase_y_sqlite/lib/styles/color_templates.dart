import 'package:flutter/material.dart';
class templateColors
{
  Color? primary;
  Color? secondary;
  Color? bodyFontColor;
  Color? titleColor;
  Color? highlight;
  Color? menu;
  Color? options;
  templateColors(
      {
        this.primary,
        this.secondary,
        this.bodyFontColor,
        this.titleColor,
        this.highlight,
        this.menu,
        this.options
      })
  {
    primary= primary ?? Colors.white;
    secondary = secondary ?? Colors.grey[400];
    bodyFontColor=bodyFontColor ?? Colors.black;
    titleColor=titleColor ?? Colors.black;
    highlight=highlight ?? Colors.grey[300];
    menu=menu ?? Colors.grey[200];
    options=options ?? Colors.grey[100];
  }
}

Map<String,Color?> pageColors()
{
  return
    {
      "primary": Colors.white,
      "secondary": Colors.orange[300],
      "bodyFontColor": Colors.deepOrange[900],
      "titleColor" : Colors.white,
      "highlight" : Colors.orange[300],
      "menu" : Colors.orange[200],
      "options": Colors.orange[100]
    };
}
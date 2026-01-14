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
    primary=this.primary ?? Colors.white;
    secondary = this.secondary ?? Colors.grey[400];
    bodyFontColor=this.bodyFontColor ?? Colors.black;
    titleColor=this.titleColor ?? Colors.black;
    highlight=this.highlight ?? Colors.grey[300];
    menu=this.menu ?? Colors.grey[200];
    options=this.options ?? Colors.grey[100];
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
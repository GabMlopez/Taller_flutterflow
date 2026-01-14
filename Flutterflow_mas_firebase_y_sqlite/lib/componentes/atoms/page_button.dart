import 'package:flutter/material.dart';

class PageButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textcolor;
  final IconData? icon;
  final bool selected;

  const PageButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white60,
    this.textcolor = Colors.black,
    this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context){


    return SizedBox(
      height: 80,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? Colors.black12 : color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.black: textcolor,
                size: 22,
              ),
              const SizedBox(height: 7,),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: selected? Colors.black : textcolor,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

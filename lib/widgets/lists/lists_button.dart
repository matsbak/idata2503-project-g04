import 'package:flutter/material.dart';

class ListsButton extends StatelessWidget {
  const ListsButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onClick,
  });

  final String text;
  final bool isActive;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 193.0,
      height: 60.0,
      child: FilledButton.tonal(
        onPressed: onClick,
        style: FilledButton.styleFrom(
          backgroundColor: isActive
              ? const Color.fromARGB(255, 247, 202, 255)
              : const Color.fromARGB(255, 222, 222, 222),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

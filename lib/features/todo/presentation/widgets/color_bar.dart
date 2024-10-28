import 'package:flutter/material.dart';

class ColorBar extends StatelessWidget {
  const ColorBar({required this.colors, required this.onSelect, super.key});
  final List<Color> colors;
  final Function(Color color) onSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        height: 64,
        child: ListView.builder(
          itemCount: colors.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              onSelect(colors[index]);
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.all(8),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.all(Radius.circular(60))),
              ),
            ),
          ),
        ));
  }
}

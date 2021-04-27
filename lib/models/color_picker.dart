import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFFC56C),
  Color(0xFFFE9D6C),
  Color(0xFFFE8D6A),
  Color(0xFFFE8189),
  Color(0xFFFB99BA),
  Color(0xFFE99CDA),
  Color(0xFFA0AEE5),
  Color(0xFF9ACAEB),
  Color(0xFF87DADE),
  Color(0xFF69C9BA),
  Color(0xFFB7DB78),
];

class ColorPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  ColorPicker({this.onTap, this.selectedIndex});
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null) {
      selectedIndex = widget.selectedIndex;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              child: Container(
                child: Center(
                    child: selectedIndex == index
                        ? Icon(Icons.done)
                        : Container()),
                decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.grey.shade800)),
              ),
            ),
          );
        },
      ),
    );
  }
}

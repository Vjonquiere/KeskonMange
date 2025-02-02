import 'package:flutter/cupertino.dart';

///Class to create a text with different colors
///on each letter.
///The font size and thickness (normal or bold) can be modified.
///usage : ColorfulTextBuilder([_text], [_fontSize], [[_bold]]).getWidget()
class ColorfulTextBuilder {
  final String _text;
  final double _fontSize;
  final bool _bold;
  static List<Color> colors = [
    const Color.fromRGBO(208, 160, 194, 1),
    const Color.fromRGBO(140, 175, 212, 1.0),
    const Color.fromRGBO(171, 188, 67, 1.0),
    const Color.fromRGBO(238, 189, 83, 1.0),
    const Color.fromRGBO(238, 158, 103, 1.0)
  ];

  ColorfulTextBuilder(this._text, this._fontSize, [this._bold = false]);

  List<TextSpan> getText() {
    var letters = <TextSpan>[];
    for (int i = 0; i < _text.length; i++) {
      letters.add(TextSpan(
          text: _text[i], style: TextStyle(color: colors[i % colors.length])));
    }
    return letters;
  }

  Column getWidget() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16.0),
        RichText(
            text: TextSpan(
          text: "",
          style: TextStyle(
              fontSize: _fontSize,
              fontFamily: "Raleway",
              fontWeight: _bold ? FontWeight.bold : FontWeight.normal),
          children: getText(),
        )),
      ],
    );
  }
}

import 'package:flutter/material.dart';

const kDefaultFont = 'Stidti';
const kBoldFont = 'Stidti-Bold';
const kColorTop = Color(0xFF009CDE);
const kColorBottom = Color(0xFF003C71);
const kColorTextGrey = Color(0xFF707070);
const kBackgroundGradiant = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kColorTop, kColorBottom],
);

const kHeaderStyle = TextStyle(
    color: kColorTextGrey,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: kDefaultFont);
const kContentStyleHeader = TextStyle(
    color: Color(0xff999999),
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: kDefaultFont);
const kContentStyle = TextStyle(
    color: Color(0xff999999),
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: kDefaultFont);
const kColorOpened = Color(0xFFE5E5E5);
const kImageEvent = Image(image: AssetImage('images/event.jpg'));

const kDialogTextStyle = TextStyle(
  fontFamily: kDefaultFont,
  fontSize: 16.0,
  color: kColorTextGrey,
);

const kDialogTitleStyle = TextStyle(
  fontFamily: kDefaultFont,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: kColorTextGrey,
);

const kIconPin = Icon(
  Icons.pin_drop,
  size: 16.0,
  color: Colors.teal,
);

const kSpaceTextEvent = SizedBox(
  height: 8.0,
);

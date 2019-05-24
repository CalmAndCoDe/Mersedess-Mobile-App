import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/Third.dart';
import 'package:mobile_app/Elements/Custombutton.dart';
import 'package:mobile_app/Elements/TextFieldBuilder.dart';

class Third extends StatefulWidget {
  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  String _nationality;
  String _nationalId;
  var third = ThirdCreate.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        StreamBuilder(
          stream: third.thirdStream,
          initialData: third.success,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (third.errors.length > 0) {
                return Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: TextFieldBuilder(
                        context: context,
                        icon: FontAwesomeIcons.userCircle,
                        text: 'Nationality :',
                        onChanged: (value) => _nationality = value,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: TextFieldBuilder(
                        context: context,
                        icon: FontAwesomeIcons.userCircle,
                        text: 'National Id :',
                        onChanged: (value) => _nationalId = value,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: TextFieldBuilder(
                        context: context,
                        icon: FontAwesomeIcons.userCircle,
                        text: 'Nationality :',
                        onChanged: (value) => _nationality = value,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: TextFieldBuilder(
                        context: context,
                        icon: FontAwesomeIcons.userCircle,
                        text: 'National Id :',
                        onChanged: (value) => _nationalId = value,
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: third.loading,
              builder: (context, value, child) {
                if (value) {
                  return CustomButton(child: CircularProgressIndicator());
                } else {
                  return GestureDetector(
                    onTap: () => third.thirdEvents.add(Create({
                          'nationality': _nationality,
                          'nationalId': _nationalId
                        })),
                    child: CustomButton(
                      child: Icon(
                        FontAwesomeIcons.longArrowAltRight,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        )
      ],
    ));
  }
}

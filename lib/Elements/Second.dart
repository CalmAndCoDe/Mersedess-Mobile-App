import 'package:flutter/material.dart';
import 'package:mobile_app/Bloc/Second.dart';
import 'package:mobile_app/Elements/Custombutton.dart';
import 'package:mobile_app/Elements/TextFieldBuilder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

class Second extends StatefulWidget {
  @override
  SecondState createState() => SecondState();
}

class SecondState extends State<Second> {
  List popup = <CustomPopupMenuItem>[
    CustomPopupMenuItem('Male', FontAwesomeIcons.male),
    CustomPopupMenuItem('Female', FontAwesomeIcons.female),
  ];
  var second = SecondCreate.instance();
  String _firstName;
  String _lastName;
  var _birthdate;
  String _age;
  String _job;
  var _gender = 'Gender :';

  @override
  void initState() {
    _birthdate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            StreamBuilder(
              stream: second.secondStream,
              initialData: second,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (second.errors.length > 0) {
                    return Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: FontAwesomeIcons.userCircle,
                            isError: true,
                            error: second.errors.toString(),
                            text: 'First Name :',
                            onChanged: (value) => _firstName = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: FontAwesomeIcons.userCircle,
                            text: 'Last Name :',
                            onChanged: (value) => _lastName = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: Icons.lock_outline,
                            text: 'Age :',
                            onChanged: (value) => _age = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: FontAwesomeIcons.briefcase,
                            text: 'Job :',
                            onChanged: (value) => _job = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              PopupMenuButton(
                                onSelected: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                                itemBuilder: (context) => popup.map((item) {
                                      return PopupMenuItem(
                                          value: item.text,
                                          child: ListTile(
                                            title: Text(item.text),
                                            enabled: _gender == item.text,
                                            leading: Icon(item.icon),
                                          ));
                                    }).toList(),
                              ),
                              Text(_gender)
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _datepicker(context);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 16.0,
                                      left: 16.0,
                                      right: 8.0,
                                      bottom: 16.0),
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.birthdayCake,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                              Text('Birthdate: '),
                              Text(
                                  '${_birthdate?.year.toString() ?? ''}/${_birthdate?.month.toString() ?? ''}/${_birthdate?.day.toString() ?? ''}')
                            ],
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
                            text: 'First Name :',
                            onChanged: (value) => _firstName = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: FontAwesomeIcons.userCircle,
                            text: 'Last Name :',
                            onChanged: (value) => _lastName = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: Icons.lock_outline,
                            text: 'Age :',
                            onChanged: (value) => _age = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            icon: FontAwesomeIcons.briefcase,
                            text: 'Job :',
                            onChanged: (value) => _job = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              PopupMenuButton(
                                onSelected: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                                itemBuilder: (context) => popup.map((item) {
                                      return PopupMenuItem(
                                          value: item.text,
                                          child: ListTile(
                                            title: Text(item.text),
                                            enabled: _gender == item.text,
                                            leading: Icon(item.icon),
                                          ));
                                    }).toList(),
                              ),
                              Text(_gender)
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _datepicker(context);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 16.0,
                                      left: 16.0,
                                      right: 8.0,
                                      bottom: 16.0),
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.birthdayCake,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                              Text('Birthdate: '),
                              Text(
                                  '${_birthdate?.year.toString() ?? ''}/${_birthdate?.month.toString() ?? ''}/${_birthdate?.day.toString() ?? ''}')
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                } else {}
              },
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: second.loading,
                    builder: (context, loading, child) {
                      if (loading) {
                        return CustomButton(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () => second.secondEvents.add(Create({
                                'firstName': _firstName,
                                'lastName': _lastName,
                                'age': _age,
                                'birthdate': _birthdate,
                                'gender': _gender,
                                'job': _job
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
              ),
            )
          ],
        ),
      ),
    );
  }

  _datepicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 300 / MediaQuery.of(context).size.height,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            minimumDate: DateTime(1980),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime time) {
              setState(() {
                _birthdate = time;
              });
            },
          ),
        );
      },
    );
  }
}

class CustomPopupMenuItem {
  final text;
  final IconData icon;

  CustomPopupMenuItem(this.text, this.icon);
}

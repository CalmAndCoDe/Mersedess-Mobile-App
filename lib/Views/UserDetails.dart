import 'package:flutter/material.dart';
import 'package:mobile_app/Bloc/Profile.dart';
import 'package:mobile_app/Elements/SettingButton.dart';
import 'package:mobile_app/Functions/TextStyles.dart';

class UserDetails extends StatelessWidget {
  var userProfile = UserProfileFetch.instance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(context),
                        color: Theme.of(context).textTheme.body1.color,
                      ),
                      Text(
                        'User Details',
                        style: settingButtonStyle,
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 20,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dear User',
                            style: titleStylesmall,
                          ),
                          Text(
                              ' You can’t change the details that appear here once you provide it to our reservation system so for any changes that you want to apply here you can send an email to our support.'),
                          StreamBuilder(
                            stream: userProfile.userStream,
                            initialData: userProfile.userProfile,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  margin: EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Name :',
                                              style: titleStylesmall.copyWith(
                                                  fontSize: 18),
                                            ),
                                            Text(
                                                '   ${snapshot.data.fullName}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Gender :',
                                              style: titleStylesmall.copyWith(
                                                  fontSize: 18),
                                            ),
                                            Text('   ${snapshot.data.gender}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Age :',
                                              style: titleStylesmall.copyWith(
                                                  fontSize: 18),
                                            ),
                                            Text(
                                                '   ${snapshot.data.age.toString()}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Birthdate :',
                                              style: titleStylesmall.copyWith(
                                                  fontSize: 18),
                                            ),
                                            Text(
                                                '   ${snapshot.data.birthdate.toString()}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else return CircularProgressIndicator(
                                backgroundColor: Theme.of(context).textTheme.body2.color,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String title = "Home";
  final Map<String, dynamic> userInfo;

  Home(this.userInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(
              "Welcome",
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 10),
            Text(userInfo["name"] + "(" + userInfo["email"] + ")",
                style: Theme.of(context).textTheme.subhead),
            SizedBox(height: 10),
            Text("Your login was successfull!\n Thank you for using Id4me.",
                style: Theme.of(context).textTheme.body1)
          ])),
    );
  }
}

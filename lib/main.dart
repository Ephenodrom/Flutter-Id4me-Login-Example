import 'package:flutter/material.dart';
import 'package:id4me_login_example/Home.dart';
import 'package:id4me_login_example/Id4meLoginWebScreen.dart';
import 'package:id4me_relying_party_api/id4me_relying_party_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Id4me Demo Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(title: 'Id4me Demo Login'),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Id4meLogon logon;
  Id4meSessionData sessionData;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 122, 157, 1),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/img/logo.png"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color.fromRGBO(0, 122, 157, 1)),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Enter domain",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> properties = {
                  Id4meConstants.KEY_CLIENT_NAME: "ID4me Demo",
                  Id4meConstants.KEY_LOGO_URI:
                      "https://www.androidpit.com/img/logo/favicon.png",
                  Id4meConstants.KEY_REDIRECT_URI: "https://id4meredirect.com",
                  Id4meConstants.KEY_DNS_RESOLVER: "8.8.8.8",
                  Id4meConstants.KEY_DNSSEC_REQUIRED: false
                };

                Id4meClaimsParameters claimsParameters =
                    new Id4meClaimsParameters();
                claimsParameters.entries
                    .add(Entry("email", true, "Needed to create the profile"));
                claimsParameters.entries
                    .add(Entry("name", true, "Displayname in the user dat"));
                String url = await buildUrl(
                    controller.text, properties, claimsParameters);
                String code = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Id4meLoginWebScreen(url)),
                );
                Map<String, dynamic> userInfo = await processLogin(code);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(userInfo)),
                );
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/id4meloginbtn.png'))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> processLogin(String code) async {
    await logon.authenticate(sessionData, code);
    return await logon.fetchUserinfo(sessionData);
  }

  Future<String> buildUrl(String domain, Map<String, dynamic> properties,
      Id4meClaimsParameters claimsParameters) async {
    logon = new Id4meLogon(
        properties: properties, claimsParameters: claimsParameters);

    sessionData = await logon.createSessionData(domain, true);
    return logon.buildAuthorizationUrl(sessionData);
  }
}

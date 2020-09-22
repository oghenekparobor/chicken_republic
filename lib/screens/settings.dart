import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  static const route = '/settings';
  const Settings({Key key}) : super(key: key);

  void visitUs() async {
    const url = 'https://chickenrepublicdeltamall.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  void mailUs() async {
    const url = 'mailto:support@chickenrepublicmall.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  void callUs() async {
    const url = 'tel:+2349094627698';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: const Text('Help Desk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () => visitUs(),
              leading: Icon(Icons.public),
              title: Text('Visit Us'),
              subtitle: Text('https://chickenrepublicdeltamall.com'),
            ),
            ListTile(
              onTap: () => mailUs(),
              leading: Icon(Icons.mail_outline),
              title: Text('Mail Us'),
              subtitle: Text('support@chickenrepublicdeltamall.com'),
            ),
            ListTile(
              onTap: () => callUs(),
              leading: Icon(Icons.phone),
              title: Text('Call Us'),
              subtitle: Text('+2349094627698'),
            )
          ],
        ),
      ),
    );
  }
}

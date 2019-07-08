import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
              "Profil",
              height: 57,
              leadingWidget: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: Container(
                height: 0,
              ),
            ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }
}

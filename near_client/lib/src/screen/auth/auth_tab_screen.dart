import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/auth/login/login_screen.dart';
import 'package:getx_near/src/screen/sos/sos_screen.dart';

class AuthTabScreen extends StatelessWidget {
  const AuthTabScreen({Key? key}) : super(key: key);
  static const routeName = '/AuthTabScreen';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabView = [SOSScreen(), LoginScreen()];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              indicatorColor: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 10),
              indicatorWeight: 4,
              tabs: [
                Tab(
                    child: Text(
                  "Help!",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                )),
                Tab(
                    child: Text(
                  "登録",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                )),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: _tabView,
        ),
      ),
    );
  }
}

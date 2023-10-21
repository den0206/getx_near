import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/auth/login/login_screen.dart';
import 'package:getx_near/src/screen/sos/sos_screen.dart';

class AuthTabScreen extends StatelessWidget {
  const AuthTabScreen({super.key});
  static const routeName = '/AuthTabScreen';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabView = [const SOSScreen(), LoginScreen()];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              indicatorColor: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 10),
              indicatorWeight: 4,
              tabs: [
                Tab(
                    child: Text(
                  "音声",
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

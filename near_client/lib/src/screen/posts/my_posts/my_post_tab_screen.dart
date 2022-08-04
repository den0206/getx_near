import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_screen.dart';
import 'package:getx_near/src/screen/posts/my_posts/near_posts/near_posts_screen.dart';
import 'package:sizer/sizer.dart';

class MyPostTabScreen extends StatelessWidget {
  const MyPostTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _tabView = [
      NearPostsScreen(),
      MyPostsScreen(),
      Text("Comments"),
    ];
    return DefaultTabController(
      length: _tabView.length,
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: TabBar(
                indicatorColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 10),
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                      child: Text(
                    "Near By",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black87,
                    ),
                  )),
                  Tab(
                      child: Text(
                    "My Posts",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black87,
                    ),
                  )),
                  Tab(
                      child: Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black87,
                    ),
                  )),
                ],
              ),
            ),
          ),
          body: TabBarView(children: _tabView)),
    );
  }
}

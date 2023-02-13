// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:psutep/screens/admin_quiz_screen.dart';
import 'package:psutep/screens/admin_examinee_screen.dart';
import 'package:psutep/screens/admin_score_screen.dart';
import 'package:psutep/screens/admin_user_screen.dart';
import 'package:psutep/services/app_service.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';

  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late AppService appService;
  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    AppService.getInstance().then((value) {
      appService = value;
    });
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.open,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'images/psu_logo.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Examinees',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.school),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Users',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Quizzes',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.video_library),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Score',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.rate_review),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Exit',
                icon: const Icon(Icons.exit_to_app),
                onTap: (page, _) {
                  appService.logout().then((value) {
                    html.window.location.href = "/";
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: const AdminExamineeScreen(),
                ),
                Container(
                  color: Colors.white,
                  child: const AdminUserScreen(),
                ),
                Container(
                  color: Colors.white,
                  child: const AdminQuizScreen(),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: AdminScoreScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Exit',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:ether_ease/add_entry/ui/add_entry.dart';
import 'package:ether_ease/screens/tab_screens/entries.dart';
import 'package:ether_ease/screens/tab_screens/stats.dart';
import 'package:flutter/material.dart';
import 'package:ether_ease/screens/tab_screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    int tabsCount = 3;
    
    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Row(
            children: [
              Image(
                image: AssetImage('assets/images/logo-2.png'),
                height: 55,
                width: 55,
                color: Colors.white,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                'Ether Ease',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEntry()),
                );
              },
            ),
          ],
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: tabBar(context),
        ),
        body: const TabBarView(
          children: [
            StatsScreen(),
            EntriesScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }

  TabBar tabBar(BuildContext context) {
    return TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Theme.of(context).colorScheme.primaryContainer,
      tabs: const <Widget>[
        Tab(
          icon: Icon(
            Icons.bar_chart,
            size: 30,
          ),
        ),
        Tab(
          icon: Icon(Icons.home, size: 30),
        ),
        Tab(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
        ),
      ],
    );
  }
}

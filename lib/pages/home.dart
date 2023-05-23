import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:app_wearable/pages/profile.dart';
import 'package:app_wearable/pages/info.dart';

class Home extends StatefulWidget {
  static const route = '/home/';
  static const routeDisplayName = 'HomePage';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selIdx = 0;

  List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(MdiIcons.walk),
      label: 'Activity',
    ),
    const BottomNavigationBarItem(
      icon: Icon(MdiIcons.moleculeCo2),
      label: ('Carbon print'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selIdx = index;
    });
  }

  /*Widget _selectPage({
    required int index,
  }) {
    switch (index) {
      case 0:
        return const Pollutants();
      case 1:
        return const Exposure();
      default:
        return const Pollutants();
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE4DFD4),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  leading: const Icon(MdiIcons.logout),
                  title: const Text('Logout'),
                  // delete all data from the database
                  onTap: () => {}),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('About'),
              ),
              ListTile(
                  leading: const Icon(MdiIcons.informationOutline),
                  title: const Text('App Information'),
                  // delete all data from the database
                  onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InfoApp(),
                        ))
                      }),
              /*ListTile(
                  leading: const Icon(MdiIcons.dotsHexagon),
                  title: const Text('Exposure Information'),
                  // delete all data from the database
                  onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InfoExposure(),
                        ))
                      }),*/
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 8, 112, 24)),
          elevation: 0,
          backgroundColor: const Color(0xFFE4DFD4),
          /*actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => Profile()));
                  },
                  icon: const Icon(
                    MdiIcons.accountCircle,
                    size: 40,
                    color: Color.fromARGB(255, 8, 112, 24),
                  )),
            )
          ],*/
        ),
        //body: _selectPage(index: _selIdx),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 8, 112, 24),
          selectedItemColor: const Color.fromARGB(255, 228, 223, 212),
          items: navBarItems,
          currentIndex: _selIdx,
          onTap: _onItemTapped,
        ));
  }
}

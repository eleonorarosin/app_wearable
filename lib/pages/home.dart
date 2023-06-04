import 'package:app_wearable/pages/onboarding/impact_ob.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app_wearable/providers/home_provider.dart';
import 'package:app_wearable/pages/info.dart';
import 'package:app_wearable/pages/walk.dart';
import 'package:app_wearable/pages/CO2.dart';
//import 'package:app_wearable/pages/login/login.dart';
import 'package:app_wearable/services/server_strings.dart';
import 'package:app_wearable/utils/shared_preferences.dart';
import 'package:app_wearable/services/impact.dart';
import 'package:app_wearable/models/db.dart';

class Home extends StatefulWidget {
  static const route = '/home/';
  static const routeDisplayName = 'HomePage';

  Home({Key? key}) : super(key: key);

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

  Widget _selectPage({
    required int index,
  }) {
    switch (index) {
      case 0:
        return CO2();
      case 1:
        return CO2();
      default:
        return CO2();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(
        Provider.of<ImpactService>(context, listen: false),
        Provider.of<AppDatabase>(context,listen: false)
      ),
      lazy: false,
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFFE4DFD4),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  leading: const Icon(MdiIcons.logout),
                  title: const Text('Logout'),
                  // delete all data from the database
                  onTap: () async {
                    bool reset = await Preferences().resetSettings();
                      if (reset) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacementNamed(ImpactOnboarding.route);
                      }
                  }),
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
          actions: [
              IconButton(
                  padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                  onPressed: () async {
                    Provider.of<HomeProvider>(context, listen: false).refresh();
                    
                  },
                  icon: const Icon(
                    MdiIcons.downloadCircle,
                    size: 30,
                    color: Color.fromARGB(255, 8, 112, 24),
                  )),]
        ),
        body: Provider.of<HomeProvider>(context).doneInit
              ? _selectPage(index: _selIdx)
              : const Center(
                  child: CircularProgressIndicator(),
                ) /* _selectPage(index: _selIdx) */,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 8, 112, 24),
            selectedItemColor: const Color.fromARGB(255, 228, 223, 212),
            items: navBarItems,
            currentIndex: _selIdx,
            onTap: _onItemTapped,
        )));
  }
}

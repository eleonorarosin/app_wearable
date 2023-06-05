import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  static const route = '/home/';
  static const routeDisplayName = 'HomePage';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selIdx = 0;

  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE4DFD4),
        drawer: Drawer(
          child: ListView(
            children: [
              
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('About'),
              ),
            ]
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF89453C)),
          elevation: 0,
          backgroundColor: const Color(0xFFE4DFD4),
          actions: [],),
    
    );
            
              
                 
           
      
  }
}

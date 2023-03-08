// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer Series',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedMinutes = 01;
  int _selectedSecondes = 30 ;
  int _tempMinutes =01;
  int _tempSecondes = 30;
  bool _timerActivate = false;

  int _series = 0;
  var f = NumberFormat("00");
  late Timer _timer;

  void _onSettingsPressed() {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container (
          color: Colors.black,
          height: 250,
          child: Container (
            child: _settingMenu(),
            decoration: BoxDecoration (
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              )
            ),
          ),
        );
      });
  }

  Column _settingMenu () {
    return Column (
          children: <Widget> [
            ListTile(
              tileColor: Colors.red,
              title: Text("00:30",
              textAlign: TextAlign.center, 
              style: TextStyle(
                    color: Colors.white,
                    fontSize:25,
                  ),
              ),
              onTap: () => _selectTimer(00,30),
            ),
            ListTile(
              title: Text("01:00",
              textAlign: TextAlign.center, 
              style: TextStyle(
                    color: Colors.white,
                    fontSize:25,                   
                  ),
              ),
              onTap: () => _selectTimer(01,00),
            ),
            ListTile(
              title: Text("01:30",
              textAlign: TextAlign.center, 
              style: TextStyle(
                    color: Colors.white,
                    fontSize:25,
                  ),
              ),
              onTap: () => _selectTimer(01,30),
            ),
            ListTile(
              title: Text("02:30",
              textAlign: TextAlign.center, 
              style: TextStyle(
                    color: Colors.white,
                    fontSize:25,                    
                  ),
              ),
              onTap: () => _selectTimer(02,30),
            ),
          ],
        );
  }

  void _selectTimer(int minutes, int secondes) {
    Navigator.pop(context);
    setState(() {
      _selectedMinutes = minutes;
      _selectedSecondes = secondes ;
      _tempMinutes = minutes;
      _tempSecondes = secondes;
    });
  }

  void _stopTimer() {
    setState(() {
      _selectedSecondes = _tempSecondes;
      _selectedMinutes = _tempMinutes;
    _timerActivate = false;
    });
    _timer.cancel();
    

  }

  void _exerciceSuivant() {
   setState(() {
        _series =0 ;
        _timerActivate = false;
      });
    _timer.cancel();
    _selectedSecondes = _tempSecondes;
    _selectedMinutes = _tempMinutes;
  }

  void _startTimer () {
      setState(() {
        _series ++;
        _timerActivate = true;
      });

    //if(_selectedMinutes > 0) {
     // _selectedSecondes += _selectedMinutes * 60;
    //}

    //if (_selectedSecondes > 60) {
     // _selectedMinutes = (_selectedSecondes/60).floor();
     // _selectedSecondes = (_selectedMinutes * 30) -30;
    // }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      setState(() {
        if (_selectedSecondes > 0){
          _selectedSecondes --;
        }
        else {
          if (_selectedMinutes >0) {
           _selectedSecondes = 59;
            _selectedMinutes--;
          }
          else {
            _timer.cancel();
            _stopTimer(); 
            //make a sound effect
            final player = AudioCache();
            player.play("beep-1.wav");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton (
                iconSize: 40,
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () => _onSettingsPressed(),
              ),
            ],
          ),
          SizedBox (
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _series <=1 ?"Série $_series".toUpperCase() : "Séries $_series".toUpperCase(),
                style: TextStyle (
                  color: Colors.white,
                  fontSize: 48,
                ),
              )
            ],
          ),
          SizedBox (
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                child: Column (children: [
                    SizedBox (
                      height: _timerActivate? 70 :50,
                    ),
                    Text(
                    "${f.format(_selectedMinutes)} : ${f.format(_selectedSecondes)}" ,
                    style: TextStyle(fontSize: 50),
                    ),
                    SizedBox (
                      height: 20,
                    ),
                    Text(
                     _timerActivate? "" : ("valider la série".toUpperCase()) ,
                    style: TextStyle(fontSize: 15),
                    ), 
                  ],
                ), 
                onPressed: () { _timerActivate? null :_startTimer();},
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 200),
                  shape: CircleBorder() ,
                  primary: _timerActivate ? (Colors.blue) : (Colors.green),
                  onSurface: Colors.blue,
                ),
              ),
            ],
            
          ),
          SizedBox (
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    minimumSize: Size (266, 53),
                    textStyle: TextStyle(fontSize: 24),
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  onPressed: _timerActivate? (() {
                    _stopTimer();}) : null, 
                  child: Text("STOP"),
                ),
              ],
          ),
          SizedBox (
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size (266, 53),
                    textStyle: TextStyle(fontSize: 24),
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {_exerciceSuivant();}, 
                  child: Text("Exercice suivant"),
                ),
              ],
          ),
          SizedBox (
            height: 80,
          ),
        ],
      ),  
    );
  }
}



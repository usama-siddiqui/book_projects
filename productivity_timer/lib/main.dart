import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_timer/settings.dart';
import 'package:productivity_timer/timer.dart';
import 'package:productivity_timer/timer_model.dart';
import 'package:productivity_timer/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5.0;
  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {
    timer.startWork();

    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('My work timer'),
        actions: [
          PopupMenuButton<String>(itemBuilder: (BuildContext context) {
            return menuItems.toList();
          }, onSelected: (s) {
            if (s == 'Settings') {
              goToSettings(context);
            }
          })
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        return Column(
          children: [
            _categories(),
            Expanded(
                child: StreamBuilder(
                    initialData: '00:00',
                    stream: timer.stream(),
                    builder: (context, snapshot) {
                      TimerModel timer = (snapshot.data == '00:00')
                          ? TimerModel('00:00', 1)
                          : snapshot.data;
                      return CircularPercentIndicator(
                        radius: availableWidth / 2,
                        lineWidth: 10.0,
                        percent: timer.percent,
                        center: Text(timer.time,
                            style: Theme.of(context).textTheme.display1),
                        progressColor: Color(0xff009688),
                      );
                    })),
            _stopAndRestartButton(),
          ],
        );
      }),
    );
  }

  _categories() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
            child: ProductivityButton(
          color: Color(0xff009688),
          text: "Work",
          onPressed: () => timer.startWork(),
          size: null,
        )),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
            child: ProductivityButton(
          color: Color(0xff607D8B),
          text: "Short Break",
          onPressed: () => timer.startBreak(true),
          size: null,
        )),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
            child: ProductivityButton(
          color: Color(0xff455A64),
          text: "Long Break",
          onPressed: () => timer.startBreak(false),
          size: null,
        )),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
      ],
    );
  }

  _stopAndRestartButton() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
            child: ProductivityButton(
          color: Color(0xff212121),
          text: 'Stop',
          onPressed: () => timer.stopTimer(),
          size: null,
        )),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
            child: ProductivityButton(
          color: Color(0xff009688),
          text: 'Restart',
          onPressed: () => timer.startTimer(),
          size: null,
        )),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
      ],
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));
  }
}

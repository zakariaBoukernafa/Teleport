import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as math;

class SensorsMode extends StatefulWidget {
  SensorsMode({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SensorsModeState createState() => _SensorsModeState();
}

class _SensorsModeState extends State<SensorsMode> {
  // color of the circle
  Color color = Colors.orange.shade900;

  // event returned from accelerometer stream
  AccelerometerEvent event;

  // hold a refernce to these, so that they can be disposed
  Timer timer;
  StreamSubscription accel;

  // positions and count
  double top = 125;
  double left;
  int count = 0;

  // variables for screen size
  double width;
  double height;
  //FireBase
  final FirebaseDatabase database = FirebaseDatabase.instance;
  //degress
  String xAngle;
  String yAngle;
  String zAngle;

  setColor(AccelerometerEvent event) {
    // Calculate Left
    if (event.x == null) return;
    double x = ((event.x * 12) + ((width - 100) / 2));
    // Calculate Top
    double y = event.y * 12 + 125;

    // find the difference from the target position
    var xDiff = x.abs() - ((width - 100) / 2);
    var yDiff = y.abs() - 125;

    // check if the circle is centered, currently allowing a buffer of 3 to make centering easier
    if (xDiff.abs() < 3 && yDiff.abs() < 3) {
      // set the color and increment count
      setState(() {
        color = Colors.greenAccent;
        count += 1;
      });
    } else {
      // set the color and restart count
      setState(() {
        color = Colors.red;
        count = 0;
      });
    }
  }

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }

    // When x = 0 it should be centered horizontally
    // The left positin should equal (width - 100) / 2
    // The greatest absolute value of x is 10, multipling it by 12 allows the left position to move a total of 120 in either direction.
    setState(() {
      left = ((event.x * 12) + ((width - 100) / 2));
    });

    // When y = 0 it should have a top position matching the target, which we set at 125
    setState(() {
      top = event.y * 12 + 125;
    });
  }

  startTimer() {
    // if the accelerometer subscription hasn't been created, go ahead and create it
    if (accel == null) {
      accel = accelerometerEvents.listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
          //
          double x = event.x, y = event.y, z = event.z;
          double normOfG = math
              .sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          x = event.x / normOfG;
          y = event.y / normOfG;
          z = event.z / normOfG;

          double xInclination = -(math.asin(x) * (180 / math.pi));
          double yInclination = (math.acos(y) * (180 / math.pi));
          double zInclination = (math.atan(z) * (180 / math.pi));

          xAngle = '${xInclination.round()}°';

          yAngle = '${yInclination.round()}°';
          zAngle = '${zInclination.round()}°';
          //print('x: $xAngle, y: $yAngle , z: $zAngle');

          database
              .reference()
              .child('position')
              .set({'x': xAngle, 'y': yAngle, 'z': zAngle});
        });
      });
    } else {
      // it has already ben created so just resume it
      accel.resume();
    }

    // Accelerometer events come faster than we need them so a timer is used to only proccess them every 200 milliseconds
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(milliseconds: 200), (_) {
        // if count has increased greater than 3 call pause timer to handle success
        if (count > 3) {
          pauseTimer();
        } else {
          // proccess the current event
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    // stop the timer and pause the accelerometer stream
    timer.cancel();
    accel.pause();

    // set the success color and reset the count
    setState(() {
      count = 0;
      color = Colors.green;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    accel?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the width and height of the screen
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
            ),
            Stack(
              children: [
                // This empty container is given a width and height to set the size of the stack
                Container(height: height / 2, width: width),
                // Create the outer target circle wrapped in a Position
                Positioned(
                  // positioned 50 from the top of the stack
                  // and centered horizontally, left = (ScreenWidth - Container width) / 2
                  top: 50,
                  left: (width - 250) / 2,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      border:
                          Border.all(color: Colors.orange.shade900, width: 2.0),
                      borderRadius: BorderRadius.circular(125),
                    ),
                  ),
                ),
                // This is the colored circle that will be moved by the accelerometer
                // the top and left are variables that will be set
                Positioned(
                  top: top,
                  left: left ?? (width - 100) / 2,
                  // the container has a color and is wrappeed in a ClipOval to make it round
                  child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: color,
                    ),
                  ),
                ),
                // inner target circle wrapped in a Position
                Positioned(
                  top: 125,
                  left: (width - 100) / 2,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
            Text(
                'x: ${(event?.x ?? 0).toStringAsFixed(3)}    x angle: ${(xAngle ?? 0)}',
                style: GoogleFonts.roboto(
                    fontSize: 25, fontWeight: FontWeight.w500)),
            Text(
                'y: ${(event?.y ?? 0).toStringAsFixed(3)}    y angle ${(yAngle ?? 0)}',
                style: GoogleFonts.roboto(
                    fontSize: 25, fontWeight: FontWeight.w500)),
            Text(
                'z: ${(event?.z ?? 0).toStringAsFixed(3)}    z angle ${(zAngle ?? 0)}',
                style: GoogleFonts.roboto(
                    fontSize: 25, fontWeight: FontWeight.w500)),
            Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: GestureDetector(
                onTap: startTimer,
                child: Container(
                  width: 100,
                  height: 40,
                  child: InkWell(
                    enableFeedback: true,
                    splashColor: Colors.white,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green,
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: Center(
                        child: Text('Start',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: pauseTimer,
                child: Container(
                  width: 100,
                  height: 40,
                  child: InkWell(
                    enableFeedback: true,
                    splashColor: Colors.white,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: Center(
                        child: Text('Pause',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

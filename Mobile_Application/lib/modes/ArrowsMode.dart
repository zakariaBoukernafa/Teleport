import 'package:flutter/material.dart';
import 'package:teleport/ui/widgets/widgets.dart';

class ArrowsMode extends StatefulWidget {
  @override
  _ArrowsModeState createState() => _ArrowsModeState();
}

class _ArrowsModeState extends State<ArrowsMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                SizedBox(width: 79),
                // up button
                Widgets('Up', Icons.arrow_upward),
                SizedBox(width: 50)
              ]),
              Row(children: [
                // left button
                Widgets('Left', Icons.arrow_back),
                SizedBox(width: 79),
                // right button
                Widgets('Right', Icons.arrow_forward)
              ]),
              Row(children: [
                SizedBox(width: 79),
                // down button
                Widgets('Down', Icons.arrow_downward),
                SizedBox(width: 50)
              ]),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';

class Widgets extends StatefulWidget {
  final String direction;
  final IconData icons;

  Widgets(this.direction, this.icons);

  @override
  _WidgetsState createState() => _WidgetsState();
}

//Widget defines the arrows in the ARROW MODE screen
class _WidgetsState extends State<Widgets> {
  //Firebase
  //Color for the animation
  Color _color = Colors.blue;

  Widget arrow(String directions, IconData icons) {
    final direction = BlocProvider.of(context).direction;
    double _size = 40.00;
    return StreamBuilder<String>(
        stream: direction.direction,
        builder: (context, snapshot) {
          return GestureDetector(
            onLongPress: () {
              setState(() {
                direction.directionChanged.add(directions);
                _color = Colors.green;
                if (snapshot.hasData) {
                  direction.directionEventSink.add(DirectionEvent());
                }
              });
            },
            onLongPressEnd: (_) {
              setState(
                () {
                  direction.directionChanged.add("stop");
                  if (snapshot.hasData) {
                    direction.directionEventSink.add(DirectionEvent());
                  }
                  _color = Colors.blue;
                },
              );
            },
            child: AnimatedContainer(
              height: _size * 2,
              width: _size * 2,
              duration: Duration(seconds: 1),
              curve: Curves.easeInOutQuad,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(360),
              ),
              child: Icon(
                icons,
                size: _size,
                color: Colors.white,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return arrow(widget.direction, widget.icons);
  }
}

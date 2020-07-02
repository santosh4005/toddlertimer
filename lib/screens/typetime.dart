import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toddlertimer/helper/constants.dart';
import 'package:toddlertimer/helper/notifhelper.dart';
import 'package:toddlertimer/models/toddlertime.dart';
import 'package:toddlertimer/provider/times.dart';
import 'package:provider/provider.dart';

class ScreenTypeTime extends StatefulWidget {
  final String type;
  final int minutes;
  final IconData icondata;
  ScreenTypeTime(this.type, this.minutes, this.icondata);
  @override
  _ScreenTypeTimeState createState() => _ScreenTypeTimeState();
}

class _ScreenTypeTimeState extends State<ScreenTypeTime>
    with SingleTickerProviderStateMixin {
  ProviderToddlerTimes provider;
  AnimationController controller;
  Animation<double> fadeanimation;
  Animation<Offset> slideanimation;

  List<ModelToddlerTime> listItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    fadeanimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    slideanimation =
        Tween<Offset>(end: Offset.zero, begin: const Offset(1.5, 0.0))
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
//this will start the animation
    controller.forward();
  }

  Future<void> _showSomeProgress() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ProviderToddlerTimes>(context);
    listItems = provider.fetchTimesOfType(widget.type);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("${widget.type} Time!"),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.minutes > 0)
            NotificationHelper(
                    body: "It's ${widget.type} time",
                    title: "${widget.type} time!")
                .showNotificationAfterDuration(
              Duration(seconds: widget.minutes),
            );
          _showSomeProgress();
          provider.addTime(ModelToddlerTime(
              date: DateTime.now(),
              type: widget.type,
              id: DateTime.now().toString()));
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => ScreenAddTime("Bathroom"),
          // ));
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Container(
        decoration: gradientBoxDecoration1,
        child: SafeArea(
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : FadeTransition(
                    opacity: fadeanimation,
                    child: Column(
                      children: <Widget>[
                        Expanded(child: _getWorkoutList(listItems)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _getWorkoutList(List<ModelToddlerTime> items) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 36.0,
              ),
            ),
            key: ValueKey(items[index].id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) => showDialog(
                context: context,
                child: AlertDialog(
                  actions: <Widget>[
                    RaisedButton(
                      child: Text("Nah"),
                      color: Theme.of(context).accentColor,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    RaisedButton(
                      child: Text("Yeah"),
                      color: Colors.red,
                      onPressed: () => Navigator.of(context).pop(true),
                    )
                  ],
                  title: Text("DELETE RECORD"),
                  content: Text("Are you sure you want to delete this entry?"),
                )),
            onDismissed: (direction) async {
              await provider.deleteRecord(items[index].id);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content:
                    Text("Deleted ${items[index].type} entry from the list"),
              ));
            },
            child: ListTile(
              trailing: CircleAvatar(
                child: Icon(
                  widget.icondata,
                  color: Theme.of(context).accentColor,
                ),
                backgroundColor: Colors.transparent,
              ),
              title:
                  Text(DateFormat.yMEd().add_jms().format(items[index].date)),
              subtitle: Text(items[index].type.toString()),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: items.length);
  }
}

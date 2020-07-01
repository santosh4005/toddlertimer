import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toddlertimer/helper/notifhelper.dart';
import 'package:toddlertimer/models/toddlertime.dart';
import 'package:toddlertimer/provider/times.dart';
import 'package:provider/provider.dart';

class ScreenTypeTime extends StatefulWidget {
  final String type;
  final int minutes;
  ScreenTypeTime(this.type, this.minutes);
  @override
  _ScreenTypeTimeState createState() => _ScreenTypeTimeState();
}

class _ScreenTypeTimeState extends State<ScreenTypeTime> {
  ProviderToddlerTimes provider;
  List<ModelToddlerTime> listItems = [];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NotificationHelper(
                  body: "It's ${widget.type} time",
                  title: "${widget.type} time!")
              .showNotificationAfterDuration(
            Duration(minutes: widget.minutes),
          );
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
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(child: _getWorkoutList(listItems)),
            ],
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
                  title: Text("Hmmm...."),
                  content: Text("Are you sure you want to delete this entry?"),
                )),
            onDismissed: (direction) async {
              await provider.deleteRecord(items[index].id);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Deleted ${items[index].type} from the list"),
              ));
            },
            child: ListTile(
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

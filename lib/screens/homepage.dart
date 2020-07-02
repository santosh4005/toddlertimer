import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toddlertimer/customicon_icons.dart';
import 'package:toddlertimer/helper/constants.dart';
import 'package:toddlertimer/models/timers.dart';
import 'package:toddlertimer/provider/timers.dart';
import 'package:toddlertimer/screens/settings.dart';
import 'package:toddlertimer/screens/typetime.dart';
import '../provider/times.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProviderToddlerTimes providerMain;
  ModelTimerSetting timerSettings;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await _getProviderTimeslist();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _getProviderTimeslist() async {
    await Provider.of<ProviderToddlerTimes>(context, listen: false)
        .fetchAndSetTimes();

    timerSettings =
        await Provider.of<ProviderTimerHelper>(context, listen: false)
            .fetchTimerSettings();
  }

  @override
  Widget build(BuildContext context) {
    providerMain = Provider.of<ProviderToddlerTimes>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "settings") {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScreenToddlerTimerSettings(),
                ));
              } else if (value == "reset") {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("Reset all the data?"),
                      content: Text(
                          "You will lose all the data stored in this app. Are you srue about this"),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text("Nah"),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        RaisedButton(
                            child: Text("Yeah"),
                            color: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              providerMain.deleteDatabase();
                            })
                      ],
                    ));
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Settings"),
                  value: "settings",
                ),
                PopupMenuItem(
                  child: Text("Reset"),
                  value: "reset",
                )
              ];
            },
          )
        ],
      ),
      body: Container(
        decoration: gradientBoxDecoration1,
        child: SafeArea(
          child: _isLoading
              ? CircularProgressIndicator()
              : GridView(
                  padding: EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8),
                  children: <Widget>[
                    buildGridTile(context,
                        icon: Icon(
                          Customicon.toilet,
                          size: 80,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "Bathroom",
                        minutes: timerSettings.bathroom),
                    buildGridTile(context,
                        icon: Icon(
                          Customicon.droplets,
                          size: 80,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "Water",
                        minutes: timerSettings.water),
                    buildGridTile(context,
                        icon: Icon(
                          Icons.fastfood,
                          size: 80,
                          color: Colors.yellow,
                        ),
                        name: "Food",
                        minutes: timerSettings.food),
                    buildGridTile(context,
                        icon: Icon(
                          Icons.motorcycle,
                          size: 80,
                          color: Colors.pink,
                        ),
                        name: "Play Time",
                        minutes: timerSettings.playtime),
                    buildGridTile(context,
                        icon: Icon(
                          Customicon.emo_sleep,
                          size: 80,
                          color: Colors.blue,
                        ),
                        name: "Nap Time",
                        minutes: timerSettings.naptime),
                  ],
                ),
        ),
      ),
    );
  }

  GridTile buildGridTile(BuildContext context,
      {Icon icon, String name, int minutes, bool isOvernight = false}) {
    int minutesToAdd = isOvernight
        ? minutes
        : DateTime.now().add(Duration(minutes: minutes)).hour < 19 && DateTime.now().add(Duration(minutes: minutes)).hour > 4
            ? minutes
            : 0;
    return GridTile(
      child: InkWell(
          focusColor: Colors.pink,
          
          splashColor: Colors.purple,
          highlightColor: Colors.green,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return ScreenTypeTime(name, minutesToAdd, icon.icon);
              },
            ));
          },
          onLongPress: () {
             Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return ScreenToddlerTimerSettings();
              },
            ));
          },
          child: Card(
            elevation: 15,
            child: icon,
          )),
    );
  }
}

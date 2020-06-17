import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toddlertimer/customicon_icons.dart';
import 'package:toddlertimer/screens/typetime.dart';
import '../provider/times.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProviderToddlerTimes provider;
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
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ProviderToddlerTimes>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "settings") {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Coming soon..."),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text("Don't give a sh*t"),
                        color: Theme.of(context).errorColor,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      RaisedButton(
                        child: Text("Cool"),
                        color: Theme.of(context).accentColor,
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                );
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => CybertruckSettings(),
                // ));
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
                              provider.deleteDatabase();
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
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //   colors: [Colors.black, Colors.pink],
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        // )),
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
                    GridTile(
                      child: InkWell(
                          splashColor: Colors.purple,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ScreenTypeTime("Bathroom");
                              },
                            ));
                          },
                          child: Card(
                            elevation: 15,
                            child: Icon(
                              Customicon.toilet,
                              color: Theme.of(context).accentColor,
                              size: 80,
                            ),
                          )),
                    ),
                    GridTile(
                      child: InkWell(
                          splashColor: Colors.purple,
                          highlightColor: Colors.green,
                          onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ScreenTypeTime("Water");
                              },
                            ));
                          },
                          child: Card(
                            elevation: 15,
                            child: Icon(
                              Customicon.droplets,
                              color: Theme.of(context).accentColor,
                              size: 80,
                            ),
                          )),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toddlertimer/helper/constants.dart';
import 'package:provider/provider.dart';
import 'package:toddlertimer/models/timers.dart';
import 'package:toddlertimer/provider/timers.dart';

class ScreenToddlerTimerSettings extends StatefulWidget {
  final String highlight;

  ScreenToddlerTimerSettings({this.highlight = ""});

  @override
  _ScreenToddlerTimerSettingsState createState() =>
      _ScreenToddlerTimerSettingsState();
}

class _ScreenToddlerTimerSettingsState
    extends State<ScreenToddlerTimerSettings> {
  bool _isLoading = false;
  bool _isInit = true;
  final _form = GlobalKey<FormState>();

  final _waterController = TextEditingController();
  final _waterfocusnode = FocusNode();
  final _bathroomController = TextEditingController();
  final _bathroomfocusnode = FocusNode();
  final _foodController = TextEditingController();
  final _foodfocusnode = FocusNode();
  final _napController = TextEditingController();
  final _napfocusnode = FocusNode();
  final _playController = TextEditingController();
  final _playfocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getTimerSettingsFromProvider() async {
    var timerSettings =
        await Provider.of<ProviderTimerHelper>(context, listen: false)
            .fetchTimerSettings();

    _waterController.text = timerSettings.water.toString();
    _bathroomController.text = timerSettings.bathroom.toString();
    _foodController.text = timerSettings.food.toString();
    _napController.text = timerSettings.naptime.toString();
    _playController.text = timerSettings.playtime.toString();

    if (widget.highlight != "") {}
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await _getTimerSettingsFromProvider();
      setState(() {
        _isLoading = false;
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Timer Settings (minutes)"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: gradientBoxDecoration1,
        child: SafeArea(
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: _bathroomfocusnode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_waterfocusnode);
                          },
                          textInputAction: TextInputAction.next,
                          controller: _bathroomController,
                          decoration: InputDecoration(
                            labelText: "Bath Room Timer",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          focusNode: _waterfocusnode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_foodfocusnode);
                          },
                          textInputAction: TextInputAction.next,
                          controller: _waterController,
                          decoration: InputDecoration(
                            labelText: "Water Timer",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          focusNode: _foodfocusnode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_playfocusnode);
                          },
                          textInputAction: TextInputAction.next,
                          controller: _foodController,
                          decoration: InputDecoration(
                            labelText: "Food Timer",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          focusNode: _playfocusnode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_napfocusnode);
                          },
                          textInputAction: TextInputAction.next,
                          controller: _playController,
                          decoration: InputDecoration(
                            labelText: "Play Timer",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          focusNode: _napfocusnode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          controller: _napController,
                          decoration: InputDecoration(
                            labelText: "Nap Timer",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RaisedButton(
                          child: Text("Update"),
                          onPressed: _updatePres,
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _updatePres() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });
    await Provider.of<ProviderTimerHelper>(context, listen: false)
        .setTimerSettings(ModelTimerSetting(
      water: int.parse(_waterController.text),
      food: int.parse(_foodController.text),
      bathroom: int.parse(_bathroomController.text),
      playtime: int.parse(_playController.text),
      naptime: int.parse(_napController.text),
    ));

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _isLoading = false;
    });
  }
}

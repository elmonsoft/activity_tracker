import 'package:flutter/material.dart';
import 'package:theme_manager/change_theme_widget.dart';
import 'package:theme_manager/theme_manager.dart';

class ChangeThemeWidget extends StatefulWidget {
  @override
  _ChangeThemeWidgetState createState() => _ChangeThemeWidgetState();
}

class _ChangeThemeWidgetState extends State<ChangeThemeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Manager'),
        centerTitle: true,
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () => ThemeManager.of(context)
                    .setBrightnessPreference(BrightnessPreference.system),
                child: const Text('System'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: RaisedButton(
                  onPressed: () => ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.light),
                  child: const Text('Light'),
                ),
              ),
              RaisedButton(
                onPressed: () => ThemeManager.of(context)
                    .setBrightnessPreference(BrightnessPreference.dark),
                child: const Text('Dark'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showThemePicker,
        child: const Icon(Icons.color_lens, color: Colors.white),
      ),
    );
  }

  void showThemePicker() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ThemePickerDialog(
          onSelectedTheme: (BrightnessPreference preference) {
            ThemeManager.of(context).setBrightnessPreference(preference);
          },
        );
      },
    );
  }
}
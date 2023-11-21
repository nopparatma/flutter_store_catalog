import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';

enum VirtualKeyboardType { Numeric, Alphanumeric, Email }
enum VirtualKeyboardKeyType { Action, String }
enum VirtualKeyboardKeyAction { Backspace, Return, Shift, Space, SwithLanguage }
enum VirtualKeyboardDefaultLayouts { Thai, English, Number }

class VirtualKeyboardKey {
  String text;
  final VirtualKeyboardKeyType keyType;
  final VirtualKeyboardKeyAction action;

  VirtualKeyboardKey({this.text, @required this.keyType, this.action}) {
    if (this.text == null && this.action != null) {
      this.text = action == VirtualKeyboardKeyAction.Space ? ' ' : (action == VirtualKeyboardKeyAction.Return ? '\n' : '');
    }
  }
}

typedef OnKeyboardKeyPress = void Function(VirtualKeyboardKey key);

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 200;

const int _virtualKeyboardBackspaceEventPerioud = 250;

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  final Function onKeyPress;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard height. Default is full screen width
  final double width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// the custom layout for multi or single language
  final VirtualKeyboardLayoutKeys customLayoutKeys;

  /// the text controller go get the output and send the default input
  final TextEditingController textController;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key) builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// inverse the layout to fix the issues with right to left languages.
  final bool reverseLayout;

  /// used for multi-languages with default layouts, the default is English only
  /// will be ignored if customLayoutKeys is not null
  final List<VirtualKeyboardDefaultLayouts> defaultLayouts;

  VirtualKeyboard({
    Key key,
    @required this.type,
    this.onKeyPress,
    this.builder,
    this.width,
    this.defaultLayouts,
    this.customLayoutKeys,
    this.textController,
    this.reverseLayout = false,
    this.height = _virtualKeyboardDefaultHeight,
    this.textColor = colorDark,
    this.fontSize = 14,
    this.alwaysCaps = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  VirtualKeyboardType type;
  Function onKeyPress;
  TextEditingController textController;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key) builder;
  double height;
  double width;
  Color textColor;
  double fontSize;
  bool reverseLayout;
  VirtualKeyboardLayoutKeys customLayoutKeys;
  // Text Style for keys.
  TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = false;

  void _onKeyPress(VirtualKeyboardKey key) {
    String newText = '';
    String oldText = textController.text;
    // if (textController is ThaiTextEditingController) {
    //   ThaiTextEditingController thaiTextEditingController = textController;
    //   oldText = thaiTextEditingController.convertToRealText(oldText);
    // }
    bool isUpdateText = false;
    if (key.keyType == VirtualKeyboardKeyType.String) {
      newText = oldText + key.text;
      isUpdateText = true;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (oldText.length == 0) return;

          newText = oldText.substring(0, oldText.length - 1);
          isUpdateText = true;
          break;
        case VirtualKeyboardKeyAction.Return:
          newText = oldText + '\n';
          isUpdateText = true;
          break;
        case VirtualKeyboardKeyAction.Space:
          newText = oldText + key.text;
          isUpdateText = true;
          break;
        case VirtualKeyboardKeyAction.Shift:
          break;
        default:
      }
    }

    if (isUpdateText) {
      textController.value = textController.value.copyWith(
        text: newText,
        selection: TextSelection.fromPosition(TextPosition(offset: newText.length)),
        composing: TextRange.empty,
      );
    }

    if (onKeyPress != null) onKeyPress(key);
  }

  @override
  dispose() {
    if (widget.textController == null) // dispose if created locally only
      textController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      onKeyPress = widget.onKeyPress;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      reverseLayout = widget.reverseLayout ?? false;
      textController = widget.textController ?? textController;
      customLayoutKeys = widget.customLayoutKeys ?? customLayoutKeys;
      // Init the Text Style for keys.
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
      builder = widget.builder;
    });
  }

  @override
  void initState() {
    super.initState();

    textController = widget.textController ?? TextEditingController();
    width = widget.width;
    type = widget.type;
    customLayoutKeys = widget.customLayoutKeys ?? VirtualKeyboardDefaultLayoutKeys(widget.defaultLayouts ?? [VirtualKeyboardDefaultLayouts.Thai, VirtualKeyboardDefaultLayouts.English]);
    onKeyPress = widget.onKeyPress;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    reverseLayout = widget.reverseLayout ?? false;
    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
    builder = widget.builder;
  }

  @override
  Widget build(BuildContext context) {
    return type == VirtualKeyboardType.Numeric ? _numeric() : _alphanumeric();
  }

  Widget _alphanumeric() {
    return Container(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  Widget _numeric() {
    return Container(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows = _getKeyboardRows(customLayoutKeys);

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      var items = List.generate(keyboardRows[rowNum].length, (int keyNum) {
        // Get the VirtualKeyboardKey object.
        VirtualKeyboardKey virtualKeyboardKey = keyboardRows[rowNum][keyNum];

        Widget keyWidget;

        // Check if builder is specified.
        // Call builder function if specified or use default
        //  Key widgets if not.
        if (builder == null) {
          // Check the key type.
          switch (virtualKeyboardKey.keyType) {
            case VirtualKeyboardKeyType.String:
              // Draw String key.
              keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
              break;
            case VirtualKeyboardKeyType.Action:
              // Draw action key.
              keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
              break;
          }
        } else {
          // Call the builder function, so the user can specify custom UI for keys.
          keyWidget = builder(context, virtualKeyboardKey);

          if (keyWidget == null) {
            throw 'builder function must return Widget';
          }
        }

        return keyWidget;
      });

      if (this.reverseLayout) items = items.reversed.toList();
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Generate keboard keys
          children: items,
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  bool longPress;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Expanded(
        child: Container(
      height: height / customLayoutKeys.activeLayout.length,
      child: Card(
        elevation: 6,
        child: InkWell(
          onTap: () {
            _onKeyPress(key);
          },
          child: Center(
              child: Text(
            ' ${key.text} ',
            style: textStyle,
          )),
        ),
      ),
    ));
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget actionKey;

    // Switch the action type to build action Key widget.
    switch (key.action) {
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = GestureDetector(
            onLongPress: () {
              longPress = true;
              // Start sending backspace key events while longPress is true
              Timer.periodic(Duration(milliseconds: _virtualKeyboardBackspaceEventPerioud), (timer) {
                if (longPress) {
                  _onKeyPress(key);
                } else {
                  // Cancel timer.
                  timer.cancel();
                }
              });
            },
            onLongPressUp: () {
              // Cancel event loop
              longPress = false;
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Icon(
                Icons.backspace,
                color: textColor,
              ),
            ));
        break;
      case VirtualKeyboardKeyAction.Shift:
        actionKey = Container(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            Icons.arrow_upward,
            color: textColor,
          ),
        );
        break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = Container(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            Icons.space_bar,
            color: textColor,
          ),
        );
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = Container(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            Icons.keyboard_return,
            color: textColor,
          ),
        );
        break;
      case VirtualKeyboardKeyAction.SwithLanguage:
        actionKey = Container(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            Icons.language,
            color: textColor,
          ),
        );
        break;
        break;
    }

    var wdgt = Container(
      alignment: Alignment.center,
      height: height / customLayoutKeys.activeLayout.length,
      child: Card(
        elevation: 6,
        child: InkWell(
          onTap: () {
            switch (key.action) {
              case VirtualKeyboardKeyAction.SwithLanguage:
                setState(() {
                  customLayoutKeys.switchLanguage();
                });
                break;
              case VirtualKeyboardKeyAction.Shift:
                setState(() {
                  customLayoutKeys.switchShift();
                });
                break;
            }
            _onKeyPress(key);
          },
          child: actionKey,
        ),
      ),
    );

    if (key.action == VirtualKeyboardKeyAction.Space)
      return SizedBox(width: (width ?? MediaQuery.of(context).size.width) / 2, child: wdgt);
    else
      return Expanded(child: wdgt);
  }
}

/// Returns a list of `VirtualKeyboardKey` objects.
List<VirtualKeyboardKey> _getKeyboardRowKeys(VirtualKeyboardLayoutKeys layoutKeys, rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(layoutKeys.activeLayout[rowNum].length, (int keyNum) {
    // Get key string value.
    if (layoutKeys.activeLayout[rowNum][keyNum] is String) {
      String key = layoutKeys.activeLayout[rowNum][keyNum];

      // Create and return new VirtualKeyboardKey object.
      return VirtualKeyboardKey(
        text: key,
        keyType: VirtualKeyboardKeyType.String,
      );
    } else {
      var action = layoutKeys.activeLayout[rowNum][keyNum] as VirtualKeyboardKeyAction;
      return VirtualKeyboardKey(keyType: VirtualKeyboardKeyType.Action, action: action);
    }
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRows(VirtualKeyboardLayoutKeys layoutKeys) {
  // Generate lists for each keyboard row.
  return List.generate(layoutKeys.activeLayout.length, (int rowNum) => _getKeyboardRowKeys(layoutKeys, rowNum));
}

abstract class VirtualKeyboardLayoutKeys {
  int activeIndex = 0;
  int activeShiftIndex = 0;

  List<List> get defaultEnglishLayout => _defaultEnglishLayout;
  List<List> get defaultThaiLayout => _defaultThaiLayout;

  List<List> get activeLayout => getLanguage(activeIndex, activeShiftIndex);
  int getLanguagesCount();
  List<List> getLanguage(int index, int shiftIndex);

  void switchLanguage() {
    if ((activeIndex + 1) == getLanguagesCount()) {
      activeIndex = 0;
      activeShiftIndex = 0;
    } else {
      activeIndex++;
      activeShiftIndex = 0;
    }
  }

  void switchShift() {
    if ((activeShiftIndex + 1) == 2)
      activeShiftIndex = 0;
    else
      activeShiftIndex++;
  }
}

class VirtualKeyboardDefaultLayoutKeys extends VirtualKeyboardLayoutKeys {
  List<VirtualKeyboardDefaultLayouts> defaultLayouts;
  VirtualKeyboardDefaultLayoutKeys(this.defaultLayouts);

  int getLanguagesCount() => defaultLayouts.length;

  List<List> getLanguage(int index, int shiftIndex) {
    switch (defaultLayouts[index]) {
      case VirtualKeyboardDefaultLayouts.English:
        return shiftIndex != 0 ? _defaultEnglishCapLayout : _defaultEnglishLayout;
      case VirtualKeyboardDefaultLayouts.Thai:
        return shiftIndex != 0 ? _defaultThaiShiftLayout : _defaultThaiLayout;
      default:
    }
    return _defaultEnglishLayout;
  }

  @override
  String toString() {
    return 'VirtualKeyboardDefaultLayoutKeys {defaultLayouts: $defaultLayouts}';
  }
}

/// Keys for Virtual Keyboard's rows.
const List<List> _defaultEnglishLayout = [
  const ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '='],
  const ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\\'],
  const ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\''],
  const [VirtualKeyboardKeyAction.Shift, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', VirtualKeyboardKeyAction.Backspace],
  const [VirtualKeyboardKeyAction.SwithLanguage, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return],
];

const List<List> _defaultEnglishCapLayout = [
  const ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')', '_', '+'],
  const ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '|'],
  const ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"'],
  const [VirtualKeyboardKeyAction.Shift, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', VirtualKeyboardKeyAction.Backspace],
  const [VirtualKeyboardKeyAction.SwithLanguage, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return],
];

const List<List> _defaultThaiLayout = [
  const ['_', 'ๅ', '/', '-', 'ภ', 'ถ', 'ุ', 'ึ', 'ค', 'ต', 'จ', 'ข', 'ช'],
  const ['ๆ', 'ไ', 'ำ', 'พ', 'ะ', 'ั', 'ี', 'ร', 'น', 'ย', 'บ', 'ล', 'ฅ'],
  const ['ฟ', 'ห', 'ก', 'ด', 'เ', '้', '่', 'า', 'ส', 'ว', 'ง'],
  const [VirtualKeyboardKeyAction.Shift, 'ผ', 'ป', 'แ', 'อ', 'ิ', 'ื', 'ท', 'ม', 'ใ', 'ฝ', VirtualKeyboardKeyAction.Backspace],
  const [VirtualKeyboardKeyAction.SwithLanguage, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return],
];

const List<List> _defaultThaiShiftLayout = [
  const ['%', '+', '๑', '๒', '๓', '๔', 'ู', '฿', '๕', '๖', '๗', '๘', '๙'],
  const ['๐', '"', 'ฎ', 'ฑ', 'ธ', 'ํ', '๊', 'ณ', 'ฯ', 'ญ', 'ฐ', ',', 'ฃ'],
  const ['ฤ', 'ฆ', 'ฏ', 'โ', 'ฌ', '็', '๋', 'ษ', 'ศ', 'ซ', '.'],
  const [VirtualKeyboardKeyAction.Shift, '(', ')', 'ฉ', 'ฮ', 'ฺ', '์', '?', 'ฒ', 'ฬ', 'ฦ', VirtualKeyboardKeyAction.Backspace],
  const [VirtualKeyboardKeyAction.SwithLanguage, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return],
];

class VirtualKeyboardNumberLayoutKeys extends VirtualKeyboardLayoutKeys {
  List<VirtualKeyboardDefaultLayouts> defaultLayouts;
  VirtualKeyboardNumberLayoutKeys(this.defaultLayouts);

  int getLanguagesCount() => defaultLayouts.length;

  List<List> getLanguage(int index, int shiftIndex) {
    return _keyRowsNumeric;
  }

  @override
  String toString() {
    return 'VirtualKeyboardNumberLayoutKeys {defaultLayouts: $defaultLayouts}';
  }
}

/// Keys for Virtual Keyboard's rows.
const List<List> _keyRowsNumeric = [
  const ['1', '2', '3'],
  const ['4', '5', '6'],
  const ['7', '8', '9'],
  const ['.', '0', VirtualKeyboardKeyAction.Backspace],
];

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_keyboard/flag_keyboard_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/widgets/text_formatter.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';

typedef KeyboardFieldBuilder = Widget Function(TextEditingController textEditingController, FocusNode focusNode, List<TextInputFormatter> inputFormatters);

final keyboardLayoutNumber = VirtualKeyboardNumberLayoutKeys([VirtualKeyboardDefaultLayouts.Number]);
final keyboardLayoutEmail = VirtualKeyboardDefaultLayoutKeys([VirtualKeyboardDefaultLayouts.English]);
final keyboardLayoutAlphanumericThai = VirtualKeyboardDefaultLayoutKeys([VirtualKeyboardDefaultLayouts.Thai, VirtualKeyboardDefaultLayouts.English]);
final keyboardLayoutAlphanumericEng = VirtualKeyboardDefaultLayoutKeys([VirtualKeyboardDefaultLayouts.English, VirtualKeyboardDefaultLayouts.Thai]);

class VirtualKeyboardWrapper extends StatefulWidget {
  final OnKeyboardKeyPress onKeyPress;
  final VirtualKeyboardType keyboardType;
  final TextEditingController textController;
  final FocusNode focusNode;
  final List<TextInputFormatter> inputFormatters;
  final KeyboardFieldBuilder builder;
  final int maxLength;
  final bool isAllowSpecialCharacter;

  VirtualKeyboardWrapper({
    Key key,
    this.onKeyPress,
    this.keyboardType = VirtualKeyboardType.Alphanumeric,
    this.textController,
    this.focusNode,
    this.inputFormatters,
    this.builder,
    this.maxLength,
    this.isAllowSpecialCharacter = true,
  }) : super(key: key);

  @override
  _VirtualKeyboardWrapperState createState() => _VirtualKeyboardWrapperState();
}

class _VirtualKeyboardWrapperState extends State<VirtualKeyboardWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlagKeyboardBloc, FlagKeyboardState>(
      builder: (context, state) {
        return VirtualKeyboardWrapperInner(
          key: ValueKey(state.isEnabled),
          isEnabled: state.isEnabled,
          onKeyPress: widget.onKeyPress,
          keyboardType: widget.keyboardType,
          width: widget.keyboardType == VirtualKeyboardType.Numeric ? 300 : 700,
          fontSize: 20,
          textController: widget.textController,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          builder: widget.builder,
          maxLength: widget.maxLength,
          isAllowSpecialCharacter: widget.isAllowSpecialCharacter,
        );
      },
    );
  }
}

class VirtualKeyboardWrapperInner extends StatefulWidget {
  final bool isEnabled;
  final OnKeyboardKeyPress onKeyPress;
  final VirtualKeyboardType keyboardType;
  final double width;
  final double fontSize;
  final TextEditingController textController;
  final FocusNode focusNode;
  final List<TextInputFormatter> inputFormatters;
  final KeyboardFieldBuilder builder;
  final int maxLength;
  final bool isAllowSpecialCharacter;

  VirtualKeyboardWrapperInner({
    Key key,
    this.isEnabled = true,
    this.onKeyPress,
    this.keyboardType,
    this.width,
    this.fontSize,
    this.textController,
    this.focusNode,
    this.inputFormatters,
    this.builder,
    this.maxLength,
    this.isAllowSpecialCharacter,
  }) : super(key: key);

  @override
  _VirtualKeyboardWrapperInnerState createState() => _VirtualKeyboardWrapperInnerState();
}

class _VirtualKeyboardWrapperInnerState extends State<VirtualKeyboardWrapperInner> {
  LayerLink _layerLink = LayerLink(); // ตัวเชื่อมระว่าง Widget
  TextEditingController textController;
  FocusNode focusNode;
  List<TextInputFormatter> inputFormatters;

  OverlayEntry _overlay;
  @override
  void initState() {
    textController = widget.textController ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    inputFormatters = widget.inputFormatters ?? [];

    // default input formatter
    inputFormatters.add(FilteringTextInputFormatter.singleLineFormatter);
    if (widget.maxLength != null) {
      inputFormatters.add(CustomLengthLimitingTextInputFormatter(widget.maxLength));
    }

    if (!widget.isAllowSpecialCharacter) {
      inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(RegularExpression.CHARACTER)));
    }

    if (widget.keyboardType == VirtualKeyboardType.Email) {
      inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(RegularExpression.EMAIL)));
    }

    if (widget.isEnabled) {
      focusNode.addListener(focusNodeListener);
    }
    textController.addListener(textEditListener);
    super.initState();
  }

  void focusNodeListener() {
    if (focusNode.hasFocus) {
      _overlay = _createKeyboardOverlay();
      Overlay.of(context).insert(_overlay);
    } else {
      _overlay?.remove();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  void textEditListener() {
    TextEditingValue value = textController.value;
    value = inputFormatters?.fold<TextEditingValue>(
          value,
          (TextEditingValue newValue, TextInputFormatter formatter) => formatter.formatEditUpdate(textController.value, newValue),
        ) ??
        value;

    // if (textController is ThaiTextEditingController) {
    //   ThaiTextEditingController thaiTextEditingController = textController;
    //   if (thaiTextEditingController.isThaiVowelLastChar(value.text)) {
    //     String text = thaiTextEditingController.convertToRealText(value.text);
    //     String newText = thaiTextEditingController.getDisplayText(text);
    //
    //     value = value.copyWith(
    //       text: newText,
    //       // selection: TextSelection.fromPosition(TextPosition(offset: text.length)),
    //       // composing: TextRange.empty,
    //     );
    //   }
    // }

    // print(value);

    textController.value = value;

    if (mounted) {
      setState(() {}); // for update state textfield
    }
  }

  @override
  dispose() {
    textController?.removeListener(textEditListener);
    focusNode?.removeListener(focusNodeListener);

    if (widget.textController == null) // dispose if created locally only
      textController?.dispose();

    super.dispose();
  }

  OverlayEntry _createKeyboardOverlay() {
    RenderBox renderBox = context.findRenderObject(); // พิกัด และขนาดการ Render ของ Widget นี้
    var size = renderBox.size; // ขนาดของ Widget
    var offset = renderBox.localToGlobal(Offset.zero); // พิกัด X,Y ที่ Widget นี้แสดงอยู่

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0,
        child: CompositedTransformFollower(
          targetAnchor: (offset.dx + widget.width) > MediaQuery.maybeOf(context).size.width ? Alignment.topRight : Alignment.topLeft,
          followerAnchor: (offset.dx + widget.width) > MediaQuery.maybeOf(context).size.width ? Alignment.topRight : Alignment.topLeft,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            child: _buildVirtualKeyboard(),
          ),
        ),
      ),
    );
  }

  VirtualKeyboardLayoutKeys getVirtualKeyboardLayout(BuildContext context, VirtualKeyboardType type) {
    if (type == VirtualKeyboardType.Numeric) {
      return keyboardLayoutNumber;
    } else if (type == VirtualKeyboardType.Email) {
      return keyboardLayoutEmail;
    } else if (LanguageUtil.isTh(context)) {
      return keyboardLayoutAlphanumericThai;
    } else {
      return keyboardLayoutAlphanumericEng;
    }
  }

  Widget _buildVirtualKeyboard() {
    return Container(
      child: VirtualKeyboard(
        width: widget.width,
        fontSize: widget.fontSize,
        textController: textController,
        type: widget.keyboardType,
        onKeyPress: widget.onKeyPress,
        customLayoutKeys: getVirtualKeyboardLayout(context, widget.keyboardType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEnabled
        ? CompositedTransformTarget(
            link: _layerLink,
            child: widget.builder(textController, focusNode, inputFormatters),
          )
        : widget.builder(textController, focusNode, inputFormatters);
  }
}

class ThaiTextEditingController extends TextEditingController {

  // for workaround TextField cursor jump to the first character when typing Thai vowel above and below the alphabet
  static const String EMPTY_STRING = '\u200B';
  static final RegExp reqExpThaiVowel = RegExp(r'^[\u0E31\u0E33-\u0E3A\u0E47-\u0E4E]+$');
  // static final RegExp reqExpThaiVowel = RegExp(r'.[\u0E31\u0E33-\u0E3A\u0E47-\u0E4E]');

  ThaiTextEditingController({String text}) : super(text: text);

  bool isThaiVowelLastChar(String paramText) {
    String lastChar = paramText.length > 0 ? paramText.substring(paramText.length - 1) : paramText;
    // print('lastChar [$lastChar][${lastChar.length}]');
    bool isThaiVowelLastChar = reqExpThaiVowel.hasMatch(lastChar);
    // print('isThaiVowelLastChar [$isThaiVowelLastChar]');
    return isThaiVowelLastChar;
  }

  String convertToRealText(String paramText) {
    return paramText.replaceAll(EMPTY_STRING, '').trim();
  }

  String getRealText() {
    return convertToRealText(text);
  }

  String getDisplayText(String paramText) {
    // return paramText.replaceAllMapped(reqExpThaiVowel, (match) =>  '${match.group(0)}$EMPTY_STRING');
    return paramText.length > 0 ? paramText + EMPTY_STRING : paramText;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final int minNumberRequired;
  final int maxNumberRequired;
  final Widget leadingIcon;
  final TextInputType type;
  final String initialText;
  final Function onSubmitted;
  final String errorText;
  final TextStyle errorTextStyle;
  final TextStyle labelTextStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle helperTextStyle;
  final String helperText;
  final double minAmount;
  final String prefixText;
  final TextStyle prefixTextStyle;
  final String hint;
  final Function onValueChange;
  final EdgeInsets labelPadding;
  final Widget trailingWidget;
  final String textFieldValue;
  final Function onTapForFirstTime;
  final bool enabled;
  final List<TextInputFormatter> textInputFormatter;
  CustomTextField(this.minNumberRequired, this.maxNumberRequired,
      {this.label = "ID NUMBER",
      this.isRequired = true,
      this.leadingIcon,
      this.initialText,
      this.onSubmitted,
      this.errorText,
      this.errorTextStyle,
      this.onValueChange,
      this.labelTextStyle,
      this.textStyle,
      this.hintStyle,
      this.trailingWidget,
      this.helperText,
      this.helperTextStyle,
      this.minAmount,
      this.hint,
      this.enabled = true,
      this.textInputFormatter,
      this.labelPadding,
      this.prefixText,
      this.prefixTextStyle,
      this.textFieldValue,
      this.onTapForFirstTime,
      this.type});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _controller;
  String errorText;
  Color borderColor = CommonColors.disabledTaskTextColor;
  FocusNode _focusNode = FocusNode();

  int tapCounter = 0;
  final int maxTapCount = 1;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      if (widget.isRequired) {
        checkForEmptyString(_controller.text);
      }
      buildErrorText(_controller.text);
    });
    if (widget.initialText != null && widget.initialText.isNotEmpty) {
      _controller.text = widget.initialText;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    // Assign new value to controller
    if (widget.textFieldValue != null) {
      final offset = _controller.selection.extentOffset;
      _controller.text = widget.textFieldValue;
      // Set the border color
      checkForBorderColor(_controller.text);
      // If the cursor is mid word, then stay there
      // For Cursor to move to last letter
      if (offset < _controller.text.length) {
        final val = TextSelection.collapsed(offset: offset);
        _controller.selection = val;
      } else {
        final val = TextSelection.collapsed(
            offset: _controller.text.runes.length);
        _controller.selection = val;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (tapCounter < maxTapCount && widget.onTapForFirstTime != null) {
          tapCounter++;
          widget.onTapForFirstTime();
        }
      },
      enabled: widget.enabled,
      controller: _controller,
      focusNode: _focusNode,
      cursorColor: CommonColors.cursorColor,
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.done,
      keyboardType: widget.type,
      inputFormatters: widget.textInputFormatter,
      onChanged: (text) {
        // Check For Border Color
        setState(() {
          checkForBorderColor(text);
        });
        widget.onValueChange(text);
      },
      style: widget.textStyle ??
          CommonTextStyles.taskTextStyle().copyWith(
            decoration: TextDecoration.none,
          ),
      onFieldSubmitted: (text) {
        widget.onSubmitted(text);
      },
      validator: (newString) {
        if (widget.isRequired) {
          return checkForEmptyString(newString);
        }
        return buildErrorText(newString);
      },
      decoration: InputDecoration(
        contentPadding: widget.labelPadding,
        alignLabelWithHint: true,
        errorText: errorText,
        prefixText: widget.prefixText,
        prefixStyle: widget.prefixTextStyle,
        prefixIcon: widget.leadingIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SizedBox(
                  width: 0,
                  height: 48,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: widget.leadingIcon,
                  ),
                ),
              ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.trailingWidget,
        ),
        errorStyle: widget.errorTextStyle,
        helperText: widget.helperText,
        helperStyle: widget.helperTextStyle,
        helperMaxLines: 2,
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CommonColors.errorTextColor),
        ),
        labelStyle: widget.labelTextStyle ??
            CommonTextStyles.taskTextStyle()
                .copyWith(fontSize: 16, color: buildLabelAndHintColor()),
        hintStyle: widget.hintStyle ??
            CommonTextStyles.taskTextStyle()
                .copyWith(fontSize: 16, color: buildLabelAndHintColor()),
        labelText: widget.label,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  Color buildLabelAndHintColor() {
    Color hintAndLabelColor;
    if (_focusNode.hasFocus || _controller.text.isNotEmpty) {
      hintAndLabelColor = Colors.grey;
    } else {
      hintAndLabelColor = CommonColors.disabledTaskTextColor;
    }
    return hintAndLabelColor;
  }

  String buildErrorText(String newText) {
    if (newText.isNotEmpty &&
        (widget.minNumberRequired != null ||
            widget.maxNumberRequired != null)) {
      if (newText.length < widget.minNumberRequired) {
        errorText =
            "${widget.label} length should be bigger than ${widget.minNumberRequired}";
      } else {
        errorText = null;
      }

      if (widget.maxNumberRequired != null &&
          newText.length > widget.maxNumberRequired) {
        errorText =
            "${widget.label} length should be less than ${widget.maxNumberRequired}";
      }

      if (widget.minAmount != null) {
        if (int.parse(_controller.text) < widget.minAmount)
          errorText =
              "${widget.label} length should not be less than ${widget.minAmount}";
        else
          errorText = null;
      }

      if (widget.minNumberRequired != null &&
          widget.maxNumberRequired == null &&
          (newText.length < widget.minNumberRequired ||
              newText.length > widget.minNumberRequired)) {
        errorText =
            "${widget.label} should be exactly ${widget.minNumberRequired} digits";
      }
    }
    return errorText;
  }

  String checkForEmptyString(String newString) {
    if (newString == null || newString.length == 0) {
      if (widget.errorText == null || widget.errorText.isEmpty)
        errorText = "${widget.label} should not be empty";
      else
        errorText = "${widget.errorText} should not be empty";
      return errorText;
    }

    if (newString != null && newString.length > 0) {
      errorText = null;
      return null;
    }

    return errorText;
  }

  checkForBorderColor(String currentText) {
    String errorCheckString;
    if (widget.isRequired) {
      errorCheckString = checkForEmptyString(currentText);
    }
    errorCheckString = buildErrorText(currentText);
    if (errorCheckString == null &&
        _controller.text != null &&
        _controller.text.isNotEmpty) {
      borderColor = CommonColors.accentColor;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

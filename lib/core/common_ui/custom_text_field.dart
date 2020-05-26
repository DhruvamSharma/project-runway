import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:provider/provider.dart';

import '../common_colors.dart';
import '../common_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final bool autoFocus;
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
  final bool enabled;
  final Function onTapForFirstTime;
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
      this.textInputFormatter,
      this.labelPadding,
      this.prefixText,
      this.autoFocus = false,
      this.prefixTextStyle,
      this.textFieldValue,
      this.onTapForFirstTime,
      this.enabled = true,
      this.type});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _controller;
  String errorText;
  Color borderColor;
  FocusNode _focusNode = FocusNode();

  int tapCounter = 0;
  final int maxTapCount = 1;

  @override
  void didChangeDependencies() {
    borderColor = Provider.of<ThemeModel>(context, listen: false)
        .currentTheme
        .accentColor
        .withOpacity(0.5);
    super.didChangeDependencies();
  }

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
      _controller.value = TextEditingValue(
        text: widget.textFieldValue,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: widget.textFieldValue.length,
          ),
        ),
      );
      // Set the border color
      checkForBorderColor(_controller.text);
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
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      cursorColor: borderColor,
      textAlign: TextAlign.left,
      enabled: widget.enabled,
      textInputAction: TextInputAction.done,
      enableSuggestions: true,
      keyboardType: widget.type,
      inputFormatters: widget.textInputFormatter,
      onChanged: (text) {
        // Check For Border Color
        setState(() {
          checkForBorderColor(text);
        });
        widget.onValueChange(text);
      },
      style: widget.textStyle ?? buildTextStyle(),
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
        isDense: true,
        contentPadding: widget.labelPadding,
        alignLabelWithHint: true,
        errorText: errorText,
        prefixText: buildPrefixText(),
        prefixStyle: buildPrefixStyle(),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.trailingWidget,
        ),
        errorStyle:
            widget.errorTextStyle ?? CommonTextStyles.errorFieldTextStyle(),
        helperText: widget.helperText,
        helperMaxLines: 3,
        helperStyle:
            widget.helperTextStyle ?? CommonTextStyles.badgeTextStyle(context),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CommonColors.errorTextColor),
        ),
        labelStyle: widget.labelTextStyle ??
            CommonTextStyles.taskTextStyle(context)
                .copyWith(color: buildLabelAndHintColor()),
        hintStyle: widget.hintStyle ??
            CommonTextStyles.taskTextStyle(context).copyWith(
              color: buildLabelAndHintColor(),
            ),
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

  TextStyle buildTextStyle() {
    TextStyle textStyle = CommonTextStyles.taskTextStyle(context);
    if (widget.enabled != null && !widget.enabled) {
      textStyle = textStyle.copyWith(
        color: Colors.grey,
      );
    }
    return textStyle;
  }

  TextStyle buildPrefixStyle() {
    TextStyle prefixTextStyle = widget.prefixTextStyle;
    if (widget.leadingIcon != null && widget.leadingIcon is Text) {
      Text text = (widget.leadingIcon as Text);
      prefixTextStyle = text.style;
    }
    return prefixTextStyle;
  }

  String buildPrefixText() {
    String prefixText = widget.prefixText;
    if (widget.leadingIcon != null && widget.leadingIcon is Text) {
      Text text = (widget.leadingIcon as Text);
      prefixText = text.data;
    }
    return prefixText;
  }

  Color buildLabelAndHintColor() {
    Color hintAndLabelColor;
    if (widget.enabled != null && !widget.enabled) {
      hintAndLabelColor = CommonColors.disabledTaskTextColor;
    } else {
      hintAndLabelColor =
          Provider.of<ThemeModel>(context, listen: false).currentTheme ==
                  lightTheme
              ? CommonColors.taskTextColorLightTheme
              : CommonColors.taskTextColor.withOpacity(0.5);
    }
    return hintAndLabelColor;
  }

  String buildErrorText(String newText) {
    if (newText.isNotEmpty &&
        (widget.minNumberRequired != null ||
            widget.maxNumberRequired != null)) {
      if (newText.length < widget.minNumberRequired) {
        errorText =
            "${widget.label} should be bigger than ${widget.minNumberRequired}";
      } else {
        errorText = null;
      }

      if (widget.maxNumberRequired != null &&
          newText.length > widget.maxNumberRequired) {
        errorText =
            "${widget.label} should be less than ${widget.maxNumberRequired}";
      }

      if (widget.minAmount != null) {
        if (int.parse(_controller.text) < widget.minAmount)
          errorText =
              "${widget.label} should not be less than ${widget.minAmount}";
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
    if (newString == null || newString.isEmpty) {
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
      borderColor = borderColor;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

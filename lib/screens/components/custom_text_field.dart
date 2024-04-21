import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/logic/authentication/sign_controller.dart';
import 'package:flutter_chat/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.labelText,
      this.keyboardType,
      this.suffix,
      this.textInputFormatter,
      this.obscureText,
      required this.controller,
      required this.validator,
      this.onTap,
      this.onChange,
      this.onFieldSubmitted,
      this.hint,
      this.maxLines = 1,
      required this.icon,
      this.editComplete,
      this.capitalazition,
      this.initialValue,
      this.perifix});

  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final int maxLines;
  final Widget? suffix;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChange;
  final Function()? editComplete;
  final Function validator;
  final List<TextInputFormatter>? textInputFormatter;
  final bool? obscureText;
  final String? hint;
  final String? initialValue;
  final TextCapitalization? capitalazition;
  final IconData icon;
  final Widget? perifix;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isChanged = true;

  //new design
  bool checkOfErrorOnFocusChange = false;
  bool isError = false;
  String errorString = "";
  FocusNode myFocusNode = FocusNode();

  getLabelTextStyle(color) {
    return TextStyle(fontSize: 12.0, color: color);
  } //label text style

  getTextFieldStyle() {
    return const TextStyle(
      fontSize: 12.0,
      color: Colors.black,
    );
  } //textfield style

  getErrorTextFieldStyle() {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: 'sfpro',
      color: Colors.redAccent,
    );
  } // Error text style

  getBorderColor(isfous) {
    return isfous ? kPrimaryColor : kBorderColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FocusScope(
          child: Focus(
            focusNode: myFocusNode,
            onFocusChange: (focus) {
              Signcontroller.hasFocus.value = myFocusNode.hasFocus;
              setState(() {
                getBorderColor(focus);
                if (checkOfErrorOnFocusChange &&
                    widget
                        .validator(widget.controller.text)
                        .toString()
                        .isNotEmpty) {
                  isError = true;
                  errorString = widget.validator(widget.controller.text);
                } else {
                  isError = false;
                  errorString = widget.validator(widget.controller.text);
                }
              });
            },
            child: Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // color: appcolor.cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: isError
                        ? Colors.redAccent
                        : getBorderColor(myFocusNode.hasFocus),
                  )),
              child: TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                textCapitalization:
                    widget.capitalazition ?? TextCapitalization.sentences,
                // initialValue: widget.initialValue,                focusNode: myFocusNode,
                controller: widget.controller,
                // style: appTextStyle.searchWidgetTitle,
                autofocus: false,
                obscureText: widget.obscureText ?? false,
                keyboardType: widget.keyboardType,
                textInputAction: TextInputAction.next,
                inputFormatters: widget.textInputFormatter ??
                    [
                      // FirstUpperCaseTextFormatter(),
                    ],
                maxLines: widget.maxLines,
                validator: (value) {
                  if (widget
                      .validator(widget.controller.text)!
                      .toString()
                      .isNotEmpty) {
                    setState(() {
                      isError = true;
                      errorString = widget.validator(widget.controller.text)!;
                    });
                    return "";
                  } else {
                    setState(() {
                      isError = false;
                      errorString = widget.validator(widget.controller.text)!;
                    });
                  }
                  return null;
                },
                onFieldSubmitted: widget.onFieldSubmitted,
                onChanged: (value) {
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                  if (widget.controller.text != '') {
                    // print(widget.controller!.text);
                    setState(() {
                      isChanged = false;
                    });
                  }
                },
                onEditingComplete: widget.editComplete,
                onTap: () {
                  widget.onTap;
                  if (widget.keyboardType == TextInputType.datetime) {
                    setState(() {
                      isChanged = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(
                      //   height: 40,
                      //   width: 40,
                      //   child: Image(
                      //     image: AssetImage(widget.image),
                      //     color: (isChanged) ? kPrimaryColor : borderColor,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          widget.icon,
                          size: 30,
                          color: (isChanged) ? kPrimaryColor : kBorderColor,
                        ),
                      ),
                      widget.perifix ?? const SizedBox(),
                    ],
                  ),
                  labelText: widget.labelText,
                  // labelStyle: appTextStyle.widgetSubHeaderTextStyle,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                  focusColor: kPrimaryColor,
                  suffixIcon: widget.suffix,
                  hintText: widget.hint,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  border: InputBorder.none,
                  errorStyle: const TextStyle(height: 0),
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Visibility(
            visible: isError ? true : false,
            child: Container(
                padding: const EdgeInsets.only(left: 15.0, top: 2.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    errorString,
                    style: getErrorTextFieldStyle(),
                  ),
                )))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/logic/authentication/sign_controller.dart';
import 'package:flutter_chat/utils/constants.dart';

// // ignore: must_be_immutable
// class CustomTextField extends StatefulWidget {
//   const CustomTextField(
//       {super.key,
//       required this.controller,
//       this.labelText,
//       this.keyboardType,
//       this.maxLines = 1,
//       this.suffix,
//       this.perifix,
//       this.onTap,
//       this.onChanged,
//       this.editComplete,
//       required this.validator,
//       this.textInputFormatter,
//       this.obscureText,
//       this.isEnamled,
//       this.hintText,
//       this.textCapitaliz,
//       this.labelStyle});

//   final TextEditingController controller;
//   final String? labelText;
//   final TextInputType? keyboardType;
//   final int maxLines;
//   final Widget? suffix;
//   final Widget? perifix;
//   final Function()? onTap;
//   final Function(String)? onChanged;
//   final Function()? editComplete;
//   final Function validator;
//   final List<TextInputFormatter>? textInputFormatter;
//   final bool? obscureText;
//   final bool? isEnamled;
//   final String? hintText;
//   final TextStyle? labelStyle;
//   final TextCapitalization? textCapitaliz;

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool isChanged = true;
//   bool isClear = false;
// //new
//   bool checkOfErrorOnFocusChange = false;
//   bool isError = false;
//   String errorString = "";
//   FocusNode myFocusNode = FocusNode();

//   getLabelTextStyle(color) {
//     return TextStyle(fontSize: 12.0, color: color);
//   } //label text style

//   getTextFieldStyle() {
//     return const TextStyle(
//       fontSize: 12.0,
//       color: Colors.black,
//     );
//   } //textfield style

//   getErrorTextFieldStyle() {
//     return const TextStyle(
//       fontSize: 12,
//       fontWeight: FontWeight.w400,
//       fontFamily: 'sfpro',
//       color: Colors.redAccent,
//     );
//   } // Error text style

//   getBorderColor(isfous) {
//     return isfous ? const Color(0xFF8F9CB1) : kPrimaryColor;
//   } //Border co

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FocusScope(
//           child: Focus(
//             onFocusChange: (focus) {
//               //Called when ever focus changes
//               // print("focus: $focus");
//               setState(() {
//                 getBorderColor(focus);
//                 if (checkOfErrorOnFocusChange &&
//                     widget
//                         .validator(widget.controller.text)!
//                         .toString()
//                         .isNotEmpty) {
//                   isError = true;
//                   errorString = widget.validator(widget.controller.text)!;
//                 } else {
//                   isError = false;
//                   errorString = widget.validator(widget.controller.text)!;
//                 }
//               });
//             },
//             child: Container(
//               height: 60,
//               width: double.infinity,
//               alignment: Alignment.center,
//               padding: const EdgeInsetsDirectional.symmetric(horizontal: 2),
//               decoration: BoxDecoration(
//                   // color: AppColor().cardColor,
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   border: Border.all(
//                     width: 1,
//                     style: BorderStyle.solid,
//                     color: isError
//                         ? Colors.redAccent
//                         : getBorderColor(myFocusNode.hasFocus),
//                   )),
//               child: TextFormField(
//                 onTapOutside: (event) {
//                   FocusManager.instance.primaryFocus?.unfocus();
//                 },
//                 textCapitalization: TextCapitalization.sentences,
//                 enabled: widget.isEnamled,
//                 focusNode: myFocusNode,
//                 controller: widget.controller,
//                 // style: CustomStyles1().searchWidgetTitle,
//                 autofocus: false,
//                 obscureText: widget.obscureText ?? false,
//                 keyboardType: widget.keyboardType,
//                 textInputAction:
//                     // (widget.maxLines == 1)
//                     //     ?
//                     TextInputAction.next,
//                 // : TextInputAction.done,
//                 inputFormatters: widget.textInputFormatter ??
//                     [
//                       // FirstUpperCaseTextFormatter(),
//                     ],
//                 maxLines: widget.maxLines,
//                 onChanged: widget.onChanged,
//                 onSaved: (newValue) {
//                   if (widget.controller.text.isNotEmpty) {
//                     widget.controller.text = newValue!;
//                   }
//                 },
//                 validator: (value) {
//                   if (widget
//                       .validator(widget.controller.text)!
//                       .toString()
//                       .isNotEmpty) {
//                     setState(() {
//                       isError = true;
//                       errorString = widget.validator(widget.controller.text)!;
//                     });
//                     return "";
//                   } else {
//                     setState(() {
//                       isError = false;
//                       errorString = widget.validator(widget.controller.text)!;
//                     });
//                   }
//                   return null;
//                 },
//                 onTap: () {
//                   widget.onTap;
//                   if (widget.keyboardType == TextInputType.datetime) {
//                     setState(() {
//                       isChanged = false;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   labelText: widget.labelText,
//                   // labelStyle: widget.labelStyle ??
//                   //     CustomStyles1().widgetSubHeaderTextStyle,
//                   contentPadding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
//                   focusColor: kPrimaryColor,
//                   suffixIcon: widget.suffix,
//                   prefixIcon: widget.perifix,
//                   hintText: widget.hintText,
//                   // hintStyle: CustomStyles1().widgetSubHeaderTextStyle,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   border: InputBorder.none,
//                   errorStyle: const TextStyle(height: 0),
//                   focusedErrorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 3),
//         Visibility(
//             visible: isError ? true : false,
//             child: Container(
//                 padding: const EdgeInsets.only(left: 15.0, top: 2.0),
//                 child: Padding(
//                   padding:
//                       EdgeInsets.only(left: widget.perifix != null ? 35 : 0),
//                   child: Text(
//                     errorString,
//                     style: getErrorTextFieldStyle(),
//                   ),
//                 )))
//       ],
//     );
//   }
// }

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
    return isfous ? kPrimaryColor : borderColor;
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
                          color: (isChanged) ? kPrimaryColor : borderColor,
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

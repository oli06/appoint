import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointFormInput extends StatefulWidget {
  final String hintText;
  final String errorText;
  final bool showSuffixIcon;
  final Widget leadingWidget;
  final bool showLeadingWidget;
  final Function(String value) onFieldSubmitted;
  final Function(String value) onSaved;
  final TextInputAction action;
  final bool obscureText;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function(String value) validator;
  final String initialValue;

  //FIXME: currently used as workaround: to have a leading widget for the birthday-input in the signup view
  final Widget customInputWidget;

  AppointFormInput({
    Key key,
    this.controller,
    @required this.hintText,
    @required this.errorText,
    @required this.onFieldSubmitted,
    this.leadingWidget,
    this.showSuffixIcon = true,
    this.obscureText = false,
    @required this.focusNode,
    this.showLeadingWidget = true,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.customInputWidget,
    this.validator,
    this.action,
    this.onSaved,
  }) : super(key: key);

  @override
  _AppointFormInputState createState() => _AppointFormInputState();
}

class _AppointFormInputState extends State<AppointFormInput> {
  TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: <Widget>[
            if (widget.showLeadingWidget) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.leadingWidget != null
                    ? widget.leadingWidget
                    : Icon(CupertinoIcons.person),
              )
            ],
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: widget.customInputWidget != null
                    ? widget.customInputWidget
                    : TextFormField(
                        onSaved: widget.onSaved != null
                            ? (value) => widget.onSaved(value)
                            : (_) {},
                        keyboardType: widget.keyboardType,
                        focusNode: widget.focusNode,
                        obscureText: widget.obscureText,
                        textInputAction: widget.action != null
                            ? widget.action
                            : TextInputAction.next,
                        onFieldSubmitted: (value) =>
                            widget.onFieldSubmitted(value),
                        validator: widget.validator == null
                            ? (value) {
                                if (value.isEmpty) {
                                  return widget.errorText;
                                }
                                return null;
                              }
                            : (value) => widget.validator(value),
                        style: TextStyle(fontSize: 18),
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          suffixIcon: widget.showSuffixIcon
                              ? IconButton(
                                  icon: Icon(
                                    CupertinoIcons.clear,
                                    size: 32,
                                  ),
                                  onPressed: () => _controller.text = "")
                              : null,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

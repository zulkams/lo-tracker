import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/constants/colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield(this.title, this.hintText, this.icon, this.controller, {this.hasSuffix = false, this.isNumber = false, this.isEmail = false, this.isPhone = false, this.isEnabled = true});
  final String hintText, title;
  final IconData icon;
  final bool hasSuffix, isNumber, isEmail, isPhone, isEnabled;
  final TextEditingController controller;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  FocusNode _focusNode = FocusNode();

  String _value = "";
  bool? _isObscure;
  bool _phoneCode = false;
  // bool _hasSuffix = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isObscure = widget.hasSuffix;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _phoneCode = true;
        });
        // Do something when the TextField gets focus
      } else {
        setState(() {
          _phoneCode = false;
        });
        // Do something when the TextField loses focus
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.lato(fontSize: 16.0),
        ),
        TextField(
          focusNode: widget.isPhone ? _focusNode : null,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
          controller: widget.controller,
          keyboardType: widget.isEmail
              ? TextInputType.emailAddress
              : widget.isNumber
                  ? TextInputType.number
                  : TextInputType.name,
          decoration: InputDecoration(
              prefixText: _phoneCode ? "+60 " : null,
              prefixIcon: Icon(
                widget.icon,
                size: 30,
                color: AppColors.secondaryColor,
              ),
              suffixIcon: widget.hasSuffix
                  ? IconButton(
                      icon: Icon(_isObscure! ? LineAwesomeIcons.eye_slash : LineAwesomeIcons.eye),
                      color: AppColors.secondaryColor,
                      onPressed: () => setState(() {
                        _isObscure = !_isObscure!;
                      }),
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.lato(fontSize: 16),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
              disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor, width: 1.5))),
          obscureText: _isObscure!,
          enabled: widget.isEnabled,
        ),
      ],
    );
  }
}

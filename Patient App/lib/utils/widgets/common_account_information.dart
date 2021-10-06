import 'package:emedic/models/user.dart';
import 'package:emedic/ui/auth/login.dart';
import 'package:flutter/material.dart';

import '../common.dart';

typedef void VoidCallback();

class CommonAccountInformation extends StatefulWidget {
  final bool signup;

  const CommonAccountInformation({Key key, this.signup = true})
      : super(key: key);

  @override
  _CommonAccountInformationState createState() =>
      _CommonAccountInformationState();
}

class _CommonAccountInformationState extends State<CommonAccountInformation> {
  User _user = User();

  DateTime _selectedDate;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _nameWithInitialController = TextEditingController();
  TextEditingController _nicController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        textFields(SignUpPageText.fullNameDescription, SignUpPageText.fullName,
            textEditingController: _fullNameController,
            onChanged: _fullNameChange,
            valid: _nameValidator(_user.fullName),
            suffixText: SignUpPageText.fullNameRequired),
        textFields(SignUpPageText.nameWithInitialsDescription,
            SignUpPageText.nameWithInitials,
            textEditingController: _nameWithInitialController,
            onChanged: _nameChange,
            valid: _nameValidator(_user.name),
            suffixText: SignUpPageText.nameWithInitialsRequired),
        textFields(
            SignUpPageText.displayNameDescription, SignUpPageText.displayName,
            textEditingController: _displayNameController,
            onChanged: _displayNameChange,
            valid: _nameValidator(_user.displayName),
            suffixText: SignUpPageText.displayName),
        textFields(SignUpPageText.emailDescription, SignUpPageText.email,
            textEditingController: _emailController,
            onChanged: _emailChange,
            valid: _emailValidator(_user.email),
            suffixText: SignUpPageText.emailRequired),
        textFields(SignUpPageText.nicDescription, SignUpPageText.nic,
            textEditingController: _nicController,
            onChanged: _nicChange,
            valid: _nicValidator(_user.nic),
            suffixText: SignUpPageText.nicRequired),
        textFields(SignUpPageText.birthdayDescription, SignUpPageText.birthday),
        SizedBox(
          height: 50,
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
            width: width * 0.85,
            child: RaisedButton(
              onPressed: () => _submit(),
              elevation: 20,
              color:
                  _canSubmit() ? Colors.white : Colors.white.withOpacity(0.5),
              child: Text(
                widget.signup ? SignUpPageText.signUpButton : "Update",
                style: theme.textTheme.headline6
                    .copyWith(color: theme.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container textFields(String hint, String text,
      {TextEditingController textEditingController,
      Function(String) onChanged,
      bool valid = true,
      String suffixText}) {
    final textTheme = Theme.of(context).textTheme;
    final padding = const EdgeInsets.all(12);
    final hintStyle = textTheme.headline6
        .copyWith(color: Colors.white, fontWeight: FontWeight.normal);
    final textStyle = textTheme.bodyText1.copyWith(color: Colors.white54);
    Icon _errorIcon = Icon(
      Icons.error,
      color: Colors.black,
    );

    InputDecoration inputDecoration = valid
        ? InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: hintStyle,
            suffixStyle: textTheme.bodyText1,
          )
        : InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: hintStyle,
            suffixIcon: _errorIcon,
            suffixText: suffixText,
            suffixStyle: textTheme.bodyText1,
          );

    if (hint.toLowerCase().contains("birthday")) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () => _selectDate(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _selectedDate == null
                    ? SignUpPageText.birthdayDescription
                    : "${_selectedDate.toLocal()}".split(' ')[0],
                style: hintStyle,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                SignUpPageText.birthday.toUpperCase(),
                style: textStyle,
              )
            ],
          ),
        ),
      );
    }
    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: textEditingController,
            decoration: inputDecoration,
            style: textTheme.headline6
                .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            cursorColor: Colors.white,
            onChanged: (value) => onChanged(value),
          ),
          Text(
            text.toUpperCase(),
            style: textStyle,
          )
        ],
      ),
    );
  }

  bool _nameValidator(String value) {
    if (value == null) return false;
    value = value.trim();
    final regex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
    bool result = true;
    if (value.isEmpty) {
      result = false;
    } else if (!regex.hasMatch(value)) {
      result = false;
    }
    return result;
  }

  bool _nicValidator(String value) {
    if (value == null) return false;
    value = value.trim();
    final regex = RegExp(r'^([0-9]{9}[x|X|v|V]|[0-9]{12})$');
    bool result = true;
    if (value.isEmpty) {
      result = false;
    } else if (!regex.hasMatch(value)) {
      result = false;
    }
    return result;
  }

  bool _emailValidator(String value) {
    if (value == null) return false;
    value = value.trim();
    final regex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    bool result = true;
    if (value.isEmpty) {
      result = false;
    } else if (!regex.hasMatch(value)) {
      result = false;
    }
    return result;
  }

  bool _canSubmit() =>
      _nameValidator(_user.fullName) &&
      _nameValidator(_user.name) &&
      _nameValidator(_user.displayName) &&
      _nicValidator(_user.nic) &&
      _emailValidator(_user.email);

  void _fullNameChange(String value) {
    setState(() {
      _user.fullName = value;
    });
  }

  void _nameChange(String value) {
    setState(() {
      _user.name = value;
    });
  }

  void _displayNameChange(String value) {
    setState(() {
      _user.displayName = value;
    });
  }

  void _emailChange(String value) {
    setState(() {
      _user.email = value;
    });
  }

  void _nicChange(String value) {
    setState(() {
      _user.nic = value;
    });

    if (value.length >= 9) {
      int days = int.parse(value.substring(2, 5));
      if (value.length == 12) {
        days = int.parse(value.substring(4, 7));
      }
      setState(() {
        _user.gender = days > 500 ? "female" : "male";
      });
    }
  }

  void _submit() {
    _user.birthday = _selectedDate;
    if (_canSubmit()) {
      if (widget.signup) {
        _user.createdAt = DateTime.now();
        pushPage(context, Login());}
    }
  }
}

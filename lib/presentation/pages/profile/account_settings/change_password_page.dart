import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _currentPasswordVisible = true;
  bool _passwordVisible = true;
  bool _passwordConfirmVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).change_password),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is ErrorUserState) {
            FlushbarHelper.createError(
              title: S.of(context).error,
              message: state.error,
              duration: Duration(seconds: 5),
            )..show(context);
          } else if (state is CompletedUserState) {
            FlushbarHelper.createSuccess(
              title: S.of(context).success,
              message: S.of(context).password_has_been_successfully_updated,
              duration: Duration(seconds: 5),
            )..show(context);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState state) {
              return FormBuilder(
                key: _fbKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "currentPassword",
                      obscureText: _currentPasswordVisible,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                        hintText: S.of(context).password,
                        filled: false,
                        border: UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_currentPasswordVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _currentPasswordVisible = !_currentPasswordVisible),
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                        FormBuilderValidators.minLength(8, errorText: S.of(context).value_must_have_a_length_greater_than_or_equal_to("8")),
                        FormBuilderValidators.maxLength(20, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("20")),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "password",
                      obscureText: _passwordVisible,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                        hintText: S.of(context).password,
                        filled: false,
                        border: UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                        FormBuilderValidators.minLength(8, errorText: S.of(context).value_must_have_a_length_greater_than_or_equal_to("8")),
                        FormBuilderValidators.maxLength(20, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("20")),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "passwordConfirm",
                      obscureText: _passwordConfirmVisible,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: S.of(context).password_confirm,
                        hintText: S.of(context).password_confirm,
                        filled: false,
                        border: UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordConfirmVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _passwordConfirmVisible = !_passwordConfirmVisible),
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                        FormBuilderValidators.minLength(8, errorText: S.of(context).value_must_have_a_length_greater_than_or_equal_to("8")),
                        FormBuilderValidators.maxLength(25, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("25")),
                        (val) => _fbKey.currentState.fields['password'].currentState.value != val ? S.of(context).passwords_do_not_match : null
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(10.0),
                        onPressed: state is LoadingUserState ? null : () => _changePassword(),
                        child: state is LoadingUserState
                            ? SizedBox(width: 15.0, height: 15.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text(S.of(context).change_password, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _changePassword() {
    if (_fbKey.currentState.saveAndValidate()) {
      BlocProvider.of<UserBloc>(context).add(ChangePassword(
        currentPassword: _fbKey.currentState.fields['currentPassword'].currentState.value,
        password: _fbKey.currentState.fields['password'].currentState.value,
        passwordConfirmation: _fbKey.currentState.fields['passwordConfirm'].currentState.value,
      ));
    }
  }
}

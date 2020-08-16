import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:base/presentation/pages/authentication/main_auth_page.dart';
import 'package:base/routes.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _passwordVisible = true;
  bool _passwordConfirmVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is ErrorUserState) {
          FlushbarHelper.createError(
            message: state.error,
            title: S.of(context).error,
            duration: Duration(seconds: 5),
          )..show(context);
        } else if (state is AuthenticatedUserState) {
          Navigator.of(context).pushReplacementNamed(Routes.mainPage);
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          return MainAuthPage(
            title: S.of(context).do_not_have_an_account,
            subTitle: S.of(context).sign_up_now,
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "username",
                    decoration: InputDecoration(
                      filled: false,
                      labelText: S.of(context).username,
                      hintText: S.of(context).username,
                      border: UnderlineInputBorder(),
                      suffixIcon: Icon(FontAwesomeIcons.solidUser, size: 20.0),
                    ),
                    validators: [
                      FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                      FormBuilderValidators.maxLength(70, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("70")),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FormBuilderTextField(
                          attribute: "firstName",
                          decoration: InputDecoration(
                            filled: false,
                            labelText: S.of(context).first_name,
                            hintText: S.of(context).first_name,
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(FontAwesomeIcons.userEdit, size: 20.0),
                          ),
                          validators: [
                            FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                            FormBuilderValidators.maxLength(70, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("70")),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: FormBuilderTextField(
                          attribute: "lastName",
                          decoration: InputDecoration(
                            filled: false,
                            labelText: S.of(context).last_name,
                            hintText: S.of(context).last_name,
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(FontAwesomeIcons.userEdit, size: 20.0),
                          ),
                          validators: [
                            FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                            FormBuilderValidators.maxLength(70, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("70")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "email",
                    decoration: InputDecoration(
                      filled: false,
                      labelText: S.of(context).email,
                      hintText: S.of(context).email,
                      border: UnderlineInputBorder(),
                      suffixIcon: Icon(FontAwesomeIcons.solidEnvelope, size: 20.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validators: [
                      FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                      FormBuilderValidators.maxLength(70, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("70")),
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
                      onPressed: state is LoadingUserState ? null : () => _signUpWithEmailAndPassword(),
                      child: state is LoadingUserState
                          ? SizedBox(width: 26.0, height: 26.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                          : Text(S.of(context).sign_up, style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.logIn),
                      child: Text(S.of(context).do_you_have_an_account + " " + S.of(context).log_in),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _signUpWithEmailAndPassword() async {
    if (_fbKey.currentState.saveAndValidate()) {
      BlocProvider.of<UserBloc>(context).add(SignUpWithEmailPassword(
        firstName: _fbKey.currentState.fields['firstName'].currentState.value,
        lastName: _fbKey.currentState.fields['lastName'].currentState.value,
        username: _fbKey.currentState.fields['username'].currentState.value,
        email: _fbKey.currentState.fields['email'].currentState.value,
        password: _fbKey.currentState.fields['password'].currentState.value,
      ));
    }
  }
}

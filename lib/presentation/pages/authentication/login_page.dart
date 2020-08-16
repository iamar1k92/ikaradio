import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:base/presentation/pages/authentication/main_auth_page.dart';
import 'package:base/routes.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _passwordVisible = true;

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
            title: S.of(context).welcome_back,
            subTitle: S.of(context).log_in_title,
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                      FormBuilderValidators.maxLength(20, errorText: S.of(context).value_must_have_a_length_less_than_or_equal_to("20")),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed(Routes.forgotPassword),
                      child: Text(S.of(context).forgot_your_password),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10.0),
                      onPressed: state is LoadingUserState ? null : () => _logInWithEmailAndPassword(),
                      child: state is LoadingUserState
                          ? SizedBox(width: 26.0, height: 26.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                          : Text(S.of(context).log_in, style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.signUp),
                      child: Text(S.of(context).do_not_have_an_account + " " + S.of(context).sign_up_now),
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

  void _logInWithEmailAndPassword() async {
    if (_fbKey.currentState.saveAndValidate()) {
      BlocProvider.of<UserBloc>(context)
          .add(LoginWithEmailPassword(email: _fbKey.currentState.fields['email'].currentState.value, password: _fbKey.currentState.fields['password'].currentState.value));
    }
  }
}

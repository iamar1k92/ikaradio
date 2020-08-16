import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:base/presentation/pages/authentication/main_auth_page.dart';
import 'package:base/routes.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return MainAuthPage(
      title: S.of(context).forgot_your_password,
      subTitle: S.of(context).reset_password,
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is ErrorUserState) {
            FlushbarHelper.createError(
              message: state.error,
              title: S.of(context).error,
              duration: Duration(seconds: 5),
            )..show(context);
          } else if (state is CompletedUserState) {
            FlushbarHelper.createSuccess(
              message: S.of(context).password_reset_link_has_been_sent,
              title: S.of(context).success,
              duration: Duration(seconds: 5),
            )..show(context);
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            return FormBuilder(
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
                      FormBuilderValidators.email(errorText: S.of(context).this_field_requires_a_valid_email_address)
                    ],
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10.0),
                      onPressed: state is LoadingUserState ? null : () => _forgotPassword(),
                      child: state is LoadingUserState
                          ? SizedBox(width: 26.0, height: 26.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                          : Text(S.of(context).reset_password, style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed(Routes.logIn),
                      child: Text(S.of(context).log_in),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _forgotPassword() async {
    if (_fbKey.currentState.saveAndValidate()) {
      BlocProvider.of<UserBloc>(context).add(ForgotMyPassword(email: _fbKey.currentState.fields['email'].currentState.value));
    }
  }
}

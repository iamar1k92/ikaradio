import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/user/bloc.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateMyInformationPage extends StatefulWidget {
  @override
  _UpdateMyInformationPageState createState() => _UpdateMyInformationPageState();
}

class _UpdateMyInformationPageState extends State<UpdateMyInformationPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).update_my_information),
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
            BlocProvider.of<UserBloc>(context).user.firstName = _fbKey.currentState.fields['firstName'].currentState.value;
            BlocProvider.of<UserBloc>(context).user.lastName = _fbKey.currentState.fields['lastName'].currentState.value;
            FlushbarHelper.createSuccess(
              title: S.of(context).success,
              message: S.of(context).your_information_has_been_successfully_updated,
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
                      attribute: "firstName",
                      initialValue: BlocProvider.of<UserBloc>(context).user.firstName,
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
                    FormBuilderTextField(
                      initialValue: BlocProvider.of<UserBloc>(context).user.lastName,
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
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(10.0),
                        onPressed: state is LoadingUserState ? null : () => _updateMyInformation(),
                        child: state is LoadingUserState
                            ? SizedBox(width: 15.0, height: 15.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text(S.of(context).update_my_information, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  _updateMyInformation() {
    if (_fbKey.currentState.saveAndValidate()) {
      BlocProvider.of<UserBloc>(context).add(UpdateMyInformation(
        firstName: _fbKey.currentState.fields['firstName'].currentState.value,
        lastName: _fbKey.currentState.fields['lastName'].currentState.value,
      ));
    }
  }
}

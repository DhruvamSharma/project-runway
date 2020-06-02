import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/keys.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';
import 'package:project_runway/features/login/presentation/manager/bloc.dart';
import 'package:project_runway/features/login/presentation/pages/user_entry_route.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

class CongratulatoryWidget extends StatefulWidget {
  @override
  _CongratulatoryWidgetState createState() => _CongratulatoryWidgetState();
}

class _CongratulatoryWidgetState extends State<CongratulatoryWidget> {
  bool isCreatingAccount = false;
  @override
  Widget build(BuildContext context) {
    final userEntryState = Provider.of<UserEntryProviderHolder>(context);
    final appState = Provider.of<ThemeModel>(context);
    return BlocProvider<LoginBloc>(
      create: (_) => sl<LoginBloc>(),
      child: Builder(
        builder: (blocContext) => BlocListener<LoginBloc, LoginBlocState>(
          listener: (_, state) {
            setState(() {
              isCreatingAccount = true;
            });

            if (state is LoadedLoginBlocState) {
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.routeName);
            }

            if (state is ErrorLoginBlocState) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Sorry, a problem occurred while creating your account",
                  style: CommonTextStyles.scaffoldTextStyle(context),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: appState.currentTheme == lightTheme
                    ? CommonColors.scaffoldColor
                    : CommonColors.accentColor,
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(
              CommonDimens.MARGIN_20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Text(
                  "Congratulations\nYou are all set up to increase your productivity",
                  style: CommonTextStyles.loginTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_60,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: OutlineButton(
                      highlightedBorderColor: CommonColors.chartColor,
                      onPressed: () {
                        if (!isCreatingAccount) {
                          setState(() {
                            isCreatingAccount = true;
                          });
                          final user = createUser(blocContext, userEntryState);
                          BlocProvider.of<LoginBloc>(blocContext)
                              .add(LoginUserEvent(user: user));
                        }
                      },
                      child: Text(
                        "Let's Begin",
                        style: CommonTextStyles.taskTextStyle(context),
                      ),
                    ),
                  ),
                ),
                if (isCreatingAccount)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_80,
                    ),
                    child: SizedBox(
                      width: 200,
                      child: Theme(
                        data: ThemeData.dark().copyWith(
                          accentColor: CommonColors.chartColor,
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: appState.currentTheme.accentColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  UserEntity createUser(
      BuildContext context, UserEntryProviderHolder userEntryState) {
    return UserEntity(
      userId: sharedPreferences.getString(USER_KEY),
      googleId: userEntryState.googleId,
      userName: userEntryState.userName,
      phoneNumber: null,
      age: userEntryState.age,
      gender: null,
      userPhotoUrl: userEntryState.userPhotoUrl,
      createdAt: userEntryState.createdDate,
      score: userEntryState.score,
      isVerified: userEntryState.isVerified,
      isDeleted: false,
      isLoggedIn: true,
      emailId: userEntryState.emailId,
    );
  }
}

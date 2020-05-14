import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/theme/theme.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/login/presentation/widgets/app_into.dart';
import 'package:project_runway/features/login/presentation/widgets/congratulation.dart';
import 'package:project_runway/features/login/presentation/widgets/user_name.dart';
import 'package:project_runway/features/login/presentation/widgets/user_sign_in.dart';
import 'package:provider/provider.dart';

class UserEntryRoute extends StatelessWidget {
  static const String routeName = "/";
  final PageController _pageController = PageController(keepPage: true);
  static const int MAX_PAGES = 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    return ChangeNotifierProvider<UserEntryProviderHolder>(
      create: (_) => UserEntryProviderHolder(),
      child: Builder(
        builder: (providerContext) => Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                    child: AppIntroWidget(),
                  ),
                  Container(
                    child: UserNameWidget(),
                  ),
                  Container(
                    child: UserSignInWidget(),
                  ),
                  Container(
                    child: CongratulatoryWidget(),
                  ),
                ],
              ),
              if (Provider.of<UserEntryProviderHolder>(providerContext)
                      .pageNumber !=
                  0)
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_40,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            buildPageNumberInReverse(providerContext),
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        mini: true,
                        child: Icon(Icons.arrow_upward, color: appState
                            .currentTheme
                            .accentColor,),
                        backgroundColor: Colors.transparent,
                      )),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CommonDimens.MARGIN_20,
                  right: CommonDimens.MARGIN_20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (Provider.of<UserEntryProviderHolder>(providerContext)
                            .pageNumber !=
                        3)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: CommonDimens.MARGIN_20,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (!Provider.of<UserEntryProviderHolder>(
                                      providerContext)
                                  .isForwardButtonDisabled) {
                                if (_pageController.page.toInt() != 1) {
                                  _pageController.animateToPage(
                                    buildPageNumber(providerContext),
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                  );
                                }

                                if (_pageController.page.toInt() == 1 &&
                                    Provider.of<UserEntryProviderHolder>(
                                                providerContext)
                                            .userName !=
                                        null &&
                                    Provider.of<UserEntryProviderHolder>(
                                            providerContext)
                                        .userName
                                        .isNotEmpty) {
                                  _pageController.animateToPage(
                                    buildPageNumber(providerContext),
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                  );
                                }

                                if (_pageController.page.toInt() == 1 &&
                                    (Provider.of<UserEntryProviderHolder>(
                                                    providerContext)
                                                .userName ==
                                            null ||
                                        Provider.of<UserEntryProviderHolder>(
                                                providerContext)
                                            .userName
                                            .isEmpty)) {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Please enter your name",
                                      style: CommonTextStyles.scaffoldTextStyle(context),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor:
                                    Provider.of<ThemeModel>(context, listen: false).currentTheme == lightTheme
                                        ? CommonColors.scaffoldColor
                                        : CommonColors.accentColor,
                                  ));
                                }
                              }
                            },
                            mini: true,
                            child: Icon(Icons.arrow_downward),
                            backgroundColor: appState
                                .currentTheme
                                .accentColor,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int buildPageNumber(BuildContext context) {
    int nextPageNumber = 0;
    double currentPageNumber = _pageController.page;
    if (currentPageNumber < MAX_PAGES - 1) {
      nextPageNumber = currentPageNumber.toInt() + 1;
    }

    if (currentPageNumber == MAX_PAGES - 1) {
//      nextPageNumber = 2;
    }
    Provider.of<UserEntryProviderHolder>(context)
        .assignPageNumber(nextPageNumber);
    return nextPageNumber;
  }

  int buildPageNumberInReverse(BuildContext context) {
    int nextPageNumber = 0;
    double currentPageNumber = _pageController.page;
    if (currentPageNumber > 0) {
      nextPageNumber = currentPageNumber.toInt() - 1;
    }

    Provider.of<UserEntryProviderHolder>(context)
        .assignPageNumber(nextPageNumber);
    return nextPageNumber;
  }
}

class UserEntryProviderHolder extends ChangeNotifier {
  String userName;
  String googleId;
  String userPhotoUrl;
  String emailId;
  String userId;
  DateTime createdDate = DateTime.now();
  bool isVerified = false;
  int pageNumber = 0;
  bool showSkipButton = true;
  bool isForwardButtonDisabled = false;
  bool isNewUser = true;
  void assignUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

  void assignPageNumber(int pageNumber) {
    this.pageNumber = pageNumber;
    notifyListeners();
  }

  void disableForwardButton(bool isDisabled) {
    isForwardButtonDisabled = isDisabled;
    notifyListeners();
  }

  void assignSkipButtonVisibility(bool showOrSkip) {
    this.showSkipButton = showOrSkip;
    notifyListeners();
  }
}

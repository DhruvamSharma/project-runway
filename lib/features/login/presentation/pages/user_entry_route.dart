import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
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
      create: (_) => UserEntryProviderHolder(controller: _pageController),
      child: Builder(
        builder: (providerContext) => Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: CommonColors.introColor.withOpacity(0.01),
              ),
              PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                pageSnapping: true,
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
                  Container(
                    child: CongratulatoryWidget(),
                  ),
                ],
              ),
              if (Provider.of<UserEntryProviderHolder>(
                    providerContext,
                  ).pageNumber !=
                  0)
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_40,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        tooltip: "Previous Step",
                        onPressed: () {
                          _pageController.animateToPage(
                            buildPageNumberInReverse(providerContext),
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        mini: true,
                        child: Icon(
                          Icons.arrow_upward,
                          color: appState.currentTheme.accentColor,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      )),
                ),
              Row(
                mainAxisAlignment: Provider.of<UserEntryProviderHolder>(
                          providerContext,
                        ).pageNumber ==
                        0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: <Widget>[
                  if (Provider.of<UserEntryProviderHolder>(
                        providerContext,
                      ).pageNumber ==
                      0)
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: CommonDimens.MARGIN_20,
                          ),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(CommonDimens.MARGIN_20))),
                            child: Tooltip(
                              message: "Start the app",
                              child: MaterialButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: CommonDimens.MARGIN_40,
                                  vertical: CommonDimens.MARGIN_20 / 2,
                                ),
                                onPressed: () {
                                  onForwardClick(providerContext);
                                },
                                child: Text(
                                  "Get Started",
                                  style: CommonTextStyles.taskTextStyle(context)
                                      .copyWith(
                                    color: appState
                                        .currentTheme.scaffoldBackgroundColor,
                                  ),
                                ),
                                color: appState.currentTheme.accentColor,
                              ),
                            ),
                          ),
                        )),
                  if (Provider.of<UserEntryProviderHolder>(
                            providerContext,
                          ).pageNumber !=
                          3 &&
                      Provider.of<UserEntryProviderHolder>(
                            providerContext,
                          ).pageNumber !=
                          0 &&
                      Provider.of<UserEntryProviderHolder>(
                            providerContext,
                          ).pageNumber !=
                          2)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: CommonDimens.MARGIN_20,
                          bottom: CommonDimens.MARGIN_20,
                        ),
                        child: FloatingActionButton(
                          tooltip: "Next Step",
                          onPressed: () {
                            onForwardClick(providerContext);
                          },
                          mini: true,
                          child: Icon(
                            Icons.arrow_downward,
                            color: CommonColors.accentColor,
                          ),
                        ),
                      ),
                    )
                ],
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
    Provider.of<UserEntryProviderHolder>(context, listen: false)
        .assignPageNumber(nextPageNumber);
    return nextPageNumber;
  }

  int buildPageNumberInReverse(BuildContext context) {
    int nextPageNumber = 0;
    double currentPageNumber = _pageController.page;
    if (currentPageNumber > 0) {
      nextPageNumber = currentPageNumber.toInt() - 1;
    }

    Provider.of<UserEntryProviderHolder>(context, listen: false)
        .assignPageNumber(nextPageNumber);
    return nextPageNumber;
  }

  void onForwardClick(BuildContext providerContext) {
    if (!Provider.of<UserEntryProviderHolder>(providerContext, listen: false)
        .isForwardButtonDisabled) {
      if (_pageController.page.toInt() != 1 &&
          _pageController.page.toInt() != 2) {
        _pageController.animateToPage(
          buildPageNumber(providerContext),
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }

      if (_pageController.page.toInt() == 2 &&
          Provider.of<UserEntryProviderHolder>(providerContext, listen: false)
                  .googleId !=
              null &&
          Provider.of<UserEntryProviderHolder>(providerContext, listen: false)
              .googleId
              .isNotEmpty) {
        _pageController.animateToPage(
          buildPageNumber(providerContext),
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
      TimeOfDay notificationTime =
          Provider.of<UserEntryProviderHolder>(providerContext, listen: false)
              .time;

      if (notificationTime != null) {
        Provider.of<UserEntryProviderHolder>(providerContext, listen: false)
            .assignNotificationTime(notificationTime);
      }

      if (_pageController.page.toInt() == 1 && notificationTime != null) {
        _pageController.animateToPage(
          buildPageNumber(providerContext),
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }

      if (_pageController.page.toInt() == 2 &&
          (Provider.of<UserEntryProviderHolder>(providerContext, listen: false)
                      .googleId ==
                  null ||
              Provider.of<UserEntryProviderHolder>(providerContext,
                      listen: false)
                  .googleId
                  .isEmpty)) {
        _scaffoldKey.currentState.showSnackBar(
          CustomSnackbar.withAnimation(
            providerContext,
            "Please login to use full suite of tools",
          ),
        );
      }

      if (_pageController.page.toInt() == 1 && (notificationTime == null)) {
        _scaffoldKey.currentState.showSnackBar(
          CustomSnackbar.withAnimation(
            providerContext,
            "Please enter the time that we should remind you",
          ),
        );
      }
    }
  }
}

class UserEntryProviderHolder extends ChangeNotifier {
  TimeOfDay time;
  String googleId;
  String userPhotoUrl;
  String emailId;
  String userId;
  double score;
  int age = 0;
  DateTime createdDate = DateTime.now();
  bool isVerified = false;
  int pageNumber = 0;
  bool showSkipButton = true;
  bool isForwardButtonDisabled = false;
  bool isNewUser = true;
  final PageController controller;

  void assignNotificationTime(TimeOfDay timeOfNotification) {
    this.time = timeOfNotification;
    notifyListeners();
  }

  UserEntryProviderHolder({@required this.controller});

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

  void animatedToNextPage() {
    print("here");
    controller.animateToPage(
      3,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    notifyListeners();
  }
}

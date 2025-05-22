import 'dart:async';
import 'package:fitness_flow/pages/food_journal/user_note_list_widget.dart';
import 'package:fitness_flow/pages/trackers/steps_tracker/steps_tracker_gps_widget.dart';
import 'package:fitness_flow/pages/work_detail/work_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';
export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(
        AppStateNotifier appStateNotifier, String initialLocation) =>
    GoRouter(
      // initialLocation: '/',
      initialLocation: initialLocation,
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: FlutterFlowTheme.of(context).primaryBackground,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : WelcomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : WelcomePageWidget(),
          routes: [
            FFRoute(
              name: 'WelcomePage',
              path: 'welcomePage',
              builder: (context, params) => WelcomePageWidget(),
            ),
            FFRoute(
              name: 'HomePage',
              path: 'homePage',
              builder: (context, params) => HomePageWidget(),
            ),
            FFRoute(
              name: 'MobileSignIn',
              path: 'mobileSignIn',
              builder: (context, params) => MobileSignInWidget(),
            ),
            FFRoute(
              name: 'VerifyMobile',
              path: 'verifyMobile',
              builder: (context, params) => VerifyMobileWidget(),
            ),
            FFRoute(
              name: 'EnterPassword',
              path: 'enterPassword',
              builder: (context, params) => EnterPasswordWidget(),
            ),
            FFRoute(
              name: 'EnableFingerprint',
              path: 'enableFingerprint',
              builder: (context, params) => EnableFingerprintWidget(),
            ),
            FFRoute(
              name: 'TurnOnNotification',
              path: 'turnOnNotification',
              builder: (context, params) => TurnOnNotificationWidget(),
            ),
            FFRoute(
              name: 'GenderSelection',
              path: 'genderSelection',
              builder: (context, params) => GenderSelectionWidget(),
            ),
            FFRoute(
              name: 'ProfilePicture',
              path: 'profilePicture',
              builder: (context, params) => ProfilePictureWidget(),
            ),
            FFRoute(
              name: 'WeightEntry',
              path: 'weightEntry',
              builder: (context, params) => WeightEntryWidget(),
            ),
            FFRoute(
              name: 'UserInterest',
              path: 'userInterest',
              builder: (context, params) => UserInterestWidget(),
            ),
            FFRoute(
              name: 'GetStarted',
              path: 'getStarted',
              builder: (context, params) => GetStartedWidget(),
            ),
            FFRoute(
              name: 'WeightTracker',
              path: 'weightTracker',
              builder: (context, params) => WeightTrackerWidget(),
            ),
            FFRoute(
              name: 'StepsTracker',
              path: 'stepsTracker',
              builder: (context, params) => StepsTrackerWidget(),
            ),
            FFRoute(
              name: 'StepsTrackerGps',
              path: 'stepsTrackerGps',
              builder: (context, params) => StepsTrackerGpsWidget(),
            ),
            FFRoute(
              name: 'FoodJournal',
              path: 'foodJournal',
              builder: (context, params) => FoodJournalWidget(),
            ),
            FFRoute(
              name: 'EventsPage',
              path: 'eventsPage',
              builder: (context, params) => EventsPageWidget(),
            ),
            FFRoute(
              name: 'EventDetails',
              path: 'eventDetails',
              builder: (context, params) => EventDetailsWidget(),
            ),
            FFRoute(
              name: 'ProfilePage',
              path: 'profilePage',
              builder: (context, params) => ProfilePageWidget(),
            ),
            FFRoute(
              name: 'WaterTracker',
              path: 'waterTracker',
              builder: (context, params) => WaterTrackerWidget(),
            ),
            FFRoute(
              name: 'CalorieTracker',
              path: 'calorieTracker',
              builder: (context, params) => CalorieTrackerWidget(),
            ),
            FFRoute(
              name: 'FoodNutrients',
              path: 'foodNutrients',
              builder: (context, params) => FoodNutrientsWidget(
                id: params.getParam('id', ParamType.int),
              ),
            ),
            FFRoute(
              name: 'Subscription',
              path: 'subscription',
              builder: (context, params) => SubscriptionWidget(),
            ),
            FFRoute(
              name: 'FormAddMeal',
              path: 'formAddMeal',
              builder: (context, params) => FormAddMealWidget(),
            ),
            FFRoute(
              name: 'FormAddWork',
              path: 'formAddWork',
              builder: (context, params) => FormAddWorkWidget(),
            ),
            FFRoute(
              name: 'WorkDetail',
              path: 'workDetail',
              builder: (context, params) => WorkDetailWidget(
                id: params.getParam('id', ParamType.int),
              ),
            ),
            FFRoute(
              name: 'ListStep',
              path: 'listStep',
              builder: (context, params) => ListStepWidget(),
            ),
            FFRoute(
              name: 'UserNoteListWidget',
              path: 'usernotelistwidget',
              builder: (context, params) => UserNoteListWidget(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

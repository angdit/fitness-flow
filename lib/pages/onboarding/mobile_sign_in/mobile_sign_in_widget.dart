import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'mobile_sign_in_model.dart';
export 'mobile_sign_in_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MobileSignInWidget extends StatefulWidget {
  const MobileSignInWidget({super.key});

  @override
  State<MobileSignInWidget> createState() => _MobileSignInWidgetState();
}

class _MobileSignInWidgetState extends State<MobileSignInWidget>
    with TickerProviderStateMixin {
  late MobileSignInModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isInputValid = true;

  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(40.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MobileSignInModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    fetchUser();
  }

  // Fungsi untuk validasi input
  bool _validateInput() {
    if (_model.textController.text.isEmpty) {
      setState(() {
        _isInputValid = false;
      });
      return false;
    }
    setState(() {
      _isInputValid = true;
    });
    return true;
  }

  dynamic futureUser = null;
  final fitnessFlowDB = FitnessFlowDB();

  void fetchUser() {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserById(1);
    });
  }

  int createOrUpdateUser(user) {
    // if (user != null) {
    // } else {
    // fitnessFlowDB.createUser(
    //     _model.textController.text, _model.textController2.text);
    fitnessFlowDB.createUserUsername(
      _model.textController.text,
    );
    fitnessFlowDB.updateUser(1, 'username', _model.textController.text);
    fitnessFlowDB.updateUser(1, 'password', _model.textController2.text);

    // data untuk makanan
    fitnessFlowDB.createMeal(
        'boiled_corn',
        100,
        96,
        1.5,
        3.2,
        19,
        'https://images.unsplash.com/photo-1634467524884-897d0af5e104?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "boiled_corn_desc",
        'staple_type_b');

    fitnessFlowDB.createMeal(
        'boiled_potato',
        100,
        87,
        0.1,
        2,
        21,
        'https://images.unsplash.com/photo-1552661397-4233881ea8c8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cG90YXRvfGVufDB8fDB8fHww',
        "boiled_potato_desc",
        'staple_type_b');

    fitnessFlowDB.createMeal(
        'white_rice',
        100,
        130,
        0.3,
        2.7,
        28,
        'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "white_rice_desc",
        'staple_type_a');

    fitnessFlowDB.createMeal(
        'grilled_chicken',
        100,
        130,
        3.6,
        31,
        0,
        'https://images.unsplash.com/photo-1630564510761-a560db92a09b?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "grilled_chicken_desc",
        'protein_type_a');
    fitnessFlowDB.createMeal(
        'fried_chicken',
        100,
        260,
        15.35,
        28.62,
        0,
        'https://images.unsplash.com/photo-1633945488458-f8cc1f3a0144?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "fried_chicken_desc",
        'protein_type_b');

    fitnessFlowDB.createMeal(
        'roast_beef',
        100,
        267,
        17.32,
        25.91,
        0,
        'https://images.unsplash.com/photo-1529694157872-4e0c0f3b238b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "roast_beef_desc",
        'protein_type_a');
    fitnessFlowDB.createMeal(
        'boiled_shrimp',
        100,
        138,
        2.26,
        26.50,
        1.19,
        'https://images.unsplash.com/photo-1599655345131-6eb73b81d8d6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "boiled_shrimp_desc",
        'protein_type_a');
    fitnessFlowDB.createMeal(
        'grilled_shrimp',
        100,
        154,
        5.03,
        24.47,
        1.17,
        'https://images.unsplash.com/photo-1514944288352-fffac99f0bdf?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "grilled_shrimp_desc",
        'protein_type_a');
    fitnessFlowDB.createMeal(
        'baked_salmon',
        100,
        183,
        10.85,
        19.9,
        0,
        'https://images.unsplash.com/photo-1611599537845-1c7aca0091c0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "baked_salmon_desc",
        'protein_type_a');

    fitnessFlowDB.createMeal(
        'fried_squid',
        100,
        125,
        2.17,
        15.3,
        9.90,
        'https://images.unsplash.com/photo-1682264895449-f75b342cbab6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "fried_squid_desc",
        'protein_type_b');

    fitnessFlowDB.createMeal(
        'boiled_squid',
        100,
        91,
        1.37,
        15.45,
        3.05,
        'https://images.unsplash.com/photo-1710508818784-d73e21e7eaa3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "boiled_squid_desc",
        'protein_type_b');

    fitnessFlowDB.createMeal(
        'chicken_sausage',
        100,
        49,
        2.83,
        5.05,
        0.43,
        'https://images.unsplash.com/photo-1672711217712-1582ab75eff1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "chicken_sausage_desc",
        'protein_type_c');

    fitnessFlowDB.createMeal(
        'brown_rice',
        100,
        110,
        0.89,
        2.56,
        22.78,
        'https://images.unsplash.com/photo-1675150303909-1bb94e33132f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "brown_rice_desc.",
        'staple_food');

    fitnessFlowDB.createMeal(
        'avocado',
        100,
        160,
        14.66,
        2.00,
        8.53,
        'https://images.unsplash.com/photo-1519162808019-7de1683fa2ad?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "avocado_desc",
        'fruit');

    fitnessFlowDB.createMeal(
        'mango',
        100,
        65,
        0.27,
        0.51,
        17.00,
        'https://images.unsplash.com/photo-1582655299221-2b6bff351df0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "mango_desc",
        'fruit');

    fitnessFlowDB.createMeal(
        'banana',
        100,
        89,
        0.33,
        1.09,
        22.84,
        'https://images.unsplash.com/photo-1523667864248-fc55f5bad7e2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "banana_desc",
        'fruit');

    fitnessFlowDB.createMeal(
        'strawberry',
        100,
        32,
        0.30,
        0.67,
        7.68,
        'https://images.unsplash.com/photo-1518933782867-2454b728cb5e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        "strawberry_desc",
        'fruit');

    // data untuk latihan
    fitnessFlowDB.createLatihan(
        'Diamond Push Up',
        10,
        'chest_type',
        'diamond_push_up_desc',
        'https://asset.kompas.com/crops/Jd9RF8s7YS1_pP0rlGI_1GkW9c0=/68x60:932x636/1200x800/data/photo/2020/06/22/5ef0a63f76763.jpg',
        'https://youtu.be/pMxR0xC74Dg?si=iD__kkp8kXRf6aBZ');
    fitnessFlowDB.createLatihan(
        'squat_jump',
        9,
        'legs_type',
        'legs_desc',
        'https://www.telkomsel.com/sites/default/files/2023-04/w2-07%20%285%29.png',
        'https://youtu.be/DmCisRo3WnY?si=9CF-MumLGaKmf69r');
    fitnessFlowDB.createLatihan(
        'Lateral Raises',
        5,
        'shoulders_type',
        'lateral_raises_desc',
        'https://hips.hearstapps.com/menshealth-uk/main/thumbs/33035/lateral-raise-to-front-raise.jpg?crop=0.672xw:1.00xh;0,0&resize=980:*',
        'https://youtu.be/EBkThfn7l9Q?si=mv87gHw0ge3sryvE');
    fitnessFlowDB.createLatihan(
        'Arm Circle',
        3,
        'shoulders_type',
        'arm_circle_desc',
        'https://steelsupplements.com/cdn/shop/articles/shutterstock_499489120_1000x.jpg?v=1641549543',
        'https://youtu.be/UVMEnIaY8aU?si=LwJo32UwqkuX5k1b');
    fitnessFlowDB.createLatihan(
        'Bench Press',
        7,
        'chest_type',
        'bench_press_desc',
        'https://www.bosshunting.com.au/wp-content/uploads/2022/09/how-to-bench-press.jpg',
        'https://youtu.be/6smdlm2yLo8?si=g7EYhp4dwQbTLG8D');

    fitnessFlowDB.createLatihan(
        'skipping_rope',
        12.2,
        'full_body_type',
        'skipping_rope_desc',
        'https://images.unsplash.com/photo-1514994667787-b48ca37155f0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=IFgQfVQT_68');

    fitnessFlowDB.createLatihan(
        'Jumping Jacks',
        9.8,
        'full_body_type',
        'jumping_jacks_desc',
        'https://images.pexels.com/photos/4853085/pexels-photo-4853085.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        'https://www.youtube.com/watch?v=nGaXj3kkmrU');
    fitnessFlowDB.createLatihan(
        'Sit up',
        9.8,
        'abs_type',
        'sit_up_desc',
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=iL06z9PWYs8&t=22s');
    fitnessFlowDB.createLatihan(
        'Squat',
        9.8,
        'legs_type',
        'squat_desc',
        'https://images.unsplash.com/photo-1536922246289-88c42f957773?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=YaXPRqUwItQ');
    fitnessFlowDB.createLatihan(
        'Spinning',
        9.8,
        'legs_type',
        'spinning_desc',
        'https://images.unsplash.com/photo-1554470166-20d3f466089b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=pt_-SdHHULE');
    fitnessFlowDB.createLatihan(
        'rowing',
        9.8,
        'full_body_type',
        'rowing_desc',
        'https://images.unsplash.com/photo-1519505907962-0a6cb0167c73?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=ZN0J6qKCIrI');
    fitnessFlowDB.createLatihan(
        'stair_climbing',
        8.6,
        'legs_type',
        'stair_climbing_desc',
        'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=Y1-uwSGuD5w');
    fitnessFlowDB.createLatihan(
        'Elliptical',
        9.8,
        'legs_type',
        'elliptical_desc',
        'https://images.unsplash.com/photo-1675026482188-8102367ecc16?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=EesEvYohy5o');
    fitnessFlowDB.createLatihan(
        'P90X',
        8.6,
        'full_body_type',
        'px_desc',
        'https://images.unsplash.com/photo-1550259979-ed79b48d2a30?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=h5qPSqJJCCk');
    fitnessFlowDB.createLatihan(
        'Muay Thai',
        8.6,
        'full_body_type',
        'muay_thai_desc',
        'https://images.unsplash.com/photo-1729673517080-44353fa68fe0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://www.youtube.com/watch?v=uFJSSYECov4');

    fetchUser();
    return 0;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 48.0,
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    LinearPercentIndicator(
                      percent: 0.16,
                      width: 120.0,
                      lineHeight: 8.0,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: Color(0xFF7165E3),
                      backgroundColor: Color(0xFFE9E9E9),
                      barRadius: Radius.circular(12.0),
                      padding: EdgeInsets.zero,
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      text: '',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0x007165E3),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Rubik',
                                  color: Color(0xFF7165E3),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.step,
                            style: GoogleFonts.getFont(
                              'Rubik',
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: '1',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: '/',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: '6',
                            style: TextStyle(),
                          )
                        ],
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(96.0, 12.0, 96.0, 0.0),
                      child: Text(
                        AppLocalizations.of(context)!.enter_name,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(84.0, 12.0, 84.0, 0.0),
                      child: Text(
                        AppLocalizations.of(context)!.please_enter_name,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              fontSize: 14.0,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          'assets/images/mobile_application.svg',
                          height: 180.0,
                          fit: BoxFit.contain,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation']!),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              48.0, 48.0, 48.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 12.0,
                                  color: Color(0x0D000000),
                                  offset: Offset(0.0, 0.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z]"))
                              ],
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.enter_name,
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Rubik',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Rubik',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        if (!_isInputValid &&
                            _model.textController.text.isEmpty)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .validation_error_enter_name,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ]),
                        FutureBuilder(
                          future: futureUser,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    72.0, 20.0, 72.0, 60.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (!_validateInput()) {
                                      return;
                                    }
                                    // Jika validasi berhasil, lanjutkan proses
                                    await createOrUpdateUser(snapshot.data);

                                    context.pushNamed(
                                      'VerifyMobile',
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                        ),
                                      },
                                    );
                                  },
                                  text: AppLocalizations.of(context)!.next,
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 54.0,
                                    padding: EdgeInsets.all(0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Rubik',
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//password
// Padding(
//   padding: EdgeInsetsDirectional.fromSTEB(
//       48.0, 10.0, 48.0, 0.0),
//   child: Container(
//     width: double.infinity,
//     height: 60.0,
//     decoration: BoxDecoration(
//       color: FlutterFlowTheme.of(context)
//           .primaryBackground,
//       boxShadow: [
//         BoxShadow(
//           blurRadius: 12.0,
//           color: Color(0x0D000000),
//           offset: Offset(0.0, 0.0),
//         )
//       ],
//       borderRadius: BorderRadius.circular(12.0),
//     ),
//     alignment: AlignmentDirectional(0.0, 0.0),
//     child: TextFormField(
//       controller: _model.textController2,
//       focusNode: _model.textFieldFocusNode2,
//       obscureText: true,
//       decoration: InputDecoration(
//         hintText: 'Masukan password',
//         hintStyle: FlutterFlowTheme.of(context)
//             .bodySmall
//             .override(
//               fontFamily: 'Rubik',
//               fontSize: 12.0,
//               fontWeight: FontWeight.normal,
//             ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0x00000000),
//             width: 1.0,
//           ),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(4.0),
//             topRight: Radius.circular(4.0),
//           ),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0x00000000),
//             width: 1.0,
//           ),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(4.0),
//             topRight: Radius.circular(4.0),
//           ),
//         ),
//         errorBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0x00000000),
//             width: 1.0,
//           ),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(4.0),
//             topRight: Radius.circular(4.0),
//           ),
//         ),
//         focusedErrorBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0x00000000),
//             width: 1.0,
//           ),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(4.0),
//             topRight: Radius.circular(4.0),
//           ),
//         ),
//         contentPadding: EdgeInsetsDirectional.fromSTEB(
//             24.0, 0.0, 24.0, 0.0),
//       ),
//       style: FlutterFlowTheme.of(context)
//           .bodyMedium
//           .override(
//             fontFamily: 'Rubik',
//             color: FlutterFlowTheme.of(context)
//                 .secondaryText,
//           ),
//       keyboardType: TextInputType.text,
//       validator: _model.textControllerValidator
//           .asValidator(context),
//     ),
//   ),
// ),

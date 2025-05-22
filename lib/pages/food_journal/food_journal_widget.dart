import 'dart:developer';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/pages/food_journal/food_journal_detail.dart';
import 'package:fitness_flow/pages/food_journal/food_journal_edit.dart';
import 'package:fitness_flow/pages/food_journal/user_note_list_widget.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'food_journal_model.dart';
export 'food_journal_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodJournalWidget extends StatefulWidget {
  const FoodJournalWidget({super.key});

  @override
  State<FoodJournalWidget> createState() => _FoodJournalWidgetState();
}

class _FoodJournalWidgetState extends State<FoodJournalWidget> {
  late FoodJournalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hariini = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateFormat = DateFormat('MMMM , yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodJournalModel());
    fetchUser();
    fetchMeals(hariini);
    jurnalHarian(hariini);
  }

  Future? futureUser;
  var futureUserSession;
  Future? futureKaloriHarian;
  Future? futureMealBreakfast;
  Future? futureMealLunch;
  Future? futureMealDinner;
  Future? futureMealSnack;

  final fitnessFlowDB = FitnessFlowDB();

  bool isNetworkImage(String imagePath) {
    final uri = Uri.tryParse(imagePath);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget displayImage(String imagePath) {
    debugPrint(
        'Gambar path: $imagePath'); // Debug log untuk melihat path gambar

    if (isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        width: 44.0,
        height: 44.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
              'Error loading network image: $error'); // Debug log untuk error URL
          return const Icon(Icons.broken_image, size: 44.0);
        },
      );
    } else if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: 44.0,
        height: 44.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
              'Error loading local file: $error'); // Debug log untuk error file
          return const Icon(Icons.broken_image, size: 44.0);
        },
      );
    } else {
      debugPrint(
          'Path tidak valid atau file tidak ditemukan'); // Debug log untuk path invalid
      return const Icon(Icons.image_not_supported, size: 44.0);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void fetchMeals(date) async {
    setState(() {
      futureMealBreakfast = fitnessFlowDB.fetchMealDaily('Breakfast', date);
      futureMealLunch = fitnessFlowDB.fetchMealDaily('Lunch', date);
      futureMealDinner = fitnessFlowDB.fetchMealDaily('Dinner', date);
      futureMealSnack = fitnessFlowDB.fetchMealDaily('Snack', date);
    });
  }

  void fetchUser() async {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserById(1);
    });
  }

  jurnalHarian(date) {
    setState(() {
      futureKaloriHarian = fitnessFlowDB.fetchKaloriHarianGroup(date);
      fetchMeals(date);
    });
  }

  deleteMealJurnal(id) {
    setState(() {
      fitnessFlowDB.deleteMealJurnal(id);
      fetchMeals(hariini);
    });
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.delete_meal.toUpperCase(),
                style: FlutterFlowTheme.of(context).titleLarge,
              ),
              content: Text(
                AppLocalizations.of(context)!.are_you_sure_delete_meal,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    AppLocalizations.of(context)!.no.toUpperCase(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    AppLocalizations.of(context)!.yes.toUpperCase(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    String dateFormat = AppLocalizations.of(context)!.date_journal;

    DateTime now = DateTime.now();

    String formattedDatee =
        DateFormat('MMMM, yyyy', Localizations.localeOf(context).toString())
            .format(now);

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 48.0, 12.0, 0.0),
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
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('CalorieTracker');
                    },
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .journal
                        .toLowerCase()
                        .split(' ')
                        .map((word) => word.isNotEmpty
                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                            : '')
                        .join(' '),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Rubik',
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 48.0,
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      // print('IconButton pressed ...');
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30.0, 12.0, 24.0, 0.0),
                child: Text(
                  "${formattedDatee}",
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Rubik',
                        color: Color(0xFFF2F2F2),
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.normal,
                      ),
                )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 7.0, 24.0, 0.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    DateTime date =
                        DateTime.now().subtract(Duration(days: 2 - index));

                    String formattedDate = DateFormat(dateFormat,
                            Localizations.localeOf(context).toString())
                        .format(date);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          jurnalHarian(formattedDate);
                          hariini = formattedDate;
                        });
                      },
                      child: Container(
                        width: 64.0,
                        decoration: BoxDecoration(
                          color: formattedDate == hariini
                              ? FlutterFlowTheme.of(context).primary
                              : Color(0x007165E3),
                          borderRadius: BorderRadius.circular(48.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat.E(Localizations.localeOf(context)
                                        .languageCode)
                                    .format(date)
                                    .toUpperCase(), // Display day of week
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Rubik',
                                      color: Color(0xFFF2F2F2),
                                      letterSpacing: 0.4,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                width: 36.0,
                                height: 36.0,
                                decoration: BoxDecoration(
                                  color: formattedDate == hariini
                                      ? FlutterFlowTheme.of(context)
                                          .secondaryBackground
                                      : Color(0x00F5F6FA),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  DateFormat.d('id')
                                      .format(date), // Display day of month
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        color: formattedDate == hariini
                                            ? FlutterFlowTheme.of(context)
                                                .secondary
                                            : Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserNoteListWidget(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 0.0, 0.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding:
                            EdgeInsets.zero, // Menghilangkan padding bawaan
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.add_circle_rounded,
                            size: 24.0,
                            color: FlutterFlowTheme.of(context).primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserNoteListWidget(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.allergy_note,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                  ),
                  child: FutureBuilder(
                      future: futureKaloriHarian,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var totalkalori = 0.0;

                          if (snap.data != null) {
                            totalkalori = (snap.data[0]['breakfast'] +
                                    snap.data[0]['lunch'] +
                                    snap.data[0]['dinner'] +
                                    snap.data[0]['snack'])
                                .toDouble();
                          }

                          log(" Data Breakfast : ${snap.data[0]['breakfast']}");

                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 24.0, 0.0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width -
                                                          100,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .breakfast_journal,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            constraints:
                                                                BoxConstraints(),
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 24.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              context.pushNamed(
                                                                  'FormAddMeal',
                                                                  queryParameters: {
                                                                    'previousPage': serializeParam(
                                                                        'FoodJournal',
                                                                        ParamType
                                                                            .String),
                                                                  });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/trending2.svg',
                                                            width: 24.0,
                                                            height: 24.0,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "${snap.data[0]['breakfast']}",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontSize:
                                                                            24.0,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          0.0,
                                                                          2.0),
                                                                  child: Text(
                                                                    'cal/${totalkalori.toStringAsFixed(1)} cal',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Rubik',
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 48.0,
                                              thickness: 1.0,
                                              color: Color(0xFFE9E9E9),
                                            ),
                                            FutureBuilder(
                                                future: futureMealBreakfast,
                                                builder: (context, snapshot) {
                                                  log("Data snapshot futureKaloriHarianJurnalB : ${snapshot.data}");
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    if (snapshot.data == null ||
                                                        snapshot.data.isEmpty) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(AppLocalizations
                                                                  .of(context)!
                                                              .no_data),
                                                        ],
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: snapshot
                                                            .data.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var itemData =
                                                              snapshot
                                                                  .data[index];
                                                          final mealName = itemData[
                                                                  'meal_nama'] ??
                                                              'Unknown';
                                                          final mealImage =
                                                              itemData[
                                                                      'meal_gambar'] ??
                                                                  '';
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailMakananPage(
                                                                          itemData:
                                                                              itemData),
                                                                ),
                                                              );
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          60.0,
                                                                      height:
                                                                          60.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: <Widget>[
                                                                          Positioned
                                                                              .fill(
                                                                            child:
                                                                                displayImage(
                                                                              mealImage, // Fungsi displayImage mengatur cara gambar ditampilkan
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              // "${itemData['nama']}",
                                                                              LocalizationHelperJournal(AppLocalizations.of(context)!).getTranslation(mealName),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Rubik',
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                              child: RichText(
                                                                                textScaler: MediaQuery.of(context).textScaler,
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: "${itemData['kalori']} Cal ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['berat']} Gram ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['fat']} " + AppLocalizations.of(context)!.fat + " ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['protein']} Protein ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['karbo']} " + AppLocalizations.of(context)!.carbs + " ",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                  ],
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Rubik',
                                                                                        fontSize: 12.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child: FlutterFlowIconButton(
                                                                          borderColor: Colors.transparent,
                                                                          borderRadius: 12.0,
                                                                          borderWidth: 1.0,
                                                                          buttonSize: 36.0,
                                                                          fillColor: Colors.transparent,
                                                                          icon: FaIcon(
                                                                            FontAwesomeIcons.edit,
                                                                            color:
                                                                                Color(0xFFBDBDBD),
                                                                            size:
                                                                                16.0,
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => FoodJournalEdit(
                                                                                  id: itemData["id"],
                                                                                  minat: itemData["minat"],
                                                                                  berat: (itemData["berat"] as num).toDouble(),
                                                                                  kalori: (itemData["kalori"] as num).toDouble(),
                                                                                  fat: (itemData["fat"] as num).toDouble(),
                                                                                  protein: (itemData["protein"] as num).toDouble(),
                                                                                  karbo: (itemData["karbo"] as num).toDouble(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          FlutterFlowIconButton(
                                                                        borderColor:
                                                                            Colors.transparent,
                                                                        borderRadius:
                                                                            12.0,
                                                                        borderWidth:
                                                                            1.0,
                                                                        buttonSize:
                                                                            36.0,
                                                                        fillColor:
                                                                            Colors.transparent,
                                                                        icon:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .trashAlt,
                                                                          color:
                                                                              Color(0xFFBDBDBD),
                                                                          size:
                                                                              16.0,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          final confirmDelete =
                                                                              await showDeleteConfirmationDialog(context);
                                                                          if (!confirmDelete)
                                                                            return;

                                                                          deleteMealJurnal(
                                                                              itemData['kalori_user_id']);
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            /// need to set following properties for best effect of awesome_snackbar_content
                                                                            elevation:
                                                                                0,
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            content:
                                                                                AwesomeSnackbarContent(
                                                                              title: AppLocalizations.of(context)!.success + '!',
                                                                              message: AppLocalizations.of(context)!.daily_calories_successfully_deleted,

                                                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                              contentType: ContentType.success,
                                                                            ),
                                                                          );

                                                                          ScaffoldMessenger.of(
                                                                              context)
                                                                            ..hideCurrentSnackBar()
                                                                            ..showSnackBar(snackBar);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  height: 48.0,
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFE9E9E9),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 24.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width -
                                                          100,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .lunch
                                                                .toUpperCase(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            constraints:
                                                                BoxConstraints(),
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 24.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              context.pushNamed(
                                                                  'FormAddMeal',
                                                                  queryParameters: {
                                                                    'previousPage': serializeParam(
                                                                        'FoodJournal',
                                                                        ParamType
                                                                            .String),
                                                                  });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/trending2.svg',
                                                            width: 24.0,
                                                            height: 24.0,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "${snap.data[0]['lunch']}",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontSize:
                                                                            24.0,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          0.0,
                                                                          2.0),
                                                                  child: Text(
                                                                    'cal/${totalkalori.toStringAsFixed(1)} cal',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Rubik',
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 48.0,
                                              thickness: 1.0,
                                              color: Color(0xFFE9E9E9),
                                            ),
                                            FutureBuilder(
                                                future: futureMealLunch,
                                                builder: (context, snapshot) {
                                                  log("Snapshot data lunch : ${snapshot.data}");
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    if
                                                        // (snapshot.data.length ==
                                                        //     0)
                                                        (snapshot.data ==
                                                                null ||
                                                            snapshot
                                                                .data.isEmpty) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(AppLocalizations
                                                                  .of(context)!
                                                              .no_data)
                                                        ],
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: snapshot
                                                            .data.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var itemData =
                                                              snapshot
                                                                  .data[index];
                                                          final mealName = itemData[
                                                                  'meal_nama'] ??
                                                              'Unknown';
                                                          final mealImage =
                                                              itemData[
                                                                      'meal_gambar'] ??
                                                                  '';
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailMakananPage(
                                                                          itemData:
                                                                              itemData),
                                                                ),
                                                              );
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          60.0,
                                                                      height:
                                                                          60.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        // image:
                                                                        //     DecorationImage(
                                                                        //   fit: BoxFit
                                                                        //       .cover,
                                                                        //   image:
                                                                        //       Image.network(
                                                                        //     itemData['gambar'],
                                                                        //   ).image,
                                                                        // ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: <Widget>[
                                                                          Positioned
                                                                              .fill(
                                                                            child:
                                                                                //     displayImage(
                                                                                //   itemData['meal_gambar'], // Fungsi displayImage mengatur cara gambar ditampilkan
                                                                                // ),
                                                                                displayImage(
                                                                              mealImage, // Fungsi displayImage mengatur cara gambar ditampilkan
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              // "${itemData['meal_nama']}",
                                                                              LocalizationHelperJournal(AppLocalizations.of(context)!).getTranslation(mealName),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Rubik',
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                              child: RichText(
                                                                                textScaler: MediaQuery.of(context).textScaler,
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: "${itemData['kalori']} Cal ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['berat']} Gram ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['fat']} " + AppLocalizations.of(context)!.fat + " ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['protein']} Protein ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['karbo']} " + AppLocalizations.of(context)!.carbs + " ",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                  ],
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Rubik',
                                                                                        fontSize: 12.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child: FlutterFlowIconButton(
                                                                          borderColor: Colors.transparent,
                                                                          borderRadius: 12.0,
                                                                          borderWidth: 1.0,
                                                                          buttonSize: 36.0,
                                                                          fillColor: Colors.transparent,
                                                                          icon: FaIcon(
                                                                            FontAwesomeIcons.edit,
                                                                            color:
                                                                                Color(0xFFBDBDBD),
                                                                            size:
                                                                                16.0,
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => FoodJournalEdit(
                                                                                  id: itemData["id"],
                                                                                  minat: itemData["minat"],
                                                                                  berat: (itemData["berat"] as num).toDouble(),
                                                                                  kalori: (itemData["kalori"] as num).toDouble(),
                                                                                  fat: (itemData["fat"] as num).toDouble(),
                                                                                  protein: (itemData["protein"] as num).toDouble(),
                                                                                  karbo: (itemData["karbo"] as num).toDouble(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          FlutterFlowIconButton(
                                                                        borderColor:
                                                                            Colors.transparent,
                                                                        borderRadius:
                                                                            12.0,
                                                                        borderWidth:
                                                                            1.0,
                                                                        buttonSize:
                                                                            36.0,
                                                                        fillColor:
                                                                            Colors.transparent,
                                                                        icon:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .trashAlt,
                                                                          color:
                                                                              Color(0xFFBDBDBD),
                                                                          size:
                                                                              16.0,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          final confirmDelete =
                                                                              await showDeleteConfirmationDialog(context);
                                                                          if (!confirmDelete)
                                                                            return;
                                                                          deleteMealJurnal(
                                                                              itemData['kalori_user_id']);
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            /// need to set following properties for best effect of awesome_snackbar_content
                                                                            elevation:
                                                                                0,
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            content:
                                                                                AwesomeSnackbarContent(
                                                                              title: AppLocalizations.of(context)!.success + '!',
                                                                              message: AppLocalizations.of(context)!.daily_calories_successfully_deleted,

                                                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                              contentType: ContentType.success,
                                                                            ),
                                                                          );

                                                                          ScaffoldMessenger.of(
                                                                              context)
                                                                            ..hideCurrentSnackBar()
                                                                            ..showSnackBar(snackBar);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  height: 48.0,
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFE9E9E9),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 24.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width -
                                                          100,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .dinner_journal,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            constraints:
                                                                BoxConstraints(),
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 24.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              context.pushNamed(
                                                                  'FormAddMeal',
                                                                  queryParameters: {
                                                                    'previousPage': serializeParam(
                                                                        'FoodJournal',
                                                                        ParamType
                                                                            .String),
                                                                  });
                                                              ;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/trending2.svg',
                                                            width: 24.0,
                                                            height: 24.0,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  '${snap.data[0]['dinner']}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontSize:
                                                                            24.0,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          0.0,
                                                                          2.0),
                                                                  child: Text(
                                                                    'cal/${totalkalori.toStringAsFixed(1)} cal',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Rubik',
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 48.0,
                                              thickness: 1.0,
                                              color: Color(0xFFE9E9E9),
                                            ),
                                            FutureBuilder(
                                                future: futureMealDinner,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    if
                                                        // (snapshot.data.length ==
                                                        //     0)
                                                        (snapshot.data ==
                                                                null ||
                                                            snapshot
                                                                .data.isEmpty) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(AppLocalizations
                                                                  .of(context)!
                                                              .no_data)
                                                        ],
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: snapshot
                                                            .data.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var itemData =
                                                              snapshot
                                                                  .data[index];
                                                          final mealName = itemData[
                                                                  'meal_nama'] ??
                                                              'Unknown';
                                                          final mealImage =
                                                              itemData[
                                                                      'meal_gambar'] ??
                                                                  '';
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailMakananPage(
                                                                          itemData:
                                                                              itemData),
                                                                ),
                                                              );
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          60.0,
                                                                      height:
                                                                          60.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        // image:
                                                                        //     DecorationImage(
                                                                        //   fit: BoxFit
                                                                        //       .cover,
                                                                        //   image:
                                                                        //       Image.network(
                                                                        //     itemData['gambar'],
                                                                        //   ).image,
                                                                        // ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: <Widget>[
                                                                          Positioned
                                                                              .fill(
                                                                            child:
                                                                                displayImage(
                                                                              mealImage, // Fungsi displayImage mengatur cara gambar ditampilkan
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              // "${itemData['nama']}",
                                                                              LocalizationHelperJournal(AppLocalizations.of(context)!).getTranslation(mealName),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Rubik',
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                              child: RichText(
                                                                                textScaler: MediaQuery.of(context).textScaler,
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: "${itemData['kalori']} Cal ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['berat']} Gram ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['fat']} " + AppLocalizations.of(context)!.fat + " ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['protein']} Protein ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['karbo']} " + AppLocalizations.of(context)!.carbs + " ",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                  ],
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Rubik',
                                                                                        fontSize: 12.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child: FlutterFlowIconButton(
                                                                          borderColor: Colors.transparent,
                                                                          borderRadius: 12.0,
                                                                          borderWidth: 1.0,
                                                                          buttonSize: 36.0,
                                                                          fillColor: Colors.transparent,
                                                                          icon: FaIcon(
                                                                            FontAwesomeIcons.edit,
                                                                            color:
                                                                                Color(0xFFBDBDBD),
                                                                            size:
                                                                                16.0,
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => FoodJournalEdit(
                                                                                  id: itemData["id"],
                                                                                  minat: itemData["minat"],
                                                                                  berat: (itemData["berat"] as num).toDouble(),
                                                                                  kalori: (itemData["kalori"] as num).toDouble(),
                                                                                  fat: (itemData["fat"] as num).toDouble(),
                                                                                  protein: (itemData["protein"] as num).toDouble(),
                                                                                  karbo: (itemData["karbo"] as num).toDouble(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          FlutterFlowIconButton(
                                                                        borderColor:
                                                                            Colors.transparent,
                                                                        borderRadius:
                                                                            12.0,
                                                                        borderWidth:
                                                                            1.0,
                                                                        buttonSize:
                                                                            36.0,
                                                                        fillColor:
                                                                            Colors.transparent,
                                                                        icon:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .trashAlt,
                                                                          color:
                                                                              Color(0xFFBDBDBD),
                                                                          size:
                                                                              16.0,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          final confirmDelete =
                                                                              await showDeleteConfirmationDialog(context);
                                                                          if (!confirmDelete)
                                                                            return;
                                                                          deleteMealJurnal(
                                                                              itemData['kalori_user_id']);
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            /// need to set following properties for best effect of awesome_snackbar_content
                                                                            elevation:
                                                                                0,
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            content:
                                                                                AwesomeSnackbarContent(
                                                                              title: AppLocalizations.of(context)!.success + '!',
                                                                              message: AppLocalizations.of(context)!.daily_calories_successfully_deleted,

                                                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                              contentType: ContentType.success,
                                                                            ),
                                                                          );

                                                                          ScaffoldMessenger.of(
                                                                              context)
                                                                            ..hideCurrentSnackBar()
                                                                            ..showSnackBar(snackBar);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  height: 48.0,
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFE9E9E9),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 24.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width -
                                                          100,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .snack
                                                                .toUpperCase(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            constraints:
                                                                BoxConstraints(),
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 24.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              context.pushNamed(
                                                                  'FormAddMeal',
                                                                  queryParameters: {
                                                                    'previousPage': serializeParam(
                                                                        'FoodJournal',
                                                                        ParamType
                                                                            .String),
                                                                  });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/trending2.svg',
                                                            width: 24.0,
                                                            height: 24.0,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "${snap.data[0]['snack']}",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontSize:
                                                                            24.0,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          0.0,
                                                                          2.0),
                                                                  child: Text(
                                                                    'cal/${totalkalori.toStringAsFixed(1)} cal',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Rubik',
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 48.0,
                                              thickness: 1.0,
                                              color: Color(0xFFE9E9E9),
                                            ),
                                            FutureBuilder(
                                                future: futureMealSnack,
                                                builder: (context, snapshot) {
                                                  log("Data snapshot futureKaloriHarianJurnalB : ${snapshot.data}");
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    // if (snapshot.data.length ==
                                                    //     0) {
                                                    //   return Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .center,
                                                    //     children: [
                                                    //       Text(AppLocalizations
                                                    //               .of(context)!
                                                    //           .no_data)
                                                    //     ],
                                                    //   );
                                                    // }
                                                    if (snapshot.data == null ||
                                                        snapshot.data.isEmpty) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(AppLocalizations
                                                                  .of(context)!
                                                              .no_data),
                                                        ],
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: snapshot
                                                            .data.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var itemData =
                                                              snapshot
                                                                  .data[index];
                                                          final mealName = itemData[
                                                                  'meal_nama'] ??
                                                              'Unknown';
                                                          final mealImage =
                                                              itemData[
                                                                      'meal_gambar'] ??
                                                                  '';
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailMakananPage(
                                                                          itemData:
                                                                              itemData),
                                                                ),
                                                              );
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          60.0,
                                                                      height:
                                                                          60.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: <Widget>[
                                                                          Positioned
                                                                              .fill(
                                                                            child:
                                                                                displayImage(
                                                                              mealImage, // Fungsi displayImage mengatur cara gambar ditampilkan
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              LocalizationHelperJournal(AppLocalizations.of(context)!).getTranslation(mealName),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Rubik',
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                              child: RichText(
                                                                                textScaler: MediaQuery.of(context).textScaler,
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: "${itemData['kalori']} Cal ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['berat']} Gram ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['fat']} " + AppLocalizations.of(context)!.fat + " ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: " ${itemData['protein']} Protein ,",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: "\n${itemData['karbo']} " + AppLocalizations.of(context)!.carbs + " ",
                                                                                      style: TextStyle(),
                                                                                    ),
                                                                                  ],
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Rubik',
                                                                                        fontSize: 12.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child: FlutterFlowIconButton(
                                                                          borderColor: Colors.transparent,
                                                                          borderRadius: 12.0,
                                                                          borderWidth: 1.0,
                                                                          buttonSize: 36.0,
                                                                          fillColor: Colors.transparent,
                                                                          icon: FaIcon(
                                                                            FontAwesomeIcons.edit,
                                                                            color:
                                                                                Color(0xFFBDBDBD),
                                                                            size:
                                                                                16.0,
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => FoodJournalEdit(
                                                                                  id: itemData["id"],
                                                                                  minat: itemData["minat"],
                                                                                  berat: (itemData["berat"] as num).toDouble(),
                                                                                  kalori: (itemData["kalori"] as num).toDouble(),
                                                                                  fat: (itemData["fat"] as num).toDouble(),
                                                                                  protein: (itemData["protein"] as num).toDouble(),
                                                                                  karbo: (itemData["karbo"] as num).toDouble(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          6.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          FlutterFlowIconButton(
                                                                        borderColor:
                                                                            Colors.transparent,
                                                                        borderRadius:
                                                                            12.0,
                                                                        borderWidth:
                                                                            1.0,
                                                                        buttonSize:
                                                                            36.0,
                                                                        fillColor:
                                                                            Colors.transparent,
                                                                        icon:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .trashAlt,
                                                                          color:
                                                                              Color(0xFFBDBDBD),
                                                                          size:
                                                                              16.0,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          final confirmDelete =
                                                                              await showDeleteConfirmationDialog(context);
                                                                          if (!confirmDelete)
                                                                            return;
                                                                          deleteMealJurnal(
                                                                              itemData['kalori_user_id']);
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            /// need to set following properties for best effect of awesome_snackbar_content
                                                                            elevation:
                                                                                0,
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            content:
                                                                                AwesomeSnackbarContent(
                                                                              title: AppLocalizations.of(context)!.success + '!',
                                                                              message: AppLocalizations.of(context)!.daily_calories_successfully_deleted,

                                                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                              contentType: ContentType.success,
                                                                            ),
                                                                          );

                                                                          ScaffoldMessenger.of(
                                                                              context)
                                                                            ..hideCurrentSnackBar()
                                                                            ..showSnackBar(snackBar);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  height: 48.0,
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFE9E9E9),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension LocalizationHelperJournal on AppLocalizations {
  String getTranslation(String key) {
    switch (key) {
      case 'boiled_corn':
        return this.boiled_corn;
      case 'boiled_potato':
        return this.boiled_potato;
      case 'white_rice':
        return this.white_rice;
      case 'grilled_chicken':
        return this.grilled_chicken;
      case 'fried_chicken':
        return this.fried_chicken;
      case 'roast_beef':
        return this.roast_beef;
      case 'boiled_shrimp':
        return this.boiled_shrimp;
      case 'grilled_shrimp':
        return this.grilled_shrimp;
      case 'baked_salmon':
        return this.baked_salmon;
      case 'fried_squid':
        return this.fried_squid;
      case 'boiled_squid':
        return this.boiled_squid;
      case 'chicken_sausage':
        return this.chicken_sausage;
      case 'brown_rice':
        return this.brown_rice;
      case 'avocado':
        return this.avocado;
      case 'mango':
        return this.mango;
      case 'banana':
        return this.banana;
      case 'strawberry':
        return this.strawberry;
      default:
        return key;
    }
  }
}

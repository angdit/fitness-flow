import 'dart:developer';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_icon_button.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_theme.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_util.dart';
import 'package:fitness_flow/pages/food_journal/user_note_add_widget.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserNoteListWidget extends StatefulWidget {
  const UserNoteListWidget({super.key});

  @override
  State<UserNoteListWidget> createState() => _UserNoteListWidgetState();
}

class _UserNoteListWidgetState extends State<UserNoteListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future? futureNotes;
  final fitnessFlowDB = FitnessFlowDB();
  void fetchNotes() async {
    setState(() {
      futureNotes = fitnessFlowDB.fetchNotes();
    });
  }

  deleteNotes(id) {
    setState(() {
      fitnessFlowDB.deleteNotes(id);
      fetchNotes();
    });
  }

  bool isNetworkImage(String imagePath) {
    final uri = Uri.tryParse(imagePath);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget displayImage(String imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 44.0);
    }
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

    Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.delete_note.toUpperCase(),
              style: FlutterFlowTheme.of(context).titleLarge,
            ),
            content: Text(
              AppLocalizations.of(context)!.are_you_sure_delete_note,
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => _model.unfocusNode.canRequestFocus
      //     ? FocusScope.of(context).requestFocus(_model.unfocusNode)
      //     : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserNoteAddWidget(),
              ),
            );
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 24.0,
          ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed('FoodJournal');
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.allergy_note,
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 0.0, 0.0),
                            child: Text(
                              AppLocalizations.of(context)!.your_allergy_notes,
                              style: FlutterFlowTheme.of(context).labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  //   child: SizedBox(
                  //     height: 45,
                  //     width: double.infinity,
                  //     child: TextField(
                  //       controller: _searchController,
                  //       focusNode: _focusNode,
                  //       decoration: InputDecoration(
                  //         filled: true,
                  //         fillColor: Color(0xFFF5F6FA),
                  //         hintText:
                  //             AppLocalizations.of(context)!.search + '...',
                  //         hintStyle: FlutterFlowTheme.of(context).labelSmall,
                  //         suffixIcon: IconButton(
                  //             icon: Icon(
                  //               Icons.clear,
                  //               color: _focusNode.hasFocus
                  //                   ? Color(0xFF7165E3)
                  //                   : Colors.grey,
                  //             ),
                  //             onPressed: () {
                  //               _searchController.clear();
                  //               updateSearchQuery('');
                  //             }),
                  //         prefixIcon: IconButton(
                  //           icon: Icon(
                  //             Icons.search,
                  //             color: _focusNode.hasFocus
                  //                 ? Color(0xFF7165E3)
                  //                 : Colors.grey,
                  //           ),
                  //           onPressed: () {},
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(8.0),
                  //           borderSide: BorderSide(
                  //             color: _focusNode.hasFocus
                  //                 ? Color(0xFF7EE4F0)
                  //                 : Colors.transparent,
                  //           ),
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(8.0),
                  //           borderSide: BorderSide(
                  //             color: Color(0xFF7EE4F0),
                  //           ),
                  //         ),
                  //       ),
                  //       onChanged: updateSearchQuery,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: FutureBuilder(
                          future: futureNotes,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData) {
                              var allData = snapshot
                                  .data; // Data tetap orisinil (QueryResultSet)
                              log("${allData}");

                              // var filteredData =
                              //     (allData as Iterable).where((item). {
                              //   String translatedName =
                              //       AppLocalizations.of(context)!
                              //           .getTranslation(item['nama']);

                              //   return translatedName
                              //       .toLowerCase()
                              //       .contains(searchQuery.toLowerCase());
                              // }).toList();

                              if (allData.isEmpty) {
                                return Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.no_data),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: allData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var itemData = allData[index];
                                  // debugPrint(
                                  //     'Data gambar untuk index $index: ${itemData['gambar']}');
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 8.0),
                                    child: Container(
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          // context.pushNamed(
                                          //   'FoodNutrients',
                                          //   queryParameters: {
                                          //     'id': serializeParam(
                                          //       itemData['id'],
                                          //       ParamType.int,
                                          //     ),
                                          //   }.withoutNulls,
                                          // );
                                        },
                                        child: Row(
                                          // mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    child: displayImage(
                                                        itemData[
                                                            'meal_gambar']),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 5.0, 0.0, .0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      LocalizationHelperNote(
                                                              AppLocalizations
                                                                  .of(context)!)
                                                          .getTranslation(
                                                              itemData[
                                                                  'meal_nama']),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "Note : ${itemData['catatan'].toString()}",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                ),
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.grey),
                                              onPressed: () async {
                                                final confirmDelete = await showDeleteConfirmationDialog(context);
                                                if (!confirmDelete) return;
                                                
                                                await deleteNotes(
                                                    itemData['note_id']);
                                                // fetchNotes(); // Refresh tampilan setelah delete
                                                final snackBar = SnackBar(
                                                  /// need to set following properties for best effect of awesome_snackbar_content
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title: AppLocalizations.of(
                                                                context)!
                                                            .success +
                                                        '!',
                                                    message: AppLocalizations
                                                            .of(context)!
                                                        .note_successfully_deleted,

                                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                    contentType:
                                                        ContentType.success,
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text('Tidak Ada Data yang di Fetch'),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension LocalizationHelperNote on AppLocalizations {
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

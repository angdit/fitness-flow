import '/flutter_flow/flutter_flow_util.dart';
import 'New_Food_Form_Widget.dart' show NewFoodFormWidget;
import 'package:flutter/material.dart';

class NewFoodFormModel extends FlutterFlowModel<NewFoodFormWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textControllerNamaMakanan;
  TextEditingController? textControllerGramMakanan;
  TextEditingController? textControllerKaloriMakanan;
  TextEditingController? textControllerLemakMakanan;
  TextEditingController? textControllerProteinMakanan;
  TextEditingController? textControllerKarboMakanan;
  TextEditingController? textControllerGambarMakanan;
  TextEditingController? textControllerDeskripsiMakanan;
  TextEditingController? textControllerGolonganMakanan;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textFieldFocusNode2?.dispose();
    textControllerNamaMakanan?.dispose();
    textControllerKaloriMakanan?.dispose();
    textControllerLemakMakanan?.dispose();
    textControllerProteinMakanan?.dispose();
    textControllerKarboMakanan?.dispose();
    textControllerGambarMakanan?.dispose();
    textControllerDeskripsiMakanan?.dispose();
    textControllerGolonganMakanan?.dispose();
  }
}

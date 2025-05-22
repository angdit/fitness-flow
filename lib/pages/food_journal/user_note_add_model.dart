import '/flutter_flow/flutter_flow_util.dart';
import 'User_Note_Add_widget.dart' show UserNoteAddWidget;
import 'package:flutter/material.dart';

class UserNoteAddModel extends FlutterFlowModel<UserNoteAddWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textControllerIdMakanan;
  TextEditingController? textControllerCatatan;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textFieldFocusNode2?.dispose();
    textControllerIdMakanan?.dispose();
    textControllerCatatan?.dispose();
  }
}

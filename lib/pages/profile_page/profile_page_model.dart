import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/random_data_util.dart' as random_data;
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNodeNama;
  TextEditingController? textControllerNama;
  FocusNode? textFieldFocusNodePassword;
  TextEditingController? textControllerPassword;
  FocusNode? textFieldFocusNodeUmur;
  TextEditingController? textControllerUmur;
  FocusNode? textFieldFocusNodeBerat;
  TextEditingController? textControllerBerat;
  FocusNode? textFieldFocusNodeTinggi;
  TextEditingController? textControllerTinggi;

  TextEditingController? textControllerTinggiType;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNodeNama?.dispose();
    textControllerNama?.dispose();
    textFieldFocusNodePassword?.dispose();
    textControllerPassword?.dispose();
    textFieldFocusNodeUmur?.dispose();
    textControllerUmur?.dispose();
    textFieldFocusNodeBerat?.dispose();
    textControllerBerat?.dispose();
    textFieldFocusNodeTinggi?.dispose();
    textControllerTinggi?.dispose();
    textControllerTinggiType?.dispose();
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import 'mobile_sign_in_widget.dart' show MobileSignInWidget;
import 'package:flutter/material.dart';

class MobileSignInModel extends FlutterFlowModel<MobileSignInWidget> {
  final unfocusNode = FocusNode();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    textControllerValidator = (BuildContext context, String? value) {
      if (value == null || value.isEmpty) {
        return 'Nama tidak boleh kosong';
      }
      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        return 'Hanya huruf yang diperbolehkan';
      }
      return null;
    };
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}

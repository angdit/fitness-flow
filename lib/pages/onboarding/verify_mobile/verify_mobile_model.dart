import '/flutter_flow/flutter_flow_util.dart';
import 'verify_mobile_widget.dart' show VerifyMobileWidget;
import 'package:flutter/material.dart';

class VerifyMobileModel extends FlutterFlowModel<VerifyMobileWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    textControllerValidator = (BuildContext context, String? value) {
      if (value == null || value.isEmpty) {
        return 'form tidak boleh kosong';
      }
      if (!RegExp(r'[^0-9.]').hasMatch(value)) {
        return 'Hanya angka yang diperbolehkan';
      }
      return null;
    };
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textFieldFocusNode2?.dispose();
    textController?.dispose();
    textController2?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

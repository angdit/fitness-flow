import '/flutter_flow/flutter_flow_util.dart';
import 'work_detail_widget.dart' show WorkDetailWidget;
import 'package:flutter/material.dart';

class WorkDetailModel extends FlutterFlowModel<WorkDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldFocusNode2;
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController;
  TextEditingController? textController2;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textFieldFocusNode2?.dispose();
    textFieldFocusNode3?.dispose();
    textController?.dispose();
    textController2?.dispose();
    textController3?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

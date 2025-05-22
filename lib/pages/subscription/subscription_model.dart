import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_widget.dart' show SubscriptionWidget;
import 'package:flutter/material.dart';

class SubscriptionModel extends FlutterFlowModel<SubscriptionWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController;
  TextEditingController? textController2;
  TextEditingController? textControllerPinggang;
  TextEditingController? textControllerTangan;
  TextEditingController? textControllerPaha;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textFieldFocusNode2?.dispose();
    textController?.dispose();
    textController2?.dispose();
    textControllerPinggang?.dispose();
    textControllerTangan?.dispose();
    textControllerPaha?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

import '/flutter_flow/flutter_flow_util.dart';
import 'food_nutrients_widget.dart' show FoodNutrientsWidget;
import 'package:flutter/material.dart';

class FoodNutrientsModel extends FlutterFlowModel<FoodNutrientsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

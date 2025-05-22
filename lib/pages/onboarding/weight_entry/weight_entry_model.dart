import '/flutter_flow/flutter_flow_util.dart';
import 'weight_entry_widget.dart' show WeightEntryWidget;
import 'package:flutter/material.dart';

class WeightEntryModel extends FlutterFlowModel<WeightEntryWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

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
    textController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

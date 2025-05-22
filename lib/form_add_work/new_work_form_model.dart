import '/flutter_flow/flutter_flow_util.dart';
import 'New_wORK_Form_Widget.dart' show NewWorkFormWidget;
import 'package:flutter/material.dart';

class NewWorkFormModel extends FlutterFlowModel<NewWorkFormWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textControllerNamaLatihan;
  TextEditingController? textControllerKaloriLatihan;
  TextEditingController? textControllerTipeLatihan;
  TextEditingController? textControllerDeskripsiLatihan;
  TextEditingController? textControllerGambarLatihan;
  TextEditingController? textControllerLinkLatihan;

  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textFieldFocusNode2?.dispose();
    textControllerNamaLatihan?.dispose();
    textControllerKaloriLatihan?.dispose();
    textControllerTipeLatihan?.dispose();
    textControllerDeskripsiLatihan?.dispose();
    textControllerGambarLatihan?.dispose();
    textControllerLinkLatihan?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

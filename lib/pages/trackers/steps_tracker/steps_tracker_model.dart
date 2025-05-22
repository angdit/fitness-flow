import '/flutter_flow/flutter_flow_util.dart';
import 'steps_tracker_widget.dart' show StepsTrackerWidget;
import 'package:flutter/material.dart';

class StepsTrackerModel extends FlutterFlowModel<StepsTrackerWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

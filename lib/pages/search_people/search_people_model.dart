import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'search_people_widget.dart' show SearchPeopleWidget;
import 'package:flutter/material.dart';

class SearchPeopleModel extends FlutterFlowModel<SearchPeopleWidget> {
  // State field(s) for search TextField widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();
  }
}

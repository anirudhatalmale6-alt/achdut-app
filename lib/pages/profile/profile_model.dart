import '/flutter_flow/flutter_flow_util.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  FocusNode? displayNameFocusNode;
  TextEditingController? displayNameController;

  FocusNode? jobTitleFocusNode;
  TextEditingController? jobTitleController;

  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberController;

  FocusNode? serviceDescriptionFocusNode;
  TextEditingController? serviceDescriptionController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    displayNameFocusNode?.dispose();
    displayNameController?.dispose();
    jobTitleFocusNode?.dispose();
    jobTitleController?.dispose();
    phoneNumberFocusNode?.dispose();
    phoneNumberController?.dispose();
    serviceDescriptionFocusNode?.dispose();
    serviceDescriptionController?.dispose();
  }
}

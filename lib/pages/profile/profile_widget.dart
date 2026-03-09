import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userDoc = await UsersRecord.collection.doc(currentUserUid).get();
    if (userDoc.exists) {
      final user = UsersRecord.fromSnapshot(userDoc);
      _model.displayNameController = TextEditingController(text: user.displayName);
      _model.displayNameFocusNode = FocusNode();
      _model.jobTitleController = TextEditingController(text: user.jobTitle);
      _model.jobTitleFocusNode = FocusNode();
      _model.phoneNumberController = TextEditingController(text: user.phoneNumber);
      _model.phoneNumberFocusNode = FocusNode();
      _model.serviceDescriptionController = TextEditingController(text: user.serviceDescription);
      _model.serviceDescriptionFocusNode = FocusNode();
    } else {
      _model.displayNameController = TextEditingController();
      _model.displayNameFocusNode = FocusNode();
      _model.jobTitleController = TextEditingController();
      _model.jobTitleFocusNode = FocusNode();
      _model.phoneNumberController = TextEditingController();
      _model.phoneNumberFocusNode = FocusNode();
      _model.serviceDescriptionController = TextEditingController();
      _model.serviceDescriptionFocusNode = FocusNode();
    }
    safeSetState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    safeSetState(() => _isSaving = true);
    try {
      await UsersRecord.collection.doc(currentUserUid).update(
        createUsersRecordData(
          displayName: _model.displayNameController!.text,
          jobTitle: _model.jobTitleController!.text,
          phoneNumber: _model.phoneNumberController!.text,
          serviceDescription: _model.serviceDescriptionController!.text,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile')),
        );
      }
    }
    safeSetState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildField(String label, IconData icon, TextEditingController? controller,
      FocusNode? focusNode, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FlutterFlowTheme.of(context).labelLarge.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        )),
        SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            prefixIcon: Icon(icon, color: FlutterFlowTheme.of(context).secondaryText, size: 20.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 15.0,
            letterSpacing: 0.0,
          ),
          cursorColor: FlutterFlowTheme.of(context).primary,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 20.0,
            buttonSize: 40.0,
            icon: Icon(Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primaryText, size: 24.0),
            onPressed: () => context.safePop(),
          ),
          title: Text('My Profile', style: FlutterFlowTheme.of(context).headlineSmall.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
          )),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary)))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            AuthUserStreamWidget(
                              builder: (context) => Container(
                                width: 80.0, height: 80.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                child: currentUserPhoto.isNotEmpty
                                    ? Image.network(currentUserPhoto, fit: BoxFit.cover)
                                    : Icon(Icons.person, color: FlutterFlowTheme.of(context).secondaryText, size: 40.0),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(currentUserEmail, style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0),
                      _buildField('Full Name', Icons.person_outline_rounded,
                          _model.displayNameController, _model.displayNameFocusNode),
                      SizedBox(height: 16.0),
                      _buildField('Job Title', Icons.work_outline_rounded,
                          _model.jobTitleController, _model.jobTitleFocusNode),
                      SizedBox(height: 16.0),
                      _buildField('Phone Number', Icons.phone_outlined,
                          _model.phoneNumberController, _model.phoneNumberFocusNode,
                          keyboardType: TextInputType.phone),
                      SizedBox(height: 16.0),
                      _buildField('Service Description', Icons.description_outlined,
                          _model.serviceDescriptionController, _model.serviceDescriptionFocusNode,
                          maxLines: 3),
                      SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        height: 52.0,
                        child: FFButtonWidget(
                          onPressed: _isSaving ? null : () => _saveProfile(),
                          text: _isSaving ? 'Saving...' : 'Save Profile',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 52.0,
                            padding: EdgeInsets.all(8.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 0.0,
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

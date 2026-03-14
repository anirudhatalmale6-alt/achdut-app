import 'dart:io';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'create_post_page_model.dart';
export 'create_post_page_model.dart';

/// CreatePostPage
class CreatePostPageWidget extends StatefulWidget {
  const CreatePostPageWidget({super.key});

  static String routeName = 'CreatePostPage';
  static String routePath = '/createPostPage';

  @override
  State<CreatePostPageWidget> createState() => _CreatePostPageWidgetState();
}

class _CreatePostPageWidgetState extends State<CreatePostPageWidget> {
  late CreatePostPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  File? _selectedImage;
  File? _selectedVideo;
  bool _isPosting = false;
  bool _showEmojiPicker = false;
  String _visibility = 'everyone'; // 'everyone' or 'connections'
  String _linkUrl = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatePostPageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      safeSetState(() {
        _selectedImage = File(pickedFile.path);
        _selectedVideo = null;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(minutes: 2),
    );
    if (pickedFile != null) {
      safeSetState(() {
        _selectedVideo = File(pickedFile.path);
        _selectedImage = null;
      });
    }
  }

  void _showLinkDialog() {
    final linkController = TextEditingController(text: _linkUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Link'),
        content: TextField(
          controller: linkController,
          decoration: InputDecoration(
            hintText: 'https://example.com',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              safeSetState(() => _linkUrl = linkController.text.trim());
              Navigator.pop(ctx);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<String?> _uploadFile(File file, String folder, String ext) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child(currentUserUid)
        .child('${folder}_$timestamp.$ext');
    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  }

  Future<void> _createPost() async {
    if (_model.textController.text.trim().isEmpty &&
        _selectedImage == null &&
        _selectedVideo == null) {
      return;
    }
    safeSetState(() => _isPosting = true);
    try {
      String? imageUrl;
      String? videoUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadFile(_selectedImage!, 'posts', 'jpg');
      }
      if (_selectedVideo != null) {
        videoUrl = await _uploadFile(_selectedVideo!, 'videos', 'mp4');
      }
      await PostsRecord.collection.doc().set({
        ...createPostsRecordData(
          createdTime: getCurrentTimestamp,
          createBy: currentUserDisplayName.isNotEmpty
              ? currentUserDisplayName
              : currentUserEmail,
          content: _model.textController.text,
          creatorUid: currentUserUid,
          creatorPhoto: currentUserPhoto,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          visibility: _visibility,
          linkUrl: _linkUrl.isNotEmpty ? _linkUrl : null,
          likes: 0,
        ),
        'liked_by': [],
        'saved_by': [],
      });
      if (mounted) context.safePop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    }
    safeSetState(() => _isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
        safeSetState(() => _showEmojiPicker = false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 22.0,
            borderWidth: 0.0,
            buttonSize: 44.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Create Post',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
              child: FFButtonWidget(
                onPressed: _isPosting ? null : () => _createPost(),
                text: _isPosting ? 'Posting...' : 'Post',
                options: FFButtonOptions(
                  height: 36.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Divider(height: 1.0, thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthUserStreamWidget(
                              builder: (context) => Container(
                                width: 48.0, height: 48.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  shape: BoxShape.circle,
                                ),
                                child: currentUserPhoto.isNotEmpty
                                    ? ClipOval(child: Image.network(currentUserPhoto,
                                        fit: BoxFit.cover, width: 48.0, height: 48.0))
                                    : Icon(Icons.person,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 28.0),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AuthUserStreamWidget(
                                      builder: (context) => Text(
                                        currentUserDisplayName.isNotEmpty
                                            ? currentUserDisplayName
                                            : currentUserEmail,
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                              letterSpacing: 0.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Visibility selector
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          safeSetState(() {
                                            _visibility = _visibility == 'everyone'
                                                ? 'connections'
                                                : 'everyone';
                                          });
                                        },
                                        child: Container(
                                          height: 28.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).accent1,
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  _visibility == 'everyone'
                                                      ? Icons.public_rounded
                                                      : Icons.people_rounded,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  size: 14.0,
                                                ),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  _visibility == 'everyone'
                                                      ? 'Everyone'
                                                      : 'Connections',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w600),
                                                ),
                                                SizedBox(width: 4.0),
                                                Icon(Icons.keyboard_arrow_down_rounded,
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    size: 14.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'What\'s on your mind?',
                            hintStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                  font: GoogleFonts.inter(fontWeight: FontWeight.normal),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 16.0, letterSpacing: 0.0, fontWeight: FontWeight.normal),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.normal),
                                fontSize: 16.0, letterSpacing: 0.0, fontWeight: FontWeight.normal),
                          maxLines: 8,
                          minLines: 4,
                          keyboardType: TextInputType.multiline,
                          validator: _model.textControllerValidator.asValidator(context),
                        ),
                      ),
                      // Selected image preview
                      if (_selectedImage != null)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.file(_selectedImage!,
                                    width: double.infinity, height: 220.0, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 8.0, right: 8.0,
                                child: GestureDetector(
                                  onTap: () => safeSetState(() => _selectedImage = null),
                                  child: Container(
                                    width: 32.0, height: 32.0,
                                    decoration: BoxDecoration(color: Color(0xCC000000), shape: BoxShape.circle),
                                    child: Icon(Icons.close_rounded, color: Colors.white, size: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Selected video preview
                      if (_selectedVideo != null)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 160.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.videocam_rounded,
                                          color: FlutterFlowTheme.of(context).primary, size: 48.0),
                                      SizedBox(height: 8.0),
                                      Text('Video selected',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.inter(),
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                letterSpacing: 0.0)),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8.0, right: 8.0,
                                child: GestureDetector(
                                  onTap: () => safeSetState(() => _selectedVideo = null),
                                  child: Container(
                                    width: 32.0, height: 32.0,
                                    decoration: BoxDecoration(color: Color(0xCC000000), shape: BoxShape.circle),
                                    child: Icon(Icons.close_rounded, color: Colors.white, size: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Link preview
                      if (_linkUrl.isNotEmpty)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: FlutterFlowTheme.of(context).primary.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.link_rounded,
                                    color: FlutterFlowTheme.of(context).primary, size: 20.0),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(_linkUrl,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            font: GoogleFonts.inter(),
                                            color: FlutterFlowTheme.of(context).primary,
                                            letterSpacing: 0.0)),
                                ),
                                GestureDetector(
                                  onTap: () => safeSetState(() => _linkUrl = ''),
                                  child: Icon(Icons.close_rounded,
                                      color: FlutterFlowTheme.of(context).secondaryText, size: 18.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Emoji picker
              if (_showEmojiPicker)
                SizedBox(
                  height: 250.0,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _model.textController!.text += emoji.emoji;
                      _model.textController!.selection = TextSelection.fromPosition(
                        TextPosition(offset: _model.textController!.text.length),
                      );
                    },
                    config: Config(
                      height: 250.0,
                      emojiViewConfig: EmojiViewConfig(
                        columns: 7,
                        emojiSizeMax: 28.0,
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      categoryViewConfig: CategoryViewConfig(
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        iconColorSelected: FlutterFlowTheme.of(context).primary,
                      ),
                      searchViewConfig: SearchViewConfig(
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                  ),
                ),
              Divider(height: 1.0, thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate),
              // Bottom toolbar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Row(
                  children: [
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 22.0,
                      buttonSize: 44.0,
                      fillColor: FlutterFlowTheme.of(context).accent1,
                      icon: Icon(Icons.image_outlined,
                          color: FlutterFlowTheme.of(context).primary, size: 22.0),
                      onPressed: _pickImage,
                    ),
                    SizedBox(width: 4.0),
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 22.0,
                      buttonSize: 44.0,
                      fillColor: _selectedVideo != null
                          ? FlutterFlowTheme.of(context).primary.withOpacity(0.2)
                          : FlutterFlowTheme.of(context).accent1,
                      icon: Icon(Icons.videocam_outlined,
                          color: FlutterFlowTheme.of(context).primary, size: 22.0),
                      onPressed: _pickVideo,
                    ),
                    SizedBox(width: 4.0),
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 22.0,
                      buttonSize: 44.0,
                      fillColor: _showEmojiPicker
                          ? FlutterFlowTheme.of(context).primary.withOpacity(0.2)
                          : FlutterFlowTheme.of(context).accent1,
                      icon: Icon(Icons.tag_faces_rounded,
                          color: FlutterFlowTheme.of(context).primary, size: 22.0),
                      onPressed: () {
                        safeSetState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                          if (_showEmojiPicker) {
                            FocusScope.of(context).unfocus();
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4.0),
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 22.0,
                      buttonSize: 44.0,
                      fillColor: _linkUrl.isNotEmpty
                          ? FlutterFlowTheme.of(context).primary.withOpacity(0.2)
                          : FlutterFlowTheme.of(context).accent1,
                      icon: Icon(Icons.link_rounded,
                          color: FlutterFlowTheme.of(context).primary, size: 22.0),
                      onPressed: _showLinkDialog,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

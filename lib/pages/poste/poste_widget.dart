import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_handler.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'poste_model.dart';
export 'poste_model.dart';

/// HomePage ( feed )
class PosteWidget extends StatefulWidget {
  const PosteWidget({super.key});

  static String routeName = 'Poste';
  static String routePath = '/poste';

  @override
  State<PosteWidget> createState() => _PosteWidgetState();
}

class _PosteWidgetState extends State<PosteWidget> {
  late PosteModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PosteModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _toggleLike(PostsRecord post) async {
    final uid = currentUserUid;
    final likedBy = List<String>.from(post.likedBy);
    final isLiked = likedBy.contains(uid);

    if (isLiked) {
      likedBy.remove(uid);
    } else {
      likedBy.add(uid);
    }

    await post.reference.update({
      'liked_by': likedBy,
      'likes': likedBy.length,
    });
  }

  void _sharePost(PostsRecord post) {
    final text = post.content.isNotEmpty ? post.content : post.title;
    if (text.isNotEmpty) {
      Share.share('${post.createBy}: $text\n\n— Shared from ACHDUT');
    }
  }

  void _showComments(BuildContext context, PostsRecord post) {
    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                // Handle bar
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 40.0, height: 4.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(ctx).alternate,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text('Comments',
                      style: FlutterFlowTheme.of(ctx).titleMedium.override(
                            font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                            letterSpacing: 0.0, fontWeight: FontWeight.w600)),
                ),
                Divider(height: 1.0, thickness: 1.0,
                    color: FlutterFlowTheme.of(ctx).alternate),
                // Comments list
                Expanded(
                  child: StreamBuilder<List<CommentsRecord>>(
                    stream: queryCommentsRecord(
                      queryBuilder: (q) => q
                          .where('post_id', isEqualTo: post.reference.id)
                          .orderBy('created_time', descending: false),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(ctx).primary)));
                      }
                      final comments = snapshot.data!;
                      if (comments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded,
                                  color: FlutterFlowTheme.of(ctx).secondaryText,
                                  size: 48.0),
                              SizedBox(height: 8.0),
                              Text('No comments yet',
                                  style: FlutterFlowTheme.of(ctx).bodyMedium.override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(ctx).secondaryText,
                                        letterSpacing: 0.0)),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: comments.length,
                        itemBuilder: (_, i) {
                          final comment = comments[i];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32.0, height: 32.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: FlutterFlowTheme.of(ctx).alternate,
                                  ),
                                  child: comment.userPhoto.isNotEmpty
                                      ? Image.network(comment.userPhoto, fit: BoxFit.cover)
                                      : Icon(Icons.person,
                                          color: FlutterFlowTheme.of(ctx).secondaryText,
                                          size: 18.0),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(comment.userName,
                                              style: FlutterFlowTheme.of(ctx).bodySmall.override(
                                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600)),
                                          SizedBox(width: 8.0),
                                          if (comment.createdTime != null)
                                            Text(timeago.format(comment.createdTime!),
                                                style: FlutterFlowTheme.of(ctx).labelSmall.override(
                                                      font: GoogleFonts.inter(),
                                                      color: FlutterFlowTheme.of(ctx).secondaryText,
                                                      letterSpacing: 0.0)),
                                        ],
                                      ),
                                      SizedBox(height: 2.0),
                                      Text(comment.text,
                                          style: FlutterFlowTheme.of(ctx).bodyMedium.override(
                                                font: GoogleFonts.inter(),
                                                letterSpacing: 0.0)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Comment input
                Divider(height: 1.0, thickness: 1.0,
                    color: FlutterFlowTheme.of(ctx).alternate),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0,
                      MediaQuery.of(ctx).viewInsets.bottom + 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            hintStyle: FlutterFlowTheme.of(ctx).bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(ctx).secondaryText,
                                  letterSpacing: 0.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(ctx).alternate),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(ctx).alternate),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(ctx).primary),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(ctx).primaryBackground,
                          ),
                          style: FlutterFlowTheme.of(ctx).bodyMedium.override(
                                font: GoogleFonts.inter(), letterSpacing: 0.0),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      IconButton(
                        icon: Icon(Icons.send_rounded,
                            color: FlutterFlowTheme.of(ctx).primary, size: 24.0),
                        onPressed: () async {
                          final text = commentController.text.trim();
                          if (text.isEmpty) return;
                          await CommentsRecord.collection.doc().set(
                            createCommentsRecordData(
                              postId: post.reference.id,
                              userUid: currentUserUid,
                              userName: currentUserDisplayName.isNotEmpty
                                  ? currentUserDisplayName
                                  : currentUserEmail,
                              userPhoto: currentUserPhoto,
                              text: text,
                              createdTime: getCurrentTimestamp,
                            ),
                          );
                          commentController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
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
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed(CreatePostPageWidget.routeName);
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_rounded,
            color: FlutterFlowTheme.of(context).info,
            size: 28.0,
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AuthUserStreamWidget(
                    builder: (context) => Container(
                      width: 40.0,
                      height: 40.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      child: currentUserPhoto.isNotEmpty
                          ? Image.network(
                              currentUserPhoto,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                      ),
                      AuthUserStreamWidget(
                        builder: (context) => Text(
                          currentUserDisplayName.isNotEmpty
                              ? currentUserDisplayName
                              : currentUserEmail,
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    fillColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.search_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 22.0,
                    ),
                    onPressed: () {
                      context.pushNamed(SearchPeopleWidget.routeName);
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    fillColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.logout_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 22.0,
                    ),
                    onPressed: () async {
                      await PushNotificationsHandler().removeToken();
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();

                      context.goNamedAuth(
                          LoginPageWidget.routeName, context.mounted);
                    },
                  ),
                ].divide(SizedBox(width: 4.0)),
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 12.0, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12.0),
          onTap: (index) {
            if (index == 1) {
              context.pushNamed(SearchPeopleWidget.routeName);
            } else if (index == 2) {
              context.pushNamed(ConnectionsWidget.routeName);
            } else if (index == 3) {
              context.pushNamed(ProfileWidget.routeName);
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Connections'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            Expanded(
              child: StreamBuilder<List<PostsRecord>>(
                stream: queryPostsRecord(
                  queryBuilder: (postsRecord) =>
                      postsRecord.orderBy('created_time', descending: true),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<PostsRecord> listViewPostsRecordList = snapshot.data!;

                  if (listViewPostsRecordList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 72.0,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'No posts yet',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Tap + to create the first post!',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(0, 12.0, 0, 80.0),
                    scrollDirection: Axis.vertical,
                    itemCount: listViewPostsRecordList.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                    itemBuilder: (context, listViewIndex) {
                      final post = listViewPostsRecordList[listViewIndex];
                      final isLiked = post.likedBy.contains(currentUserUid);

                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 16.0, 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .alternate,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.person,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 22.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.createBy.isNotEmpty
                                            ? post.createBy
                                            : 'Anonymous',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (post.createdTime != null)
                                        Text(
                                          timeago.format(post.createdTime!),
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (post.content.isNotEmpty)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  post.content,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            // Post image
                            if (post.imageUrl.isNotEmpty)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    post.imageUrl,
                                    width: double.infinity,
                                    height: 220.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (post.title.isNotEmpty)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 6.0, 0.0, 0.0),
                                child: Text(
                                  post.title,
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            // Action buttons
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Like button
                                  GestureDetector(
                                    onTap: () => _toggleLike(post),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isLiked
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          color: isLiked
                                              ? Colors.red
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          size: 20.0,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          '${post.likes}',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color: isLiked
                                                    ? Colors.red
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  // Comment button
                                  GestureDetector(
                                    onTap: () => _showComments(context, post),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 20.0,
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  // Share button
                                  GestureDetector(
                                    onTap: () => _sharePost(post),
                                    child: Icon(
                                      Icons.share_outlined,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

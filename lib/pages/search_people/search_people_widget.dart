import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search_people_model.dart';
export 'search_people_model.dart';

/// Search People by Job Title
class SearchPeopleWidget extends StatefulWidget {
  const SearchPeopleWidget({super.key});

  static String routeName = 'SearchPeople';
  static String routePath = '/searchPeople';

  @override
  State<SearchPeopleWidget> createState() => _SearchPeopleWidgetState();
}

class _SearchPeopleWidgetState extends State<SearchPeopleWidget> {
  late SearchPeopleModel _model;
  List<UsersRecord> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  // Connection state
  Set<String> _connectedUids = {};
  Set<String> _pendingSentUids = {};
  Set<String> _pendingReceivedUids = {};

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchPeopleModel());
    _model.searchTextController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
    _loadConnectionStatus();
  }

  Future<void> _loadConnectionStatus() async {
    final myUid = currentUserUid;
    final allConnections = await queryConnectionsRecordOnce();

    final connected = <String>{};
    final pendingSent = <String>{};
    final pendingReceived = <String>{};

    for (final c in allConnections) {
      if (c.status == 'accepted') {
        if (c.fromUid == myUid) connected.add(c.toUid);
        if (c.toUid == myUid) connected.add(c.fromUid);
      } else if (c.status == 'pending') {
        if (c.fromUid == myUid) pendingSent.add(c.toUid);
        if (c.toUid == myUid) pendingReceived.add(c.fromUid);
      }
    }

    safeSetState(() {
      _connectedUids = connected;
      _pendingSentUids = pendingSent;
      _pendingReceivedUids = pendingReceived;
    });
  }

  Future<void> _sendConnectionRequest(String toUid) async {
    await ConnectionsRecord.collection.add(createConnectionsRecordData(
      fromUid: currentUserUid,
      toUid: toUid,
      status: 'pending',
      createdTime: getCurrentTimestamp,
    ));
    safeSetState(() {
      _pendingSentUids.add(toUid);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      safeSetState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    safeSetState(() => _isSearching = true);

    try {
      final allUsers = await queryUsersRecordOnce();
      final lowerQuery = query.trim().toLowerCase();
      final myUid = currentUserUid;
      final filtered = allUsers.where((user) {
        if (user.uid == myUid) return false;
        return user.jobTitle.toLowerCase().contains(lowerQuery) ||
            user.displayName.toLowerCase().contains(lowerQuery) ||
            user.serviceDescription.toLowerCase().contains(lowerQuery);
      }).toList();

      safeSetState(() {
        _searchResults = filtered;
        _isSearching = false;
        _hasSearched = true;
      });
    } catch (e) {
      safeSetState(() {
        _isSearching = false;
        _hasSearched = true;
      });
    }
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
          title: Text('Search People',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  )),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Divider(height: 1.0, thickness: 1.0, color: FlutterFlowTheme.of(context).alternate),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
              child: TextFormField(
                controller: _model.searchTextController,
                focusNode: _model.searchFocusNode,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) => _performSearch(value),
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    safeSetState(() {
                      _searchResults = [];
                      _hasSearched = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search by job title, name, or service...',
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
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
                  contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 14.0),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText, size: 22.0),
                  suffixIcon: _model.searchTextController!.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            _model.searchTextController!.clear();
                            safeSetState(() {
                              _searchResults = [];
                              _hasSearched = false;
                            });
                          },
                          child: Icon(Icons.clear_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText, size: 20.0),
                        )
                      : null,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                    ),
                cursorColor: FlutterFlowTheme.of(context).primary,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 44.0,
                child: ElevatedButton.icon(
                  onPressed: () => _performSearch(_model.searchTextController!.text),
                  icon: Icon(Icons.search_rounded, size: 20.0),
                  label: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0.0,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
            Divider(height: 1.0, thickness: 1.0, color: FlutterFlowTheme.of(context).alternate),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isSearching) {
      return Center(
        child: SizedBox(width: 50.0, height: 50.0,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary))),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search_rounded,
                color: FlutterFlowTheme.of(context).secondaryText, size: 72.0),
            SizedBox(height: 16.0),
            Text('Find people by job title',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
              child: Text(
                'Search for professionals by their job title to connect and collaborate',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0),
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                color: FlutterFlowTheme.of(context).secondaryText, size: 72.0),
            SizedBox(height: 16.0),
            Text('No results found',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.0),
            Text('Try searching with a different job title',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 12.0, 0, 24.0),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => Divider(
          height: 1.0, thickness: 1.0, color: FlutterFlowTheme.of(context).alternate),
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final isConnected = _connectedUids.contains(user.uid);
        final isPendingSent = _pendingSentUids.contains(user.uid);
        final isPendingReceived = _pendingReceivedUids.contains(user.uid);

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50.0, height: 50.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FlutterFlowTheme.of(context).alternate),
                    child: user.photoUrl.isNotEmpty
                        ? Image.network(user.photoUrl, fit: BoxFit.cover)
                        : Icon(Icons.person,
                            color: FlutterFlowTheme.of(context).secondaryText, size: 28.0),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName.isNotEmpty ? user.displayName : user.email,
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                letterSpacing: 0.0, fontWeight: FontWeight.w600),
                        ),
                        if (user.jobTitle.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.work_outline_rounded,
                                    color: FlutterFlowTheme.of(context).secondaryText, size: 14.0),
                                SizedBox(width: 4.0),
                                Flexible(
                                  child: Text(user.jobTitle,
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            font: GoogleFonts.inter(),
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            letterSpacing: 0.0)),
                                ),
                              ],
                            ),
                          ),
                        // Show contact info only if connected
                        if (isConnected) ...[
                          if (user.email.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Row(children: [
                                Icon(Icons.email_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText, size: 14.0),
                                SizedBox(width: 4.0),
                                Flexible(
                                  child: Text(user.email,
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(),
                                            color: FlutterFlowTheme.of(context).primary,
                                            letterSpacing: 0.0)),
                                ),
                              ]),
                            ),
                          if (user.phoneNumber.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Row(children: [
                                Icon(Icons.phone_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText, size: 14.0),
                                SizedBox(width: 4.0),
                                Text(user.phoneNumber,
                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0)),
                              ]),
                            ),
                        ],
                      ],
                    ),
                  ),
                  // Connection button
                  if (isConnected)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.check_circle_rounded,
                            color: FlutterFlowTheme.of(context).primary, size: 16.0),
                        SizedBox(width: 4.0),
                        Text('Connected',
                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0, fontWeight: FontWeight.w600)),
                      ]),
                    )
                  else if (isPendingSent)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text('Pending',
                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0, fontWeight: FontWeight.w600)),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => _sendConnectionRequest(user.uid),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Text('Connect',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12.0)),
                    ),
                ],
              ),
              // Service description
              if (user.serviceDescription.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 62.0),
                  child: Text(user.serviceDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0)),
                ),
            ],
          ),
        );
      },
    );
  }
}

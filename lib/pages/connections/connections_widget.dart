import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'connections_model.dart';
export 'connections_model.dart';

class ConnectionsWidget extends StatefulWidget {
  const ConnectionsWidget({super.key});

  static String routeName = 'Connections';
  static String routePath = '/connections';

  @override
  State<ConnectionsWidget> createState() => _ConnectionsWidgetState();
}

class _ConnectionsWidgetState extends State<ConnectionsWidget>
    with SingleTickerProviderStateMixin {
  late ConnectionsModel _model;
  late TabController _tabController;
  List<UsersRecord> _connectedUsers = [];
  List<ConnectionsRecord> _pendingRequests = [];
  List<UsersRecord> _pendingFromUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConnectionsModel());
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    safeSetState(() => _isLoading = true);
    final myUid = currentUserUid;

    // Get accepted connections where I'm either from or to
    final allConnections = await queryConnectionsRecordOnce(
      queryBuilder: (q) => q.where('status', isEqualTo: 'accepted'),
    );
    final myConnections = allConnections.where(
        (c) => c.fromUid == myUid || c.toUid == myUid).toList();

    // Get connected user UIDs
    final connectedUids = myConnections.map((c) =>
        c.fromUid == myUid ? c.toUid : c.fromUid).toSet();

    // Load connected user records
    List<UsersRecord> connected = [];
    if (connectedUids.isNotEmpty) {
      final allUsers = await queryUsersRecordOnce();
      connected = allUsers.where((u) => connectedUids.contains(u.uid)).toList();
    }

    // Get pending requests TO me
    final pendingConnections = await queryConnectionsRecordOnce(
      queryBuilder: (q) => q
          .where('to_uid', isEqualTo: myUid)
          .where('status', isEqualTo: 'pending'),
    );

    // Load users who sent requests
    List<UsersRecord> pendingFrom = [];
    if (pendingConnections.isNotEmpty) {
      final fromUids = pendingConnections.map((c) => c.fromUid).toSet();
      final allUsers = await queryUsersRecordOnce();
      pendingFrom = allUsers.where((u) => fromUids.contains(u.uid)).toList();
    }

    safeSetState(() {
      _connectedUsers = connected;
      _pendingRequests = pendingConnections;
      _pendingFromUsers = pendingFrom;
      _isLoading = false;
    });
  }

  Future<void> _acceptRequest(ConnectionsRecord request) async {
    await request.reference.update({'status': 'accepted'});
    _loadData();
  }

  Future<void> _declineRequest(ConnectionsRecord request) async {
    await request.reference.update({'status': 'declined'});
    _loadData();
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
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
          title: Text('My Connections',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  )),
          centerTitle: false,
          elevation: 0.0,
          bottom: TabBar(
            controller: _tabController,
            labelColor: FlutterFlowTheme.of(context).primary,
            unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
            indicatorColor: FlutterFlowTheme.of(context).primary,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Connected (${_connectedUsers.length})'),
              Tab(text: 'Pending (${_pendingRequests.length})'),
            ],
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary)))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildConnectedTab(),
                  _buildPendingTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildConnectedTab() {
    if (_connectedUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline_rounded,
                color: FlutterFlowTheme.of(context).secondaryText, size: 72.0),
            SizedBox(height: 16.0),
            Text('No connections yet',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    )),
            SizedBox(height: 8.0),
            Text('Search for people and send connection requests',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    )),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 12.0, 0, 24.0),
      itemCount: _connectedUsers.length,
      separatorBuilder: (_, __) => Divider(
          height: 1.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate),
      itemBuilder: (context, index) {
        final user = _connectedUsers[index];
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: Row(
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
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (user.jobTitle.isNotEmpty)
                      Row(children: [
                        Icon(Icons.work_outline_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText, size: 14.0),
                        SizedBox(width: 4.0),
                        Flexible(
                          child: Text(user.jobTitle,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  )),
                        ),
                      ]),
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
                                      letterSpacing: 0.0,
                                    )),
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
                                    letterSpacing: 0.0,
                                  )),
                        ]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingTab() {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty_rounded,
                color: FlutterFlowTheme.of(context).secondaryText, size: 72.0),
            SizedBox(height: 16.0),
            Text('No pending requests',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    )),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(0, 12.0, 0, 24.0),
      itemCount: _pendingRequests.length,
      separatorBuilder: (_, __) => Divider(
          height: 1.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate),
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        final fromUser = _pendingFromUsers.firstWhere(
            (u) => u.uid == request.fromUid,
            orElse: () => UsersRecord.getDocumentFromData({}, UsersRecord.collection.doc()));

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: Row(
            children: [
              Container(
                width: 50.0, height: 50.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FlutterFlowTheme.of(context).alternate),
                child: Icon(Icons.person,
                    color: FlutterFlowTheme.of(context).secondaryText, size: 28.0),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromUser.displayName.isNotEmpty
                          ? fromUser.displayName
                          : fromUser.email,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (fromUser.jobTitle.isNotEmpty)
                      Text(fromUser.jobTitle,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              )),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _acceptRequest(request),
                    icon: Icon(Icons.check_circle_rounded,
                        color: FlutterFlowTheme.of(context).primary, size: 32.0),
                  ),
                  IconButton(
                    onPressed: () => _declineRequest(request),
                    icon: Icon(Icons.cancel_rounded,
                        color: FlutterFlowTheme.of(context).error, size: 32.0),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

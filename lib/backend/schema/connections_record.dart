import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConnectionsRecord extends FirestoreRecord {
  ConnectionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "from_uid" field - user who sent the request.
  String? _fromUid;
  String get fromUid => _fromUid ?? '';
  bool hasFromUid() => _fromUid != null;

  // "to_uid" field - user who received the request.
  String? _toUid;
  String get toUid => _toUid ?? '';
  bool hasToUid() => _toUid != null;

  // "status" field - pending, accepted, declined.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _fromUid = snapshotData['from_uid'] as String?;
    _toUid = snapshotData['to_uid'] as String?;
    _status = snapshotData['status'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('connections');

  static Stream<ConnectionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConnectionsRecord.fromSnapshot(s));

  static Future<ConnectionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConnectionsRecord.fromSnapshot(s));

  static ConnectionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConnectionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConnectionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConnectionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConnectionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConnectionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConnectionsRecordData({
  String? fromUid,
  String? toUid,
  String? status,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'from_uid': fromUid,
      'to_uid': toUid,
      'status': status,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

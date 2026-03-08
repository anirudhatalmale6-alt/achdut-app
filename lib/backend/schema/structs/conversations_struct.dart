// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConversationsStruct extends FFFirebaseStruct {
  ConversationsStruct({
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _participants = participants,
        _lastMessage = lastMessage,
        _lastMessageTime = lastMessageTime,
        super(firestoreUtilData);

  // "participants" field.
  List<String>? _participants;
  List<String> get participants => _participants ?? const [];
  set participants(List<String>? val) => _participants = val;

  void updateParticipants(Function(List<String>) updateFn) {
    updateFn(_participants ??= []);
  }

  bool hasParticipants() => _participants != null;

  // "lastMessage" field.
  String? _lastMessage;
  String get lastMessage => _lastMessage ?? '';
  set lastMessage(String? val) => _lastMessage = val;

  bool hasLastMessage() => _lastMessage != null;

  // "lastMessageTime" field.
  DateTime? _lastMessageTime;
  DateTime? get lastMessageTime => _lastMessageTime;
  set lastMessageTime(DateTime? val) => _lastMessageTime = val;

  bool hasLastMessageTime() => _lastMessageTime != null;

  static ConversationsStruct fromMap(Map<String, dynamic> data) =>
      ConversationsStruct(
        participants: getDataList(data['participants']),
        lastMessage: data['lastMessage'] as String?,
        lastMessageTime: data['lastMessageTime'] as DateTime?,
      );

  static ConversationsStruct? maybeFromMap(dynamic data) => data is Map
      ? ConversationsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'participants': _participants,
        'lastMessage': _lastMessage,
        'lastMessageTime': _lastMessageTime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'participants': serializeParam(
          _participants,
          ParamType.String,
          isList: true,
        ),
        'lastMessage': serializeParam(
          _lastMessage,
          ParamType.String,
        ),
        'lastMessageTime': serializeParam(
          _lastMessageTime,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static ConversationsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ConversationsStruct(
        participants: deserializeParam<String>(
          data['participants'],
          ParamType.String,
          true,
        ),
        lastMessage: deserializeParam(
          data['lastMessage'],
          ParamType.String,
          false,
        ),
        lastMessageTime: deserializeParam(
          data['lastMessageTime'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'ConversationsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ConversationsStruct &&
        listEquality.equals(participants, other.participants) &&
        lastMessage == other.lastMessage &&
        lastMessageTime == other.lastMessageTime;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([participants, lastMessage, lastMessageTime]);
}

ConversationsStruct createConversationsStruct({
  String? lastMessage,
  DateTime? lastMessageTime,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ConversationsStruct(
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ConversationsStruct? updateConversationsStruct(
  ConversationsStruct? conversations, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    conversations
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addConversationsStructData(
  Map<String, dynamic> firestoreData,
  ConversationsStruct? conversations,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (conversations == null) {
    return;
  }
  if (conversations.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && conversations.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final conversationsData =
      getConversationsFirestoreData(conversations, forFieldValue);
  final nestedData =
      conversationsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = conversations.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getConversationsFirestoreData(
  ConversationsStruct? conversations, [
  bool forFieldValue = false,
]) {
  if (conversations == null) {
    return {};
  }
  final firestoreData = mapToFirestore(conversations.toMap());

  // Add any Firestore field values
  conversations.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getConversationsListFirestoreData(
  List<ConversationsStruct>? conversationss,
) =>
    conversationss
        ?.map((e) => getConversationsFirestoreData(e, true))
        .toList() ??
    [];

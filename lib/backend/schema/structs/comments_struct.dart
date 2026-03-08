// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommentsStruct extends FFFirebaseStruct {
  CommentsStruct({
    String? text,
    DocumentReference? postRef,
    String? createdBy,
    DateTime? createdTime,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _text = text,
        _postRef = postRef,
        _createdBy = createdBy,
        _createdTime = createdTime,
        super(firestoreUtilData);

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "postRef" field.
  DocumentReference? _postRef;
  DocumentReference? get postRef => _postRef;
  set postRef(DocumentReference? val) => _postRef = val;

  bool hasPostRef() => _postRef != null;

  // "createdBy" field.
  String? _createdBy;
  String get createdBy => _createdBy ?? '';
  set createdBy(String? val) => _createdBy = val;

  bool hasCreatedBy() => _createdBy != null;

  // "createdTime" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  set createdTime(DateTime? val) => _createdTime = val;

  bool hasCreatedTime() => _createdTime != null;

  static CommentsStruct fromMap(Map<String, dynamic> data) => CommentsStruct(
        text: data['text'] as String?,
        postRef: data['postRef'] as DocumentReference?,
        createdBy: data['createdBy'] as String?,
        createdTime: data['createdTime'] as DateTime?,
      );

  static CommentsStruct? maybeFromMap(dynamic data) =>
      data is Map ? CommentsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'text': _text,
        'postRef': _postRef,
        'createdBy': _createdBy,
        'createdTime': _createdTime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'postRef': serializeParam(
          _postRef,
          ParamType.DocumentReference,
        ),
        'createdBy': serializeParam(
          _createdBy,
          ParamType.String,
        ),
        'createdTime': serializeParam(
          _createdTime,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static CommentsStruct fromSerializableMap(Map<String, dynamic> data) =>
      CommentsStruct(
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        postRef: deserializeParam(
          data['postRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['posts'],
        ),
        createdBy: deserializeParam(
          data['createdBy'],
          ParamType.String,
          false,
        ),
        createdTime: deserializeParam(
          data['createdTime'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'CommentsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CommentsStruct &&
        text == other.text &&
        postRef == other.postRef &&
        createdBy == other.createdBy &&
        createdTime == other.createdTime;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([text, postRef, createdBy, createdTime]);
}

CommentsStruct createCommentsStruct({
  String? text,
  DocumentReference? postRef,
  String? createdBy,
  DateTime? createdTime,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CommentsStruct(
      text: text,
      postRef: postRef,
      createdBy: createdBy,
      createdTime: createdTime,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CommentsStruct? updateCommentsStruct(
  CommentsStruct? comments, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    comments
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCommentsStructData(
  Map<String, dynamic> firestoreData,
  CommentsStruct? comments,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (comments == null) {
    return;
  }
  if (comments.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && comments.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final commentsData = getCommentsFirestoreData(comments, forFieldValue);
  final nestedData = commentsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = comments.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCommentsFirestoreData(
  CommentsStruct? comments, [
  bool forFieldValue = false,
]) {
  if (comments == null) {
    return {};
  }
  final firestoreData = mapToFirestore(comments.toMap());

  // Add any Firestore field values
  comments.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCommentsListFirestoreData(
  List<CommentsStruct>? commentss,
) =>
    commentss?.map((e) => getCommentsFirestoreData(e, true)).toList() ?? [];

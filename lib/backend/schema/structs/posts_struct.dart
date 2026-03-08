// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostsStruct extends FFFirebaseStruct {
  PostsStruct({
    String? text,
    String? image,
    String? createdBy,
    DateTime? createdTime,
    List<String>? likes,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _text = text,
        _image = image,
        _createdBy = createdBy,
        _createdTime = createdTime,
        _likes = likes,
        super(firestoreUtilData);

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

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

  // "likes" field.
  List<String>? _likes;
  List<String> get likes => _likes ?? const [];
  set likes(List<String>? val) => _likes = val;

  void updateLikes(Function(List<String>) updateFn) {
    updateFn(_likes ??= []);
  }

  bool hasLikes() => _likes != null;

  static PostsStruct fromMap(Map<String, dynamic> data) => PostsStruct(
        text: data['text'] as String?,
        image: data['image'] as String?,
        createdBy: data['createdBy'] as String?,
        createdTime: data['createdTime'] as DateTime?,
        likes: getDataList(data['likes']),
      );

  static PostsStruct? maybeFromMap(dynamic data) =>
      data is Map ? PostsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'text': _text,
        'image': _image,
        'createdBy': _createdBy,
        'createdTime': _createdTime,
        'likes': _likes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'createdBy': serializeParam(
          _createdBy,
          ParamType.String,
        ),
        'createdTime': serializeParam(
          _createdTime,
          ParamType.DateTime,
        ),
        'likes': serializeParam(
          _likes,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static PostsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PostsStruct(
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
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
        likes: deserializeParam<String>(
          data['likes'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'PostsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PostsStruct &&
        text == other.text &&
        image == other.image &&
        createdBy == other.createdBy &&
        createdTime == other.createdTime &&
        listEquality.equals(likes, other.likes);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([text, image, createdBy, createdTime, likes]);
}

PostsStruct createPostsStruct({
  String? text,
  String? image,
  String? createdBy,
  DateTime? createdTime,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PostsStruct(
      text: text,
      image: image,
      createdBy: createdBy,
      createdTime: createdTime,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PostsStruct? updatePostsStruct(
  PostsStruct? posts, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    posts
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPostsStructData(
  Map<String, dynamic> firestoreData,
  PostsStruct? posts,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (posts == null) {
    return;
  }
  if (posts.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && posts.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final postsData = getPostsFirestoreData(posts, forFieldValue);
  final nestedData = postsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = posts.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPostsFirestoreData(
  PostsStruct? posts, [
  bool forFieldValue = false,
]) {
  if (posts == null) {
    return {};
  }
  final firestoreData = mapToFirestore(posts.toMap());

  // Add any Firestore field values
  posts.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPostsListFirestoreData(
  List<PostsStruct>? postss,
) =>
    postss?.map((e) => getPostsFirestoreData(e, true)).toList() ?? [];

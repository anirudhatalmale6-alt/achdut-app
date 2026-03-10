import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostsRecord extends FirestoreRecord {
  PostsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  bool hasContent() => _content != null;

  // "createBy" field.
  String? _createBy;
  String get createBy => _createBy ?? '';
  bool hasCreateBy() => _createBy != null;

  // "likes" field.
  int? _likes;
  int get likes => _likes ?? 0;
  bool hasLikes() => _likes != null;

  // "liked_by" field - list of UIDs who liked this post.
  List<String>? _likedBy;
  List<String> get likedBy => _likedBy ?? const [];
  bool hasLikedBy() => _likedBy != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "creator_uid" field.
  String? _creatorUid;
  String get creatorUid => _creatorUid ?? '';
  bool hasCreatorUid() => _creatorUid != null;

  // "video_url" field.
  String? _videoUrl;
  String get videoUrl => _videoUrl ?? '';
  bool hasVideoUrl() => _videoUrl != null;

  // "visibility" field.
  String? _visibility;
  String get visibility => _visibility ?? 'everyone';
  bool hasVisibility() => _visibility != null;

  // "link_url" field.
  String? _linkUrl;
  String get linkUrl => _linkUrl ?? '';
  bool hasLinkUrl() => _linkUrl != null;

  void _initializeFields() {
    _createdTime = snapshotData['created_time'] as DateTime?;
    _title = snapshotData['title'] as String?;
    _content = snapshotData['content'] as String?;
    _createBy = snapshotData['createBy'] as String?;
    _likes = castToType<int>(snapshotData['likes']);
    _likedBy = getDataList(snapshotData['liked_by']);
    _imageUrl = snapshotData['image_url'] as String?;
    _creatorUid = snapshotData['creator_uid'] as String?;
    _videoUrl = snapshotData['video_url'] as String?;
    _visibility = snapshotData['visibility'] as String?;
    _linkUrl = snapshotData['link_url'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('posts');

  static Stream<PostsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PostsRecord.fromSnapshot(s));

  static Future<PostsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PostsRecord.fromSnapshot(s));

  static PostsRecord fromSnapshot(DocumentSnapshot snapshot) => PostsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PostsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PostsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PostsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PostsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPostsRecordData({
  DateTime? createdTime,
  String? title,
  String? content,
  String? createBy,
  int? likes,
  String? imageUrl,
  String? creatorUid,
  String? videoUrl,
  String? visibility,
  String? linkUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_time': createdTime,
      'title': title,
      'content': content,
      'createBy': createBy,
      'likes': likes,
      'image_url': imageUrl,
      'creator_uid': creatorUid,
      'video_url': videoUrl,
      'visibility': visibility,
      'link_url': linkUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class PostsRecordDocumentEquality implements Equality<PostsRecord> {
  const PostsRecordDocumentEquality();

  @override
  bool equals(PostsRecord? e1, PostsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.createdTime == e2?.createdTime &&
        e1?.title == e2?.title &&
        e1?.content == e2?.content &&
        e1?.createBy == e2?.createBy &&
        e1?.likes == e2?.likes &&
        listEquality.equals(e1?.likedBy, e2?.likedBy) &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.creatorUid == e2?.creatorUid;
  }

  @override
  int hash(PostsRecord? e) => const ListEquality().hash([
        e?.createdTime,
        e?.title,
        e?.content,
        e?.createBy,
        e?.likes,
        e?.likedBy,
        e?.imageUrl,
        e?.creatorUid,
      ]);

  @override
  bool isValidKey(Object? o) => o is PostsRecord;
}

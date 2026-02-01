// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMessageIsarCollection on Isar {
  IsarCollection<MessageIsar> get messageIsars => this.collection();
}

const MessageIsarSchema = CollectionSchema(
  name: r'MessageIsar',
  id: 3260995708908258659,
  properties: {
    r'chatId': PropertySchema(
      id: 0,
      name: r'chatId',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'localCreatedAt': PropertySchema(
      id: 2,
      name: r'localCreatedAt',
      type: IsarType.dateTime,
    ),
    r'localMessageId': PropertySchema(
      id: 3,
      name: r'localMessageId',
      type: IsarType.string,
    ),
    r'media': PropertySchema(
      id: 4,
      name: r'media',
      type: IsarType.object,
      target: r'MediaIsar',
    ),
    r'messageType': PropertySchema(
      id: 5,
      name: r'messageType',
      type: IsarType.string,
    ),
    r'seenBy': PropertySchema(
      id: 6,
      name: r'seenBy',
      type: IsarType.stringList,
    ),
    r'senderId': PropertySchema(
      id: 7,
      name: r'senderId',
      type: IsarType.string,
    ),
    r'serverCreatedAt': PropertySchema(
      id: 8,
      name: r'serverCreatedAt',
      type: IsarType.dateTime,
    ),
    r'serverMessageId': PropertySchema(
      id: 9,
      name: r'serverMessageId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.string,
    )
  },
  estimateSize: _messageIsarEstimateSize,
  serialize: _messageIsarSerialize,
  deserialize: _messageIsarDeserialize,
  deserializeProp: _messageIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'localMessageId': IndexSchema(
      id: 952918565102295947,
      name: r'localMessageId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'localMessageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'serverMessageId': IndexSchema(
      id: 3340808824564104802,
      name: r'serverMessageId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverMessageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'chatId': IndexSchema(
      id: 1909629659142158609,
      name: r'chatId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chatId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'senderId': IndexSchema(
      id: -1619654757968658561,
      name: r'senderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'senderId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'localCreatedAt': IndexSchema(
      id: -44009826510721484,
      name: r'localCreatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'localCreatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'MediaIsar': MediaIsarSchema},
  getId: _messageIsarGetId,
  getLinks: _messageIsarGetLinks,
  attach: _messageIsarAttach,
  version: '3.1.0+1',
);

int _messageIsarEstimateSize(
  MessageIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chatId.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.localMessageId.length * 3;
  {
    final value = object.media;
    if (value != null) {
      bytesCount += 3 +
          MediaIsarSchema.estimateSize(
              value, allOffsets[MediaIsar]!, allOffsets);
    }
  }
  bytesCount += 3 + object.messageType.length * 3;
  {
    final list = object.seenBy;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.senderId.length * 3;
  {
    final value = object.serverMessageId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _messageIsarSerialize(
  MessageIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chatId);
  writer.writeString(offsets[1], object.content);
  writer.writeDateTime(offsets[2], object.localCreatedAt);
  writer.writeString(offsets[3], object.localMessageId);
  writer.writeObject<MediaIsar>(
    offsets[4],
    allOffsets,
    MediaIsarSchema.serialize,
    object.media,
  );
  writer.writeString(offsets[5], object.messageType);
  writer.writeStringList(offsets[6], object.seenBy);
  writer.writeString(offsets[7], object.senderId);
  writer.writeDateTime(offsets[8], object.serverCreatedAt);
  writer.writeString(offsets[9], object.serverMessageId);
  writer.writeString(offsets[10], object.status);
}

MessageIsar _messageIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MessageIsar();
  object.chatId = reader.readString(offsets[0]);
  object.content = reader.readString(offsets[1]);
  object.id = id;
  object.localCreatedAt = reader.readDateTimeOrNull(offsets[2]);
  object.localMessageId = reader.readString(offsets[3]);
  object.media = reader.readObjectOrNull<MediaIsar>(
    offsets[4],
    MediaIsarSchema.deserialize,
    allOffsets,
  );
  object.messageType = reader.readString(offsets[5]);
  object.seenBy = reader.readStringList(offsets[6]);
  object.senderId = reader.readString(offsets[7]);
  object.serverCreatedAt = reader.readDateTimeOrNull(offsets[8]);
  object.serverMessageId = reader.readStringOrNull(offsets[9]);
  object.status = reader.readString(offsets[10]);
  return object;
}

P _messageIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectOrNull<MediaIsar>(
        offset,
        MediaIsarSchema.deserialize,
        allOffsets,
      )) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringList(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _messageIsarGetId(MessageIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _messageIsarGetLinks(MessageIsar object) {
  return [];
}

void _messageIsarAttach(
    IsarCollection<dynamic> col, Id id, MessageIsar object) {
  object.id = id;
}

extension MessageIsarQueryWhereSort
    on QueryBuilder<MessageIsar, MessageIsar, QWhere> {
  QueryBuilder<MessageIsar, MessageIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhere> anyLocalCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'localCreatedAt'),
      );
    });
  }
}

extension MessageIsarQueryWhere
    on QueryBuilder<MessageIsar, MessageIsar, QWhereClause> {
  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localMessageIdEqualTo(String localMessageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'localMessageId',
        value: [localMessageId],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localMessageIdNotEqualTo(String localMessageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localMessageId',
              lower: [],
              upper: [localMessageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localMessageId',
              lower: [localMessageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localMessageId',
              lower: [localMessageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localMessageId',
              lower: [],
              upper: [localMessageId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      serverMessageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverMessageId',
        value: [null],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      serverMessageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'serverMessageId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      serverMessageIdEqualTo(String? serverMessageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverMessageId',
        value: [serverMessageId],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      serverMessageIdNotEqualTo(String? serverMessageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverMessageId',
              lower: [],
              upper: [serverMessageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverMessageId',
              lower: [serverMessageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverMessageId',
              lower: [serverMessageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverMessageId',
              lower: [],
              upper: [serverMessageId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> chatIdEqualTo(
      String chatId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chatId',
        value: [chatId],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> chatIdNotEqualTo(
      String chatId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> senderIdEqualTo(
      String senderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'senderId',
        value: [senderId],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> senderIdNotEqualTo(
      String senderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'senderId',
              lower: [],
              upper: [senderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'senderId',
              lower: [senderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'senderId',
              lower: [senderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'senderId',
              lower: [],
              upper: [senderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> statusEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause> statusNotEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'localCreatedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localCreatedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtEqualTo(DateTime? localCreatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'localCreatedAt',
        value: [localCreatedAt],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtNotEqualTo(DateTime? localCreatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localCreatedAt',
              lower: [],
              upper: [localCreatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localCreatedAt',
              lower: [localCreatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localCreatedAt',
              lower: [localCreatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localCreatedAt',
              lower: [],
              upper: [localCreatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtGreaterThan(
    DateTime? localCreatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localCreatedAt',
        lower: [localCreatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtLessThan(
    DateTime? localCreatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localCreatedAt',
        lower: [],
        upper: [localCreatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterWhereClause>
      localCreatedAtBetween(
    DateTime? lowerLocalCreatedAt,
    DateTime? upperLocalCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localCreatedAt',
        lower: [lowerLocalCreatedAt],
        includeLower: includeLower,
        upper: [upperLocalCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MessageIsarQueryFilter
    on QueryBuilder<MessageIsar, MessageIsar, QFilterCondition> {
  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> chatIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      chatIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> chatIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> chatIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      chatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> chatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> chatIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> chatIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      chatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      chatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localCreatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localCreatedAt',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localCreatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localCreatedAt',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localCreatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localCreatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localCreatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localCreatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localCreatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localMessageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localMessageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localMessageId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      localMessageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localMessageId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> mediaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'media',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      mediaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'media',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'messageType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageType',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      messageTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'messageType',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> seenByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seenBy',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seenBy',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seenBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seenBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seenBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seenBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'seenBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'seenBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'seenBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'seenBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seenBy',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'seenBy',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seenBy',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seenBy',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seenBy',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seenBy',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seenBy',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      seenByLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seenBy',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> senderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> senderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> senderIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      senderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverCreatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverCreatedAt',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverCreatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverCreatedAt',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverCreatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverCreatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverCreatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverCreatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverCreatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverMessageId',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverMessageId',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverMessageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverMessageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverMessageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverMessageId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      serverMessageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverMessageId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension MessageIsarQueryObject
    on QueryBuilder<MessageIsar, MessageIsar, QFilterCondition> {
  QueryBuilder<MessageIsar, MessageIsar, QAfterFilterCondition> media(
      FilterQuery<MediaIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'media');
    });
  }
}

extension MessageIsarQueryLinks
    on QueryBuilder<MessageIsar, MessageIsar, QFilterCondition> {}

extension MessageIsarQuerySortBy
    on QueryBuilder<MessageIsar, MessageIsar, QSortBy> {
  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByLocalCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localCreatedAt', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      sortByLocalCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localCreatedAt', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByLocalMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localMessageId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      sortByLocalMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localMessageId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortBySenderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByServerCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCreatedAt', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      sortByServerCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCreatedAt', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByServerMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverMessageId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      sortByServerMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverMessageId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension MessageIsarQuerySortThenBy
    on QueryBuilder<MessageIsar, MessageIsar, QSortThenBy> {
  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByLocalCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localCreatedAt', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      thenByLocalCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localCreatedAt', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByLocalMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localMessageId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      thenByLocalMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localMessageId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenBySenderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByServerCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCreatedAt', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      thenByServerCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCreatedAt', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByServerMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverMessageId', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy>
      thenByServerMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverMessageId', Sort.desc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension MessageIsarQueryWhereDistinct
    on QueryBuilder<MessageIsar, MessageIsar, QDistinct> {
  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByChatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByLocalCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localCreatedAt');
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByLocalMessageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localMessageId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByMessageType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctBySeenBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seenBy');
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctBySenderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct>
      distinctByServerCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverCreatedAt');
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByServerMessageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverMessageId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageIsar, MessageIsar, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension MessageIsarQueryProperty
    on QueryBuilder<MessageIsar, MessageIsar, QQueryProperty> {
  QueryBuilder<MessageIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MessageIsar, String, QQueryOperations> chatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatId');
    });
  }

  QueryBuilder<MessageIsar, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<MessageIsar, DateTime?, QQueryOperations>
      localCreatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localCreatedAt');
    });
  }

  QueryBuilder<MessageIsar, String, QQueryOperations> localMessageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localMessageId');
    });
  }

  QueryBuilder<MessageIsar, MediaIsar?, QQueryOperations> mediaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'media');
    });
  }

  QueryBuilder<MessageIsar, String, QQueryOperations> messageTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageType');
    });
  }

  QueryBuilder<MessageIsar, List<String>?, QQueryOperations> seenByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seenBy');
    });
  }

  QueryBuilder<MessageIsar, String, QQueryOperations> senderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderId');
    });
  }

  QueryBuilder<MessageIsar, DateTime?, QQueryOperations>
      serverCreatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverCreatedAt');
    });
  }

  QueryBuilder<MessageIsar, String?, QQueryOperations>
      serverMessageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverMessageId');
    });
  }

  QueryBuilder<MessageIsar, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

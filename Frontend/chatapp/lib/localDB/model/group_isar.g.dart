// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGroupIsarCollection on Isar {
  IsarCollection<GroupIsar> get groupIsars => this.collection();
}

const GroupIsarSchema = CollectionSchema(
  name: r'GroupIsar',
  id: -3445220930281838384,
  properties: {
    r'groupDescription': PropertySchema(
      id: 0,
      name: r'groupDescription',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 1,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'groupName': PropertySchema(
      id: 2,
      name: r'groupName',
      type: IsarType.string,
    ),
    r'groupPic': PropertySchema(
      id: 3,
      name: r'groupPic',
      type: IsarType.string,
    )
  },
  estimateSize: _groupIsarEstimateSize,
  serialize: _groupIsarSerialize,
  deserialize: _groupIsarDeserialize,
  deserializeProp: _groupIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'groupMembers': LinkSchema(
      id: -1599496501132259063,
      name: r'groupMembers',
      target: r'UserIsar',
      single: false,
    ),
    r'groupAdmins': LinkSchema(
      id: 2492565726131315381,
      name: r'groupAdmins',
      target: r'UserIsar',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _groupIsarGetId,
  getLinks: _groupIsarGetLinks,
  attach: _groupIsarAttach,
  version: '3.1.0+1',
);

int _groupIsarEstimateSize(
  GroupIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.groupDescription.length * 3;
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.groupName.length * 3;
  bytesCount += 3 + object.groupPic.length * 3;
  return bytesCount;
}

void _groupIsarSerialize(
  GroupIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.groupDescription);
  writer.writeString(offsets[1], object.groupId);
  writer.writeString(offsets[2], object.groupName);
  writer.writeString(offsets[3], object.groupPic);
}

GroupIsar _groupIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupIsar();
  object.groupDescription = reader.readString(offsets[0]);
  object.groupId = reader.readString(offsets[1]);
  object.groupName = reader.readString(offsets[2]);
  object.groupPic = reader.readString(offsets[3]);
  object.id = id;
  return object;
}

P _groupIsarDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _groupIsarGetId(GroupIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _groupIsarGetLinks(GroupIsar object) {
  return [object.groupMembers, object.groupAdmins];
}

void _groupIsarAttach(IsarCollection<dynamic> col, Id id, GroupIsar object) {
  object.id = id;
  object.groupMembers
      .attach(col, col.isar.collection<UserIsar>(), r'groupMembers', id);
  object.groupAdmins
      .attach(col, col.isar.collection<UserIsar>(), r'groupAdmins', id);
}

extension GroupIsarByIndex on IsarCollection<GroupIsar> {
  Future<GroupIsar?> getByGroupId(String groupId) {
    return getByIndex(r'groupId', [groupId]);
  }

  GroupIsar? getByGroupIdSync(String groupId) {
    return getByIndexSync(r'groupId', [groupId]);
  }

  Future<bool> deleteByGroupId(String groupId) {
    return deleteByIndex(r'groupId', [groupId]);
  }

  bool deleteByGroupIdSync(String groupId) {
    return deleteByIndexSync(r'groupId', [groupId]);
  }

  Future<List<GroupIsar?>> getAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'groupId', values);
  }

  List<GroupIsar?> getAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'groupId', values);
  }

  Future<int> deleteAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'groupId', values);
  }

  int deleteAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'groupId', values);
  }

  Future<Id> putByGroupId(GroupIsar object) {
    return putByIndex(r'groupId', object);
  }

  Id putByGroupIdSync(GroupIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'groupId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGroupId(List<GroupIsar> objects) {
    return putAllByIndex(r'groupId', objects);
  }

  List<Id> putAllByGroupIdSync(List<GroupIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'groupId', objects, saveLinks: saveLinks);
  }
}

extension GroupIsarQueryWhereSort
    on QueryBuilder<GroupIsar, GroupIsar, QWhere> {
  QueryBuilder<GroupIsar, GroupIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupIsarQueryWhere
    on QueryBuilder<GroupIsar, GroupIsar, QWhereClause> {
  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> groupIdEqualTo(
      String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterWhereClause> groupIdNotEqualTo(
      String groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GroupIsarQueryFilter
    on QueryBuilder<GroupIsar, GroupIsar, QFilterCondition> {
  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupName',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupName',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupPic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupPic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupPic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupPic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupPic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupPic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupPic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupPic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupPicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupPic',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupPicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupPic',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> idBetween(
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
}

extension GroupIsarQueryObject
    on QueryBuilder<GroupIsar, GroupIsar, QFilterCondition> {}

extension GroupIsarQueryLinks
    on QueryBuilder<GroupIsar, GroupIsar, QFilterCondition> {
  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupMembers(
      FilterQuery<UserIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'groupMembers');
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupMembersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupMembers', length, true, length, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupMembersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupMembers', 0, true, 0, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupMembersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupMembers', 0, false, 999999, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupMembersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupMembers', 0, true, length, include);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupMembersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupMembers', length, include, 999999, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupMembersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'groupMembers', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition> groupAdmins(
      FilterQuery<UserIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'groupAdmins');
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupAdminsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupAdmins', length, true, length, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupAdminsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupAdmins', 0, true, 0, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupAdminsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupAdmins', 0, false, 999999, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupAdminsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupAdmins', 0, true, length, include);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupAdminsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupAdmins', length, include, 999999, true);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterFilterCondition>
      groupAdminsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'groupAdmins', lower, includeLower, upper, includeUpper);
    });
  }
}

extension GroupIsarQuerySortBy on QueryBuilder<GroupIsar, GroupIsar, QSortBy> {
  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupDescription', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy>
      sortByGroupDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupDescription', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupPic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupPic', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> sortByGroupPicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupPic', Sort.desc);
    });
  }
}

extension GroupIsarQuerySortThenBy
    on QueryBuilder<GroupIsar, GroupIsar, QSortThenBy> {
  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupDescription', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy>
      thenByGroupDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupDescription', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupPic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupPic', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByGroupPicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupPic', Sort.desc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension GroupIsarQueryWhereDistinct
    on QueryBuilder<GroupIsar, GroupIsar, QDistinct> {
  QueryBuilder<GroupIsar, GroupIsar, QDistinct> distinctByGroupDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QDistinct> distinctByGroupName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupIsar, GroupIsar, QDistinct> distinctByGroupPic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupPic', caseSensitive: caseSensitive);
    });
  }
}

extension GroupIsarQueryProperty
    on QueryBuilder<GroupIsar, GroupIsar, QQueryProperty> {
  QueryBuilder<GroupIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GroupIsar, String, QQueryOperations> groupDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupDescription');
    });
  }

  QueryBuilder<GroupIsar, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<GroupIsar, String, QQueryOperations> groupNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupName');
    });
  }

  QueryBuilder<GroupIsar, String, QQueryOperations> groupPicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupPic');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInteractionIsarCollection on Isar {
  IsarCollection<InteractionIsar> get interactionIsars => this.collection();
}

const InteractionIsarSchema = CollectionSchema(
  name: r'InteractionIsar',
  id: -5522254164634346315,
  properties: {
    r'status': PropertySchema(
      id: 0,
      name: r'status',
      type: IsarType.string,
    )
  },
  estimateSize: _interactionIsarEstimateSize,
  serialize: _interactionIsarSerialize,
  deserialize: _interactionIsarDeserialize,
  deserializeProp: _interactionIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'toUser': LinkSchema(
      id: 8488708820858683321,
      name: r'toUser',
      target: r'UserIsar',
      single: true,
    ),
    r'fromUser': LinkSchema(
      id: -8023490421807538461,
      name: r'fromUser',
      target: r'UserIsar',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _interactionIsarGetId,
  getLinks: _interactionIsarGetLinks,
  attach: _interactionIsarAttach,
  version: '3.1.0+1',
);

int _interactionIsarEstimateSize(
  InteractionIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _interactionIsarSerialize(
  InteractionIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.status);
}

InteractionIsar _interactionIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InteractionIsar();
  object.id = id;
  object.status = reader.readString(offsets[0]);
  return object;
}

P _interactionIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _interactionIsarGetId(InteractionIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _interactionIsarGetLinks(InteractionIsar object) {
  return [object.toUser, object.fromUser];
}

void _interactionIsarAttach(
    IsarCollection<dynamic> col, Id id, InteractionIsar object) {
  object.id = id;
  object.toUser.attach(col, col.isar.collection<UserIsar>(), r'toUser', id);
  object.fromUser.attach(col, col.isar.collection<UserIsar>(), r'fromUser', id);
}

extension InteractionIsarQueryWhereSort
    on QueryBuilder<InteractionIsar, InteractionIsar, QWhere> {
  QueryBuilder<InteractionIsar, InteractionIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InteractionIsarQueryWhere
    on QueryBuilder<InteractionIsar, InteractionIsar, QWhereClause> {
  QueryBuilder<InteractionIsar, InteractionIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterWhereClause> idBetween(
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
}

extension InteractionIsarQueryFilter
    on QueryBuilder<InteractionIsar, InteractionIsar, QFilterCondition> {
  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusEqualTo(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusLessThan(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusBetween(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusEndsWith(
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

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension InteractionIsarQueryObject
    on QueryBuilder<InteractionIsar, InteractionIsar, QFilterCondition> {}

extension InteractionIsarQueryLinks
    on QueryBuilder<InteractionIsar, InteractionIsar, QFilterCondition> {
  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition> toUser(
      FilterQuery<UserIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'toUser');
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      toUserIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'toUser', 0, true, 0, true);
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      fromUser(FilterQuery<UserIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'fromUser');
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterFilterCondition>
      fromUserIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fromUser', 0, true, 0, true);
    });
  }
}

extension InteractionIsarQuerySortBy
    on QueryBuilder<InteractionIsar, InteractionIsar, QSortBy> {
  QueryBuilder<InteractionIsar, InteractionIsar, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension InteractionIsarQuerySortThenBy
    on QueryBuilder<InteractionIsar, InteractionIsar, QSortThenBy> {
  QueryBuilder<InteractionIsar, InteractionIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InteractionIsar, InteractionIsar, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension InteractionIsarQueryWhereDistinct
    on QueryBuilder<InteractionIsar, InteractionIsar, QDistinct> {
  QueryBuilder<InteractionIsar, InteractionIsar, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension InteractionIsarQueryProperty
    on QueryBuilder<InteractionIsar, InteractionIsar, QQueryProperty> {
  QueryBuilder<InteractionIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InteractionIsar, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

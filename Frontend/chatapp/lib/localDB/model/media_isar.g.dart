// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_isar.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MediaIsarSchema = Schema(
  name: r'MediaIsar',
  id: 8577575726066654014,
  properties: {
    r'height': PropertySchema(
      id: 0,
      name: r'height',
      type: IsarType.long,
    ),
    r'localPath': PropertySchema(
      id: 1,
      name: r'localPath',
      type: IsarType.string,
    ),
    r'size': PropertySchema(
      id: 2,
      name: r'size',
      type: IsarType.long,
    ),
    r'thumbnail': PropertySchema(
      id: 3,
      name: r'thumbnail',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 4,
      name: r'url',
      type: IsarType.string,
    ),
    r'width': PropertySchema(
      id: 5,
      name: r'width',
      type: IsarType.long,
    )
  },
  estimateSize: _mediaIsarEstimateSize,
  serialize: _mediaIsarSerialize,
  deserialize: _mediaIsarDeserialize,
  deserializeProp: _mediaIsarDeserializeProp,
);

int _mediaIsarEstimateSize(
  MediaIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.localPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.thumbnail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.url;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _mediaIsarSerialize(
  MediaIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.height);
  writer.writeString(offsets[1], object.localPath);
  writer.writeLong(offsets[2], object.size);
  writer.writeString(offsets[3], object.thumbnail);
  writer.writeString(offsets[4], object.url);
  writer.writeLong(offsets[5], object.width);
}

MediaIsar _mediaIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MediaIsar();
  object.height = reader.readLongOrNull(offsets[0]);
  object.localPath = reader.readStringOrNull(offsets[1]);
  object.size = reader.readLongOrNull(offsets[2]);
  object.thumbnail = reader.readStringOrNull(offsets[3]);
  object.url = reader.readStringOrNull(offsets[4]);
  object.width = reader.readLongOrNull(offsets[5]);
  return object;
}

P _mediaIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MediaIsarQueryFilter
    on QueryBuilder<MediaIsar, MediaIsar, QFilterCondition> {
  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> heightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'height',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> heightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'height',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> heightEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> heightGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> heightLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> heightBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition>
      localPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition>
      localPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> localPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition>
      localPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> sizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'size',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> sizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'size',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> sizeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> sizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> sizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> sizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbnail',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition>
      thumbnailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbnail',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition>
      thumbnailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbnail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> thumbnailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnail',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition>
      thumbnailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbnail',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> widthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> widthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> widthEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> widthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> widthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaIsar, MediaIsar, QAfterFilterCondition> widthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MediaIsarQueryObject
    on QueryBuilder<MediaIsar, MediaIsar, QFilterCondition> {}

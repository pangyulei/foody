// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PackagedFoodsTable extends PackagedFoods
    with TableInfo<$PackagedFoodsTable, PackagedFoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackagedFoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kjMeta = const VerificationMeta('kj');
  @override
  late final GeneratedColumn<double> kj = GeneratedColumn<double>(
    'kj',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netContentMeta = const VerificationMeta(
    'netContent',
  );
  @override
  late final GeneratedColumn<double> netContent = GeneratedColumn<double>(
    'net_content',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basisAmountMeta = const VerificationMeta(
    'basisAmount',
  );
  @override
  late final GeneratedColumn<double> basisAmount = GeneratedColumn<double>(
    'basis_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedTimeMeta = const VerificationMeta(
    'lastUsedTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedTime = GeneratedColumn<DateTime>(
    'last_used_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kj,
    carbs,
    protein,
    fat,
    netContent,
    basisAmount,
    unitName,
    lastUsedTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packaged_foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackagedFoodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kj')) {
      context.handle(_kjMeta, kj.isAcceptableOrUnknown(data['kj']!, _kjMeta));
    } else if (isInserting) {
      context.missing(_kjMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('net_content')) {
      context.handle(
        _netContentMeta,
        netContent.isAcceptableOrUnknown(data['net_content']!, _netContentMeta),
      );
    } else if (isInserting) {
      context.missing(_netContentMeta);
    }
    if (data.containsKey('basis_amount')) {
      context.handle(
        _basisAmountMeta,
        basisAmount.isAcceptableOrUnknown(
          data['basis_amount']!,
          _basisAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_basisAmountMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    if (data.containsKey('last_used_time')) {
      context.handle(
        _lastUsedTimeMeta,
        lastUsedTime.isAcceptableOrUnknown(
          data['last_used_time']!,
          _lastUsedTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUsedTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackagedFoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackagedFoodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kj: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kj'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      netContent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}net_content'],
      )!,
      basisAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}basis_amount'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
      lastUsedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_time'],
      )!,
    );
  }

  @override
  $PackagedFoodsTable createAlias(String alias) {
    return $PackagedFoodsTable(attachedDatabase, alias);
  }
}

class PackagedFoodRow extends DataClass implements Insertable<PackagedFoodRow> {
  final int id;
  final String name;
  final double kj;
  final double carbs;
  final double protein;
  final double fat;
  final double netContent;
  final double basisAmount;
  final String unitName;
  final DateTime lastUsedTime;
  const PackagedFoodRow({
    required this.id,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.netContent,
    required this.basisAmount,
    required this.unitName,
    required this.lastUsedTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['kj'] = Variable<double>(kj);
    map['carbs'] = Variable<double>(carbs);
    map['protein'] = Variable<double>(protein);
    map['fat'] = Variable<double>(fat);
    map['net_content'] = Variable<double>(netContent);
    map['basis_amount'] = Variable<double>(basisAmount);
    map['unit_name'] = Variable<String>(unitName);
    map['last_used_time'] = Variable<DateTime>(lastUsedTime);
    return map;
  }

  PackagedFoodsCompanion toCompanion(bool nullToAbsent) {
    return PackagedFoodsCompanion(
      id: Value(id),
      name: Value(name),
      kj: Value(kj),
      carbs: Value(carbs),
      protein: Value(protein),
      fat: Value(fat),
      netContent: Value(netContent),
      basisAmount: Value(basisAmount),
      unitName: Value(unitName),
      lastUsedTime: Value(lastUsedTime),
    );
  }

  factory PackagedFoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackagedFoodRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kj: serializer.fromJson<double>(json['kj']),
      carbs: serializer.fromJson<double>(json['carbs']),
      protein: serializer.fromJson<double>(json['protein']),
      fat: serializer.fromJson<double>(json['fat']),
      netContent: serializer.fromJson<double>(json['netContent']),
      basisAmount: serializer.fromJson<double>(json['basisAmount']),
      unitName: serializer.fromJson<String>(json['unitName']),
      lastUsedTime: serializer.fromJson<DateTime>(json['lastUsedTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kj': serializer.toJson<double>(kj),
      'carbs': serializer.toJson<double>(carbs),
      'protein': serializer.toJson<double>(protein),
      'fat': serializer.toJson<double>(fat),
      'netContent': serializer.toJson<double>(netContent),
      'basisAmount': serializer.toJson<double>(basisAmount),
      'unitName': serializer.toJson<String>(unitName),
      'lastUsedTime': serializer.toJson<DateTime>(lastUsedTime),
    };
  }

  PackagedFoodRow copyWith({
    int? id,
    String? name,
    double? kj,
    double? carbs,
    double? protein,
    double? fat,
    double? netContent,
    double? basisAmount,
    String? unitName,
    DateTime? lastUsedTime,
  }) => PackagedFoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kj: kj ?? this.kj,
    carbs: carbs ?? this.carbs,
    protein: protein ?? this.protein,
    fat: fat ?? this.fat,
    netContent: netContent ?? this.netContent,
    basisAmount: basisAmount ?? this.basisAmount,
    unitName: unitName ?? this.unitName,
    lastUsedTime: lastUsedTime ?? this.lastUsedTime,
  );
  PackagedFoodRow copyWithCompanion(PackagedFoodsCompanion data) {
    return PackagedFoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kj: data.kj.present ? data.kj.value : this.kj,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      netContent: data.netContent.present
          ? data.netContent.value
          : this.netContent,
      basisAmount: data.basisAmount.present
          ? data.basisAmount.value
          : this.basisAmount,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      lastUsedTime: data.lastUsedTime.present
          ? data.lastUsedTime.value
          : this.lastUsedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackagedFoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('netContent: $netContent, ')
          ..write('basisAmount: $basisAmount, ')
          ..write('unitName: $unitName, ')
          ..write('lastUsedTime: $lastUsedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kj,
    carbs,
    protein,
    fat,
    netContent,
    basisAmount,
    unitName,
    lastUsedTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackagedFoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kj == this.kj &&
          other.carbs == this.carbs &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.netContent == this.netContent &&
          other.basisAmount == this.basisAmount &&
          other.unitName == this.unitName &&
          other.lastUsedTime == this.lastUsedTime);
}

class PackagedFoodsCompanion extends UpdateCompanion<PackagedFoodRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> kj;
  final Value<double> carbs;
  final Value<double> protein;
  final Value<double> fat;
  final Value<double> netContent;
  final Value<double> basisAmount;
  final Value<String> unitName;
  final Value<DateTime> lastUsedTime;
  const PackagedFoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kj = const Value.absent(),
    this.carbs = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.netContent = const Value.absent(),
    this.basisAmount = const Value.absent(),
    this.unitName = const Value.absent(),
    this.lastUsedTime = const Value.absent(),
  });
  PackagedFoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double kj,
    required double carbs,
    required double protein,
    required double fat,
    required double netContent,
    required double basisAmount,
    required String unitName,
    required DateTime lastUsedTime,
  }) : name = Value(name),
       kj = Value(kj),
       carbs = Value(carbs),
       protein = Value(protein),
       fat = Value(fat),
       netContent = Value(netContent),
       basisAmount = Value(basisAmount),
       unitName = Value(unitName),
       lastUsedTime = Value(lastUsedTime);
  static Insertable<PackagedFoodRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? kj,
    Expression<double>? carbs,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? netContent,
    Expression<double>? basisAmount,
    Expression<String>? unitName,
    Expression<DateTime>? lastUsedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kj != null) 'kj': kj,
      if (carbs != null) 'carbs': carbs,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (netContent != null) 'net_content': netContent,
      if (basisAmount != null) 'basis_amount': basisAmount,
      if (unitName != null) 'unit_name': unitName,
      if (lastUsedTime != null) 'last_used_time': lastUsedTime,
    });
  }

  PackagedFoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? kj,
    Value<double>? carbs,
    Value<double>? protein,
    Value<double>? fat,
    Value<double>? netContent,
    Value<double>? basisAmount,
    Value<String>? unitName,
    Value<DateTime>? lastUsedTime,
  }) {
    return PackagedFoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kj: kj ?? this.kj,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      netContent: netContent ?? this.netContent,
      basisAmount: basisAmount ?? this.basisAmount,
      unitName: unitName ?? this.unitName,
      lastUsedTime: lastUsedTime ?? this.lastUsedTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kj.present) {
      map['kj'] = Variable<double>(kj.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (netContent.present) {
      map['net_content'] = Variable<double>(netContent.value);
    }
    if (basisAmount.present) {
      map['basis_amount'] = Variable<double>(basisAmount.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (lastUsedTime.present) {
      map['last_used_time'] = Variable<DateTime>(lastUsedTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackagedFoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('netContent: $netContent, ')
          ..write('basisAmount: $basisAmount, ')
          ..write('unitName: $unitName, ')
          ..write('lastUsedTime: $lastUsedTime')
          ..write(')'))
        .toString();
  }
}

class $CustomFoodsTable extends CustomFoods
    with TableInfo<$CustomFoodsTable, CustomFoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kjMeta = const VerificationMeta('kj');
  @override
  late final GeneratedColumn<double> kj = GeneratedColumn<double>(
    'kj',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basisAmountMeta = const VerificationMeta(
    'basisAmount',
  );
  @override
  late final GeneratedColumn<double> basisAmount = GeneratedColumn<double>(
    'basis_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedTimeMeta = const VerificationMeta(
    'lastUsedTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedTime = GeneratedColumn<DateTime>(
    'last_used_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kj,
    carbs,
    protein,
    fat,
    basisAmount,
    unitName,
    lastUsedTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFoodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kj')) {
      context.handle(_kjMeta, kj.isAcceptableOrUnknown(data['kj']!, _kjMeta));
    } else if (isInserting) {
      context.missing(_kjMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('basis_amount')) {
      context.handle(
        _basisAmountMeta,
        basisAmount.isAcceptableOrUnknown(
          data['basis_amount']!,
          _basisAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_basisAmountMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    if (data.containsKey('last_used_time')) {
      context.handle(
        _lastUsedTimeMeta,
        lastUsedTime.isAcceptableOrUnknown(
          data['last_used_time']!,
          _lastUsedTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUsedTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFoodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kj: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kj'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      basisAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}basis_amount'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
      lastUsedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_time'],
      )!,
    );
  }

  @override
  $CustomFoodsTable createAlias(String alias) {
    return $CustomFoodsTable(attachedDatabase, alias);
  }
}

class CustomFoodRow extends DataClass implements Insertable<CustomFoodRow> {
  final int id;
  final String name;
  final double kj;
  final double carbs;
  final double protein;
  final double fat;
  final double basisAmount;
  final String unitName;
  final DateTime lastUsedTime;
  const CustomFoodRow({
    required this.id,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.basisAmount,
    required this.unitName,
    required this.lastUsedTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['kj'] = Variable<double>(kj);
    map['carbs'] = Variable<double>(carbs);
    map['protein'] = Variable<double>(protein);
    map['fat'] = Variable<double>(fat);
    map['basis_amount'] = Variable<double>(basisAmount);
    map['unit_name'] = Variable<String>(unitName);
    map['last_used_time'] = Variable<DateTime>(lastUsedTime);
    return map;
  }

  CustomFoodsCompanion toCompanion(bool nullToAbsent) {
    return CustomFoodsCompanion(
      id: Value(id),
      name: Value(name),
      kj: Value(kj),
      carbs: Value(carbs),
      protein: Value(protein),
      fat: Value(fat),
      basisAmount: Value(basisAmount),
      unitName: Value(unitName),
      lastUsedTime: Value(lastUsedTime),
    );
  }

  factory CustomFoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFoodRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kj: serializer.fromJson<double>(json['kj']),
      carbs: serializer.fromJson<double>(json['carbs']),
      protein: serializer.fromJson<double>(json['protein']),
      fat: serializer.fromJson<double>(json['fat']),
      basisAmount: serializer.fromJson<double>(json['basisAmount']),
      unitName: serializer.fromJson<String>(json['unitName']),
      lastUsedTime: serializer.fromJson<DateTime>(json['lastUsedTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kj': serializer.toJson<double>(kj),
      'carbs': serializer.toJson<double>(carbs),
      'protein': serializer.toJson<double>(protein),
      'fat': serializer.toJson<double>(fat),
      'basisAmount': serializer.toJson<double>(basisAmount),
      'unitName': serializer.toJson<String>(unitName),
      'lastUsedTime': serializer.toJson<DateTime>(lastUsedTime),
    };
  }

  CustomFoodRow copyWith({
    int? id,
    String? name,
    double? kj,
    double? carbs,
    double? protein,
    double? fat,
    double? basisAmount,
    String? unitName,
    DateTime? lastUsedTime,
  }) => CustomFoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kj: kj ?? this.kj,
    carbs: carbs ?? this.carbs,
    protein: protein ?? this.protein,
    fat: fat ?? this.fat,
    basisAmount: basisAmount ?? this.basisAmount,
    unitName: unitName ?? this.unitName,
    lastUsedTime: lastUsedTime ?? this.lastUsedTime,
  );
  CustomFoodRow copyWithCompanion(CustomFoodsCompanion data) {
    return CustomFoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kj: data.kj.present ? data.kj.value : this.kj,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      basisAmount: data.basisAmount.present
          ? data.basisAmount.value
          : this.basisAmount,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      lastUsedTime: data.lastUsedTime.present
          ? data.lastUsedTime.value
          : this.lastUsedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('basisAmount: $basisAmount, ')
          ..write('unitName: $unitName, ')
          ..write('lastUsedTime: $lastUsedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kj,
    carbs,
    protein,
    fat,
    basisAmount,
    unitName,
    lastUsedTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kj == this.kj &&
          other.carbs == this.carbs &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.basisAmount == this.basisAmount &&
          other.unitName == this.unitName &&
          other.lastUsedTime == this.lastUsedTime);
}

class CustomFoodsCompanion extends UpdateCompanion<CustomFoodRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> kj;
  final Value<double> carbs;
  final Value<double> protein;
  final Value<double> fat;
  final Value<double> basisAmount;
  final Value<String> unitName;
  final Value<DateTime> lastUsedTime;
  const CustomFoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kj = const Value.absent(),
    this.carbs = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.basisAmount = const Value.absent(),
    this.unitName = const Value.absent(),
    this.lastUsedTime = const Value.absent(),
  });
  CustomFoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double kj,
    required double carbs,
    required double protein,
    required double fat,
    required double basisAmount,
    required String unitName,
    required DateTime lastUsedTime,
  }) : name = Value(name),
       kj = Value(kj),
       carbs = Value(carbs),
       protein = Value(protein),
       fat = Value(fat),
       basisAmount = Value(basisAmount),
       unitName = Value(unitName),
       lastUsedTime = Value(lastUsedTime);
  static Insertable<CustomFoodRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? kj,
    Expression<double>? carbs,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? basisAmount,
    Expression<String>? unitName,
    Expression<DateTime>? lastUsedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kj != null) 'kj': kj,
      if (carbs != null) 'carbs': carbs,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (basisAmount != null) 'basis_amount': basisAmount,
      if (unitName != null) 'unit_name': unitName,
      if (lastUsedTime != null) 'last_used_time': lastUsedTime,
    });
  }

  CustomFoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? kj,
    Value<double>? carbs,
    Value<double>? protein,
    Value<double>? fat,
    Value<double>? basisAmount,
    Value<String>? unitName,
    Value<DateTime>? lastUsedTime,
  }) {
    return CustomFoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kj: kj ?? this.kj,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      basisAmount: basisAmount ?? this.basisAmount,
      unitName: unitName ?? this.unitName,
      lastUsedTime: lastUsedTime ?? this.lastUsedTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kj.present) {
      map['kj'] = Variable<double>(kj.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (basisAmount.present) {
      map['basis_amount'] = Variable<double>(basisAmount.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (lastUsedTime.present) {
      map['last_used_time'] = Variable<DateTime>(lastUsedTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('basisAmount: $basisAmount, ')
          ..write('unitName: $unitName, ')
          ..write('lastUsedTime: $lastUsedTime')
          ..write(')'))
        .toString();
  }
}

class $PackagedMealsTable extends PackagedMeals
    with TableInfo<$PackagedMealsTable, PackagedMealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackagedMealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packagedFoodIdMeta = const VerificationMeta(
    'packagedFoodId',
  );
  @override
  late final GeneratedColumn<int> packagedFoodId = GeneratedColumn<int>(
    'packaged_food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packaged_foods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createTimeMeta = const VerificationMeta(
    'createTime',
  );
  @override
  late final GeneratedColumn<DateTime> createTime = GeneratedColumn<DateTime>(
    'create_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packagedFoodId,
    quantity,
    createTime,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packaged_meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackagedMealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('packaged_food_id')) {
      context.handle(
        _packagedFoodIdMeta,
        packagedFoodId.isAcceptableOrUnknown(
          data['packaged_food_id']!,
          _packagedFoodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packagedFoodIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
        _createTimeMeta,
        createTime.isAcceptableOrUnknown(data['create_time']!, _createTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_createTimeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackagedMealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackagedMealRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packagedFoodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}packaged_food_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      createTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}create_time'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PackagedMealsTable createAlias(String alias) {
    return $PackagedMealsTable(attachedDatabase, alias);
  }
}

class PackagedMealRow extends DataClass implements Insertable<PackagedMealRow> {
  final int id;
  final int packagedFoodId;
  final double quantity;
  final DateTime createTime;
  final String? note;
  const PackagedMealRow({
    required this.id,
    required this.packagedFoodId,
    required this.quantity,
    required this.createTime,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['packaged_food_id'] = Variable<int>(packagedFoodId);
    map['quantity'] = Variable<double>(quantity);
    map['create_time'] = Variable<DateTime>(createTime);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PackagedMealsCompanion toCompanion(bool nullToAbsent) {
    return PackagedMealsCompanion(
      id: Value(id),
      packagedFoodId: Value(packagedFoodId),
      quantity: Value(quantity),
      createTime: Value(createTime),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PackagedMealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackagedMealRow(
      id: serializer.fromJson<int>(json['id']),
      packagedFoodId: serializer.fromJson<int>(json['packagedFoodId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packagedFoodId': serializer.toJson<int>(packagedFoodId),
      'quantity': serializer.toJson<double>(quantity),
      'createTime': serializer.toJson<DateTime>(createTime),
      'note': serializer.toJson<String?>(note),
    };
  }

  PackagedMealRow copyWith({
    int? id,
    int? packagedFoodId,
    double? quantity,
    DateTime? createTime,
    Value<String?> note = const Value.absent(),
  }) => PackagedMealRow(
    id: id ?? this.id,
    packagedFoodId: packagedFoodId ?? this.packagedFoodId,
    quantity: quantity ?? this.quantity,
    createTime: createTime ?? this.createTime,
    note: note.present ? note.value : this.note,
  );
  PackagedMealRow copyWithCompanion(PackagedMealsCompanion data) {
    return PackagedMealRow(
      id: data.id.present ? data.id.value : this.id,
      packagedFoodId: data.packagedFoodId.present
          ? data.packagedFoodId.value
          : this.packagedFoodId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      createTime: data.createTime.present
          ? data.createTime.value
          : this.createTime,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackagedMealRow(')
          ..write('id: $id, ')
          ..write('packagedFoodId: $packagedFoodId, ')
          ..write('quantity: $quantity, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packagedFoodId, quantity, createTime, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackagedMealRow &&
          other.id == this.id &&
          other.packagedFoodId == this.packagedFoodId &&
          other.quantity == this.quantity &&
          other.createTime == this.createTime &&
          other.note == this.note);
}

class PackagedMealsCompanion extends UpdateCompanion<PackagedMealRow> {
  final Value<int> id;
  final Value<int> packagedFoodId;
  final Value<double> quantity;
  final Value<DateTime> createTime;
  final Value<String?> note;
  const PackagedMealsCompanion({
    this.id = const Value.absent(),
    this.packagedFoodId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.createTime = const Value.absent(),
    this.note = const Value.absent(),
  });
  PackagedMealsCompanion.insert({
    this.id = const Value.absent(),
    required int packagedFoodId,
    required double quantity,
    required DateTime createTime,
    this.note = const Value.absent(),
  }) : packagedFoodId = Value(packagedFoodId),
       quantity = Value(quantity),
       createTime = Value(createTime);
  static Insertable<PackagedMealRow> custom({
    Expression<int>? id,
    Expression<int>? packagedFoodId,
    Expression<double>? quantity,
    Expression<DateTime>? createTime,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packagedFoodId != null) 'packaged_food_id': packagedFoodId,
      if (quantity != null) 'quantity': quantity,
      if (createTime != null) 'create_time': createTime,
      if (note != null) 'note': note,
    });
  }

  PackagedMealsCompanion copyWith({
    Value<int>? id,
    Value<int>? packagedFoodId,
    Value<double>? quantity,
    Value<DateTime>? createTime,
    Value<String?>? note,
  }) {
    return PackagedMealsCompanion(
      id: id ?? this.id,
      packagedFoodId: packagedFoodId ?? this.packagedFoodId,
      quantity: quantity ?? this.quantity,
      createTime: createTime ?? this.createTime,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packagedFoodId.present) {
      map['packaged_food_id'] = Variable<int>(packagedFoodId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackagedMealsCompanion(')
          ..write('id: $id, ')
          ..write('packagedFoodId: $packagedFoodId, ')
          ..write('quantity: $quantity, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CustomMealsTable extends CustomMeals
    with TableInfo<$CustomMealsTable, CustomMealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomMealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customFoodIdMeta = const VerificationMeta(
    'customFoodId',
  );
  @override
  late final GeneratedColumn<int> customFoodId = GeneratedColumn<int>(
    'custom_food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES custom_foods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _netContentMeta = const VerificationMeta(
    'netContent',
  );
  @override
  late final GeneratedColumn<double> netContent = GeneratedColumn<double>(
    'net_content',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createTimeMeta = const VerificationMeta(
    'createTime',
  );
  @override
  late final GeneratedColumn<DateTime> createTime = GeneratedColumn<DateTime>(
    'create_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customFoodId,
    netContent,
    createTime,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomMealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('custom_food_id')) {
      context.handle(
        _customFoodIdMeta,
        customFoodId.isAcceptableOrUnknown(
          data['custom_food_id']!,
          _customFoodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customFoodIdMeta);
    }
    if (data.containsKey('net_content')) {
      context.handle(
        _netContentMeta,
        netContent.isAcceptableOrUnknown(data['net_content']!, _netContentMeta),
      );
    } else if (isInserting) {
      context.missing(_netContentMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
        _createTimeMeta,
        createTime.isAcceptableOrUnknown(data['create_time']!, _createTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_createTimeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomMealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomMealRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customFoodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_food_id'],
      )!,
      netContent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}net_content'],
      )!,
      createTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}create_time'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $CustomMealsTable createAlias(String alias) {
    return $CustomMealsTable(attachedDatabase, alias);
  }
}

class CustomMealRow extends DataClass implements Insertable<CustomMealRow> {
  final int id;
  final int customFoodId;
  final double netContent;
  final DateTime createTime;
  final String? note;
  const CustomMealRow({
    required this.id,
    required this.customFoodId,
    required this.netContent,
    required this.createTime,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['custom_food_id'] = Variable<int>(customFoodId);
    map['net_content'] = Variable<double>(netContent);
    map['create_time'] = Variable<DateTime>(createTime);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CustomMealsCompanion toCompanion(bool nullToAbsent) {
    return CustomMealsCompanion(
      id: Value(id),
      customFoodId: Value(customFoodId),
      netContent: Value(netContent),
      createTime: Value(createTime),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CustomMealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomMealRow(
      id: serializer.fromJson<int>(json['id']),
      customFoodId: serializer.fromJson<int>(json['customFoodId']),
      netContent: serializer.fromJson<double>(json['netContent']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customFoodId': serializer.toJson<int>(customFoodId),
      'netContent': serializer.toJson<double>(netContent),
      'createTime': serializer.toJson<DateTime>(createTime),
      'note': serializer.toJson<String?>(note),
    };
  }

  CustomMealRow copyWith({
    int? id,
    int? customFoodId,
    double? netContent,
    DateTime? createTime,
    Value<String?> note = const Value.absent(),
  }) => CustomMealRow(
    id: id ?? this.id,
    customFoodId: customFoodId ?? this.customFoodId,
    netContent: netContent ?? this.netContent,
    createTime: createTime ?? this.createTime,
    note: note.present ? note.value : this.note,
  );
  CustomMealRow copyWithCompanion(CustomMealsCompanion data) {
    return CustomMealRow(
      id: data.id.present ? data.id.value : this.id,
      customFoodId: data.customFoodId.present
          ? data.customFoodId.value
          : this.customFoodId,
      netContent: data.netContent.present
          ? data.netContent.value
          : this.netContent,
      createTime: data.createTime.present
          ? data.createTime.value
          : this.createTime,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomMealRow(')
          ..write('id: $id, ')
          ..write('customFoodId: $customFoodId, ')
          ..write('netContent: $netContent, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, customFoodId, netContent, createTime, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomMealRow &&
          other.id == this.id &&
          other.customFoodId == this.customFoodId &&
          other.netContent == this.netContent &&
          other.createTime == this.createTime &&
          other.note == this.note);
}

class CustomMealsCompanion extends UpdateCompanion<CustomMealRow> {
  final Value<int> id;
  final Value<int> customFoodId;
  final Value<double> netContent;
  final Value<DateTime> createTime;
  final Value<String?> note;
  const CustomMealsCompanion({
    this.id = const Value.absent(),
    this.customFoodId = const Value.absent(),
    this.netContent = const Value.absent(),
    this.createTime = const Value.absent(),
    this.note = const Value.absent(),
  });
  CustomMealsCompanion.insert({
    this.id = const Value.absent(),
    required int customFoodId,
    required double netContent,
    required DateTime createTime,
    this.note = const Value.absent(),
  }) : customFoodId = Value(customFoodId),
       netContent = Value(netContent),
       createTime = Value(createTime);
  static Insertable<CustomMealRow> custom({
    Expression<int>? id,
    Expression<int>? customFoodId,
    Expression<double>? netContent,
    Expression<DateTime>? createTime,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customFoodId != null) 'custom_food_id': customFoodId,
      if (netContent != null) 'net_content': netContent,
      if (createTime != null) 'create_time': createTime,
      if (note != null) 'note': note,
    });
  }

  CustomMealsCompanion copyWith({
    Value<int>? id,
    Value<int>? customFoodId,
    Value<double>? netContent,
    Value<DateTime>? createTime,
    Value<String?>? note,
  }) {
    return CustomMealsCompanion(
      id: id ?? this.id,
      customFoodId: customFoodId ?? this.customFoodId,
      netContent: netContent ?? this.netContent,
      createTime: createTime ?? this.createTime,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customFoodId.present) {
      map['custom_food_id'] = Variable<int>(customFoodId.value);
    }
    if (netContent.present) {
      map['net_content'] = Variable<double>(netContent.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomMealsCompanion(')
          ..write('id: $id, ')
          ..write('customFoodId: $customFoodId, ')
          ..write('netContent: $netContent, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $DailySummariesTable extends DailySummaries
    with TableInfo<$DailySummariesTable, DailySummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalKjMeta = const VerificationMeta(
    'totalKj',
  );
  @override
  late final GeneratedColumn<double> totalKj = GeneratedColumn<double>(
    'total_kj',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCarbsMeta = const VerificationMeta(
    'totalCarbs',
  );
  @override
  late final GeneratedColumn<double> totalCarbs = GeneratedColumn<double>(
    'total_carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalProteinMeta = const VerificationMeta(
    'totalProtein',
  );
  @override
  late final GeneratedColumn<double> totalProtein = GeneratedColumn<double>(
    'total_protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFatMeta = const VerificationMeta(
    'totalFat',
  );
  @override
  late final GeneratedColumn<double> totalFat = GeneratedColumn<double>(
    'total_fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealCountMeta = const VerificationMeta(
    'mealCount',
  );
  @override
  late final GeneratedColumn<int> mealCount = GeneratedColumn<int>(
    'meal_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    totalKj,
    totalCarbs,
    totalProtein,
    totalFat,
    mealCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySummaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('total_kj')) {
      context.handle(
        _totalKjMeta,
        totalKj.isAcceptableOrUnknown(data['total_kj']!, _totalKjMeta),
      );
    } else if (isInserting) {
      context.missing(_totalKjMeta);
    }
    if (data.containsKey('total_carbs')) {
      context.handle(
        _totalCarbsMeta,
        totalCarbs.isAcceptableOrUnknown(data['total_carbs']!, _totalCarbsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCarbsMeta);
    }
    if (data.containsKey('total_protein')) {
      context.handle(
        _totalProteinMeta,
        totalProtein.isAcceptableOrUnknown(
          data['total_protein']!,
          _totalProteinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalProteinMeta);
    }
    if (data.containsKey('total_fat')) {
      context.handle(
        _totalFatMeta,
        totalFat.isAcceptableOrUnknown(data['total_fat']!, _totalFatMeta),
      );
    } else if (isInserting) {
      context.missing(_totalFatMeta);
    }
    if (data.containsKey('meal_count')) {
      context.handle(
        _mealCountMeta,
        mealCount.isAcceptableOrUnknown(data['meal_count']!, _mealCountMeta),
      );
    } else if (isInserting) {
      context.missing(_mealCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DailySummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySummaryRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      totalKj: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_kj'],
      )!,
      totalCarbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_carbs'],
      )!,
      totalProtein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_protein'],
      )!,
      totalFat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fat'],
      )!,
      mealCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_count'],
      )!,
    );
  }

  @override
  $DailySummariesTable createAlias(String alias) {
    return $DailySummariesTable(attachedDatabase, alias);
  }
}

class DailySummaryRow extends DataClass implements Insertable<DailySummaryRow> {
  /// Local calendar day in `yyyy-MM-dd` form.
  final String day;
  final double totalKj;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;
  final int mealCount;
  const DailySummaryRow({
    required this.day,
    required this.totalKj,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
    required this.mealCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['total_kj'] = Variable<double>(totalKj);
    map['total_carbs'] = Variable<double>(totalCarbs);
    map['total_protein'] = Variable<double>(totalProtein);
    map['total_fat'] = Variable<double>(totalFat);
    map['meal_count'] = Variable<int>(mealCount);
    return map;
  }

  DailySummariesCompanion toCompanion(bool nullToAbsent) {
    return DailySummariesCompanion(
      day: Value(day),
      totalKj: Value(totalKj),
      totalCarbs: Value(totalCarbs),
      totalProtein: Value(totalProtein),
      totalFat: Value(totalFat),
      mealCount: Value(mealCount),
    );
  }

  factory DailySummaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySummaryRow(
      day: serializer.fromJson<String>(json['day']),
      totalKj: serializer.fromJson<double>(json['totalKj']),
      totalCarbs: serializer.fromJson<double>(json['totalCarbs']),
      totalProtein: serializer.fromJson<double>(json['totalProtein']),
      totalFat: serializer.fromJson<double>(json['totalFat']),
      mealCount: serializer.fromJson<int>(json['mealCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'totalKj': serializer.toJson<double>(totalKj),
      'totalCarbs': serializer.toJson<double>(totalCarbs),
      'totalProtein': serializer.toJson<double>(totalProtein),
      'totalFat': serializer.toJson<double>(totalFat),
      'mealCount': serializer.toJson<int>(mealCount),
    };
  }

  DailySummaryRow copyWith({
    String? day,
    double? totalKj,
    double? totalCarbs,
    double? totalProtein,
    double? totalFat,
    int? mealCount,
  }) => DailySummaryRow(
    day: day ?? this.day,
    totalKj: totalKj ?? this.totalKj,
    totalCarbs: totalCarbs ?? this.totalCarbs,
    totalProtein: totalProtein ?? this.totalProtein,
    totalFat: totalFat ?? this.totalFat,
    mealCount: mealCount ?? this.mealCount,
  );
  DailySummaryRow copyWithCompanion(DailySummariesCompanion data) {
    return DailySummaryRow(
      day: data.day.present ? data.day.value : this.day,
      totalKj: data.totalKj.present ? data.totalKj.value : this.totalKj,
      totalCarbs: data.totalCarbs.present
          ? data.totalCarbs.value
          : this.totalCarbs,
      totalProtein: data.totalProtein.present
          ? data.totalProtein.value
          : this.totalProtein,
      totalFat: data.totalFat.present ? data.totalFat.value : this.totalFat,
      mealCount: data.mealCount.present ? data.mealCount.value : this.mealCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySummaryRow(')
          ..write('day: $day, ')
          ..write('totalKj: $totalKj, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalFat: $totalFat, ')
          ..write('mealCount: $mealCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(day, totalKj, totalCarbs, totalProtein, totalFat, mealCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySummaryRow &&
          other.day == this.day &&
          other.totalKj == this.totalKj &&
          other.totalCarbs == this.totalCarbs &&
          other.totalProtein == this.totalProtein &&
          other.totalFat == this.totalFat &&
          other.mealCount == this.mealCount);
}

class DailySummariesCompanion extends UpdateCompanion<DailySummaryRow> {
  final Value<String> day;
  final Value<double> totalKj;
  final Value<double> totalCarbs;
  final Value<double> totalProtein;
  final Value<double> totalFat;
  final Value<int> mealCount;
  final Value<int> rowid;
  const DailySummariesCompanion({
    this.day = const Value.absent(),
    this.totalKj = const Value.absent(),
    this.totalCarbs = const Value.absent(),
    this.totalProtein = const Value.absent(),
    this.totalFat = const Value.absent(),
    this.mealCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySummariesCompanion.insert({
    required String day,
    required double totalKj,
    required double totalCarbs,
    required double totalProtein,
    required double totalFat,
    required int mealCount,
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       totalKj = Value(totalKj),
       totalCarbs = Value(totalCarbs),
       totalProtein = Value(totalProtein),
       totalFat = Value(totalFat),
       mealCount = Value(mealCount);
  static Insertable<DailySummaryRow> custom({
    Expression<String>? day,
    Expression<double>? totalKj,
    Expression<double>? totalCarbs,
    Expression<double>? totalProtein,
    Expression<double>? totalFat,
    Expression<int>? mealCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (totalKj != null) 'total_kj': totalKj,
      if (totalCarbs != null) 'total_carbs': totalCarbs,
      if (totalProtein != null) 'total_protein': totalProtein,
      if (totalFat != null) 'total_fat': totalFat,
      if (mealCount != null) 'meal_count': mealCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySummariesCompanion copyWith({
    Value<String>? day,
    Value<double>? totalKj,
    Value<double>? totalCarbs,
    Value<double>? totalProtein,
    Value<double>? totalFat,
    Value<int>? mealCount,
    Value<int>? rowid,
  }) {
    return DailySummariesCompanion(
      day: day ?? this.day,
      totalKj: totalKj ?? this.totalKj,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalProtein: totalProtein ?? this.totalProtein,
      totalFat: totalFat ?? this.totalFat,
      mealCount: mealCount ?? this.mealCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (totalKj.present) {
      map['total_kj'] = Variable<double>(totalKj.value);
    }
    if (totalCarbs.present) {
      map['total_carbs'] = Variable<double>(totalCarbs.value);
    }
    if (totalProtein.present) {
      map['total_protein'] = Variable<double>(totalProtein.value);
    }
    if (totalFat.present) {
      map['total_fat'] = Variable<double>(totalFat.value);
    }
    if (mealCount.present) {
      map['meal_count'] = Variable<int>(mealCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySummariesCompanion(')
          ..write('day: $day, ')
          ..write('totalKj: $totalKj, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalFat: $totalFat, ')
          ..write('mealCount: $mealCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PackagedFoodsTable packagedFoods = $PackagedFoodsTable(this);
  late final $CustomFoodsTable customFoods = $CustomFoodsTable(this);
  late final $PackagedMealsTable packagedMeals = $PackagedMealsTable(this);
  late final $CustomMealsTable customMeals = $CustomMealsTable(this);
  late final $DailySummariesTable dailySummaries = $DailySummariesTable(this);
  late final Index idxPackagedFoodsLastUsed = Index(
    'idx_packaged_foods_last_used',
    'CREATE INDEX idx_packaged_foods_last_used ON packaged_foods (last_used_time)',
  );
  late final Index idxCustomFoodsLastUsed = Index(
    'idx_custom_foods_last_used',
    'CREATE INDEX idx_custom_foods_last_used ON custom_foods (last_used_time)',
  );
  late final Index idxPackagedMealsCreateTime = Index(
    'idx_packaged_meals_create_time',
    'CREATE INDEX idx_packaged_meals_create_time ON packaged_meals (create_time)',
  );
  late final Index idxCustomMealsCreateTime = Index(
    'idx_custom_meals_create_time',
    'CREATE INDEX idx_custom_meals_create_time ON custom_meals (create_time)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    packagedFoods,
    customFoods,
    packagedMeals,
    customMeals,
    dailySummaries,
    idxPackagedFoodsLastUsed,
    idxCustomFoodsLastUsed,
    idxPackagedMealsCreateTime,
    idxCustomMealsCreateTime,
  ];
}

typedef $$PackagedFoodsTableCreateCompanionBuilder =
    PackagedFoodsCompanion Function({
      Value<int> id,
      required String name,
      required double kj,
      required double carbs,
      required double protein,
      required double fat,
      required double netContent,
      required double basisAmount,
      required String unitName,
      required DateTime lastUsedTime,
    });
typedef $$PackagedFoodsTableUpdateCompanionBuilder =
    PackagedFoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> kj,
      Value<double> carbs,
      Value<double> protein,
      Value<double> fat,
      Value<double> netContent,
      Value<double> basisAmount,
      Value<String> unitName,
      Value<DateTime> lastUsedTime,
    });

final class $$PackagedFoodsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PackagedFoodsTable, PackagedFoodRow> {
  $$PackagedFoodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PackagedMealsTable, List<PackagedMealRow>>
  _packagedMealsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packagedMeals,
    aliasName: 'packaged_foods__id__packaged_meals__packaged_food_id',
  );

  $$PackagedMealsTableProcessedTableManager get packagedMealsRefs {
    final manager = $$PackagedMealsTableTableManager(
      $_db,
      $_db.packagedMeals,
    ).filter((f) => f.packagedFoodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_packagedMealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PackagedFoodsTableFilterComposer
    extends Composer<_$AppDatabase, $PackagedFoodsTable> {
  $$PackagedFoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kj => $composableBuilder(
    column: $table.kj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netContent => $composableBuilder(
    column: $table.netContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basisAmount => $composableBuilder(
    column: $table.basisAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> packagedMealsRefs(
    Expression<bool> Function($$PackagedMealsTableFilterComposer f) f,
  ) {
    final $$PackagedMealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packagedMeals,
      getReferencedColumn: (t) => t.packagedFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagedMealsTableFilterComposer(
            $db: $db,
            $table: $db.packagedMeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackagedFoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackagedFoodsTable> {
  $$PackagedFoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kj => $composableBuilder(
    column: $table.kj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netContent => $composableBuilder(
    column: $table.netContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basisAmount => $composableBuilder(
    column: $table.basisAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackagedFoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackagedFoodsTable> {
  $$PackagedFoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get kj =>
      $composableBuilder(column: $table.kj, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get netContent => $composableBuilder(
    column: $table.netContent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get basisAmount => $composableBuilder(
    column: $table.basisAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => column,
  );

  Expression<T> packagedMealsRefs<T extends Object>(
    Expression<T> Function($$PackagedMealsTableAnnotationComposer a) f,
  ) {
    final $$PackagedMealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packagedMeals,
      getReferencedColumn: (t) => t.packagedFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagedMealsTableAnnotationComposer(
            $db: $db,
            $table: $db.packagedMeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackagedFoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackagedFoodsTable,
          PackagedFoodRow,
          $$PackagedFoodsTableFilterComposer,
          $$PackagedFoodsTableOrderingComposer,
          $$PackagedFoodsTableAnnotationComposer,
          $$PackagedFoodsTableCreateCompanionBuilder,
          $$PackagedFoodsTableUpdateCompanionBuilder,
          (PackagedFoodRow, $$PackagedFoodsTableReferences),
          PackagedFoodRow,
          PrefetchHooks Function({bool packagedMealsRefs})
        > {
  $$PackagedFoodsTableTableManager(_$AppDatabase db, $PackagedFoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackagedFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackagedFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackagedFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> kj = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double> netContent = const Value.absent(),
                Value<double> basisAmount = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<DateTime> lastUsedTime = const Value.absent(),
              }) => PackagedFoodsCompanion(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                netContent: netContent,
                basisAmount: basisAmount,
                unitName: unitName,
                lastUsedTime: lastUsedTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double kj,
                required double carbs,
                required double protein,
                required double fat,
                required double netContent,
                required double basisAmount,
                required String unitName,
                required DateTime lastUsedTime,
              }) => PackagedFoodsCompanion.insert(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                netContent: netContent,
                basisAmount: basisAmount,
                unitName: unitName,
                lastUsedTime: lastUsedTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PackagedFoodsTable, PackagedFoodRow>(table),
                  $$PackagedFoodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packagedMealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (packagedMealsRefs) db.packagedMeals,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (packagedMealsRefs)
                    await $_getPrefetchedData<
                      PackagedFoodRow,
                      $PackagedFoodsTable,
                      PackagedMealRow
                    >(
                      currentTable: table,
                      referencedTable: $$PackagedFoodsTableReferences
                          ._packagedMealsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PackagedFoodsTableReferences(
                            db,
                            table,
                            p0,
                          ).packagedMealsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.packagedFoodId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PackagedFoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackagedFoodsTable,
      PackagedFoodRow,
      $$PackagedFoodsTableFilterComposer,
      $$PackagedFoodsTableOrderingComposer,
      $$PackagedFoodsTableAnnotationComposer,
      $$PackagedFoodsTableCreateCompanionBuilder,
      $$PackagedFoodsTableUpdateCompanionBuilder,
      (PackagedFoodRow, $$PackagedFoodsTableReferences),
      PackagedFoodRow,
      PrefetchHooks Function({bool packagedMealsRefs})
    >;
typedef $$CustomFoodsTableCreateCompanionBuilder =
    CustomFoodsCompanion Function({
      Value<int> id,
      required String name,
      required double kj,
      required double carbs,
      required double protein,
      required double fat,
      required double basisAmount,
      required String unitName,
      required DateTime lastUsedTime,
    });
typedef $$CustomFoodsTableUpdateCompanionBuilder =
    CustomFoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> kj,
      Value<double> carbs,
      Value<double> protein,
      Value<double> fat,
      Value<double> basisAmount,
      Value<String> unitName,
      Value<DateTime> lastUsedTime,
    });

final class $$CustomFoodsTableReferences
    extends BaseReferences<_$AppDatabase, $CustomFoodsTable, CustomFoodRow> {
  $$CustomFoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomMealsTable, List<CustomMealRow>>
  _customMealsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customMeals,
    aliasName: 'custom_foods__id__custom_meals__custom_food_id',
  );

  $$CustomMealsTableProcessedTableManager get customMealsRefs {
    final manager = $$CustomMealsTableTableManager(
      $_db,
      $_db.customMeals,
    ).filter((f) => f.customFoodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_customMealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomFoodsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFoodsTable> {
  $$CustomFoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kj => $composableBuilder(
    column: $table.kj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basisAmount => $composableBuilder(
    column: $table.basisAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customMealsRefs(
    Expression<bool> Function($$CustomMealsTableFilterComposer f) f,
  ) {
    final $$CustomMealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customMeals,
      getReferencedColumn: (t) => t.customFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomMealsTableFilterComposer(
            $db: $db,
            $table: $db.customMeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomFoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFoodsTable> {
  $$CustomFoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kj => $composableBuilder(
    column: $table.kj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basisAmount => $composableBuilder(
    column: $table.basisAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomFoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFoodsTable> {
  $$CustomFoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get kj =>
      $composableBuilder(column: $table.kj, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get basisAmount => $composableBuilder(
    column: $table.basisAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => column,
  );

  Expression<T> customMealsRefs<T extends Object>(
    Expression<T> Function($$CustomMealsTableAnnotationComposer a) f,
  ) {
    final $$CustomMealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customMeals,
      getReferencedColumn: (t) => t.customFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomMealsTableAnnotationComposer(
            $db: $db,
            $table: $db.customMeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomFoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFoodsTable,
          CustomFoodRow,
          $$CustomFoodsTableFilterComposer,
          $$CustomFoodsTableOrderingComposer,
          $$CustomFoodsTableAnnotationComposer,
          $$CustomFoodsTableCreateCompanionBuilder,
          $$CustomFoodsTableUpdateCompanionBuilder,
          (CustomFoodRow, $$CustomFoodsTableReferences),
          CustomFoodRow,
          PrefetchHooks Function({bool customMealsRefs})
        > {
  $$CustomFoodsTableTableManager(_$AppDatabase db, $CustomFoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> kj = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double> basisAmount = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<DateTime> lastUsedTime = const Value.absent(),
              }) => CustomFoodsCompanion(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                basisAmount: basisAmount,
                unitName: unitName,
                lastUsedTime: lastUsedTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double kj,
                required double carbs,
                required double protein,
                required double fat,
                required double basisAmount,
                required String unitName,
                required DateTime lastUsedTime,
              }) => CustomFoodsCompanion.insert(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                basisAmount: basisAmount,
                unitName: unitName,
                lastUsedTime: lastUsedTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomFoodsTable, CustomFoodRow>(table),
                  $$CustomFoodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customMealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (customMealsRefs) db.customMeals],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (customMealsRefs)
                    await $_getPrefetchedData<
                      CustomFoodRow,
                      $CustomFoodsTable,
                      CustomMealRow
                    >(
                      currentTable: table,
                      referencedTable: $$CustomFoodsTableReferences
                          ._customMealsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomFoodsTableReferences(
                            db,
                            table,
                            p0,
                          ).customMealsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.customFoodId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomFoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFoodsTable,
      CustomFoodRow,
      $$CustomFoodsTableFilterComposer,
      $$CustomFoodsTableOrderingComposer,
      $$CustomFoodsTableAnnotationComposer,
      $$CustomFoodsTableCreateCompanionBuilder,
      $$CustomFoodsTableUpdateCompanionBuilder,
      (CustomFoodRow, $$CustomFoodsTableReferences),
      CustomFoodRow,
      PrefetchHooks Function({bool customMealsRefs})
    >;
typedef $$PackagedMealsTableCreateCompanionBuilder =
    PackagedMealsCompanion Function({
      Value<int> id,
      required int packagedFoodId,
      required double quantity,
      required DateTime createTime,
      Value<String?> note,
    });
typedef $$PackagedMealsTableUpdateCompanionBuilder =
    PackagedMealsCompanion Function({
      Value<int> id,
      Value<int> packagedFoodId,
      Value<double> quantity,
      Value<DateTime> createTime,
      Value<String?> note,
    });

final class $$PackagedMealsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PackagedMealsTable, PackagedMealRow> {
  $$PackagedMealsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PackagedFoodsTable _packagedFoodIdTable(_$AppDatabase db) => db
      .packagedFoods
      .createAlias('packaged_meals__packaged_food_id__packaged_foods__id');

  $$PackagedFoodsTableProcessedTableManager get packagedFoodId {
    final $_column = $_itemColumn<int>('packaged_food_id')!;

    final manager = $$PackagedFoodsTableTableManager(
      $_db,
      $_db.packagedFoods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packagedFoodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PackagedMealsTableFilterComposer
    extends Composer<_$AppDatabase, $PackagedMealsTable> {
  $$PackagedMealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PackagedFoodsTableFilterComposer get packagedFoodId {
    final $$PackagedFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packagedFoodId,
      referencedTable: $db.packagedFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagedFoodsTableFilterComposer(
            $db: $db,
            $table: $db.packagedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackagedMealsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackagedMealsTable> {
  $$PackagedMealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PackagedFoodsTableOrderingComposer get packagedFoodId {
    final $$PackagedFoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packagedFoodId,
      referencedTable: $db.packagedFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagedFoodsTableOrderingComposer(
            $db: $db,
            $table: $db.packagedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackagedMealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackagedMealsTable> {
  $$PackagedMealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PackagedFoodsTableAnnotationComposer get packagedFoodId {
    final $$PackagedFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packagedFoodId,
      referencedTable: $db.packagedFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagedFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.packagedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackagedMealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackagedMealsTable,
          PackagedMealRow,
          $$PackagedMealsTableFilterComposer,
          $$PackagedMealsTableOrderingComposer,
          $$PackagedMealsTableAnnotationComposer,
          $$PackagedMealsTableCreateCompanionBuilder,
          $$PackagedMealsTableUpdateCompanionBuilder,
          (PackagedMealRow, $$PackagedMealsTableReferences),
          PackagedMealRow,
          PrefetchHooks Function({bool packagedFoodId})
        > {
  $$PackagedMealsTableTableManager(_$AppDatabase db, $PackagedMealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackagedMealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackagedMealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackagedMealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> packagedFoodId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<DateTime> createTime = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => PackagedMealsCompanion(
                id: id,
                packagedFoodId: packagedFoodId,
                quantity: quantity,
                createTime: createTime,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int packagedFoodId,
                required double quantity,
                required DateTime createTime,
                Value<String?> note = const Value.absent(),
              }) => PackagedMealsCompanion.insert(
                id: id,
                packagedFoodId: packagedFoodId,
                quantity: quantity,
                createTime: createTime,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PackagedMealsTable, PackagedMealRow>(table),
                  $$PackagedMealsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packagedFoodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packagedFoodId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packagedFoodId,
                        referencedTable: $$PackagedMealsTableReferences
                            ._packagedFoodIdTable(db),
                        referencedColumn: $$PackagedMealsTableReferences
                            ._packagedFoodIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PackagedMealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackagedMealsTable,
      PackagedMealRow,
      $$PackagedMealsTableFilterComposer,
      $$PackagedMealsTableOrderingComposer,
      $$PackagedMealsTableAnnotationComposer,
      $$PackagedMealsTableCreateCompanionBuilder,
      $$PackagedMealsTableUpdateCompanionBuilder,
      (PackagedMealRow, $$PackagedMealsTableReferences),
      PackagedMealRow,
      PrefetchHooks Function({bool packagedFoodId})
    >;
typedef $$CustomMealsTableCreateCompanionBuilder =
    CustomMealsCompanion Function({
      Value<int> id,
      required int customFoodId,
      required double netContent,
      required DateTime createTime,
      Value<String?> note,
    });
typedef $$CustomMealsTableUpdateCompanionBuilder =
    CustomMealsCompanion Function({
      Value<int> id,
      Value<int> customFoodId,
      Value<double> netContent,
      Value<DateTime> createTime,
      Value<String?> note,
    });

final class $$CustomMealsTableReferences
    extends BaseReferences<_$AppDatabase, $CustomMealsTable, CustomMealRow> {
  $$CustomMealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomFoodsTable _customFoodIdTable(_$AppDatabase db) => db
      .customFoods
      .createAlias('custom_meals__custom_food_id__custom_foods__id');

  $$CustomFoodsTableProcessedTableManager get customFoodId {
    final $_column = $_itemColumn<int>('custom_food_id')!;

    final manager = $$CustomFoodsTableTableManager(
      $_db,
      $_db.customFoods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customFoodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomMealsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomMealsTable> {
  $$CustomMealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netContent => $composableBuilder(
    column: $table.netContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomFoodsTableFilterComposer get customFoodId {
    final $$CustomFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customFoodId,
      referencedTable: $db.customFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFoodsTableFilterComposer(
            $db: $db,
            $table: $db.customFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomMealsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomMealsTable> {
  $$CustomMealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netContent => $composableBuilder(
    column: $table.netContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomFoodsTableOrderingComposer get customFoodId {
    final $$CustomFoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customFoodId,
      referencedTable: $db.customFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFoodsTableOrderingComposer(
            $db: $db,
            $table: $db.customFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomMealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomMealsTable> {
  $$CustomMealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get netContent => $composableBuilder(
    column: $table.netContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$CustomFoodsTableAnnotationComposer get customFoodId {
    final $$CustomFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customFoodId,
      referencedTable: $db.customFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.customFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomMealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomMealsTable,
          CustomMealRow,
          $$CustomMealsTableFilterComposer,
          $$CustomMealsTableOrderingComposer,
          $$CustomMealsTableAnnotationComposer,
          $$CustomMealsTableCreateCompanionBuilder,
          $$CustomMealsTableUpdateCompanionBuilder,
          (CustomMealRow, $$CustomMealsTableReferences),
          CustomMealRow,
          PrefetchHooks Function({bool customFoodId})
        > {
  $$CustomMealsTableTableManager(_$AppDatabase db, $CustomMealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomMealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomMealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomMealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> customFoodId = const Value.absent(),
                Value<double> netContent = const Value.absent(),
                Value<DateTime> createTime = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => CustomMealsCompanion(
                id: id,
                customFoodId: customFoodId,
                netContent: netContent,
                createTime: createTime,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int customFoodId,
                required double netContent,
                required DateTime createTime,
                Value<String?> note = const Value.absent(),
              }) => CustomMealsCompanion.insert(
                id: id,
                customFoodId: customFoodId,
                netContent: netContent,
                createTime: createTime,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomMealsTable, CustomMealRow>(table),
                  $$CustomMealsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customFoodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (customFoodId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.customFoodId,
                        referencedTable: $$CustomMealsTableReferences
                            ._customFoodIdTable(db),
                        referencedColumn: $$CustomMealsTableReferences
                            ._customFoodIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomMealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomMealsTable,
      CustomMealRow,
      $$CustomMealsTableFilterComposer,
      $$CustomMealsTableOrderingComposer,
      $$CustomMealsTableAnnotationComposer,
      $$CustomMealsTableCreateCompanionBuilder,
      $$CustomMealsTableUpdateCompanionBuilder,
      (CustomMealRow, $$CustomMealsTableReferences),
      CustomMealRow,
      PrefetchHooks Function({bool customFoodId})
    >;
typedef $$DailySummariesTableCreateCompanionBuilder =
    DailySummariesCompanion Function({
      required String day,
      required double totalKj,
      required double totalCarbs,
      required double totalProtein,
      required double totalFat,
      required int mealCount,
      Value<int> rowid,
    });
typedef $$DailySummariesTableUpdateCompanionBuilder =
    DailySummariesCompanion Function({
      Value<String> day,
      Value<double> totalKj,
      Value<double> totalCarbs,
      Value<double> totalProtein,
      Value<double> totalFat,
      Value<int> mealCount,
      Value<int> rowid,
    });

class $$DailySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalKj => $composableBuilder(
    column: $table.totalKj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFat => $composableBuilder(
    column: $table.totalFat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealCount => $composableBuilder(
    column: $table.mealCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalKj => $composableBuilder(
    column: $table.totalKj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFat => $composableBuilder(
    column: $table.totalFat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealCount => $composableBuilder(
    column: $table.mealCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<double> get totalKj =>
      $composableBuilder(column: $table.totalKj, builder: (column) => column);

  GeneratedColumn<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFat =>
      $composableBuilder(column: $table.totalFat, builder: (column) => column);

  GeneratedColumn<int> get mealCount =>
      $composableBuilder(column: $table.mealCount, builder: (column) => column);
}

class $$DailySummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySummariesTable,
          DailySummaryRow,
          $$DailySummariesTableFilterComposer,
          $$DailySummariesTableOrderingComposer,
          $$DailySummariesTableAnnotationComposer,
          $$DailySummariesTableCreateCompanionBuilder,
          $$DailySummariesTableUpdateCompanionBuilder,
          (
            DailySummaryRow,
            BaseReferences<
              _$AppDatabase,
              $DailySummariesTable,
              DailySummaryRow
            >,
          ),
          DailySummaryRow,
          PrefetchHooks Function()
        > {
  $$DailySummariesTableTableManager(
    _$AppDatabase db,
    $DailySummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<double> totalKj = const Value.absent(),
                Value<double> totalCarbs = const Value.absent(),
                Value<double> totalProtein = const Value.absent(),
                Value<double> totalFat = const Value.absent(),
                Value<int> mealCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySummariesCompanion(
                day: day,
                totalKj: totalKj,
                totalCarbs: totalCarbs,
                totalProtein: totalProtein,
                totalFat: totalFat,
                mealCount: mealCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                required double totalKj,
                required double totalCarbs,
                required double totalProtein,
                required double totalFat,
                required int mealCount,
                Value<int> rowid = const Value.absent(),
              }) => DailySummariesCompanion.insert(
                day: day,
                totalKj: totalKj,
                totalCarbs: totalCarbs,
                totalProtein: totalProtein,
                totalFat: totalFat,
                mealCount: mealCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailySummariesTable, DailySummaryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailySummariesTable,
                    DailySummaryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySummariesTable,
      DailySummaryRow,
      $$DailySummariesTableFilterComposer,
      $$DailySummariesTableOrderingComposer,
      $$DailySummariesTableAnnotationComposer,
      $$DailySummariesTableCreateCompanionBuilder,
      $$DailySummariesTableUpdateCompanionBuilder,
      (
        DailySummaryRow,
        BaseReferences<_$AppDatabase, $DailySummariesTable, DailySummaryRow>,
      ),
      DailySummaryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PackagedFoodsTableTableManager get packagedFoods =>
      $$PackagedFoodsTableTableManager(_db, _db.packagedFoods);
  $$CustomFoodsTableTableManager get customFoods =>
      $$CustomFoodsTableTableManager(_db, _db.customFoods);
  $$PackagedMealsTableTableManager get packagedMeals =>
      $$PackagedMealsTableTableManager(_db, _db.packagedMeals);
  $$CustomMealsTableTableManager get customMeals =>
      $$CustomMealsTableTableManager(_db, _db.customMeals);
  $$DailySummariesTableTableManager get dailySummaries =>
      $$DailySummariesTableTableManager(_db, _db.dailySummaries);
}

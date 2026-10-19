// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PremadeFoodsTable extends PremadeFoods
    with TableInfo<$PremadeFoodsTable, PremadeFoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PremadeFoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _servingAmountMeta = const VerificationMeta(
    'servingAmount',
  );
  @override
  late final GeneratedColumn<double> servingAmount = GeneratedColumn<double>(
    'serving_amount',
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
    servingAmount,
    basisAmount,
    unitName,
    lastUsedTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'premade_foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<PremadeFoodRow> instance, {
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
    if (data.containsKey('serving_amount')) {
      context.handle(
        _servingAmountMeta,
        servingAmount.isAcceptableOrUnknown(
          data['serving_amount']!,
          _servingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_servingAmountMeta);
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
  PremadeFoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PremadeFoodRow(
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
      servingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_amount'],
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
  $PremadeFoodsTable createAlias(String alias) {
    return $PremadeFoodsTable(attachedDatabase, alias);
  }
}

class PremadeFoodRow extends DataClass implements Insertable<PremadeFoodRow> {
  final int id;
  final String name;
  final double kj;
  final double carbs;
  final double protein;
  final double fat;
  final double servingAmount;
  final double basisAmount;
  final String unitName;
  final DateTime lastUsedTime;
  const PremadeFoodRow({
    required this.id,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.servingAmount,
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
    map['serving_amount'] = Variable<double>(servingAmount);
    map['basis_amount'] = Variable<double>(basisAmount);
    map['unit_name'] = Variable<String>(unitName);
    map['last_used_time'] = Variable<DateTime>(lastUsedTime);
    return map;
  }

  PremadeFoodsCompanion toCompanion(bool nullToAbsent) {
    return PremadeFoodsCompanion(
      id: Value(id),
      name: Value(name),
      kj: Value(kj),
      carbs: Value(carbs),
      protein: Value(protein),
      fat: Value(fat),
      servingAmount: Value(servingAmount),
      basisAmount: Value(basisAmount),
      unitName: Value(unitName),
      lastUsedTime: Value(lastUsedTime),
    );
  }

  factory PremadeFoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PremadeFoodRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kj: serializer.fromJson<double>(json['kj']),
      carbs: serializer.fromJson<double>(json['carbs']),
      protein: serializer.fromJson<double>(json['protein']),
      fat: serializer.fromJson<double>(json['fat']),
      servingAmount: serializer.fromJson<double>(json['servingAmount']),
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
      'servingAmount': serializer.toJson<double>(servingAmount),
      'basisAmount': serializer.toJson<double>(basisAmount),
      'unitName': serializer.toJson<String>(unitName),
      'lastUsedTime': serializer.toJson<DateTime>(lastUsedTime),
    };
  }

  PremadeFoodRow copyWith({
    int? id,
    String? name,
    double? kj,
    double? carbs,
    double? protein,
    double? fat,
    double? servingAmount,
    double? basisAmount,
    String? unitName,
    DateTime? lastUsedTime,
  }) => PremadeFoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kj: kj ?? this.kj,
    carbs: carbs ?? this.carbs,
    protein: protein ?? this.protein,
    fat: fat ?? this.fat,
    servingAmount: servingAmount ?? this.servingAmount,
    basisAmount: basisAmount ?? this.basisAmount,
    unitName: unitName ?? this.unitName,
    lastUsedTime: lastUsedTime ?? this.lastUsedTime,
  );
  PremadeFoodRow copyWithCompanion(PremadeFoodsCompanion data) {
    return PremadeFoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kj: data.kj.present ? data.kj.value : this.kj,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      servingAmount: data.servingAmount.present
          ? data.servingAmount.value
          : this.servingAmount,
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
    return (StringBuffer('PremadeFoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('servingAmount: $servingAmount, ')
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
    servingAmount,
    basisAmount,
    unitName,
    lastUsedTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PremadeFoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kj == this.kj &&
          other.carbs == this.carbs &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.servingAmount == this.servingAmount &&
          other.basisAmount == this.basisAmount &&
          other.unitName == this.unitName &&
          other.lastUsedTime == this.lastUsedTime);
}

class PremadeFoodsCompanion extends UpdateCompanion<PremadeFoodRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> kj;
  final Value<double> carbs;
  final Value<double> protein;
  final Value<double> fat;
  final Value<double> servingAmount;
  final Value<double> basisAmount;
  final Value<String> unitName;
  final Value<DateTime> lastUsedTime;
  const PremadeFoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kj = const Value.absent(),
    this.carbs = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.servingAmount = const Value.absent(),
    this.basisAmount = const Value.absent(),
    this.unitName = const Value.absent(),
    this.lastUsedTime = const Value.absent(),
  });
  PremadeFoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double kj,
    required double carbs,
    required double protein,
    required double fat,
    required double servingAmount,
    required double basisAmount,
    required String unitName,
    required DateTime lastUsedTime,
  }) : name = Value(name),
       kj = Value(kj),
       carbs = Value(carbs),
       protein = Value(protein),
       fat = Value(fat),
       servingAmount = Value(servingAmount),
       basisAmount = Value(basisAmount),
       unitName = Value(unitName),
       lastUsedTime = Value(lastUsedTime);
  static Insertable<PremadeFoodRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? kj,
    Expression<double>? carbs,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? servingAmount,
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
      if (servingAmount != null) 'serving_amount': servingAmount,
      if (basisAmount != null) 'basis_amount': basisAmount,
      if (unitName != null) 'unit_name': unitName,
      if (lastUsedTime != null) 'last_used_time': lastUsedTime,
    });
  }

  PremadeFoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? kj,
    Value<double>? carbs,
    Value<double>? protein,
    Value<double>? fat,
    Value<double>? servingAmount,
    Value<double>? basisAmount,
    Value<String>? unitName,
    Value<DateTime>? lastUsedTime,
  }) {
    return PremadeFoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kj: kj ?? this.kj,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      servingAmount: servingAmount ?? this.servingAmount,
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
    if (servingAmount.present) {
      map['serving_amount'] = Variable<double>(servingAmount.value);
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
    return (StringBuffer('PremadeFoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('servingAmount: $servingAmount, ')
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
  final DateTime lastUsedTime;
  const CustomFoodRow({
    required this.id,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
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
    DateTime? lastUsedTime,
  }) => CustomFoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kj: kj ?? this.kj,
    carbs: carbs ?? this.carbs,
    protein: protein ?? this.protein,
    fat: fat ?? this.fat,
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
          ..write('lastUsedTime: $lastUsedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, kj, carbs, protein, fat, lastUsedTime);
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
          other.lastUsedTime == this.lastUsedTime);
}

class CustomFoodsCompanion extends UpdateCompanion<CustomFoodRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> kj;
  final Value<double> carbs;
  final Value<double> protein;
  final Value<double> fat;
  final Value<DateTime> lastUsedTime;
  const CustomFoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kj = const Value.absent(),
    this.carbs = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.lastUsedTime = const Value.absent(),
  });
  CustomFoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double kj,
    required double carbs,
    required double protein,
    required double fat,
    required DateTime lastUsedTime,
  }) : name = Value(name),
       kj = Value(kj),
       carbs = Value(carbs),
       protein = Value(protein),
       fat = Value(fat),
       lastUsedTime = Value(lastUsedTime);
  static Insertable<CustomFoodRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? kj,
    Expression<double>? carbs,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<DateTime>? lastUsedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kj != null) 'kj': kj,
      if (carbs != null) 'carbs': carbs,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
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
    Value<DateTime>? lastUsedTime,
  }) {
    return CustomFoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kj: kj ?? this.kj,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
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
          ..write('lastUsedTime: $lastUsedTime')
          ..write(')'))
        .toString();
  }
}

class $DietLogsTable extends DietLogs
    with TableInfo<$DietLogsTable, DietLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DietLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _premadeFoodIdMeta = const VerificationMeta(
    'premadeFoodId',
  );
  @override
  late final GeneratedColumn<int> premadeFoodId = GeneratedColumn<int>(
    'premade_food_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES premade_foods (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _customFoodIdMeta = const VerificationMeta(
    'customFoodId',
  );
  @override
  late final GeneratedColumn<int> customFoodId = GeneratedColumn<int>(
    'custom_food_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES custom_foods (id) ON DELETE SET NULL',
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
    premadeFoodId,
    customFoodId,
    quantity,
    createTime,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diet_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DietLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('premade_food_id')) {
      context.handle(
        _premadeFoodIdMeta,
        premadeFoodId.isAcceptableOrUnknown(
          data['premade_food_id']!,
          _premadeFoodIdMeta,
        ),
      );
    }
    if (data.containsKey('custom_food_id')) {
      context.handle(
        _customFoodIdMeta,
        customFoodId.isAcceptableOrUnknown(
          data['custom_food_id']!,
          _customFoodIdMeta,
        ),
      );
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
  DietLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DietLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      premadeFoodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}premade_food_id'],
      ),
      customFoodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_food_id'],
      ),
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
  $DietLogsTable createAlias(String alias) {
    return $DietLogsTable(attachedDatabase, alias);
  }
}

class DietLogRow extends DataClass implements Insertable<DietLogRow> {
  final int id;
  final int? premadeFoodId;
  final int? customFoodId;
  final double quantity;
  final DateTime createTime;
  final String? note;
  const DietLogRow({
    required this.id,
    this.premadeFoodId,
    this.customFoodId,
    required this.quantity,
    required this.createTime,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || premadeFoodId != null) {
      map['premade_food_id'] = Variable<int>(premadeFoodId);
    }
    if (!nullToAbsent || customFoodId != null) {
      map['custom_food_id'] = Variable<int>(customFoodId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['create_time'] = Variable<DateTime>(createTime);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DietLogsCompanion toCompanion(bool nullToAbsent) {
    return DietLogsCompanion(
      id: Value(id),
      premadeFoodId: premadeFoodId == null && nullToAbsent
          ? const Value.absent()
          : Value(premadeFoodId),
      customFoodId: customFoodId == null && nullToAbsent
          ? const Value.absent()
          : Value(customFoodId),
      quantity: Value(quantity),
      createTime: Value(createTime),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DietLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DietLogRow(
      id: serializer.fromJson<int>(json['id']),
      premadeFoodId: serializer.fromJson<int?>(json['premadeFoodId']),
      customFoodId: serializer.fromJson<int?>(json['customFoodId']),
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
      'premadeFoodId': serializer.toJson<int?>(premadeFoodId),
      'customFoodId': serializer.toJson<int?>(customFoodId),
      'quantity': serializer.toJson<double>(quantity),
      'createTime': serializer.toJson<DateTime>(createTime),
      'note': serializer.toJson<String?>(note),
    };
  }

  DietLogRow copyWith({
    int? id,
    Value<int?> premadeFoodId = const Value.absent(),
    Value<int?> customFoodId = const Value.absent(),
    double? quantity,
    DateTime? createTime,
    Value<String?> note = const Value.absent(),
  }) => DietLogRow(
    id: id ?? this.id,
    premadeFoodId: premadeFoodId.present
        ? premadeFoodId.value
        : this.premadeFoodId,
    customFoodId: customFoodId.present ? customFoodId.value : this.customFoodId,
    quantity: quantity ?? this.quantity,
    createTime: createTime ?? this.createTime,
    note: note.present ? note.value : this.note,
  );
  DietLogRow copyWithCompanion(DietLogsCompanion data) {
    return DietLogRow(
      id: data.id.present ? data.id.value : this.id,
      premadeFoodId: data.premadeFoodId.present
          ? data.premadeFoodId.value
          : this.premadeFoodId,
      customFoodId: data.customFoodId.present
          ? data.customFoodId.value
          : this.customFoodId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      createTime: data.createTime.present
          ? data.createTime.value
          : this.createTime,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DietLogRow(')
          ..write('id: $id, ')
          ..write('premadeFoodId: $premadeFoodId, ')
          ..write('customFoodId: $customFoodId, ')
          ..write('quantity: $quantity, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, premadeFoodId, customFoodId, quantity, createTime, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DietLogRow &&
          other.id == this.id &&
          other.premadeFoodId == this.premadeFoodId &&
          other.customFoodId == this.customFoodId &&
          other.quantity == this.quantity &&
          other.createTime == this.createTime &&
          other.note == this.note);
}

class DietLogsCompanion extends UpdateCompanion<DietLogRow> {
  final Value<int> id;
  final Value<int?> premadeFoodId;
  final Value<int?> customFoodId;
  final Value<double> quantity;
  final Value<DateTime> createTime;
  final Value<String?> note;
  const DietLogsCompanion({
    this.id = const Value.absent(),
    this.premadeFoodId = const Value.absent(),
    this.customFoodId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.createTime = const Value.absent(),
    this.note = const Value.absent(),
  });
  DietLogsCompanion.insert({
    this.id = const Value.absent(),
    this.premadeFoodId = const Value.absent(),
    this.customFoodId = const Value.absent(),
    required double quantity,
    required DateTime createTime,
    this.note = const Value.absent(),
  }) : quantity = Value(quantity),
       createTime = Value(createTime);
  static Insertable<DietLogRow> custom({
    Expression<int>? id,
    Expression<int>? premadeFoodId,
    Expression<int>? customFoodId,
    Expression<double>? quantity,
    Expression<DateTime>? createTime,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (premadeFoodId != null) 'premade_food_id': premadeFoodId,
      if (customFoodId != null) 'custom_food_id': customFoodId,
      if (quantity != null) 'quantity': quantity,
      if (createTime != null) 'create_time': createTime,
      if (note != null) 'note': note,
    });
  }

  DietLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? premadeFoodId,
    Value<int?>? customFoodId,
    Value<double>? quantity,
    Value<DateTime>? createTime,
    Value<String?>? note,
  }) {
    return DietLogsCompanion(
      id: id ?? this.id,
      premadeFoodId: premadeFoodId ?? this.premadeFoodId,
      customFoodId: customFoodId ?? this.customFoodId,
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
    if (premadeFoodId.present) {
      map['premade_food_id'] = Variable<int>(premadeFoodId.value);
    }
    if (customFoodId.present) {
      map['custom_food_id'] = Variable<int>(customFoodId.value);
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
    return (StringBuffer('DietLogsCompanion(')
          ..write('id: $id, ')
          ..write('premadeFoodId: $premadeFoodId, ')
          ..write('customFoodId: $customFoodId, ')
          ..write('quantity: $quantity, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PremadeFoodsTable premadeFoods = $PremadeFoodsTable(this);
  late final $CustomFoodsTable customFoods = $CustomFoodsTable(this);
  late final $DietLogsTable dietLogs = $DietLogsTable(this);
  late final Index idxPremadeFoodsLastUsed = Index(
    'idx_premade_foods_last_used',
    'CREATE INDEX idx_premade_foods_last_used ON premade_foods (last_used_time)',
  );
  late final Index idxCustomFoodsLastUsed = Index(
    'idx_custom_foods_last_used',
    'CREATE INDEX idx_custom_foods_last_used ON custom_foods (last_used_time)',
  );
  late final Index idxDietLogsCreateTime = Index(
    'idx_diet_logs_create_time',
    'CREATE INDEX idx_diet_logs_create_time ON diet_logs (create_time)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    premadeFoods,
    customFoods,
    dietLogs,
    idxPremadeFoodsLastUsed,
    idxCustomFoodsLastUsed,
    idxDietLogsCreateTime,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'premade_foods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diet_logs', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'custom_foods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diet_logs', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$PremadeFoodsTableCreateCompanionBuilder =
    PremadeFoodsCompanion Function({
      Value<int> id,
      required String name,
      required double kj,
      required double carbs,
      required double protein,
      required double fat,
      required double servingAmount,
      required double basisAmount,
      required String unitName,
      required DateTime lastUsedTime,
    });
typedef $$PremadeFoodsTableUpdateCompanionBuilder =
    PremadeFoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> kj,
      Value<double> carbs,
      Value<double> protein,
      Value<double> fat,
      Value<double> servingAmount,
      Value<double> basisAmount,
      Value<String> unitName,
      Value<DateTime> lastUsedTime,
    });

final class $$PremadeFoodsTableReferences
    extends BaseReferences<_$AppDatabase, $PremadeFoodsTable, PremadeFoodRow> {
  $$PremadeFoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DietLogsTable, List<DietLogRow>>
  _dietLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dietLogs,
    aliasName: 'premade_foods__id__diet_logs__premade_food_id',
  );

  $$DietLogsTableProcessedTableManager get dietLogsRefs {
    final manager = $$DietLogsTableTableManager(
      $_db,
      $_db.dietLogs,
    ).filter((f) => f.premadeFoodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dietLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PremadeFoodsTableFilterComposer
    extends Composer<_$AppDatabase, $PremadeFoodsTable> {
  $$PremadeFoodsTableFilterComposer({
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

  ColumnFilters<double> get servingAmount => $composableBuilder(
    column: $table.servingAmount,
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

  Expression<bool> dietLogsRefs(
    Expression<bool> Function($$DietLogsTableFilterComposer f) f,
  ) {
    final $$DietLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dietLogs,
      getReferencedColumn: (t) => t.premadeFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DietLogsTableFilterComposer(
            $db: $db,
            $table: $db.dietLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PremadeFoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PremadeFoodsTable> {
  $$PremadeFoodsTableOrderingComposer({
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

  ColumnOrderings<double> get servingAmount => $composableBuilder(
    column: $table.servingAmount,
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

class $$PremadeFoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PremadeFoodsTable> {
  $$PremadeFoodsTableAnnotationComposer({
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

  GeneratedColumn<double> get servingAmount => $composableBuilder(
    column: $table.servingAmount,
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

  Expression<T> dietLogsRefs<T extends Object>(
    Expression<T> Function($$DietLogsTableAnnotationComposer a) f,
  ) {
    final $$DietLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dietLogs,
      getReferencedColumn: (t) => t.premadeFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DietLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.dietLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PremadeFoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PremadeFoodsTable,
          PremadeFoodRow,
          $$PremadeFoodsTableFilterComposer,
          $$PremadeFoodsTableOrderingComposer,
          $$PremadeFoodsTableAnnotationComposer,
          $$PremadeFoodsTableCreateCompanionBuilder,
          $$PremadeFoodsTableUpdateCompanionBuilder,
          (PremadeFoodRow, $$PremadeFoodsTableReferences),
          PremadeFoodRow,
          PrefetchHooks Function({bool dietLogsRefs})
        > {
  $$PremadeFoodsTableTableManager(_$AppDatabase db, $PremadeFoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PremadeFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PremadeFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PremadeFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> kj = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double> servingAmount = const Value.absent(),
                Value<double> basisAmount = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<DateTime> lastUsedTime = const Value.absent(),
              }) => PremadeFoodsCompanion(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                servingAmount: servingAmount,
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
                required double servingAmount,
                required double basisAmount,
                required String unitName,
                required DateTime lastUsedTime,
              }) => PremadeFoodsCompanion.insert(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                servingAmount: servingAmount,
                basisAmount: basisAmount,
                unitName: unitName,
                lastUsedTime: lastUsedTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PremadeFoodsTable, PremadeFoodRow>(table),
                  $$PremadeFoodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dietLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dietLogsRefs) db.dietLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dietLogsRefs)
                    await $_getPrefetchedData<
                      PremadeFoodRow,
                      $PremadeFoodsTable,
                      DietLogRow
                    >(
                      currentTable: table,
                      referencedTable: $$PremadeFoodsTableReferences
                          ._dietLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PremadeFoodsTableReferences(
                            db,
                            table,
                            p0,
                          ).dietLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.premadeFoodId == item.id,
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

typedef $$PremadeFoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PremadeFoodsTable,
      PremadeFoodRow,
      $$PremadeFoodsTableFilterComposer,
      $$PremadeFoodsTableOrderingComposer,
      $$PremadeFoodsTableAnnotationComposer,
      $$PremadeFoodsTableCreateCompanionBuilder,
      $$PremadeFoodsTableUpdateCompanionBuilder,
      (PremadeFoodRow, $$PremadeFoodsTableReferences),
      PremadeFoodRow,
      PrefetchHooks Function({bool dietLogsRefs})
    >;
typedef $$CustomFoodsTableCreateCompanionBuilder =
    CustomFoodsCompanion Function({
      Value<int> id,
      required String name,
      required double kj,
      required double carbs,
      required double protein,
      required double fat,
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
      Value<DateTime> lastUsedTime,
    });

final class $$CustomFoodsTableReferences
    extends BaseReferences<_$AppDatabase, $CustomFoodsTable, CustomFoodRow> {
  $$CustomFoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DietLogsTable, List<DietLogRow>>
  _dietLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dietLogs,
    aliasName: 'custom_foods__id__diet_logs__custom_food_id',
  );

  $$DietLogsTableProcessedTableManager get dietLogsRefs {
    final manager = $$DietLogsTableTableManager(
      $_db,
      $_db.dietLogs,
    ).filter((f) => f.customFoodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dietLogsRefsTable($_db));
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

  ColumnFilters<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dietLogsRefs(
    Expression<bool> Function($$DietLogsTableFilterComposer f) f,
  ) {
    final $$DietLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dietLogs,
      getReferencedColumn: (t) => t.customFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DietLogsTableFilterComposer(
            $db: $db,
            $table: $db.dietLogs,
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

  GeneratedColumn<DateTime> get lastUsedTime => $composableBuilder(
    column: $table.lastUsedTime,
    builder: (column) => column,
  );

  Expression<T> dietLogsRefs<T extends Object>(
    Expression<T> Function($$DietLogsTableAnnotationComposer a) f,
  ) {
    final $$DietLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dietLogs,
      getReferencedColumn: (t) => t.customFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DietLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.dietLogs,
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
          PrefetchHooks Function({bool dietLogsRefs})
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
                Value<DateTime> lastUsedTime = const Value.absent(),
              }) => CustomFoodsCompanion(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
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
                required DateTime lastUsedTime,
              }) => CustomFoodsCompanion.insert(
                id: id,
                name: name,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
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
          prefetchHooksCallback: ({dietLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dietLogsRefs) db.dietLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dietLogsRefs)
                    await $_getPrefetchedData<
                      CustomFoodRow,
                      $CustomFoodsTable,
                      DietLogRow
                    >(
                      currentTable: table,
                      referencedTable: $$CustomFoodsTableReferences
                          ._dietLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomFoodsTableReferences(
                            db,
                            table,
                            p0,
                          ).dietLogsRefs,
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
      PrefetchHooks Function({bool dietLogsRefs})
    >;
typedef $$DietLogsTableCreateCompanionBuilder = DietLogsCompanion Function({
  Value<int> id,
  Value<int?> premadeFoodId,
  Value<int?> customFoodId,
  required double quantity,
  required DateTime createTime,
  Value<String?> note,
});
typedef $$DietLogsTableUpdateCompanionBuilder = DietLogsCompanion Function({
  Value<int> id,
  Value<int?> premadeFoodId,
  Value<int?> customFoodId,
  Value<double> quantity,
  Value<DateTime> createTime,
  Value<String?> note,
});

final class $$DietLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DietLogsTable, DietLogRow> {
  $$DietLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PremadeFoodsTable _premadeFoodIdTable(_$AppDatabase db) => db
      .premadeFoods
      .createAlias('diet_logs__premade_food_id__premade_foods__id');

  $$PremadeFoodsTableProcessedTableManager? get premadeFoodId {
    final $_column = $_itemColumn<int>('premade_food_id');
    if ($_column == null) return null;
    final manager = $$PremadeFoodsTableTableManager(
      $_db,
      $_db.premadeFoods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_premadeFoodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomFoodsTable _customFoodIdTable(_$AppDatabase db) =>
      db.customFoods.createAlias('diet_logs__custom_food_id__custom_foods__id');

  $$CustomFoodsTableProcessedTableManager? get customFoodId {
    final $_column = $_itemColumn<int>('custom_food_id');
    if ($_column == null) return null;
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

class $$DietLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DietLogsTable> {
  $$DietLogsTableFilterComposer({
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

  $$PremadeFoodsTableFilterComposer get premadeFoodId {
    final $$PremadeFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.premadeFoodId,
      referencedTable: $db.premadeFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PremadeFoodsTableFilterComposer(
            $db: $db,
            $table: $db.premadeFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$DietLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DietLogsTable> {
  $$DietLogsTableOrderingComposer({
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

  $$PremadeFoodsTableOrderingComposer get premadeFoodId {
    final $$PremadeFoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.premadeFoodId,
      referencedTable: $db.premadeFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PremadeFoodsTableOrderingComposer(
            $db: $db,
            $table: $db.premadeFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$DietLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DietLogsTable> {
  $$DietLogsTableAnnotationComposer({
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

  $$PremadeFoodsTableAnnotationComposer get premadeFoodId {
    final $$PremadeFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.premadeFoodId,
      referencedTable: $db.premadeFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PremadeFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.premadeFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$DietLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DietLogsTable,
          DietLogRow,
          $$DietLogsTableFilterComposer,
          $$DietLogsTableOrderingComposer,
          $$DietLogsTableAnnotationComposer,
          $$DietLogsTableCreateCompanionBuilder,
          $$DietLogsTableUpdateCompanionBuilder,
          (DietLogRow, $$DietLogsTableReferences),
          DietLogRow,
          PrefetchHooks Function({bool premadeFoodId, bool customFoodId})
        > {
  $$DietLogsTableTableManager(_$AppDatabase db, $DietLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DietLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DietLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DietLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> premadeFoodId = const Value.absent(),
                Value<int?> customFoodId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<DateTime> createTime = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => DietLogsCompanion(
                id: id,
                premadeFoodId: premadeFoodId,
                customFoodId: customFoodId,
                quantity: quantity,
                createTime: createTime,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> premadeFoodId = const Value.absent(),
                Value<int?> customFoodId = const Value.absent(),
                required double quantity,
                required DateTime createTime,
                Value<String?> note = const Value.absent(),
              }) => DietLogsCompanion.insert(
                id: id,
                premadeFoodId: premadeFoodId,
                customFoodId: customFoodId,
                quantity: quantity,
                createTime: createTime,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DietLogsTable, DietLogRow>(table),
                  $$DietLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({premadeFoodId = false, customFoodId = false}) {
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
                        if (premadeFoodId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.premadeFoodId,
                            referencedTable: $$DietLogsTableReferences
                                ._premadeFoodIdTable(db),
                            referencedColumn: $$DietLogsTableReferences
                                ._premadeFoodIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (customFoodId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customFoodId,
                            referencedTable: $$DietLogsTableReferences
                                ._customFoodIdTable(db),
                            referencedColumn: $$DietLogsTableReferences
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

typedef $$DietLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DietLogsTable,
      DietLogRow,
      $$DietLogsTableFilterComposer,
      $$DietLogsTableOrderingComposer,
      $$DietLogsTableAnnotationComposer,
      $$DietLogsTableCreateCompanionBuilder,
      $$DietLogsTableUpdateCompanionBuilder,
      (DietLogRow, $$DietLogsTableReferences),
      DietLogRow,
      PrefetchHooks Function({bool premadeFoodId, bool customFoodId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PremadeFoodsTableTableManager get premadeFoods =>
      $$PremadeFoodsTableTableManager(_db, _db.premadeFoods);
  $$CustomFoodsTableTableManager get customFoods =>
      $$CustomFoodsTableTableManager(_db, _db.customFoods);
  $$DietLogsTableTableManager get dietLogs =>
      $$DietLogsTableTableManager(_db, _db.dietLogs);
}

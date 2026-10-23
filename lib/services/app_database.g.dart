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

class $MealsTable extends Meals with TableInfo<$MealsTable, MealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
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
  static const VerificationMeta _rawFoodSourceMeta = const VerificationMeta(
    'rawFoodSource',
  );
  @override
  late final GeneratedColumn<int> rawFoodSource = GeneratedColumn<int>(
    'raw_food_source',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    foodName,
    kj,
    carbs,
    protein,
    fat,
    rawFoodSource,
    netContent,
    basisAmount,
    unitName,
    quantity,
    createTime,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
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
    if (data.containsKey('raw_food_source')) {
      context.handle(
        _rawFoodSourceMeta,
        rawFoodSource.isAcceptableOrUnknown(
          data['raw_food_source']!,
          _rawFoodSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawFoodSourceMeta);
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
  MealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
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
      rawFoodSource: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}raw_food_source'],
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
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class MealRow extends DataClass implements Insertable<MealRow> {
  final int id;
  final String foodName;
  final double kj;
  final double carbs;
  final double protein;
  final double fat;
  final int rawFoodSource;
  final double netContent;
  final double basisAmount;
  final String unitName;
  final double quantity;
  final DateTime createTime;
  final String? note;
  const MealRow({
    required this.id,
    required this.foodName,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.rawFoodSource,
    required this.netContent,
    required this.basisAmount,
    required this.unitName,
    required this.quantity,
    required this.createTime,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_name'] = Variable<String>(foodName);
    map['kj'] = Variable<double>(kj);
    map['carbs'] = Variable<double>(carbs);
    map['protein'] = Variable<double>(protein);
    map['fat'] = Variable<double>(fat);
    map['raw_food_source'] = Variable<int>(rawFoodSource);
    map['net_content'] = Variable<double>(netContent);
    map['basis_amount'] = Variable<double>(basisAmount);
    map['unit_name'] = Variable<String>(unitName);
    map['quantity'] = Variable<double>(quantity);
    map['create_time'] = Variable<DateTime>(createTime);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      foodName: Value(foodName),
      kj: Value(kj),
      carbs: Value(carbs),
      protein: Value(protein),
      fat: Value(fat),
      rawFoodSource: Value(rawFoodSource),
      netContent: Value(netContent),
      basisAmount: Value(basisAmount),
      unitName: Value(unitName),
      quantity: Value(quantity),
      createTime: Value(createTime),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealRow(
      id: serializer.fromJson<int>(json['id']),
      foodName: serializer.fromJson<String>(json['foodName']),
      kj: serializer.fromJson<double>(json['kj']),
      carbs: serializer.fromJson<double>(json['carbs']),
      protein: serializer.fromJson<double>(json['protein']),
      fat: serializer.fromJson<double>(json['fat']),
      rawFoodSource: serializer.fromJson<int>(json['rawFoodSource']),
      netContent: serializer.fromJson<double>(json['netContent']),
      basisAmount: serializer.fromJson<double>(json['basisAmount']),
      unitName: serializer.fromJson<String>(json['unitName']),
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
      'foodName': serializer.toJson<String>(foodName),
      'kj': serializer.toJson<double>(kj),
      'carbs': serializer.toJson<double>(carbs),
      'protein': serializer.toJson<double>(protein),
      'fat': serializer.toJson<double>(fat),
      'rawFoodSource': serializer.toJson<int>(rawFoodSource),
      'netContent': serializer.toJson<double>(netContent),
      'basisAmount': serializer.toJson<double>(basisAmount),
      'unitName': serializer.toJson<String>(unitName),
      'quantity': serializer.toJson<double>(quantity),
      'createTime': serializer.toJson<DateTime>(createTime),
      'note': serializer.toJson<String?>(note),
    };
  }

  MealRow copyWith({
    int? id,
    String? foodName,
    double? kj,
    double? carbs,
    double? protein,
    double? fat,
    int? rawFoodSource,
    double? netContent,
    double? basisAmount,
    String? unitName,
    double? quantity,
    DateTime? createTime,
    Value<String?> note = const Value.absent(),
  }) => MealRow(
    id: id ?? this.id,
    foodName: foodName ?? this.foodName,
    kj: kj ?? this.kj,
    carbs: carbs ?? this.carbs,
    protein: protein ?? this.protein,
    fat: fat ?? this.fat,
    rawFoodSource: rawFoodSource ?? this.rawFoodSource,
    netContent: netContent ?? this.netContent,
    basisAmount: basisAmount ?? this.basisAmount,
    unitName: unitName ?? this.unitName,
    quantity: quantity ?? this.quantity,
    createTime: createTime ?? this.createTime,
    note: note.present ? note.value : this.note,
  );
  MealRow copyWithCompanion(MealsCompanion data) {
    return MealRow(
      id: data.id.present ? data.id.value : this.id,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      kj: data.kj.present ? data.kj.value : this.kj,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      rawFoodSource: data.rawFoodSource.present
          ? data.rawFoodSource.value
          : this.rawFoodSource,
      netContent: data.netContent.present
          ? data.netContent.value
          : this.netContent,
      basisAmount: data.basisAmount.present
          ? data.basisAmount.value
          : this.basisAmount,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      createTime: data.createTime.present
          ? data.createTime.value
          : this.createTime,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealRow(')
          ..write('id: $id, ')
          ..write('foodName: $foodName, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('rawFoodSource: $rawFoodSource, ')
          ..write('netContent: $netContent, ')
          ..write('basisAmount: $basisAmount, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity, ')
          ..write('createTime: $createTime, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    foodName,
    kj,
    carbs,
    protein,
    fat,
    rawFoodSource,
    netContent,
    basisAmount,
    unitName,
    quantity,
    createTime,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealRow &&
          other.id == this.id &&
          other.foodName == this.foodName &&
          other.kj == this.kj &&
          other.carbs == this.carbs &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.rawFoodSource == this.rawFoodSource &&
          other.netContent == this.netContent &&
          other.basisAmount == this.basisAmount &&
          other.unitName == this.unitName &&
          other.quantity == this.quantity &&
          other.createTime == this.createTime &&
          other.note == this.note);
}

class MealsCompanion extends UpdateCompanion<MealRow> {
  final Value<int> id;
  final Value<String> foodName;
  final Value<double> kj;
  final Value<double> carbs;
  final Value<double> protein;
  final Value<double> fat;
  final Value<int> rawFoodSource;
  final Value<double> netContent;
  final Value<double> basisAmount;
  final Value<String> unitName;
  final Value<double> quantity;
  final Value<DateTime> createTime;
  final Value<String?> note;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.foodName = const Value.absent(),
    this.kj = const Value.absent(),
    this.carbs = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.rawFoodSource = const Value.absent(),
    this.netContent = const Value.absent(),
    this.basisAmount = const Value.absent(),
    this.unitName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.createTime = const Value.absent(),
    this.note = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String foodName,
    required double kj,
    required double carbs,
    required double protein,
    required double fat,
    required int rawFoodSource,
    required double netContent,
    required double basisAmount,
    required String unitName,
    required double quantity,
    required DateTime createTime,
    this.note = const Value.absent(),
  }) : foodName = Value(foodName),
       kj = Value(kj),
       carbs = Value(carbs),
       protein = Value(protein),
       fat = Value(fat),
       rawFoodSource = Value(rawFoodSource),
       netContent = Value(netContent),
       basisAmount = Value(basisAmount),
       unitName = Value(unitName),
       quantity = Value(quantity),
       createTime = Value(createTime);
  static Insertable<MealRow> custom({
    Expression<int>? id,
    Expression<String>? foodName,
    Expression<double>? kj,
    Expression<double>? carbs,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<int>? rawFoodSource,
    Expression<double>? netContent,
    Expression<double>? basisAmount,
    Expression<String>? unitName,
    Expression<double>? quantity,
    Expression<DateTime>? createTime,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodName != null) 'food_name': foodName,
      if (kj != null) 'kj': kj,
      if (carbs != null) 'carbs': carbs,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (rawFoodSource != null) 'raw_food_source': rawFoodSource,
      if (netContent != null) 'net_content': netContent,
      if (basisAmount != null) 'basis_amount': basisAmount,
      if (unitName != null) 'unit_name': unitName,
      if (quantity != null) 'quantity': quantity,
      if (createTime != null) 'create_time': createTime,
      if (note != null) 'note': note,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<String>? foodName,
    Value<double>? kj,
    Value<double>? carbs,
    Value<double>? protein,
    Value<double>? fat,
    Value<int>? rawFoodSource,
    Value<double>? netContent,
    Value<double>? basisAmount,
    Value<String>? unitName,
    Value<double>? quantity,
    Value<DateTime>? createTime,
    Value<String?>? note,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      kj: kj ?? this.kj,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      rawFoodSource: rawFoodSource ?? this.rawFoodSource,
      netContent: netContent ?? this.netContent,
      basisAmount: basisAmount ?? this.basisAmount,
      unitName: unitName ?? this.unitName,
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
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
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
    if (rawFoodSource.present) {
      map['raw_food_source'] = Variable<int>(rawFoodSource.value);
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
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('foodName: $foodName, ')
          ..write('kj: $kj, ')
          ..write('carbs: $carbs, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('rawFoodSource: $rawFoodSource, ')
          ..write('netContent: $netContent, ')
          ..write('basisAmount: $basisAmount, ')
          ..write('unitName: $unitName, ')
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
  late final $PackagedFoodsTable packagedFoods = $PackagedFoodsTable(this);
  late final $CustomFoodsTable customFoods = $CustomFoodsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final Index idxPackagedFoodsLastUsed = Index(
    'idx_packaged_foods_last_used',
    'CREATE INDEX idx_packaged_foods_last_used ON packaged_foods (last_used_time)',
  );
  late final Index idxCustomFoodsLastUsed = Index(
    'idx_custom_foods_last_used',
    'CREATE INDEX idx_custom_foods_last_used ON custom_foods (last_used_time)',
  );
  late final Index idxMealsCreateTime = Index(
    'idx_meals_create_time',
    'CREATE INDEX idx_meals_create_time ON meals (create_time)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    packagedFoods,
    customFoods,
    meals,
    idxPackagedFoodsLastUsed,
    idxCustomFoodsLastUsed,
    idxMealsCreateTime,
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
          (
            PackagedFoodRow,
            BaseReferences<_$AppDatabase, $PackagedFoodsTable, PackagedFoodRow>,
          ),
          PackagedFoodRow,
          PrefetchHooks Function()
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
                  BaseReferences<
                    _$AppDatabase,
                    $PackagedFoodsTable,
                    PackagedFoodRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
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
      (
        PackagedFoodRow,
        BaseReferences<_$AppDatabase, $PackagedFoodsTable, PackagedFoodRow>,
      ),
      PackagedFoodRow,
      PrefetchHooks Function()
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
          (
            CustomFoodRow,
            BaseReferences<_$AppDatabase, $CustomFoodsTable, CustomFoodRow>,
          ),
          CustomFoodRow,
          PrefetchHooks Function()
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
                  BaseReferences<
                    _$AppDatabase,
                    $CustomFoodsTable,
                    CustomFoodRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
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
      (
        CustomFoodRow,
        BaseReferences<_$AppDatabase, $CustomFoodsTable, CustomFoodRow>,
      ),
      CustomFoodRow,
      PrefetchHooks Function()
    >;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  required String foodName,
  required double kj,
  required double carbs,
  required double protein,
  required double fat,
  required int rawFoodSource,
  required double netContent,
  required double basisAmount,
  required String unitName,
  required double quantity,
  required DateTime createTime,
  Value<String?> note,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String> foodName,
  Value<double> kj,
  Value<double> carbs,
  Value<double> protein,
  Value<double> fat,
  Value<int> rawFoodSource,
  Value<double> netContent,
  Value<double> basisAmount,
  Value<String> unitName,
  Value<double> quantity,
  Value<DateTime> createTime,
  Value<String?> note,
});

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
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

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
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

  ColumnFilters<int> get rawFoodSource => $composableBuilder(
    column: $table.rawFoodSource,
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
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
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

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
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

  ColumnOrderings<int> get rawFoodSource => $composableBuilder(
    column: $table.rawFoodSource,
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
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get kj =>
      $composableBuilder(column: $table.kj, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<int> get rawFoodSource => $composableBuilder(
    column: $table.rawFoodSource,
    builder: (column) => column,
  );

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

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get createTime => $composableBuilder(
    column: $table.createTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          MealRow,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (MealRow, BaseReferences<_$AppDatabase, $MealsTable, MealRow>),
          MealRow,
          PrefetchHooks Function()
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<double> kj = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<int> rawFoodSource = const Value.absent(),
                Value<double> netContent = const Value.absent(),
                Value<double> basisAmount = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<DateTime> createTime = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                foodName: foodName,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                rawFoodSource: rawFoodSource,
                netContent: netContent,
                basisAmount: basisAmount,
                unitName: unitName,
                quantity: quantity,
                createTime: createTime,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String foodName,
                required double kj,
                required double carbs,
                required double protein,
                required double fat,
                required int rawFoodSource,
                required double netContent,
                required double basisAmount,
                required String unitName,
                required double quantity,
                required DateTime createTime,
                Value<String?> note = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                foodName: foodName,
                kj: kj,
                carbs: carbs,
                protein: protein,
                fat: fat,
                rawFoodSource: rawFoodSource,
                netContent: netContent,
                basisAmount: basisAmount,
                unitName: unitName,
                quantity: quantity,
                createTime: createTime,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealsTable, MealRow>(table),
                  BaseReferences<_$AppDatabase, $MealsTable, MealRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      MealRow,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (MealRow, BaseReferences<_$AppDatabase, $MealsTable, MealRow>),
      MealRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PackagedFoodsTableTableManager get packagedFoods =>
      $$PackagedFoodsTableTableManager(_db, _db.packagedFoods);
  $$CustomFoodsTableTableManager get customFoods =>
      $$CustomFoodsTableTableManager(_db, _db.customFoods);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
}

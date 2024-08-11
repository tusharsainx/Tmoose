// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CodeVerifierModelAdapter extends TypeAdapter<CodeVerifierModel> {
  @override
  final int typeId = 0;

  @override
  CodeVerifierModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CodeVerifierModel(
      codeVerifier: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CodeVerifierModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.codeVerifier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeVerifierModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TokenModelAdapter extends TypeAdapter<TokenModel> {
  @override
  final int typeId = 1;

  @override
  TokenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenModel(
      refreshToken: fields[1] as String?,
      accessToken: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TokenModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

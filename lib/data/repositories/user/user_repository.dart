import 'package:architecture_study/data/services/remote/api/user/user_api_service.dart';
import 'package:architecture_study/data/services/remote/api/user/user_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart' as dto;
import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart' show UserDto;
import 'package:architecture_study/domain/entities/user/user.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    userApiService: ref.read(userApiServiceImplProvider),
  ),
);

/// リポジトリクラス
class UserRepository {
  /// コンストラクタ
  UserRepository({required this.userApiService});

  /// Userに関連するAPI通信を抽象化したサービスインターフェース。
  final UserApiService userApiService;

  /// [User] を取得
  Future<Result<User>> fetch() async {
    try {
      final result = await userApiService.fetch();

      switch (result) {
        case SuccessResult<UserDto>():
          final user = _toEntity(result.value);
          if (user == null) {
            return FailureResult(Exception('Required fields missing for User'));
          }
          return SuccessResult(user);
        case FailureResult<UserDto>():
          logger.e('[UserRepository] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      return FailureResult(error);
    }
  }

  /// [UserDto] を [User] エンティティに変換します。
  User? _toEntity(UserDto dto) {
    // 必須フィールドが欠損している場合はnullを返す
    if (dto.id == null) {
      return null;
    }

    return User(
      id: dto.id!,
      firstName: dto.firstName ?? '',
      lastName: dto.lastName ?? '',
      maidenName: dto.maidenName ?? '',
      age: dto.age ?? 0,
      gender: dto.gender ?? '',
      email: dto.email ?? '',
      phone: dto.phone ?? '',
      username: dto.username ?? '',
      password: dto.password ?? '',
      birthDate: dto.birthDate ?? '',
      image: dto.image ?? '',
      bloodGroup: dto.bloodGroup ?? '',
      height: dto.height ?? 0.0,
      weight: dto.weight ?? 0.0,
      eyeColor: dto.eyeColor ?? '',
      hair: _toHairEntity(dto.hair),
      ip: dto.ip ?? '',
      address: _toAddressEntity(dto.address),
      macAddress: dto.macAddress ?? '',
      university: dto.university ?? '',
      bank: _toBankEntity(dto.bank),
      company: _toCompanyEntity(dto.company),
      ein: dto.ein ?? '',
      ssn: dto.ssn ?? '',
      userAgent: dto.userAgent ?? '',
      crypto: _toCryptoEntity(dto.crypto),
      role: dto.role ?? '',
    );
  }

  Hair _toHairEntity(dto.Hair? hairDto) {
    return Hair(
      color: hairDto?.color ?? '',
      type: hairDto?.type ?? '',
    );
  }

  Address _toAddressEntity(dto.Address? addressDto) {
    return Address(
      address: addressDto?.address ?? '',
      city: addressDto?.city ?? '',
      state: addressDto?.state ?? '',
      stateCode: addressDto?.stateCode ?? '',
      postalCode: addressDto?.postalCode ?? '',
      coordinates: _toCoordinatesEntity(addressDto?.coordinates),
      country: addressDto?.country ?? '',
    );
  }

  Coordinates _toCoordinatesEntity(dto.Coordinates? coordinatesDto) {
    return Coordinates(
      lat: coordinatesDto?.lat ?? 0.0,
      lng: coordinatesDto?.lng ?? 0.0,
    );
  }

  Bank _toBankEntity(dto.Bank? bankDto) {
    return Bank(
      cardExpire: bankDto?.cardExpire ?? '',
      cardNumber: bankDto?.cardNumber ?? '',
      cardType: bankDto?.cardType ?? '',
      currency: bankDto?.currency ?? '',
      iban: bankDto?.iban ?? '',
    );
  }

  Company _toCompanyEntity(dto.Company? companyDto) {
    return Company(
      department: companyDto?.department ?? '',
      name: companyDto?.name ?? '',
      title: companyDto?.title ?? '',
      address: _toAddressEntity(companyDto?.address),
    );
  }

  Crypto _toCryptoEntity(dto.Crypto? cryptoDto) {
    return Crypto(
      coin: cryptoDto?.coin ?? '',
      wallet: cryptoDto?.wallet ?? '',
      network: cryptoDto?.network ?? '',
    );
  }
}

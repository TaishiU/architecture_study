import 'package:architecture_study/data/services/remote/api/user/user_api_service.dart';
import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final fakeUserApiServiceImplProvider = Provider<FakeUserApiServiceImpl>(
  (ref) => FakeUserApiServiceImpl(),
);

/// 開発用サービス実装クラス
class FakeUserApiServiceImpl implements UserApiService {
  /// コンストラクタ
  FakeUserApiServiceImpl();

  @override
  Future<Result<UserDto>> fetch() async {
    const userDto = UserDto(
      id: 1,
      firstName: 'Emily',
      lastName: 'Johnson',
      maidenName: 'Smith',
      age: 28,
      gender: 'female',
      email: 'emily.johnson@x.dummyjson.com',
      phone: '+81 965-431-3024',
      username: 'emilys',
      password: 'emilyspass',
      birthDate: '1996-5-30',
      image: '...',
      bloodGroup: 'O-',
      height: 193.24,
      weight: 63.16,
      eyeColor: 'Green',
      hair: Hair(
        color: 'Brown',
        type: 'Curly',
      ),
      ip: '42.48.100.32',
      address: Address(
        address: '626 Main Street',
        city: 'Phoenix',
        state: 'Mississippi',
        stateCode: 'MS',
        postalCode: '29112',
        coordinates: Coordinates(
          lat: -77.16213,
          lng: -92.084824,
        ),
        country: 'United States',
      ),
      macAddress: '47:fa:41:18:ec:eb',
      university: 'University of Wisconsin--Madison',
      bank: Bank(
        cardExpire: '03/26',
        cardNumber: '9289760655481815',
        cardType: 'Elo',
        currency: 'CNY',
        iban: 'YPUXISOBI7TTHPK2BR3HAIXL',
      ),
      company: Company(
        department: 'Engineering',
        name: 'Dooley, Kozey and Cronin',
        title: 'Sales Manager',
        address: Address(
          address: '263 Tenth Street',
          city: 'San Francisco',
          state: 'Wisconsin',
          stateCode: 'WI',
          postalCode: '37657',
          coordinates: Coordinates(
            lat: 71.814525,
            lng: -161.150263,
          ),
          country: 'United States',
        ),
      ),
      ein: '977-175',
      ssn: '900-590-289',
      userAgent:
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36',
      crypto: Crypto(
        coin: 'Bitcoin',
        wallet: '0xb9fc2fe63b2a6c003f1c324c3bfa53259162181a',
        network: 'Ethereum (ERC20)',
      ),
      role: 'admin',
    );

    return const SuccessResult(userDto);
  }
}

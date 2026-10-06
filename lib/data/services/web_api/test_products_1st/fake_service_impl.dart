import 'package:architecture_study/data/services/web_api/test_products_1st/dto.dart';
import 'package:architecture_study/data/services/web_api/test_products_1st/service.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final fakeProductsApiServiceImplProvider = Provider<FakeProductsApiServiceImpl>(
  (ref) => FakeProductsApiServiceImpl(),
);

/// 開発用商品APIサービス実装クラス
class FakeProductsApiServiceImpl implements ProductsApiService {
  /// コンストラクタ
  FakeProductsApiServiceImpl();

  @override
  Future<Result<ProductsDto>> fetch({
    String? q,
    int? categoryId,
    int? minPrice,
    int? maxPrice,
    String? sort,
    int? limit,
    int? offset,
    String? cursor,
  }) async {
    final items = List.generate(2, (index) {
      return ProductSummaryDto(
        id: index + 1,
        sellerId: 1,
        categoryId: 1,
        name: 'test name ${index + 1}',
        price: 1000,
        stock: 10,
        status: 'published',
        createdAt: '2024-01-01T00:00:00Z',
      );
    });
    return SuccessResult(ProductsDto(data: items, total: items.length));
  }

  @override
  Future<Result<ProductDetailDto>> fetchById({
    required int productId,
  }) async {
    return SuccessResult(_buildProductDetail(id: productId));
  }

  @override
  Future<Result<ProductDetailDto>> create({
    required int categoryId,
    required String name,
    required int price,
    required int stock,
    String? description,
    String? status,
    List<String>? images,
  }) async {
    return SuccessResult(_buildProductDetail(id: 1));
  }

  @override
  Future<Result<ProductDetailDto>> update({
    required int productId,
    int? categoryId,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? status,
    List<String>? images,
  }) async {
    return SuccessResult(_buildProductDetail(id: productId));
  }

  @override
  Future<Result<void>> delete({required int productId}) async {
    return const SuccessResult(null);
  }

  ProductDetailDto _buildProductDetail({required int id}) {
    return ProductDetailDto(
      id: id,
      sellerId: 1,
      categoryId: 1,
      name: 'test name',
      description: 'test description',
      price: 1000,
      stock: 10,
      status: 'published',
      images: [
        const ProductImageDto(
          id: 1,
          url: 'https://example.com/image.jpg',
          displayOrder: 1,
        ),
      ],
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    );
  }
}

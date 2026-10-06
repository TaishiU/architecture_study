import 'package:freezed_annotation/freezed_annotation.dart';

part 'dto.freezed.dart';
part 'dto.g.dart';

/// 商品一覧レスポンスDto
@freezed
abstract class ProductsDto with _$ProductsDto {
  /// コンストラクタ
  const factory ProductsDto({
    /// 商品一覧
    List<ProductSummaryDto>? data,

    /// 総件数（OFFSETページング時のみ）
    int? total,

    /// 次ページカーソル
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _ProductsDto;

  /// JSONから生成
  factory ProductsDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsDtoFromJson(json);
}

/// 商品サマリーDto（一覧用）
@freezed
abstract class ProductSummaryDto with _$ProductSummaryDto {
  /// コンストラクタ
  const factory ProductSummaryDto({
    /// ID
    int? id,

    /// 出品者ID
    @JsonKey(name: 'seller_id') int? sellerId,

    /// カテゴリID
    @JsonKey(name: 'category_id') int? categoryId,

    /// 商品名
    String? name,

    /// 価格
    int? price,

    /// 在庫数
    int? stock,

    /// ステータス
    String? status,

    /// 作成日時
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ProductSummaryDto;

  /// JSONから生成
  factory ProductSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSummaryDtoFromJson(json);
}

/// 商品詳細Dto
@freezed
abstract class ProductDetailDto with _$ProductDetailDto {
  /// コンストラクタ
  const factory ProductDetailDto({
    /// ID
    int? id,

    /// 出品者ID
    @JsonKey(name: 'seller_id') int? sellerId,

    /// カテゴリID
    @JsonKey(name: 'category_id') int? categoryId,

    /// 商品名
    String? name,

    /// 商品説明
    String? description,

    /// 価格
    int? price,

    /// 在庫数
    int? stock,

    /// ステータス
    String? status,

    /// 商品画像一覧
    List<ProductImageDto>? images,

    /// 作成日時
    @JsonKey(name: 'created_at') String? createdAt,

    /// 更新日時
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ProductDetailDto;

  /// JSONから生成
  factory ProductDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailDtoFromJson(json);
}

/// 商品画像Dto
@freezed
abstract class ProductImageDto with _$ProductImageDto {
  /// コンストラクタ
  const factory ProductImageDto({
    /// ID
    int? id,

    /// 画像URL
    String? url,

    /// 表示順
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _ProductImageDto;

  /// JSONから生成
  factory ProductImageDto.fromJson(Map<String, dynamic> json) =>
      _$ProductImageDtoFromJson(json);
}

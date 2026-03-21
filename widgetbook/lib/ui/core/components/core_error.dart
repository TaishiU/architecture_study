import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/ui/core/components/core_error.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/base_scaffold.dart';

@widgetbook.UseCase(name: 'Default', type: CoreError)
Widget buildCoreErrorUseCase(BuildContext context) {
  final error = context.knobs.object.dropdown<Object>(
    label: 'Error Type',
    options: [
      NoInternetConnectionException('No Internet'),
      BadRequestException('Bad Request (400)'),
      UnauthorizedException('Unauthorized (401)'),
      ForbiddenException('Forbidden (403)'),
      NotFoundException('Not Found (404)'),
      MethodNotAllowedException('Method Not Allowed (405)'),
      InternalServerErrorException('Internal Server Error (500)'),
      UnknownErrorException('Unknown Error'),
      ApiClientException('Custom API Exception', statusCode: 418),
      FormatException('Unexpected Format Error'),
    ],
    labelBuilder: (error) {
      if (error is ApiClientException) {
        return '${error.runtimeType}(${error.statusCode ?? "no status"})';
      }
      return error.runtimeType.toString();
    },
  );

  return BaseScaffold(
    title: 'CoreError',
    body: CoreError(
      error: error,
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('再読み込みボタンが押されました')));
      },
    ),
  );
}

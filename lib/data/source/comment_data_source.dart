import 'package:dio/dio.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRemoteDataSource extends ICommentDataSource with HttpResponseValidator{
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async{
    final response =await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    (response.data as List).forEach((comment) {
      comments.add(CommentEntity.fromJson(comment));
    });
    return comments;
  }

}
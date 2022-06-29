import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/common/http_client.dart';
import 'package:nike_store/data/source/comment_data_source.dart';

final commentRepository = CommentRepository(CommentRemoteDataSource(httpClient));

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRepository extends ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);
}

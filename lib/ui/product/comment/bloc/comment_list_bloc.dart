import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/repo/comment_repository.dart';

part 'comment_list_event.dart';
part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final int productId;
  CommentListBloc({required this.repository, required this.productId}) : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async{
      if(event is CommentListStarted){
        emit(CommentListLoading());
        try{
          final comments = await commentRepository.getAll(productId: productId);
          emit(CommentListSuccess(comments));
        }catch(e){
          emit(CommentListError(AppException()));
        }
      }
    });
  }
}

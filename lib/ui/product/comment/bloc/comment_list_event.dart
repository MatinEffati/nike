part of 'comment_list_bloc.dart';

@immutable
abstract class CommentListEvent extends Equatable{
  const CommentListEvent();

  @override
  List<Object> get props => [];
}

class CommentListStarted extends CommentListEvent{}
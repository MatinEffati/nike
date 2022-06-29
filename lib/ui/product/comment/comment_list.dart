import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/data/repo/comment_repository.dart';
import 'package:nike_store/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nike_store/ui/product/comment/comment.dart';
import 'package:nike_store/ui/widgets/error.dart';

class CommentList extends StatelessWidget {
  const CommentList({Key? key, required this.productId}) : super(key: key);
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
            repository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        builder: (context, state) {
          if (state is CommentListSuccess) {
            return SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return CommentItem(comment: state.comments[index]);
                }, childCount: state.comments.length),
              ),
            );
          } else if (state is CommentListLoading) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CommentListError) {
            return SliverToBoxAdapter(
              child: AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<CommentListBloc>(context)
                      .add(CommentListStarted());
                },
              ),
            );
          } else {
            throw Exception('state isn\'t supported');
          }
        },
      ),
    );
  }
}

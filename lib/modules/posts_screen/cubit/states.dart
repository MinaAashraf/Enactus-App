abstract class PostStates {}

class PostsInitState extends PostStates {}

class PostsReadLoading extends PostStates {}
class PostsOnReadSuccess extends PostStates {}

class PostsOnReadFailed extends PostStates {}

class PostOnCreateSuccess extends PostStates {}

class PostOnCreateFailed extends PostStates {
  final String errorMsg;

  PostOnCreateFailed(this.errorMsg);
}

class PostOnCreateLoading extends PostStates {}
class PostOnLikeState extends PostStates {}

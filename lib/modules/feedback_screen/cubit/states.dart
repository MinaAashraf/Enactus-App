abstract class FeedbackStates {}

class FeedbackInitStates extends FeedbackStates {}

class FeedbackOnMembersSelectedState extends FeedbackStates {}

class FeedbackOnSendSuccess extends FeedbackStates {}
class FeedbackOnLoadingSuccess extends FeedbackStates {}

class FeedbackOnSendFailed extends FeedbackStates {
  final String err ;
  FeedbackOnSendFailed(this.err);
}
class FeedbackOnFilesAttach extends FeedbackStates {}
class FeedbackOnRemoveAttachedFile extends FeedbackStates {}



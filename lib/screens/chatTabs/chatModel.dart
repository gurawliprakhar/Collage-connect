class ChatModel {
  ChatModel(
      {required this.name,
      this.timer,
      this.currentMessage,
      this.branch,
      this.course,
      this.contact,
      this.imageUrl,
      this.studentId,
      this.year});

  String name;
  var studentId;
  var year;
  var timer;
  var currentMessage;
  // late String profileUrl;
  var course;
  var branch;
  var contact;
  var imageUrl;
}

// class ChatModel2 {
//   ChatModel2({required this.name, required this.course, required this.branch});
//
//   String name;
//   String course;
//   String branch;
// }

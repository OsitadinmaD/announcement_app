
class Announcement {
  String id;
  String title;
  String content;
  String lecturerId;
  String lecturerName;
  DateTime timestamp;
  List<AnnouncementFile> files;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.lecturerId,
    required this.lecturerName,
    required this.timestamp,
    this.files = const [],
  });

  factory Announcement.fromMap(Map<String, dynamic> data) {
    return Announcement(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      lecturerId: data['lecturerId'],
      lecturerName: data['full_name'],
      timestamp: data['created_at'],
      files: [], // Files will be fetched separately
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lecturerId': lecturerId,
      'timestamp': timestamp,
    };
  }
}

class AnnouncementFile {
  String id;
  String name;
  String url;
  int fileSize;

  AnnouncementFile({
    required this.id,
    required this.name,
    required this.url,
    required this.fileSize,
  });

  factory AnnouncementFile.fromMap(Map<String, dynamic> data) {
    return AnnouncementFile(
      id: data['id'],
      name: data['name'],
      url: data['url'],
      fileSize: data['fileSize'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'fileSize': fileSize,
    };
  }
}
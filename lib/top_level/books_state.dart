part of 'books_cubit.dart';

@immutable
abstract class BooksState extends Equatable {
  final List<Book> books;

  @override
  List<Object?> get props => books;

  const BooksState(this.books);

  Map<String, dynamic> toMap() {
    return {
      'books': this.books,
    };
  }

  factory BooksState.fromBooks(List<Book> from) {
    return BooksInitial(from);
  }

  factory BooksState.non() {
    return const BooksInitial([]);
  }
}

class BooksInitial extends BooksState {
  const BooksInitial(super.books);
}

@immutable
class Book extends Equatable {
  final String id;
  final String? title;
  final String? childName;
  final String? story;
  final List<Page> pages;

  const Book(this.id, this.title, this.childName, this.story, this.pages);

  @override
  List<Object?> get props => [childName, story, id, title, pages];

  Map<String, dynamic> toMap() {
    return {
      'childName': childName,
      'story': story,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> book = map['book'];
    List ps = book['pages'];
    final List<Page> p = ps.map((e) => Page.fromMap(e)).toList();
    map["pages"];
    return Book(map['bookId'] as String, book['title'] as String?,
        map['childName'] as String?, map['story'] as String?, p);
  }

  String getTitle() {
    if (title != null && title != "") {
      return title!;
    }
    if (childName != null && childName != "") {
      return childName!;
    }
    return story ?? "";
  }
}

class Page extends Equatable {
  final int _pageNumber;
  final String _text;
  final String? _picture;

  Page copyWith({
    int? pageNumber,
    String? text,
    String? picture,
  }) =>
      Page(
        pageNumber ?? _pageNumber,
        text ?? _text,
        picture ?? _picture,
      );

  String get text => _text;

  String? get picture => _picture;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['pageNumber'] = _pageNumber;
  //   map['text'] = _text;
  //   map['picture'] = _picture;
  //   return map;
  // }

  const Page(this._pageNumber, this._text, this._picture);

  // Map<String, dynamic> toMap() {
  //   return {
  //     '_text': _text,
  //     '_picture': _picture,
  //   };
  // }

  factory Page.fromMap(Map<String, dynamic> map) {
    return Page(
      map.containsKey('pageNumber') ? int.parse(map['pageNumber']) : 0,
      map.containsKey('text') ? map['text'] as String : "",
      map['picture'],
    );
  }

  @override
  List<Object?> get props => [_picture, _text];
}

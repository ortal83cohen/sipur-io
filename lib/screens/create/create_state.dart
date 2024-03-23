import 'package:equatable/equatable.dart';

abstract class CreateState extends Equatable {
  final String bookId;
  final bool enoughFunds;
  final int pages;
  final String childName;
  final String readerAge;
  final String story;

  @override
  List<Object> get props => [childName, readerAge, story, pages, enoughFunds];

  static final List<String> readerAgeOptions = [
    "1-2",
    "2-3",
    "3-4",
    "4-5",
    "5+"
  ];
  static final List<String> stories = [
    "The Sleepy Bear's Adventure",
    "Magical Dreams in the Forest",
    "The Nighttime Garden Party",
    "The Little Star's Big Journey",
    "Teddy and the Moonlight Picnic",
    "The Lost Moonbeam",
    "A Tale of Sleepy Sheep",
    "The Adventures of Twinkle the Firefly",
    "Moonlit Frolics with Bunny and Friends",
    "Dreamland Dinosaur Adventure",
    "The Sleepy Kitten's Secret",
    "The Brave Little Owl",
    "Counting Stars with Mr. Rabbit",
    "Adventure in Dreamland with the Friendly Alien",
    "The Moonlit Adventure of Little Explorer",
    "The Bedtime Balloon's Skyward Journey",
    "The Sleepy Butterfly's Garden Dream",
    "Dreamy Dragonfly Adventures",
    "Bedtime with the Friendly Monsters",
    "The Nighttime Adventure of Little Rover",
    "The Sleepy Ant's Underground Dream",
    "Dreamland Safari with Explorer Ellie",
    "The Moonlit Adventure of Little Aviator",
    "Bedtime with the Busy Beavers",
    "The Sleepy Ladybug's Meadow Dream",
    "Dreamy Dinosaur Adventures",
    "The Nighttime Journey of Little Voyager",
    "Bedtime with the Brave Little Firefighter",
    "The Sleepy Penguin's Icy Dream",
    "Dreamland Detective Puppies",
    "The Nighttime Adventure of Little Dreamer"
  ];

  const CreateState(this.bookId, this.pages, this.childName, this.readerAge,
      this.story, this.enoughFunds);

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'childName': childName,
      'readerAge': readerAge,
      'story': story,
      'requiredPages': pages,
      'enoughFunds': enoughFunds,
    };
  }

  CreateState copy({
    int? pages,
    String? childName,
    String? readerAge,
    String? story,
    bool? enoughFunds,
  }) {
    return CreateInitial(
      bookId,
      pages ?? this.pages,
      childName ?? this.childName,
      readerAge ?? this.readerAge,
      story ?? this.story,
      enoughFunds ?? this.enoughFunds,
    );
  }
}

class CreateInitial extends CreateState {
  const CreateInitial(super.bookId, super.pages, super.childName,
      super.readerAge, super.story, super.enoughFunds);
}

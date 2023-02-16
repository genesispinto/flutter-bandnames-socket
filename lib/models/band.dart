// ignore_for_file: public_member_api_docs, sort_constructors_first



class Band {
  String id;
  String name;
  int votes;
  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj){
    return Band(
      id: obj.containsKey('id') ? obj['id'] : 'no-id', 
      name: obj.containsKey('name') ? obj['name'] : 'no-name', 
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes');
  }


}

class Seller {

  String? name;
  String? uid;
  String? photoUrl;
  String? email;
  String? rating;

  Seller({this.name,this.uid,this.photoUrl,this.email,this.rating});

  Seller.fromJson(Map<String,dynamic> json)
  {
    name= json['name'];
    uid= json['uid'];
    photoUrl= json['photoUrl'];
    email= json['email'];
    rating= json['ratings'];
  }

}
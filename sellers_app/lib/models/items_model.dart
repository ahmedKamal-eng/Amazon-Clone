
class Item {

  String? brandId;
  String? itemId;
  String? itemInfo;
  String? itemTitle;
  String? longDescription;
  String? price;
  String? publishedDate;
  String? sellerName;
  String? sellerUID;
  String? status;
  String? thumbnailsUrl;

  Item({
    this.brandId,
    this.status,
    this.price,
    this.itemId,
    this.itemInfo,
    this.itemTitle,
    this.longDescription,
    this.publishedDate,
    this.sellerName,
    this.sellerUID,
    this.thumbnailsUrl,
  });

  Item.fromJson(Map<String,dynamic> json)
  {
     brandId =json['brandId'];
     itemId =json['itemId'];
     itemInfo =json['itemInfo'];
     itemTitle =json['itemTitle'];
     longDescription =json['description'];
     price=json['price'];
     publishedDate=json['publishDate'].toString();
     sellerName=json['sellerName'];
     sellerUID =json['sellerUid'];
     status=json['status'];
     thumbnailsUrl=json['thumbnailUrl'];
  }

}

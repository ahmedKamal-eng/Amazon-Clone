

class Brand{
  String? brandId;
  String? brandInfo;
  String? brandTitle;
  String? publishDate;
  String? sellerUid;
  String? status;
  String? thumbnailUrl;

  Brand({this.brandId,this.brandInfo,this.brandTitle,this.publishDate,this.sellerUid,this.status,this.thumbnailUrl});

  Brand.fromJson(Map<String,dynamic> json)
  { brandId=json['brandId'];
    brandInfo=json['brandInfo'];
    brandTitle=json['brandTitle'];
    publishDate=json['publishDate'].toString();
    sellerUid=json['sellerUid'];
    status=json['status'];
    thumbnailUrl=json['thumbnailUrl'];}
}
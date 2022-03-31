class HotelListData {
  String? date;
  String? description;
  int? id;
  String? image;
  String? name;
  String? popularDescription;
  String? popularImage;
  String? docId;

  HotelListData({this.date, this.description, this.id, this.image, this.name,
    this.popularDescription, this.popularImage,this.docId});

  Map<String,dynamic> toJson() {
    final data = {
      'date': date,
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'popular_description': popularDescription,
      'popular_image': popularImage
    };
    return data;
  }

}

class TicketJson {
  int productId;
  String productName;
  double rate;

  TicketJson({this.productId, this.productName, this.rate});

  factory TicketJson.fromJson(Map<String, dynamic> parsedJson) {
    return TicketJson(
      productId: parsedJson["productId"],
      productName: parsedJson["productName"] as String,
      rate: parsedJson["sellingPrice"] ,
    );
  }
}
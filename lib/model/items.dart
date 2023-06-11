class Item{
  String? itemId;
  String? userId;
  String? itemName;
  String? itemDesc;
  String? itemPrice;
  String? itemDelivery;
  String? itemQty;
  String? itemState;
  String? itemLocal;
  String? itemLat;
  String? itemLng;
  String? itemDate;

  Item(
    {required this.itemId,
    required this.userId,
    required this.itemName,
    required this.itemQty,    
    required this.itemPrice,
    required this.itemDelivery,
    required this.itemDesc,
    required this.itemDate,
    required this.itemState,
    required this.itemLocal,
    required this.itemLat,
    required this.itemLng});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemDesc = json['item_desc'];
    itemPrice = json['item_price'];
    itemDelivery = json['item_delivery'];
    itemQty = json['item_qty'];
    itemState = json['item_state'];
    itemLocal = json['item_local'];
    itemLat = json['item_lat'];
    itemLng = json['item_lng'];
    itemDate = json['item_date'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_desc'] = itemDesc;
    data['item_price'] = itemPrice;
    data['item_delivery'] = itemDelivery;
    data['item_qty'] = itemQty;
    data['item_state'] = itemState;
    data['item_local'] = itemLocal;
    data['item_lat'] = itemLat;
    data['item_lng'] = itemLng;
    data['item_date'] = itemDate;
    return data;
  }

}
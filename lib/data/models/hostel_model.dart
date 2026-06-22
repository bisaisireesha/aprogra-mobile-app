class HostelModel {
  final String id;
  final String blockName;
  final int totalRooms;
  final int occupiedRooms;
  final String wardenName;

  HostelModel({
    required this.id,
    required this.blockName,
    required this.totalRooms,
    required this.occupiedRooms,
    required this.wardenName,
  });

  factory HostelModel.fromJson(Map<String, dynamic> json) {
    return HostelModel(
      id: json['id'] as String,
      blockName: json['blockName'] as String,
      totalRooms: json['totalRooms'] as int,
      occupiedRooms: json['occupiedRooms'] as int,
      wardenName: json['wardenName'] as String,
    );
  }
}

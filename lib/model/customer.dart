import 'dart:convert';
import 'dart:typed_data';

class Customer {
  String? customerId;
  String? name;
  String? mobile;
  String? email;
  String? address;
  double? latitude;
  double? longitude;
  String? imagePath;
  Uint8List? imageData;
  Customer({
    this.customerId,
    this.name,
    this.mobile,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.imagePath,
    this.imageData,
  });

  Customer copyWith({
    String? customerId,
    String? name,
    String? mobile,
    String? email,
    String? address,
    double? latitude,
    double? longitude,
    String? imagePath,
    Uint8List? imageData,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePath: imagePath ?? this.imagePath,
      imageData: imageData ?? this.imageData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'imageData': imageData?.asMap(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customerId: map['customerId'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      address: map['address'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      imagePath: map['imagePath'],
      imageData: Uint8List.fromList(List<int>.from(map['imageData'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(customerId: $customerId, name: $name, mobile: $mobile, email: $email, address: $address, latitude: $latitude, longitude: $longitude, imagePath: $imagePath, imageData: $imageData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.customerId == customerId &&
        other.name == name &&
        other.mobile == mobile &&
        other.email == email &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.imagePath == imagePath &&
        other.imageData == imageData;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
        name.hashCode ^
        mobile.hashCode ^
        email.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        imagePath.hashCode ^
        imageData.hashCode;
  }
}

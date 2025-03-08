
class Profile {
  int? id;
  String? name;
  String? phone;
  int? age;
  double? weight;
  double? height;
  String? chronicDiseases;
  String? emergencyContact;
  String? phoneNumber;
  String? address;
  String? city;
  String? country;
  String? bloodType;
  String? allergies;
  String? medications;
  String? additionalNotes;
  String? slug;
  DateTime? dateTime;
  int? user;
  String? image;

  // Constructor
  Profile({
    this.id,
    this.name,
    this.phone,
    this.age,
    this.weight,
    this.height,
    this.chronicDiseases,
    this.emergencyContact,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.bloodType,
    this.allergies,
    this.medications,
    this.additionalNotes,
    this.slug,
    this.dateTime,
    this.user,
    this.image,
  });

  // Factory method to create an instance from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      phone: json['phon'],
      age: json['age'],
      weight: json['weight'] != null ? double.tryParse(json['weight'].toString()) : null,
      height: json['height'] != null ? double.tryParse(json['height'].toString()) : null,
      chronicDiseases: json['chronic_diseases'],
      emergencyContact: json['emergency_contact'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      bloodType: json['blood_type'],
      allergies: json['allergies'],
      medications: json['medications'],
      additionalNotes: json['additional_notes'],
      slug: json['slug'],
      dateTime: json['dete_time'] != null ? DateTime.parse(json['dete_time']) : null,
      user: json['user'],
      image: json['image'],
    );
  }

  // Method to convert the class instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phon': phone,
      'age': age,
      'weight': weight,
      'height': height,
      'chronic_diseases': chronicDiseases,
      'emergency_contact': emergencyContact,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'country': country,
      'blood_type': bloodType,
      'allergies': allergies,
      'medications': medications,
      'additional_notes': additionalNotes,
      'slug': slug,
      'dete_time': dateTime?.toIso8601String(),
      'user': user,
      'image': image,
    };
  }
}

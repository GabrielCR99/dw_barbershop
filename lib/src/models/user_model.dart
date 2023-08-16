sealed class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) =>
      switch (json['profile']) {
        'ADM' => UserModelAdm.fromMap(json),
        'EMPLOYEE' => UserModelEmployee.fromMap(json),
        _ => throw FormatException('Invalid UserModel JSON: $json'),
      };
}

final class UserModelAdm extends UserModel {
  final List<String>? workDays;
  final List<int>? workHours;

  const UserModelAdm({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    this.workDays,
    this.workHours,
  });

  factory UserModelAdm.fromMap(Map<String, dynamic> json) => switch (json) {
        {
          'id': final int id,
          'name': final String name,
          'email': final String email
        } =>
          UserModelAdm(
            id: id,
            name: name,
            email: email,
            avatar: json['avatar'] as String?,
            workDays: (json['workDays'] as List<Object?>?)?.cast<String>(),
            workHours: (json['workHours'] as List<Object?>?)?.cast<int>(),
          ),
        _ => throw FormatException('Invalid UserModelAdm JSON: $json'),
      };
}

final class UserModelEmployee extends UserModel {
  final int barberShopId;
  final List<String> workDays;
  final List<int> workHours;

  const UserModelEmployee({
    required super.id,
    required super.name,
    required super.email,
    required this.barberShopId,
    required this.workDays,
    required this.workHours,
    super.avatar,
  });

  factory UserModelEmployee.fromMap(Map<String, dynamic> json) =>
      switch (json) {
        {
          'id': final int id,
          'name': final String name,
          'email': final String email,
          'barbershop_id': final int barberShopId,
          'work_days': final List<Object?> workDays,
          'work_hours': final List<Object?> workHours,
        } =>
          UserModelEmployee(
            id: id,
            name: name,
            email: email,
            barberShopId: barberShopId,
            workDays: workDays.cast<String>(),
            workHours: workHours.cast<int>(),
            avatar: json['avatar'] as String?,
          ),
        _ => throw FormatException('Invalid UserModelEmployee JSON: $json'),
      };
}

final class ScheduleModel {
  final int id;
  final int barbershopId;
  final int userId;
  final String clientName;
  final DateTime date;
  final int hour;

  const ScheduleModel({
    required this.id,
    required this.barbershopId,
    required this.userId,
    required this.clientName,
    required this.date,
    required this.hour,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': final int id,
          'barbershop_id': final int barbershopId,
          'user_id': final int userId,
          'client_name': final String clientName,
          'date': final String date,
          'time': final int hour,
        } =>
          ScheduleModel(
            id: id,
            barbershopId: barbershopId,
            userId: userId,
            clientName: clientName,
            date: DateTime.parse(date),
            hour: hour,
          ),
        _ => throw const FormatException('Unexpected JSON structure'),
      };
}

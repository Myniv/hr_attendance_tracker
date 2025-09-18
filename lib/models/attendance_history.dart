class AttendanceHistory {
  int? id;
  DateTime date;
  DateTime? in_time;
  DateTime? out_time;
  double? total_hours;
  String? employee_id;
  String? status;
  String? in_photo;
  String? out_photo;
  String? in_latlong;
  String? out_latlong;

  AttendanceHistory({
    this.id,
    required DateTime date,
    this.in_time,
    this.out_time,
    this.total_hours,
    this.employee_id,
    this.status,
    this.in_photo,
    this.out_photo,
    this.in_latlong,
    this.out_latlong,
  }) : date = DateTime(date.year, date.month, date.day);

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    DateTime dateOnly = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    );

    return AttendanceHistory(
      id: json['id'],
      date: dateOnly,
      in_time: json['in_time'] != null ? DateTime.parse(json['in_time']) : null,
      out_time: json['out_time'] != null
          ? DateTime.parse(json['out_time'])
          : null,
      total_hours: json['total_hours']?.toDouble(),
      employee_id: json['employee_id'],
      status: json['status'],
      in_photo: json['in_photo'],
      out_photo: json['out_photo'],
      in_latlong: json['in_latlong'],
      out_latlong: json['out_latlong'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String(),
      'in_time': in_time?.toIso8601String(),
      'out_time': out_time?.toIso8601String(),
      'total_hours': total_hours,
      'employee_id': employee_id,
      'status': status,
      'in_photo': in_photo,
      'out_photo': out_photo,
      'in_latlong': in_latlong,
      'out_latlong': out_latlong,
    };
  }
}

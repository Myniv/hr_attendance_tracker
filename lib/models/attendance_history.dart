class AttendanceHistory {
  int? id;
  DateTime date;
  DateTime? in_time;
  DateTime? out_time;
  double? total_hours;
  String? employee_id;

  AttendanceHistory({
    this.id,
    required DateTime date,
    this.in_time,
    this.out_time,
    this.total_hours,
    this.employee_id,
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
    };
  }
}

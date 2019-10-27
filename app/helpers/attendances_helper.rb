module AttendancesHelper
  
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価する
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらない場合はfalseを返す
    false
  end
  
  # 出勤時と退勤時間を受け取り、在社時間を計算して返す
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
end

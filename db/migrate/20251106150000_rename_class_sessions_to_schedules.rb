class RenameClassSessionsToSchedules < ActiveRecord::Migration[8.1]
  def change
    rename_table :class_sessions, :schedules
    # rename index if it exists
    if index_name_exists?(:schedules, 'index_class_sessions_on_group_day_start')
      rename_index :schedules, 'index_class_sessions_on_group_day_start', 'index_schedules_on_group_day_start'
    end
  end
end

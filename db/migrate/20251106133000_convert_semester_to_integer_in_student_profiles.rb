class ConvertSemesterToIntegerInStudentProfiles < ActiveRecord::Migration[8.1]
  def up
    # Add temporary integer column
    add_column :student_profiles, :semester_tmp, :integer

    # Backfill from existing string values to integers
    StudentProfile.reset_column_information
    StudentProfile.find_each do |profile|
      case profile.semester&.downcase
      when 'fall'
        profile.update_column(:semester_tmp, 1)
      when 'spring'
        profile.update_column(:semester_tmp, 2)
      else
        # try parse numeric strings
        if profile.semester.to_s =~ /\A\d+\z/
          profile.update_column(:semester_tmp, profile.semester.to_i)
        else
          profile.update_column(:semester_tmp, nil)
        end
      end
    end

    # Remove old column and rename tmp to semester
    remove_column :student_profiles, :semester
    rename_column :student_profiles, :semester_tmp, :semester
  end

  def down
    add_column :student_profiles, :semester_tmp, :string
    StudentProfile.reset_column_information
    StudentProfile.find_each do |profile|
      profile.update_column(:semester_tmp, profile.semester.to_s)
    end
    remove_column :student_profiles, :semester
    rename_column :student_profiles, :semester_tmp, :semester
  end
end

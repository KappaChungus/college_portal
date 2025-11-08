module Api
  module Teacher
    class ManageCoursesController < BaseController
      # GET /api/teacher/courses
      def index
        teacher = current_user.becomes(::Teacher)

  # include courses where teacher is primary or through course_teachers join
  # Use a single WHERE with subselect to keep the relation structurally compatible
  courses = Course.where("teacher_id = :tid OR id IN (SELECT course_id FROM course_teachers WHERE teacher_id = :tid)", tid: teacher.id).distinct

        render json: courses.as_json(only: [ :id, :code, :title, :group_id ])
      end

      # GET /api/teacher/courses/:id
      def show
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        # Ensure teacher can see this course
        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

        render json: course.as_json(include: { group: { only: [ :id, :name ] }, teacher: { only: [ :id, :name, :email ] } }, only: [ :id, :code, :title ])
      end

      # GET /api/teacher/courses/:id/students
      def students
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

  # The app uses `student_courses` (StudentCourse) instead of enrollments table.
  # Query users through StudentCourse to avoid relying on a missing enrollments table.
  students = User.where(id: StudentCourse.where(course_id: course.id).select(:student_id)).distinct
  render json: students.as_json(only: [ :id, :name, :email ])
      end

      # POST /api/teacher/courses/:id/student/:student_id/mark
      # Params: name (string), mark (int)
      def mark
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

  # student_id comes from the route param now
  student_id = params[:student_id]
  return render json: { error: "student_id is required" }, status: :bad_request unless student_id

        sc = StudentCourse.find_or_initialize_by(course_id: course.id, student_id: student_id)
        # initialize default values if new
        sc.status ||= "current"

        name = params[:name].to_s
        mark_value = params[:mark].to_i

        sc.grades ||= []
        sc.grades << { "name" => name, "mark" => mark_value, "added_by" => current_user.id, "created_at" => Time.now.utc }

        if sc.save
          render json: sc.as_json(only: [ :id, :final_grade, :grades, :student_id, :course_id ])
        else
          render json: { error: sc.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      # GET /api/teacher/courses/:id/student/:student_id/marks
      # Returns all marks for the given student in this course
      def marks
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

        student_id = params[:student_id]
        return render json: { error: "student_id is required" }, status: :bad_request unless student_id

        sc = StudentCourse.find_by(course_id: course.id, student_id: student_id)
        marks = sc&.grades || []
        render json: { marks: marks }
      end

      # GET /api/teacher/courses/:id/student/:student_id/grades
      # Returns all grades for the given student in this course
      def grades
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

        student_id = params[:student_id]
        return render json: { error: "student_id is required" }, status: :bad_request unless student_id

        sc = StudentCourse.find_by(course_id: course.id, student_id: student_id)
        grades = sc&.grades || []
        render json: { grades: grades }
      end

      # PUT /api/teacher/courses/:id/student/:student_id/grade/:grade_index
      # Params: name (string), mark (int)
      def update_grade
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

        student_id = params[:student_id]
        grade_index = params[:grade_index].to_i
        return render json: { error: "student_id and grade_index are required" }, status: :bad_request unless student_id

        sc = StudentCourse.find_by(course_id: course.id, student_id: student_id)
        return render json: { error: "Student course not found" }, status: :not_found unless sc

        grades = sc.grades || []
        return render json: { error: "Grade not found" }, status: :not_found if grade_index < 0 || grade_index >= grades.length

        # Update the grade
        grades[grade_index]["name"] = params[:name].to_s if params[:name]
        grades[grade_index]["mark"] = params[:mark].to_i if params[:mark]
        grades[grade_index]["updated_at"] = Time.now.utc
        grades[grade_index]["updated_by"] = current_user.id

        sc.grades = grades
        if sc.save
          render json: { grades: sc.grades }
        else
          render json: { error: sc.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      # DELETE /api/teacher/courses/:id/student/:student_id/grade/:grade_index
      def delete_grade
        course = Course.find_by(id: params[:id])
        return render json: { error: "Course not found" }, status: :not_found unless course

        teacher = current_user.becomes(::Teacher)
        permitted = course.teacher_id == teacher.id || course.course_teachers.exists?(teacher_id: teacher.id)
        return render json: { error: "Access denied" }, status: :forbidden unless permitted

        student_id = params[:student_id]
        grade_index = params[:grade_index].to_i
        return render json: { error: "student_id and grade_index are required" }, status: :bad_request unless student_id

        sc = StudentCourse.find_by(course_id: course.id, student_id: student_id)
        return render json: { error: "Student course not found" }, status: :not_found unless sc

        grades = sc.grades || []
        return render json: { error: "Grade not found" }, status: :not_found if grade_index < 0 || grade_index >= grades.length

        # Delete the grade
        grades.delete_at(grade_index)
        sc.grades = grades

        if sc.save
          render json: { grades: sc.grades }
        else
          render json: { error: sc.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      private
    end
  end
end

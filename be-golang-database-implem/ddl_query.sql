-- ============================================
-- 1. CREATE ENUM TYPES FIRST
-- ============================================
CREATE TYPE user_status_enum AS ENUM ('active', 'inactive', 'suspended');
CREATE TYPE attendance_status_enum AS ENUM ('present', 'absent', 'late', 'excused');

-- ============================================
-- 2. CREATE TABLES (urut dari yang paling independent)
-- ============================================

-- Table: users
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    status user_status_enum DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: classrooms
CREATE TABLE classrooms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: classroom_mentors
CREATE TABLE classroom_mentors (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    mentor_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: classroom_students
CREATE TABLE classroom_students (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: schedules
CREATE TABLE schedules (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    topic VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: materials
CREATE TABLE materials (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    uploaded_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: material_classrooms
CREATE TABLE material_classrooms (
    id BIGSERIAL PRIMARY KEY,
    material_id BIGINT NOT NULL,
    classroom_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Table: attendances
CREATE TABLE attendances (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    status attendance_status_enum NOT NULL,
    checked_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: assignments
CREATE TABLE assignments (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_url TEXT,
    deadline TIMESTAMP NOT NULL,
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: assignment_submissions
CREATE TABLE assignment_submissions (
    id BIGSERIAL PRIMARY KEY,
    assignment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    file_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: grades
CREATE TABLE grades (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    assignment_id BIGINT NOT NULL,
    grade DECIMAL(5,2) CHECK (grade >= 0 AND grade <= 100),
    feedback TEXT,
    graded_by BIGINT NOT NULL,
    graded_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: announcements
CREATE TABLE announcements (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    created_by BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: notifications
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    announcement_id BIGINT,
    discussion_id BIGINT,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: discussions
CREATE TABLE discussions (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    parent_id BIGINT,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: feedbacks
CREATE TABLE feedbacks (
    id BIGSERIAL PRIMARY KEY,
    from_user_id BIGINT NOT NULL,
    to_user_id BIGINT NOT NULL,
    classroom_id BIGINT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- 3. ADD FOREIGN KEY CONSTRAINTS
-- ============================================

-- classroom_mentors
ALTER TABLE classroom_mentors 
ADD CONSTRAINT fk_classroom_mentors_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

ALTER TABLE classroom_mentors 
ADD CONSTRAINT fk_classroom_mentors_mentor 
FOREIGN KEY (mentor_id) REFERENCES users(id) ON DELETE CASCADE;

-- classroom_students
ALTER TABLE classroom_students 
ADD CONSTRAINT fk_classroom_students_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

ALTER TABLE classroom_students 
ADD CONSTRAINT fk_classroom_students_student 
FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE;

-- schedules
ALTER TABLE schedules 
ADD CONSTRAINT fk_schedules_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

-- materials
ALTER TABLE materials 
ADD CONSTRAINT fk_materials_uploader 
FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE CASCADE;

-- material_classrooms
ALTER TABLE material_classrooms 
ADD CONSTRAINT fk_material_classrooms_material 
FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE;

ALTER TABLE material_classrooms 
ADD CONSTRAINT fk_material_classrooms_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

-- attendances
ALTER TABLE attendances 
ADD CONSTRAINT fk_attendances_schedule 
FOREIGN KEY (schedule_id) REFERENCES schedules(id) ON DELETE CASCADE;

ALTER TABLE attendances 
ADD CONSTRAINT fk_attendances_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- assignments
ALTER TABLE assignments 
ADD CONSTRAINT fk_assignments_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

ALTER TABLE assignments 
ADD CONSTRAINT fk_assignments_creator 
FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE;

-- assignment_submissions
ALTER TABLE assignment_submissions 
ADD CONSTRAINT fk_assignment_submissions_assignment 
FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE;

ALTER TABLE assignment_submissions 
ADD CONSTRAINT fk_assignment_submissions_student 
FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE;

-- grades
ALTER TABLE grades 
ADD CONSTRAINT fk_grades_student 
FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE grades 
ADD CONSTRAINT fk_grades_assignment 
FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE;

ALTER TABLE grades 
ADD CONSTRAINT fk_grades_graded_by 
FOREIGN KEY (graded_by) REFERENCES users(id) ON DELETE CASCADE;

-- announcements
ALTER TABLE announcements 
ADD CONSTRAINT fk_announcements_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

ALTER TABLE announcements 
ADD CONSTRAINT fk_announcements_creator 
FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE;

-- notifications
ALTER TABLE notifications 
ADD CONSTRAINT fk_notifications_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE notifications 
ADD CONSTRAINT fk_notifications_announcement 
FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON DELETE SET NULL;

-- discussions
ALTER TABLE discussions 
ADD CONSTRAINT fk_discussions_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

ALTER TABLE discussions 
ADD CONSTRAINT fk_discussions_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE discussions 
ADD CONSTRAINT fk_discussions_parent 
FOREIGN KEY (parent_id) REFERENCES discussions(id) ON DELETE CASCADE;

-- feedbacks
ALTER TABLE feedbacks 
ADD CONSTRAINT fk_feedbacks_from_user 
FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE feedbacks 
ADD CONSTRAINT fk_feedbacks_to_user 
FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE feedbacks 
ADD CONSTRAINT fk_feedbacks_classroom 
FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE;

-- ============================================
-- 4. ADD UNIQUE CONSTRAINTS (Composite Keys)
-- ============================================

-- Prevent duplicate mentor-classroom assignment
ALTER TABLE classroom_mentors 
ADD CONSTRAINT unique_mentor_classroom 
UNIQUE (classroom_id, mentor_id);

-- Prevent duplicate student-classroom assignment
ALTER TABLE classroom_students 
ADD CONSTRAINT unique_student_classroom 
UNIQUE (classroom_id, student_id);

-- One attendance per user per schedule
ALTER TABLE attendances 
ADD CONSTRAINT unique_attendance 
UNIQUE (schedule_id, user_id);

-- One submission per student per assignment
ALTER TABLE assignment_submissions 
ADD CONSTRAINT unique_submission 
UNIQUE (assignment_id, student_id);

-- One grade per student per assignment
ALTER TABLE grades 
ADD CONSTRAINT unique_grade 
UNIQUE (assignment_id, student_id);

-- One feedback per from-to-classroom combination
ALTER TABLE feedbacks 
ADD CONSTRAINT unique_feedback 
UNIQUE (from_user_id, to_user_id, classroom_id);

-- ============================================
-- 5. ADD INDEXES FOR PERFORMANCE
-- ============================================

-- Index untuk foreign keys
CREATE INDEX idx_classroom_mentors_classroom ON classroom_mentors(classroom_id);
CREATE INDEX idx_classroom_mentors_mentor ON classroom_mentors(mentor_id);
CREATE INDEX idx_classroom_students_classroom ON classroom_students(classroom_id);
CREATE INDEX idx_classroom_students_student ON classroom_students(student_id);
CREATE INDEX idx_schedules_classroom ON schedules(classroom_id);
CREATE INDEX idx_materials_uploaded_by ON materials(uploaded_by);
CREATE INDEX idx_material_classrooms_material ON material_classrooms(material_id);
CREATE INDEX idx_material_classrooms_classroom ON material_classrooms(classroom_id);
CREATE INDEX idx_attendances_schedule ON attendances(schedule_id);
CREATE INDEX idx_attendances_user ON attendances(user_id);
CREATE INDEX idx_assignments_classroom ON assignments(classroom_id);
CREATE INDEX idx_assignments_created_by ON assignments(created_by);
CREATE INDEX idx_assignment_submissions_assignment ON assignment_submissions(assignment_id);
CREATE INDEX idx_assignment_submissions_student ON assignment_submissions(student_id);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_assignment ON grades(assignment_id);
CREATE INDEX idx_grades_graded_by ON grades(graded_by);
CREATE INDEX idx_announcements_classroom ON announcements(classroom_id);
CREATE INDEX idx_announcements_created_by ON announcements(created_by);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_announcement ON notifications(announcement_id);
CREATE INDEX idx_discussions_classroom ON discussions(classroom_id);
CREATE INDEX idx_discussions_user ON discussions(user_id);
CREATE INDEX idx_discussions_parent ON discussions(parent_id);
CREATE INDEX idx_feedbacks_from_user ON feedbacks(from_user_id);
CREATE INDEX idx_feedbacks_to_user ON feedbacks(to_user_id);
CREATE INDEX idx_feedbacks_classroom ON feedbacks(classroom_id);

-- Index untuk query yang sering digunakan
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_schedules_time_range ON schedules(start_time, end_time);
CREATE INDEX idx_assignments_deadline ON assignments(deadline);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_discussions_created_at ON discussions(created_at);
CREATE INDEX idx_announcements_created_at ON announcements(created_at);

-- ============================================
-- 6. ADD TRIGGERS FOR UPDATED_AT (Optional)
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at
DO $$ 
DECLARE 
    tbl text;
BEGIN 
    FOR tbl IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_at' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            DROP TRIGGER IF EXISTS update_%s_updated_at ON %s;
            CREATE TRIGGER update_%s_updated_at
            BEFORE UPDATE ON %s
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();
        ', tbl, tbl, tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 7. VERIFICATION QUERY
-- ============================================
SELECT 
    'Database created successfully!' as message,
    COUNT(*) as table_count
FROM information_schema.tables 
WHERE table_schema = 'public';
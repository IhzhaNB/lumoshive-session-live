-- ============================================
-- 1. INSERT USERS (20 users)
-- ============================================
INSERT INTO users (name, email, password, role, status) VALUES
-- Admin
('Admin Utama', 'admin@school.com', '$2y$10$abc123', 'admin', 'active'),

-- Mentors (3)
('Mentor Budi Santoso', 'budi@school.com', '$2y$10$def456', 'mentor', 'active'),
('Mentor Sari Wijaya', 'sari@school.com', '$2y$10$ghi789', 'mentor', 'active'),
('Mentor Agus Prabowo', 'agus@school.com', '$2y$10$jkl012', 'mentor', 'active'),

-- Students (16)
('Andi Wijaya', 'andi@school.com', '$2y$10$mno345', 'student', 'active'),
('Budi Hartono', 'budi.student@school.com', '$2y$10$pqr678', 'student', 'active'),
('Citra Dewi', 'citra@school.com', '$2y$10$stu901', 'student', 'active'),
('Dedi Kurniawan', 'dedi@school.com', '$2y$10$vwx234', 'student', 'active'),
('Eka Putri', 'eka@school.com', '$2y$10$yza567', 'student', 'active'),
('Fajar Ramadan', 'fajar@school.com', '$2y$10$bcd890', 'student', 'active'),
('Gita Maharani', 'gita@school.com', '$2y$10$efg123', 'student', 'active'),
('Hendra Pratama', 'hendra@school.com', '$2y$10$hij456', 'student', 'active'),
('Intan Permata', 'intan@school.com', '$2y$10$klm789', 'student', 'active'),
('Joko Susilo', 'joko@school.com', '$2y$10$nop012', 'student', 'active'),
('Kartika Sari', 'kartika@school.com', '$2y$10$qrs345', 'student', 'active'),
('Lukman Hakim', 'lukman@school.com', '$2y$10$tuv678', 'student', 'active'),
('Maya Indah', 'maya@school.com', '$2y$10$wxy901', 'student', 'active'),
('Nina Rosita', 'nina@school.com', '$2y$10$zab234', 'student', 'active'),
('Oki Setiawan', 'oki@school.com', '$2y$10$cde567', 'student', 'active'),
('Putri Ayu', 'putri@school.com', '$2y$10$fgh890', 'student', 'active');

-- ============================================
-- 2. INSERT CLASSROOMS (3 kelas)
-- ============================================
INSERT INTO classrooms (name, description) VALUES
('Kelas Backend Basic', 'Pemrograman Backend dengan Node.js dan PostgreSQL'),
('Kelas Frontend Pro', 'Advanced Frontend: React, Vue, dan State Management'),
('Kelas Fullstack Developer', 'Fullstack Development dengan MERN Stack');

-- ============================================
-- 3. INSERT CLASSROOM_MENTORS (Assign mentors ke kelas)
-- ============================================
INSERT INTO classroom_mentors (classroom_id, mentor_id) VALUES
-- Kelas Backend: Mentor Budi & Sari
(1, 2), (1, 3),
-- Kelas Frontend: Mentor Agus
(2, 4),
-- Kelas Fullstack: Mentor Budi & Agus
(3, 2), (3, 4);

-- ============================================
-- 4. INSERT CLASSROOM_STUDENTS (Assign students ke kelas)
-- ============================================
INSERT INTO classroom_students (classroom_id, student_id) VALUES
-- Kelas Backend (8 siswa)
(1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12),
-- Kelas Frontend (5 siswa)
(2, 13), (2, 14), (2, 15), (2, 16), (2, 17),
-- Kelas Fullstack (7 siswa)
(3, 18), (3, 19), (3, 20), (3, 5), (3, 7), (3, 13), (3, 15);

-- ============================================
-- 5. INSERT SCHEDULES (Jadwal per kelas)
-- ============================================
INSERT INTO schedules (classroom_id, start_time, end_time, topic) VALUES
-- Kelas Backend: Senin & Rabu
(1, '2024-01-08 09:00:00', '2024-01-08 11:00:00', 'Intro to Backend & REST API'),
(1, '2024-01-10 09:00:00', '2024-01-10 11:00:00', 'Database Design & PostgreSQL'),
(1, '2024-01-15 09:00:00', '2024-01-15 11:00:00', 'Authentication & Authorization'),
(1, '2024-01-17 09:00:00', '2024-01-17 11:00:00', 'Deployment & DevOps Basics'),

-- Kelas Frontend: Selasa & Kamis
(2, '2024-01-09 13:00:00', '2024-01-09 15:00:00', 'Advanced React Hooks'),
(2, '2024-01-11 13:00:00', '2024-01-11 15:00:00', 'State Management dengan Redux'),
(2, '2024-01-16 13:00:00', '2024-01-16 15:00:00', 'Testing dengan Jest'),
(2, '2024-01-18 13:00:00', '2024-01-18 15:00:00', 'Performance Optimization'),

-- Kelas Fullstack: Jumat & Sabtu
(3, '2024-01-12 10:00:00', '2024-01-12 12:00:00', 'MERN Stack Overview'),
(3, '2024-01-13 10:00:00', '2024-01-13 12:00:00', 'Fullstack Project Structure'),
(3, '2024-01-19 10:00:00', '2024-01-19 12:00:00', 'Real-time dengan Socket.io'),
(3, '2024-01-20 10:00:00', '2024-01-20 12:00:00', 'Deployment Fullstack App');

-- ============================================
-- 6. INSERT ATTENDANCES (Kehadiran siswa per jadwal)
-- ============================================
INSERT INTO attendances (schedule_id, user_id, status, checked_at) VALUES
-- Jadwal 1 (Backend - 8 siswa)
(1, 5, 'present', '2024-01-08 08:55:00'),
(1, 6, 'present', '2024-01-08 08:58:00'),
(1, 7, 'late', '2024-01-08 09:15:00'),
(1, 8, 'present', '2024-01-08 08:50:00'),
(1, 9, 'absent', NULL),
(1, 10, 'present', '2024-01-08 09:00:00'),
(1, 11, 'present', '2024-01-08 08:45:00'),
(1, 12, 'excused', '2024-01-08 08:30:00'),

-- Jadwal 2 (Backend)
(2, 5, 'present', '2024-01-10 08:58:00'),
(2, 6, 'present', '2024-01-10 09:00:00'),
(2, 7, 'present', '2024-01-10 08:55:00'),
(2, 8, 'late', '2024-01-10 09:10:00'),
(2, 9, 'present', '2024-01-10 08:52:00'),
(2, 10, 'absent', NULL),
(2, 11, 'present', '2024-01-10 09:00:00'),
(2, 12, 'present', '2024-01-10 08:48:00'),

-- Jadwal 5 (Frontend - 5 siswa)
(5, 13, 'present', '2024-01-09 12:55:00'),
(5, 14, 'present', '2024-01-09 12:58:00'),
(5, 15, 'present', '2024-01-09 13:00:00'),
(5, 16, 'late', '2024-01-09 13:20:00'),
(5, 17, 'present', '2024-01-09 12:50:00'),

-- Jadwal 9 (Fullstack - 7 siswa)
(9, 18, 'present', '2024-01-12 09:55:00'),
(9, 19, 'present', '2024-01-12 10:00:00'),
(9, 20, 'late', '2024-01-12 10:15:00'),
(9, 5, 'present', '2024-01-12 09:58:00'),
(9, 7, 'absent', NULL),
(9, 13, 'present', '2024-01-12 10:00:00'),
(9, 15, 'present', '2024-01-12 09:45:00');

-- ============================================
-- 7. INSERT MATERIALS (Materi pembelajaran)
-- ============================================
INSERT INTO materials (title, file_url, uploaded_by) VALUES
('Slide REST API', 'https://storage.com/slides/api.pdf', 2),
('PostgreSQL Cheatsheet', 'https://storage.com/docs/pg-cheat.pdf', 3),
('React Hooks Guide', 'https://storage.com/docs/react-hooks.pdf', 4),
('Authentication Best Practices', 'https://storage.com/docs/auth.pdf', 2),
('Deployment Checklist', 'https://storage.com/docs/deploy.pdf', 4);

-- ============================================
-- 8. INSERT MATERIAL_CLASSROOMS (Link materi ke kelas)
-- ============================================
INSERT INTO material_classrooms (material_id, classroom_id) VALUES
(1, 1), (1, 3),    -- REST API untuk Backend & Fullstack
(2, 1), (2, 3),    -- PostgreSQL untuk Backend & Fullstack
(3, 2), (3, 3),    -- React untuk Frontend & Fullstack
(4, 1), (4, 3),    -- Auth untuk Backend & Fullstack
(5, 1), (5, 2), (5, 3);  -- Deployment untuk semua kelas

-- ============================================
-- 9. INSERT ASSIGNMENTS (Tugas per kelas)
-- ============================================
INSERT INTO assignments (classroom_id, title, description, file_url, deadline, created_by) VALUES
-- Tugas Backend
(1, 'CRUD API dengan Express', 'Buat REST API untuk manajemen user', 'https://storage.com/assignments/crud.pdf', '2024-01-20 23:59:00', 2),
(1, 'Database Design', 'Design schema untuk e-commerce', 'https://storage.com/assignments/db-design.pdf', '2024-01-25 23:59:00', 3),

-- Tugas Frontend
(2, 'Todo App dengan React', 'Buat todo app dengan React Hooks', 'https://storage.com/assignments/todo-app.pdf', '2024-01-22 23:59:00', 4),
(2, 'Redux State Management', 'Implement Redux untuk shopping cart', 'https://storage.com/assignments/redux.pdf', '2024-01-28 23:59:00', 4),

-- Tugas Fullstack
(3, 'Fullstack Blog App', 'Blog dengan React + Node.js + PostgreSQL', 'https://storage.com/assignments/blog-app.pdf', '2024-01-30 23:59:00', 2),
(3, 'Real-time Chat App', 'Chat app dengan Socket.io', 'https://storage.com/assignments/chat-app.pdf', '2024-02-05 23:59:00', 4);

-- ============================================
-- 10. INSERT ASSIGNMENT_SUBMISSIONS (Submit tugas)
-- ============================================
INSERT INTO assignment_submissions (assignment_id, student_id, file_url) VALUES
-- Submission tugas 1 (Backend CRUD API)
(1, 5, 'https://storage.com/submissions/andi-crud.zip'),
(1, 6, 'https://storage.com/submissions/budi-crud.zip'),
(1, 7, 'https://storage.com/submissions/citra-crud.zip'),
(1, 8, 'https://storage.com/submissions/dedi-crud.zip'),

-- Submission tugas 3 (Frontend Todo App)
(3, 13, 'https://storage.com/submissions/maya-todo.zip'),
(3, 14, 'https://storage.com/submissions/nina-todo.zip'),
(3, 15, 'https://storage.com/submissions/oki-todo.zip'),

-- Submission tugas 5 (Fullstack Blog)
(5, 18, 'https://storage.com/submissions/lukman-blog.zip'),
(5, 19, 'https://storage.com/submissions/intan-blog.zip'),
(5, 5, 'https://storage.com/submissions/andi-blog.zip'),  -- Andi di 2 kelas
(5, 13, 'https://storage.com/submissions/maya-blog.zip'); -- Maya di 2 kelas

-- ============================================
-- 11. INSERT GRADES (Nilai tugas)
-- ============================================
INSERT INTO grades (student_id, assignment_id, grade, feedback, graded_by) VALUES
-- Nilai tugas 1
(5, 1, 85.5, 'Good implementation, but missing error handling', 2),
(6, 1, 92.0, 'Excellent work with clean code', 2),
(7, 1, 78.0, 'Need to improve API documentation', 3),
(8, 1, 88.5, 'Good structure, but slow response time', 3),

-- Nilai tugas 3
(13, 3, 95.0, 'Perfect implementation!', 4),
(14, 3, 87.5, 'Good but needs better UI/UX', 4),
(15, 3, 82.0, 'Functional but has some bugs', 4),

-- Nilai tugas 5
(18, 5, 90.0, 'Great fullstack implementation', 2),
(19, 5, 85.0, 'Good but database design can be improved', 2),
(5, 5, 88.0, 'Well structured project', 4),
(13, 5, 93.5, 'Excellent work on both frontend and backend', 4);

-- ============================================
-- 12. INSERT ANNOUNCEMENTS (Pengumuman)
-- ============================================
INSERT INTO announcements (classroom_id, created_by, title, message) VALUES
(1, 2, 'Jadwal Ujian Akhir', 'Ujian akhir akan dilaksanakan tanggal 30 Januari 2024'),
(2, 4, 'Libur Nasional', 'Kelas ditiadakan tanggal 17 Januari karena libur nasional'),
(3, 2, 'Project Showcase', 'Presentasi final project tanggal 5 Februari 2024'),
(1, 3, 'Materi Tambahan', 'Silakan download materi tambahan di link berikut...');

-- ============================================
-- 13. INSERT NOTIFICATIONS (Notifikasi ke user)
-- ============================================
INSERT INTO notifications (user_id, announcement_id, title, message) VALUES
-- Notifikasi untuk siswa Backend
(5, 1, 'Pengumuman Baru', 'Jadwal Ujian Akhir telah diumumkan'),
(6, 1, 'Pengumuman Baru', 'Jadwal Ujian Akhir telah diumumkan'),
(7, 1, 'Pengumuman Baru', 'Jadwal Ujian Akhir telah diumumkan'),

-- Notifikasi untuk siswa Frontend
(13, 2, 'Info Libur', 'Kelas ditiadakan tanggal 17 Januari'),

-- Notifikasi untuk siswa Fullstack
(18, 3, 'Reminder', 'Presentasi final project tanggal 5 Februari'),
(19, 3, 'Reminder', 'Presentasi final project tanggal 5 Februari'),

-- Notifikasi tanpa announcement (system notification)
(5, NULL, 'Tugas Dinilai', 'Tugas CRUD API sudah dinilai'),
(13, NULL, 'Tugas Dinilai', 'Tugas Todo App sudah dinilai');

-- ============================================
-- 14. INSERT DISCUSSIONS (Diskusi per kelas)
-- ============================================
INSERT INTO discussions (classroom_id, user_id, parent_id, content) VALUES
-- Diskusi utama
(1, 5, NULL, 'Ada yang bisa bantu error "connection refused" di PostgreSQL?'),
(1, 2, 1, 'Coba cek apakah service PostgreSQL sudah running di port 5432'),

(2, 13, NULL, 'Bagaimana cara optimize React render performance?'),
(2, 4, 3, 'Gunakan React.memo dan useMemo untuk prevent unnecessary re-renders'),

(3, 18, NULL, 'Socket.io connection kadang timeout, solusinya?'),

-- Reply ke diskusi
(1, 7, 1, 'Saya juga mengalami error yang sama'),
(1, 2, 5, 'Coba restart PostgreSQL service dan cek firewall settings');

-- ============================================
-- 15. INSERT FEEDBACKS (Feedback antar user)
-- ============================================
INSERT INTO feedbacks (from_user_id, to_user_id, classroom_id, rating, comment) VALUES
-- Feedback siswa ke mentor
(5, 2, 1, 5, 'Penjelasan sangat jelas dan sabar'),
(6, 2, 1, 4, 'Materi mudah dipahami, tapi terlalu cepat'),
(13, 4, 2, 5, 'Sangat helpful dalam menjawab pertanyaan'),

-- Feedback mentor ke siswa
(2, 5, 1, 5, 'Siswa sangat aktif dan bertanya bagus'),
(4, 13, 2, 4, 'Progress baik, perlu lebih banyak practice');

-- ============================================
-- VERIFIKASI DATA
-- ============================================
SELECT 'Data berhasil diinsert!' as status;

-- Cek jumlah data per tabel
SELECT 
    'users' as table_name,
    COUNT(*) as row_count 
FROM users
UNION ALL
SELECT 'classrooms', COUNT(*) FROM classrooms
UNION ALL
SELECT 'classroom_students', COUNT(*) FROM classroom_students
UNION ALL
SELECT 'schedules', COUNT(*) FROM schedules
UNION ALL
SELECT 'attendances', COUNT(*) FROM attendances
UNION ALL
SELECT 'assignments', COUNT(*) FROM assignments
UNION ALL
SELECT 'assignment_submissions', COUNT(*) FROM assignment_submissions
UNION ALL
SELECT 'grades', COUNT(*) FROM grades
ORDER BY table_name;
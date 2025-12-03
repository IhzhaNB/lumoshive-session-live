-- 1. Jumlah siswa per-kelas
SELECT 
    c.id AS kelas_id,
    c.name AS nama_kelas,
    COUNT(cs.student_id) AS jumlah_siswa
FROM classrooms c
LEFT JOIN classroom_students cs ON c.id = cs.classroom_id
GROUP BY c.id, c.name
ORDER BY c.id;

-- 2. Jumlah Mentor per-kelas
SELECT 
    c.id AS "ID Kelas",
    c.name AS "Nama Kelas",
    COUNT(DISTINCT cm.mentor_id) AS "Jumlah Mentor",
    STRING_AGG(u.name, ', ' ORDER BY u.name) AS "Daftar Mentor"
FROM classrooms c
LEFT JOIN classroom_mentors cm ON c.id = cm.classroom_id
LEFT JOIN users u ON cm.mentor_id = u.id
GROUP BY c.id, c.name
ORDER BY c.id;

-- 3. Kehadiran siswa perjadwal
SELECT 
    s.id AS "ID Jadwal",
    c.name AS "Kelas",
    s.topic AS "Topik",
    TO_CHAR(s.start_time, 'DD/MM/YYYY') AS "Tanggal",
    TO_CHAR(s.start_time, 'HH24:MI') || ' - ' || TO_CHAR(s.end_time, 'HH24:MI') AS "Jam",
    COUNT(a.id) AS "Total",
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS "Hadir",
    COUNT(CASE WHEN a.status = 'late' THEN 1 END) AS "Terlambat",
    COUNT(CASE WHEN a.status = 'absent' THEN 1 END) AS "Absen",
    COUNT(CASE WHEN a.status = 'excused' THEN 1 END) AS "Izin",
    ROUND(
        (COUNT(CASE WHEN a.status IN ('present', 'late', 'excused') THEN 1 END) * 100.0 / 
        NULLIF(COUNT(a.id), 0)), 1
    ) AS "% Kehadiran"
FROM schedules s
JOIN classrooms c ON s.classroom_id = c.id
LEFT JOIN attendances a ON s.id = a.schedule_id
GROUP BY s.id, c.name, s.topic, s.start_time, s.end_time
ORDER BY s.start_time DESC;

-- 4. kehadiran per-siswa
-- Mingguan
SELECT 
    u.name AS "Siswa",
    c.name AS "Kelas",
    EXTRACT(WEEK FROM s.start_time) AS "Minggu",
    COUNT(DISTINCT s.id) AS "Jadwal",
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS "Hadir",
    ROUND(
        (COUNT(CASE WHEN a.status = 'present' THEN 1 END) * 100.0 /
        NULLIF(COUNT(DISTINCT s.id), 0)), 0
    ) AS "% Hadir"
FROM users u
JOIN classroom_students cs ON u.id = cs.student_id
JOIN classrooms c ON cs.classroom_id = c.id
JOIN schedules s ON c.id = s.classroom_id
LEFT JOIN attendances a ON s.id = a.schedule_id AND a.user_id = u.id
WHERE u.role = 'student'
GROUP BY u.id, u.name, c.name, EXTRACT(WEEK FROM s.start_time)
HAVING COUNT(DISTINCT s.id) > 0
ORDER BY "Minggu" DESC, c.name;

-- Bulanan
SELECT 
    u.name AS "Siswa",
    c.name AS "Kelas",
    TO_CHAR(s.start_time, 'Mon YYYY') AS "Bulan",
    COUNT(DISTINCT s.id) AS "Jadwal",
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) AS "Hadir",
    ROUND(
        (COUNT(CASE WHEN a.status = 'present' THEN 1 END) * 100.0 /
        NULLIF(COUNT(DISTINCT s.id), 0)), 0
    ) AS "% Hadir"
FROM users u
JOIN classroom_students cs ON u.id = cs.student_id
JOIN classrooms c ON cs.classroom_id = c.id
JOIN schedules s ON c.id = s.classroom_id
LEFT JOIN attendances a ON s.id = a.schedule_id AND a.user_id = u.id
WHERE u.role = 'student'
GROUP BY u.id, u.name, c.name, TO_CHAR(s.start_time, 'Mon YYYY')
HAVING COUNT(DISTINCT s.id) > 0
ORDER BY TO_CHAR(s.start_time, 'Mon YYYY') DESC, c.name;

-- 5. Daftar materi yg digunakan perkelas
SELECT 
    c.name AS "Kelas",
    COUNT(DISTINCT m.id) AS "Jumlah Materi",
    STRING_AGG(m.title, E'\n' ORDER BY m.created_at DESC) AS "Daftar Materi",
    STRING_AGG(DISTINCT u.name, ', ') AS "Diupload Oleh"
FROM classrooms c
LEFT JOIN material_classrooms mc ON c.id = mc.classroom_id
LEFT JOIN materials m ON mc.material_id = m.id
LEFT JOIN users u ON m.uploaded_by = u.id
GROUP BY c.id, c.name
ORDER BY c.name;

-- 6. Daftar Assigment
SELECT 
    c.name AS "Kelas",
    a.title AS "Assignment",
    TO_CHAR(a.deadline, 'DD/MM/YYYY HH24:MI') AS "Deadline",
    CASE 
        WHEN a.deadline < NOW() THEN 'TERLEWAT'
        WHEN a.deadline <= NOW() + INTERVAL '3 days' THEN 'SEGERA'
        ELSE 'OK'
    END AS "Status",
    u.name AS "Pembuat",
    COUNT(asub.id) AS "Jumlah Submission",
    (SELECT COUNT(*) 
     FROM classroom_students cs 
     WHERE cs.classroom_id = c.id) AS "Total Siswa",
    ROUND(
        (COUNT(asub.id) * 100.0 / 
        NULLIF((SELECT COUNT(*) 
               FROM classroom_students cs 
               WHERE cs.classroom_id = c.id), 0)), 1
    ) AS "% Submit"
FROM assignments a
JOIN classrooms c ON a.classroom_id = c.id
JOIN users u ON a.created_by = u.id
LEFT JOIN assignment_submissions asub ON a.id = asub.assignment_id
GROUP BY c.id, c.name, a.id, a.title, a.deadline, u.name
ORDER BY 
    CASE 
        WHEN a.deadline < NOW() THEN 3
        WHEN a.deadline <= NOW() + INTERVAL '3 days' THEN 2
        ELSE 1
    END,
    a.deadline,
    c.name;

-- 7. Riwayat Submission
SELECT 
    u.name AS "Siswa",
    c.name AS "Kelas",
    COUNT(DISTINCT asub.id) AS "Jumlah Submission",
    COUNT(DISTINCT g.id) AS "Sudah Dinilai",
    ROUND(AVG(g.grade), 1) AS "Rata-rata Nilai",
    COUNT(CASE WHEN asub.created_at <= a.deadline THEN 1 END) AS "Tepat Waktu",
    ROUND(
        (COUNT(CASE WHEN asub.created_at <= a.deadline THEN 1 END) * 100.0 /
        NULLIF(COUNT(DISTINCT asub.id), 0)), 1
    ) AS "% Tepat Waktu"
FROM users u
JOIN classroom_students cs ON u.id = cs.student_id
JOIN classrooms c ON cs.classroom_id = c.id
LEFT JOIN assignments a ON c.id = a.classroom_id
LEFT JOIN assignment_submissions asub ON a.id = asub.assignment_id AND u.id = asub.student_id
LEFT JOIN grades g ON a.id = g.assignment_id AND u.id = g.student_id
WHERE u.role = 'student'
GROUP BY u.id, u.name, c.name
ORDER BY c.name, "Rata-rata Nilai" DESC NULLS LAST;

-- 8. Nilai siswa per assignment
SELECT 
    u.name AS "Siswa",
    c.name AS "Kelas",
    a.title AS "Assignment",
    g.grade AS "Nilai",
    CASE 
        WHEN g.grade >= 85 THEN 'A'
        WHEN g.grade >= 70 THEN 'B'
        WHEN g.grade >= 60 THEN 'C'
        ELSE 'D'
    END AS "Grade",
    grader.name AS "Penilai",
    TO_CHAR(g.graded_at, 'DD/MM/YYYY') AS "Tanggal",
    LEFT(g.feedback, 100) AS "Feedback"
FROM grades g
JOIN users u ON g.student_id = u.id
JOIN assignments a ON g.assignment_id = a.id
JOIN classrooms c ON a.classroom_id = c.id
JOIN users grader ON g.graded_by = grader.id
ORDER BY c.name, u.name, g.graded_at DESC;

-- 9. Rata-rata Nilai per Siswa dalam Satu Kelas
SELECT 
    u.name AS "Siswa",
    c.name AS "Kelas",
    ROUND(AVG(g.grade), 2) AS "Rata-rata Nilai",
    COUNT(g.id) AS "Jumlah Assignment Dinilai",
    RANK() OVER (PARTITION BY c.name ORDER BY AVG(g.grade) DESC) AS "Ranking di Kelas",
    ROUND(
        (AVG(g.grade) * 100.0 / 
        NULLIF((SELECT AVG(g2.grade) 
               FROM grades g2 
               JOIN assignments a2 ON g2.assignment_id = a2.id 
               WHERE a2.classroom_id = c.id), 0)) - 100, 1
    ) AS "% dari Rata-rata Kelas"
FROM grades g
JOIN users u ON g.student_id = u.id
JOIN assignments a ON g.assignment_id = a.id
JOIN classrooms c ON a.classroom_id = c.id
WHERE u.role = 'student'
GROUP BY u.id, u.name, c.id, c.name
ORDER BY c.name, "Rata-rata Nilai" DESC;

-- 10. Daftar Notifikasi per User (Read/Unread)
SELECT 
    u.name AS "User",
    n.title AS "Notification",
    CASE n.is_read 
        WHEN true THEN 'READ'
        ELSE 'UNREAD' 
    END AS "Status",
    TO_CHAR(n.created_at, 'DD/MM/YYYY HH24:MI') AS "Time",
    CASE 
        WHEN n.announcement_id IS NOT NULL THEN 'From: Announcement'
        WHEN n.discussion_id IS NOT NULL THEN 'From: Discussion Reply'
        ELSE 'From: System'
    END AS "Source",
    LEFT(n.message, 100) || '...' AS "Preview"
FROM notifications n
JOIN users u ON n.user_id = u.id
WHERE u.id = 5  -- Ganti dengan user ID
ORDER BY 
    CASE WHEN n.is_read THEN 1 ELSE 0 END,
    n.created_at DESC;
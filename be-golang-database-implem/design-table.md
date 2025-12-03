```mermaid

erDiagram

  users {
    BIGINT id PK
    VARCHAR name
    VARCHAR email
    VARCHAR password
    VARCHAR role
    ENUM status
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  classrooms {
    BIGINT id PK
    VARCHAR name
    TEXT description
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  classroom_mentors {
    BIGINT id PK
    BIGINT classroom_id FK
    BIGINT mentor_id FK
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  classroom_students {
    BIGINT id PK
    BIGINT classroom_id FK
    BIGINT student_id FK
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  schedules {
    BIGINT id PK
    BIGINT classroom_id FK
    TIMESTAMP start_time
    TIMESTAMP end_time
    VARCHAR topic
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  materials {
    BIGINT id PK
    VARCHAR title
    TEXT file_url
    BIGINT uploaded_by FK
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  material_classrooms {
    BIGINT id PK
    BIGINT material_id FK
    BIGINT classroom_id FK
    TIMESTAMP created_at
  }

  attendances {
    BIGINT id PK
    BIGINT schedule_id FK
    BIGINT user_id FK
    ENUM status
    TIMESTAMP checked_at
    TIMESTAMP updated_at
  }

  assignments {
    BIGINT id PK
    BIGINT classroom_id FK
    VARCHAR title
    TEXT description
    TEXT file_url
    TIMESTAMP deadline
    BIGINT created_by FK
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  assignment_submissions {
    BIGINT id PK
    BIGINT assignment_id FK
    BIGINT student_id FK
    TEXT file_url
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  grades {
    BIGINT id PK
    BIGINT student_id FK
    BIGINT assignment_id FK
    DECIMAL grade
    TEXT feedback
    BIGINT graded_by FK
    TIMESTAMP graded_at
    TIMESTAMP updated_at
  }

  announcements {
    BIGINT id PK
    BIGINT classroom_id FK
    BIGINT created_by FK
    VARCHAR title
    TEXT message
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  notifications {
    BIGINT id PK
    BIGINT user_id FK
    BIGINT announcement_id FK
    BIGINT discussion_id FK
    VARCHAR title
    TEXT message
    BOOLEAN is_read
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  discussions {
    BIGINT id PK
    BIGINT classroom_id FK
    BIGINT user_id FK
    BIGINT parent_id FK
    TEXT content
    TIMESTAMP created_at
    TIMESTAMP updated_at
  }

  feedbacks {
    BIGINT id PK
    BIGINT from_user_id FK
    BIGINT to_user_id FK
    BIGINT classroom_id FK
    INT rating
    TEXT comment
    TIMESTAMP created_at
  }

  users ||--o{ classroom_students : is_student
  users ||--o{ classroom_mentors : is_mentor
  users ||--o{ materials : uploads
  users ||--o{ attendances : attends
  users ||--o{ assignments : creates
  users ||--o{ assignment_submissions : submits
  users ||--o{ grades : evaluates
  users ||--o{ notifications : receives
  users ||--o{ discussions : posts
  users ||--o{ feedbacks : gives
  users ||--o{ feedbacks : receives
  users ||--o{ announcements : announces

  classrooms ||--o{ classroom_students : has_students
  classrooms ||--o{ classroom_mentors : has_mentors
  classrooms ||--o{ schedules : has_schedules
  classrooms ||--o{ assignments : has_assignments
  classrooms ||--o{ material_classrooms : linked_materials
  classrooms ||--o{ discussions : discussion_board
  classrooms ||--o{ feedbacks : gets_feedback
  classrooms ||--o{ announcements : announces_in

  materials ||--o{ material_classrooms : mapped_to_class

  schedules ||--o{ attendances : logs

  assignments ||--o{ assignment_submissions : receives
  assignments ||--o{ grades : evaluated_by

  assignment_submissions ||--o{ grades : gets

  announcements ||--o{ notifications : triggers

  discussions ||--|{ discussions : replies_to

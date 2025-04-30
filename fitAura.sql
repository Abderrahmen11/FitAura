-- Database: fitaura
DROP DATABASE IF EXISTS fitaura;
CREATE DATABASE fitaura CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fitaura;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other') DEFAULT 'other',
    profile_image VARCHAR(255),
    membership_type ENUM('basic', 'standard', 'premium') DEFAULT 'basic',
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    reset_token VARCHAR(255),
    reset_token_expiry DATETIME,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB;

-- Membership Plans Table
CREATE TABLE membership_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration_days INT NOT NULL,
    features JSON,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- User Memberships Table
CREATE TABLE user_memberships (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    transaction_id VARCHAR(100),
    auto_renew BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES membership_plans(plan_id),
    CONSTRAINT chk_end_date CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- Muscle Groups Table
CREATE TABLE muscle_groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(255)
) ENGINE=InnoDB;

-- Exercises Table
CREATE TABLE exercises (
    exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    muscle_group_id INT,
    equipment VARCHAR(100),
    difficulty ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    video_url VARCHAR(255),
    image_url VARCHAR(255),
    instructions TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (muscle_group_id) REFERENCES muscle_groups(group_id)
) ENGINE=InnoDB;

-- Workout Plans Table
CREATE TABLE workout_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    level ENUM('beginner', 'intermediate', 'advanced') NOT NULL,
    duration_weeks INT DEFAULT 4,
    created_by INT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Workout Plan Exercises (Junction Table)
CREATE TABLE workout_plan_exercises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    workout_plan_id INT NOT NULL,
    exercise_id INT NOT NULL,
    day_number INT NOT NULL,
    sets INT DEFAULT 3,
    reps INT DEFAULT 10,
    rest_seconds INT DEFAULT 60,
    notes TEXT,
    FOREIGN KEY (workout_plan_id) REFERENCES workout_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(exercise_id),
    UNIQUE KEY (workout_plan_id, exercise_id, day_number)
) ENGINE=InnoDB;

-- User Workouts Table
CREATE TABLE user_workouts (
    workout_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    workout_plan_id INT,
    start_date DATETIME NOT NULL,
    end_date DATETIME,
    status ENUM('in_progress', 'completed', 'paused') DEFAULT 'in_progress',
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (workout_plan_id) REFERENCES workout_plans(plan_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Workout Sessions Table
CREATE TABLE workout_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    workout_id INT NOT NULL,
    session_date DATETIME NOT NULL,
    duration_minutes INT,
    notes TEXT,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (workout_id) REFERENCES user_workouts(workout_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Session Exercises Table
CREATE TABLE session_exercises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    exercise_id INT NOT NULL,
    sets_completed INT,
    reps_completed JSON, -- Stores array of reps for each set
    weights_used JSON, -- Stores array of weights for each set
    notes TEXT,
    FOREIGN KEY (session_id) REFERENCES workout_sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(exercise_id)
) ENGINE=InnoDB;

-- Progress Photos Table
CREATE TABLE progress_photos (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    photo_date DATE NOT NULL,
    notes TEXT,
    is_front_view BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Measurements Table
CREATE TABLE measurements (
    measurement_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    measurement_date DATE NOT NULL,
    weight_kg DECIMAL(5,2),
    height_cm DECIMAL(5,2),
    body_fat_percentage DECIMAL(5,2),
    chest_cm DECIMAL(5,2),
    waist_cm DECIMAL(5,2),
    hips_cm DECIMAL(5,2),
    arms_cm DECIMAL(5,2),
    thighs_cm DECIMAL(5,2),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Insert Initial Data
INSERT INTO membership_plans (plan_name, description, price, duration_days, features) VALUES
('Basic', 'Access to basic gym facilities', 70.00, 30, '["Access to all gym areas", "Flexible training times"]'),
('Standard', 'Standard membership with extra features', 350.00, 180, '["Free body composition test", "1 guest pass per month", "Access to group classes"]'),
('Premium', 'Premium membership with all features', 600.00, 365, '["Personalized workout plan", "Unlimited access to all classes", "Bring a friend 2x/month"]');

INSERT INTO muscle_groups (group_name, description) VALUES
('Arms', 'Biceps, Triceps and Forearms'),
('Shoulders', 'Deltoids and Rotator Cuff muscles'),
('Chest', 'Pectoral muscles'),
('Back', 'Latissimus dorsi, Trapezius and Rhomboids'),
('Legs', 'Quadriceps, Hamstrings, Glutes and Calves'),
('Abdomen', 'Abdominal and Core muscles');

-- Sample Exercises
INSERT INTO exercises (name, description, muscle_group_id, equipment, difficulty, instructions) VALUES
('Dumbbell Bicep Curl', 'Classic bicep exercise using dumbbells', 1, 'Dumbbells', 'beginner', 'Stand straight with dumbbells at sides...'),
('Tricep Pushdown', 'Targets triceps using cable machine', 1, 'Cable Machine', 'beginner', 'Attach straight bar to high pulley...'),
('Dumbbell Shoulder Press', 'Overhead press for shoulder development', 2, 'Dumbbells', 'intermediate', 'Sit on bench with back support...'),
('Barbell Bench Press', 'Classic chest exercise', 3, 'Barbell', 'intermediate', 'Lie on bench with barbell at chest level...'),
('Lat Pulldown', 'Works the latissimus dorsi', 4, 'Cable Machine', 'beginner', 'Sit at lat pulldown station...'),
('Bodyweight Squats', 'Fundamental leg exercise', 5, 'None', 'beginner', 'Stand with feet shoulder-width apart...'),
('Plank', 'Core strengthening exercise', 6, 'None', 'beginner', 'Hold position with forearms on ground...');

-- Create indexes for performance
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_exercise_muscle_group ON exercises(muscle_group_id);
CREATE INDEX idx_workout_plan_level ON workout_plans(level);
CREATE INDEX idx_user_membership_dates ON user_memberships(start_date, end_date);

-- Create database user with privileges
CREATE USER 'fitaura_admin'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT ALL PRIVILEGES ON fitaura.* TO 'fitaura_admin'@'localhost';
FLUSH PRIVILEGES;
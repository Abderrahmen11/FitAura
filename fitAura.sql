-- Database creation
CREATE DATABASE IF NOT EXISTS FitAura;
USE FitAura;

-- Users table (for registration and login)
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- User profiles (additional user information)
CREATE TABLE IF NOT EXISTS user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    birth_date DATE,
    gender ENUM('Male', 'Female', 'Other'),
    fitness_level ENUM('Beginner', 'Intermediate', 'Advanced'),
    height DECIMAL(5,2), -- in cm
    weight DECIMAL(5,2), -- in kg
    goals TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Membership plans (matches your pricing options)
CREATE TABLE IF NOT EXISTS membership_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    duration_days INT NOT NULL,
    description TEXT,
    features TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Insert membership plans (from your pricing section)
INSERT INTO membership_plans (plan_name, price, duration_days, description, features) VALUES
('Basic Plan', 70.00, 30, 'Standard gym access', 'Access to all gym areas, Valid for 30 days, Flexible training times'),
('Premium Plan', 350.00, 180, 'Enhanced features with guest pass', 'Free body composition test, 1 guest pass per month, Includes access to group classes'),
('VIP Plan', 600.00, 365, 'Full access with personalization', 'Personalized workout plan, Unlimited access to all classes, Bring a friend 2x/month');

-- User memberships
CREATE TABLE IF NOT EXISTS user_memberships (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    end_date DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (plan_id) REFERENCES membership_plans(plan_id)
);

-- Exercise categories
CREATE TABLE IF NOT EXISTS exercise_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)
);

-- Insert categories (from your muscle groups)
INSERT INTO exercise_categories (category_name, description) VALUES
('Arms', 'Exercises targeting biceps, triceps, and forearms'),
('Shoulders', 'Exercises for deltoids and rotator cuff muscles'),
('Chest', 'Exercises focusing on pectoral muscles'),
('Back', 'Exercises for latissimus dorsi, trapezius, and other back muscles'),
('Legs', 'Exercises for quadriceps, hamstrings, glutes, and calves'),
('Abdomen', 'Core exercises for abs and obliques');

-- Difficulty levels
CREATE TABLE IF NOT EXISTS difficulty_levels (
    level_id INT AUTO_INCREMENT PRIMARY KEY,
    level_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Insert difficulty levels (from your user levels)
INSERT INTO difficulty_levels (level_name, description) VALUES
('Beginner', 'Simple movements with easy instructions, Focus on form and control'),
('Intermediate', 'Compound movements & muscle isolation, Incorporates weights and machines'),
('Advanced', 'Heavy lifting, super sets, and advanced techniques');

-- Exercises
CREATE TABLE IF NOT EXISTS exercises (
    exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    exercise_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    level_id INT NOT NULL,
    description TEXT,
    video_url VARCHAR(255),
    instructions TEXT,
    FOREIGN KEY (category_id) REFERENCES exercise_categories(category_id),
    FOREIGN KEY (level_id) REFERENCES difficulty_levels(level_id)
);

-- Insert sample exercises (from your flip cards)
-- Arms - Beginner
INSERT INTO exercises (exercise_name, category_id, level_id, description, video_url) VALUES
('Dumbbell Bicep Curl', 1, 1, 'Basic bicep exercise with dumbbells', 'https://www.youtube.com/shorts/iui51E31sX8'),
('Tricep Pushdown', 1, 1, 'Cable machine exercise for triceps', NULL),
('Hammer Curl', 1, 1, 'Variation of bicep curl targeting brachialis', NULL);

-- Shoulders - Beginner
INSERT INTO exercises (exercise_name, category_id, level_id, description, video_url) VALUES
('Dumbbell Shoulder Press', 2, 1, 'Basic shoulder exercise with dumbbells', NULL),
('Lateral Raises', 2, 1, 'Isolates medial deltoids', NULL),
('Front Raises', 2, 1, 'Targets anterior deltoids', NULL);

-- Add more exercises following the same pattern for all categories and levels...

-- User workout plans
CREATE TABLE IF NOT EXISTS user_workouts (
    workout_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    workout_name VARCHAR(100) NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Workout exercises (junction table)
CREATE TABLE IF NOT EXISTS workout_exercises (
    workout_exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    workout_id INT NOT NULL,
    exercise_id INT NOT NULL,
    sets INT,
    reps INT,
    rest_seconds INT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    FOREIGN KEY (workout_id) REFERENCES user_workouts(workout_id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(exercise_id)
);

-- User progress tracking
CREATE TABLE IF NOT EXISTS user_progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    exercise_id INT NOT NULL,
    date_recorded DATE NOT NULL,
    weight_used DECIMAL(6,2),
    reps INT,
    sets INT,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (exercise_id) REFERENCES exercises(exercise_id)
);

-- Create indexes for performance
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_user_membership ON user_memberships(user_id, is_active);
CREATE INDEX idx_exercise_category ON exercises(category_id);
CREATE INDEX idx_exercise_level ON exercises(level_id);
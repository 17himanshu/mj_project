-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255),
    id_number VARCHAR(13),
    date_of_birth TIMESTAMP,
    image_name VARCHAR(255),
    profile_image_path TEXT,
    google_auth_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sitter_authen BOOLEAN DEFAULT FALSE
);

-- Create pet_type table
CREATE TABLE IF NOT EXISTS pet_type (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

-- Create pets table
CREATE TABLE IF NOT EXISTS pets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    pet_type_id INTEGER REFERENCES pet_type(id),
    breed VARCHAR(255),
    sex VARCHAR(10),
    age INTEGER,
    color VARCHAR(50),
    weight DECIMAL,
    description TEXT,
    image_name VARCHAR(255),
    image_path TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create pet_sitter table
CREATE TABLE IF NOT EXISTS pet_sitter (
    id SERIAL PRIMARY KEY,
    experience TEXT,
    introduction TEXT,
    trade_name VARCHAR(255),
    service_description TEXT,
    place_description TEXT,
    address_detail TEXT,
    district VARCHAR(100),
    province VARCHAR(100),
    sub_district VARCHAR(100),
    post_code VARCHAR(10),
    user_id INTEGER REFERENCES users(id),
    image_name VARCHAR(255),
    profile_image_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    pet_sitter_id INTEGER REFERENCES pet_sitter(id),
    start_date_time TIMESTAMP NOT NULL,
    end_date_time TIMESTAMP NOT NULL,
    amount DECIMAL NOT NULL,
    message TEXT,
    payment_method VARCHAR(50),
    statuses VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create booking_pets table
CREATE TABLE IF NOT EXISTS booking_pets (
    booking_id INTEGER REFERENCES bookings(id),
    pet_id INTEGER REFERENCES pets(id),
    PRIMARY KEY (booking_id, pet_id)
);

-- Create sitter_reviews table
CREATE TABLE IF NOT EXISTS sitter_reviews (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(id),
    rating INTEGER NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create views
CREATE OR REPLACE VIEW user_login AS
SELECT 
    u.id,
    u.full_name,
    u.email,
    u.id_number,
    u.phone,
    u.date_of_birth,
    u.image_name,
    u.profile_image_path,
    ps.id as pet_sitter_id,
    ps.image_name as pet_sitter_image_name,
    ps.profile_image_path as pet_sitter_profile_image_path,
    u.sitter_authen
FROM users u
LEFT JOIN pet_sitter ps ON u.id = ps.user_id;

CREATE OR REPLACE VIEW user_modal AS
SELECT 
    u.id as user_ids,
    u.full_name,
    u.email,
    u.id_number,
    u.phone,
    u.date_of_birth,
    u.image_name,
    u.profile_image_path,
    ps.id as pet_sitter_id,
    ps.image_name as pet_sitter_image_name,
    ps.profile_image_path as pet_sitter_profile_image_path,
    u.sitter_authen
FROM users u
LEFT JOIN pet_sitter ps ON u.id = ps.user_id;

CREATE OR REPLACE VIEW bookings_history_detail AS
SELECT 
    b.id as booking_no,
    b.user_id,
    b.pet_sitter_id,
    b.start_date_time,
    b.end_date_time,
    b.amount,
    b.message,
    b.payment_method,
    b.statuses,
    b.created_at,
    u.full_name as user_name,
    ps.trade_name as sitter_name,
    sr.rating,
    sr.comment as review_comment
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN pet_sitter ps ON b.pet_sitter_id = ps.id
LEFT JOIN sitter_reviews sr ON b.id = sr.booking_id;

CREATE OR REPLACE VIEW booking_reviews_by_user AS
SELECT 
    b.id as booking_id,
    sr.rating,
    sr.comment,
    sr.created_at
FROM bookings b
LEFT JOIN sitter_reviews sr ON b.id = sr.booking_id; 
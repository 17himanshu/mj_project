-- Insert some basic pet types
INSERT INTO pet_type (type) VALUES
    ('Dog'),
    ('Cat'),
    ('Bird'),
    ('Fish'),
    ('Rabbit'),
    ('Hamster'),
    ('Guinea Pig'),
    ('Turtle'),
    ('Other')
ON CONFLICT DO NOTHING; 
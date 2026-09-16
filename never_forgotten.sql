CREATE DATABASE never_forgotten;
USE never_forgotten;

CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE people (
    person_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    location_id INT,
    occupation VARCHAR(100),
    category VARCHAR(50),

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);

CREATE TABLE organizations (
    organization_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL UNIQUE,
    type VARCHAR(100)
);

CREATE TABLE service_records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    organization_id INT NOT NULL,
    role VARCHAR(100),

    FOREIGN KEY (person_id)
        REFERENCES people(person_id),

    FOREIGN KEY (organization_id)
        REFERENCES organizations(organization_id)
);

CREATE TABLE memorial_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    message TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (person_id)
        REFERENCES people(person_id)
);

CREATE TABLE historical_events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_date DATE NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT
);

INSERT INTO locations (name, description)
VALUES
    ('World Trade Center',
     'New York City'),
    ('Pentagon',
     'Arlington, Virginia'),
    ('Shanksville',
     'Pennsylvania');

INSERT INTO organizations (name, type)
VALUES
    ('Fire Department of New York', 'Fire Service'),
    ('New York City Police Department', 'Police'),
    ('Port Authority Police Department', 'Police');

INSERT INTO historical_events
    (event_date, title, description)
VALUES
    (
        '2001-09-11',
        'September 11, 2001',
        'A day remembered for the lives lost and the courage shown by survivors, responders, and ordinary people.'
    );

SELECT
    l.name AS location,
    COUNT(p.person_id) AS people_remembered
FROM locations l
LEFT JOIN people p
    ON l.location_id = p.location_id
GROUP BY l.location_id, l.name;

SELECT
    category,
    COUNT(*) AS number_of_people
FROM people
GROUP BY category
ORDER BY number_of_people DESC;

SELECT
    o.name AS organization,
    COUNT(sr.person_id) AS people_recorded
FROM organizations o
LEFT JOIN service_records sr
    ON o.organization_id = sr.organization_id
GROUP BY o.organization_id, o.name;

CREATE VIEW memorial_archive AS
SELECT
    p.person_id,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    p.occupation,
    p.category,
    l.name AS location
FROM people p
LEFT JOIN locations l
    ON p.location_id = l.location_id;

SELECT *
FROM memorial_archive
ORDER BY last_name;

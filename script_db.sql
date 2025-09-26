-- Adresse
CREATE TABLE `address` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   country VARCHAR(255) NOT NULL,
   city VARCHAR(255) NOT NULL,
   street_name VARCHAR(255) NOT NULL,
   street_number VARCHAR(50) NOT NULL,
   additionnal_informations VARCHAR(255)
);

-- Agences
CREATE TABLE `offices` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(250) ,
   phone_number VARCHAR(50) ,
   id_address INT NOT NULL,
   FOREIGN KEY(id_address) REFERENCES address(id)
);

-- Utilisateurs
CREATE TABLE `users` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   last_name VARCHAR(250) ,
   first_name VARCHAR(250) ,
   birth_date DATE,
   email VARCHAR(250) NOT NULL,
   password VARCHAR(250)  NOT NULL,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   id_address INT NOT NULL,
   UNIQUE(email),
   FOREIGN KEY(id_address) REFERENCES address(id)
);

-- Voitures
CREATE TABLE `cars` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   brand VARCHAR(255) ,
   category VARCHAR(255) ,
   model VARCHAR(255) ,
   year_construction INT,
   daily_rate DECIMAL(15,2)  ,
   registration VARCHAR(50) ,
   status ENUM('disponible','maintenance','indisponible') DEFAULT 'disponible',
   id_office INT NOT NULL,
   FOREIGN KEY(id_office) REFERENCES offices(id)
);

-- Location
CREATE TABLE `rentals` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   price DECIMAL(15,2)  ,
   status ENUM('en_attente','confirmee','annulee') DEFAULT 'en_attente',
   date_start DATETIME,
   date_end DATETIME,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   id_arrival INT NOT NULL,
   id_departure INT NOT NULL,
   id_car INT NOT NULL,
   id_user INT,
   FOREIGN KEY(id_arrival) REFERENCES offices(id),
   FOREIGN KEY(id_departure) REFERENCES offices(id),
   FOREIGN KEY(id_car) REFERENCES cars(id),
   FOREIGN KEY(id_user) REFERENCES users(id)
);

-- Documents
CREATE TABLE `documents` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(255) ,
   type VARCHAR(50) ,
   url VARCHAR(255) ,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   id_user INT,
   FOREIGN KEY(id_user) REFERENCES users(id)
);

-- Paiement
CREATE TABLE `payment` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   price DECIMAL(15,2)  ,
   status ENUM('accepte','refuse','en_attente') DEFAULT 'en_attente',
   date_payment DATETIME,
   transaction_ref VARCHAR(255) ,
   provider VARCHAR(50) ,
   id_rental INT NOT NULL,
   FOREIGN KEY(id_rental) REFERENCES rentals(id)
);

-- Conversations
CREATE TABLE `conversations` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   closed_at DATETIME,
   status ENUM('open','closed') DEFAULT 'open',
   id_agent INT NOT NULL,
   id_user INT NOT NULL,
   FOREIGN KEY(id_agent) REFERENCES users(id),
   FOREIGN KEY(id_user) REFERENCES users(id)
);

-- Requête pour une vidéo-conférence
CREATE TABLE `video_requests` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   status ENUM('pending','accepted','declined') DEFAULT 'pending',
   scheduled_for DATETIME,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   id_user INT NOT NULL,
   FOREIGN KEY(id_user) REFERENCES users(id)
);

-- Messages
CREATE TABLE `messages` (
   id INT PRIMARY KEY AUTO_INCREMENT,
   sender ENUM('client','support') NOT NULL,
   type ENUM('chat','contact_form') NOT NULL,
   content TEXT,
   status ENUM('sent','delivered','read') DEFAULT 'sent',
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   id_user INT NOT NULL,
   id_conversation INT NOT NULL,
   FOREIGN KEY(id_user) REFERENCES users(id),
   FOREIGN KEY(id_conversation) REFERENCES conversations(id)
);

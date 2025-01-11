-- init.sql
CREATE TABLE IF NOT EXISTS `login_details` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(255) NULL,
    `password` VARCHAR(255) NULL,
    `role` VARCHAR(255) NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `email` (`email`)
);

INSERT INTO login_details (id, email, password, role)
VALUES (1, 'vlad', '$2a$10$zUNaTJZOSZ.mK3k4YLsYQubOgRnL.M0S/ie9rqgoiwVODkHVimL/6', 'admin');

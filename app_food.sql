CREATE TABLE IF NOT EXISTS `user` (
	`user_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- --------------------
	`fullname` VARCHAR(255),
	`email` VARCHAR(25),
	`password` VARCHAR(25),
	-- --------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -----------------

CREATE TABLE IF NOT EXISTS `restaurant` (
	`res_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- --------------------
	`res_name` VARCHAR(255),
	`Image` VARCHAR(255),
	`desc` VARCHAR(255),
	-- --------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- --------------

CREATE TABLE IF NOT EXISTS `rate_res` (
	`userId` INT,
	`resId` INT,
	FOREIGN KEY (`userId`) REFERENCES `user`(`user_id`),
	FOREIGN KEY (`resId`) REFERENCES `restaurant`(`res_id`),
	`amount` INT,
	`date_rate` DATETIME,
	-- ------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ----------------------------

CREATE TABLE IF NOT EXISTS `like_res` (
	`user_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- --------------------	
	`userId` INT,
	`resId` INT,
	FOREIGN KEY (`userId`) REFERENCES `user`(`user_id`),
	FOREIGN KEY (`resId`) REFERENCES `restaurant`(`res_id`),
	`date_like` DATETIME,
	-- ---------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -----------------------

CREATE TABLE IF NOT EXISTS `food_type` (
	`type_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- ----------------------------
	`type_name` VARCHAR(255),
	-- ----------------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- --------------------------

CREATE TABLE IF NOT EXISTS `food` (
	`food_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- --------------------------
	`food_name` VARCHAR(255),
	`image` VARCHAR(25),
	`price` FLOAT,
	`desc` VARCHAR(255),
	`type_id` INT,
	FOREIGN KEY (`type_id`) REFERENCES `food_type`(`type_id`),
	-- --------------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -------------------------

CREATE TABLE IF NOT EXISTS `sub_food` (
	`sub_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- ----------------------------
	`sub_name` VARCHAR(255),
	`sub_price` FLOAT,
	`food_id` INT,
	FOREIGN KEY (`food_id`) REFERENCES `food`(`food_id`),
	-- ----------------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ------------------

CREATE TABLE IF NOT EXISTS `order` (
	`user_id` INT,
	`food_id` INT,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`),
	FOREIGN KEY (`food_id`) REFERENCES `food`(`food_id`),
	`amount` INT,
	`code` VARCHAR(25),
	`arr_sub_id` VARCHAR(255),
	-- ----------------------------
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


SELECT 
    u.user_id,
    u.fullname,
    u.email,
    COUNT(lr.resId) AS total_likes
FROM `like_res` AS lr
JOIN `user` AS u 
    ON lr.userId = u.user_id
WHERE lr.isDeleted = 0
GROUP BY 
    u.user_id,
    u.fullname,
    u.email
ORDER BY total_likes DESC
LIMIT 5;


SELECT 
    r.res_id,
    r.res_name,
    COUNT(lr.userId) AS total_likes
FROM `like_res` AS lr
JOIN `restaurant` AS r
    ON lr.resId = r.res_id
WHERE lr.isDeleted = 0
GROUP BY 
    r.res_id,
    r.res_name
ORDER BY total_likes DESC
LIMIT 2;


SELECT 
    u.user_id,
    u.fullname,
    u.email,
    COUNT(*) AS total_orders
FROM `order` AS o
JOIN `user` AS u
    ON o.user_id = u.user_id
WHERE o.isDeleted = 0
GROUP BY 
    u.user_id,
    u.fullname,
    u.email
ORDER BY total_orders DESC
LIMIT 1;


SELECT 
    u.user_id,
    u.fullname,
    u.email
FROM `user` AS u
LEFT JOIN `order` AS o
    ON u.user_id = o.user_id AND o.isDeleted = 0
LEFT JOIN `like_res` AS lr
    ON u.user_id = lr.userId AND lr.isDeleted = 0
LEFT JOIN `rate_res` AS rr
    ON u.user_id = rr.userId AND rr.isDeleted = 0
WHERE 
    u.isDeleted = 0
    AND o.user_id IS NULL
    AND lr.userId IS NULL
    AND rr.userId IS NULL;
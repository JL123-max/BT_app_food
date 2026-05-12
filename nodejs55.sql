# tat ca cac lenh sql deu phai luon viet hoa tat ca cac chu
# ten cua database, table, column: viet thuong va co _ de tao khoang cach (snake case) vd: nguoi_dung
# dat ten khong khoang trang, khong co ky tu dac biet, khong co so o dau cau

# tao database
CREATE DATABASE demo_nodejs55

# xoa database (hoc de biet - khong su dung)
DROP DATABASE demo_nodejs55

# tao TABLE
# B1: to den
# B2: run current
# B3: refresh workspace
CREATE TABLE nguoi_dung (
	id INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	phone INT(10),
	gender VARCHAR(10),
	address VARCHAR(255)
)

# xoa table
DROP TABLE nguoi_dung

# rename table
RENAME TABLE `User` TO `Users`

# add/delete column
# BEST PRACTICE - TAO MOI THAY VI XOA COT
ALTER TABLE nguoi_dung
ADD birthday DATE

ALTER TABLE nguoi_dung
DROP COLUMN birthday

# update datatype
ALTER TABLE nguoi_dung
MODIFY gender VARCHAR(20)

# soft deleted

# bai tap 1: tao 1 table food: co id (int), name (string -30), description (string 255), image (string 255), price (int), tag (string 255)

# rang buoc du lieu
# default: dat cac gia tri mac dinh cho cot neu khong co gia tri
# not null unique: khong duoc null, phai duy nhat
CREATE TABLE `food` (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(30),
	description VARCHAR(255) DEFAULT "chua co thong tin",
	image VARCHAR(255),
	price INT,
	tag VARCHAR(255)
)

DROP TABLE food

CREATE TABLE `User` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`full_name` VARCHAR(255),
	`email` VARCHAR(255) NOT NULL UNIQUE,
	`phone` INT(10),
	`gender` VARCHAR(10),
	`address` VARCHAR(255)
)

DROP TABLE `User`

# them du lieu
INSERT INTO nguoi_dung(full_name, email, phone, gender) VALUES
	('Nguyen Minh Anh', 'nguyenminhanh@gmail.com', '0901234567', 'Nu'),
('Le Hoang Nam', 'lehoangnam@gmail.com', '0912345678', 'Nam'),
('Pham Thu Ha', 'phamthuha@gmail.com', '0923456789', 'Nu'),
('Tran Quoc Bao', 'tranquocbao@gmail.com', '0934567890', 'Nam'),
('Vo Ngoc Linh', 'vongoclinh@gmail.com', '0945678901', 'Nu'),
('Dang Gia Huy', 'danggiahuy@gmail.com', '0956789012', 'Nam'),
('Bui Khanh Vy', 'buikhanhvy@gmail.com', '0967890123', 'Nu'),
('Hoang Minh Khang', 'hoangminhkhang@gmail.com', '0978901234', 'Nam'),
('Do Mai Chi', 'domaichi@gmail.com', '0989012345', 'Nu'),
('Phan Duc Anh', 'phanducanh@gmail.com', '0990123456', 'Nam');


#create, insert table có chưa khóa chính phải tạo trước
#delete, table có khóa ngoại phải xóa trước 
 CREATE TABLE user_type(
 	type_id INT PRIMARY KEY AUTO_INCREMENT,
 	type_name VARCHAR(100)
 )
 
 CREATE TABLE users (
 	user_id INT PRIMARY KEY AUTO_INCREMENT,
 	user_name VARCHAR(30),
 	email VARCHAR(30),
 	type_id INT,
 	
 	FOREIGN KEY (type_id) REFERENCES user_type(type_id)
 )
 
INSERT INTO users values (0, "Nguyen Văn A", "b@gmail.com", 1),
(0, "Nguyễn Văn B", "b@gmail.com", 2),
(0, "Nguyễn Văn C", "c@gmail.com", 6),
(0, "Nguyễn Văn D", "d@gmail.com", 3)
 
 
 # basic query
 # *: biểu tất cả các cột dữ liệu có trong bảng
 SELECT *
 FROM `users`
 
 SELECT user_name, email 
 FROM users
 
 SELECT *
 FROM users
 WHERE user_id = 3
 
 # as - alias: tên thay thế tên table
 # and hoặc or giống js về && hoặc ||
 SELECT user_name AS fullname, email
 FROM users u, user_type utype
 WHERE user_id = 3 
 
 #limit: lấy ra 5 dòng đầu tiên
 SELECT * 
 FROM nguoi_dung
 LIMIT 5
 
 # order by: sắp xếp
 # giả sử người dùng có cột age
 # desc, asc
 SELECT * 
 FROM nguoi_dung
 ORDER BY age DESC 
 
 SELECT * 
 FROM nguoi_dung
 ORDER BY age DESC
 LIMIT 5
 
 
 CREATE TABLE `Foods` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(255),
	`description` VARCHAR(255) DEFAULT "Chưa có thông tin"
)

INSERT INTO `Foods` (`name`, `description`) VALUES
					("gỏi gà", "được làm từ ga"),
					("gỏi vit", "được làm từ vịt"),
					("gỏi cá", "được làm từ cá"),
					("gỏi heo", "được làm từ heo")
 
 
 CREATE TABLE `Orders` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	
	`userId` INT,
	`foodId` INT,
	
	FOREIGN KEY (`userId`) REFERENCES `users`(`user_id`),
	FOREIGN KEY (`foodId`) REFERENCES `Foods`(`id`)
)

INSERT INTO `Orders` (`userId`, `foodId`) VALUES 
					(1, 2),
					(3, 1),
					(2, 4),
					(1, 3),
					(3, 2)
					
					
# inner join: sử dụng để kết hợp các dữ liệu trùng khớp và có tồn tại với các bảng tương ứng
SELECT *
FROM Orders
INNER JOIN users ON Orders.userId = users.user_id
INNER JOIN Foods ON Orders.foodId = Foods.id

# right join / left join: sẽ thể toàn bộ dữ liệu bảng gốc, thể ra các dữ liệu chưa có hành động (null)
# ví dụ 1: tìm kiếm ngừi dùng chưa có hành động
SELECT *
FROM Orders
RIGHT JOIN users ON Orders.userId = users.user_id
WHERE Orders.userId IS NULL

SELECT *
FROM users
LEFT JOIN Orders ON users.user_id = Orders.userId 
WHERE Orders.userId IS NULL
					
					
					-- GIẢI BÀI TẬP
-- Tìm người đã đặt hàng nhiều nhất.
-- Phân tích: 
	-- Có phát sinh mua hàng thì mới xuất hiện trong bảng orders
	-- GROUP BY: Nhóm những user giống nhau lại rồi đếm hộ xuất hiện bao nhiêu lần
		-- COUNT(), MAX(), MIN(), AVERAGE()
	-- ORDER BY: Sắp xếp giảm dần, người xuất hiện nhiều nhất ở trên cùng
	-- LIMIT 1, lấy người đầu tiên => done
	
	
# bước 1: lấy và map dữ liệu ở bảng Orders
SELECT * 
FROM Orders
INNER JOIN users ON Orders.userId = users.user_id
# bước 2: thống kê - group by
SELECT COUNT(userId) AS `số lần mua hàng`, users.user_id, users.email
FROM Orders
INNER JOIN users ON Orders.userId = users.user_id 
GROUP BY userId
#bước 3: sắp xếp
SELECT COUNT(userId) AS `số lần mua hàng`, users.user_id, users.email
FROM Orders
INNER JOIN users ON Orders.userId = users.user_id 
GROUP BY userId
ORDER BY `số lần mua hàng` DESC
#bước 4: limit
SELECT COUNT(userId) AS `số lần mua hàng`, users.user_id, users.email
FROM Orders
INNER JOIN users ON Orders.userId = users.user_id 
GROUP BY userId
ORDER BY `số lần mua hàng` DESC
LIMIT 1

#mẫu để ranking
SELECT user_id, total_orders
FROM (
    SELECT 
        user_id,
        COUNT(*) AS total_orders,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
    FROM Orders
    GROUP BY user_id
) AS ranked_orders
WHERE ranking = 1;
# cú pháp: RANK() OVER (ĐIỀU KIỆN ĐÁNH GIÁ RANK)

DROP TABLE nguoi_dung, Orders
DROP TABLE Foods, users
DROP TABLE user_type
#TEMPLATE TABLE
#LƯU Ý: ĐÂY LÀ TEMPLATE MẪU - K TẠO
CREATE TABLE IF NOT EXISTS `TABLE_TEMPLATE` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	
	-- ĐẶT CÁC THUỘC TÍNH CỦA TABLE Ở ĐÂY
	
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `Users` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	
	`email` VARCHAR(255) NOT NULL UNIQUE,
	`fullName` VARCHAR(255),
	`avatar` TEXT,
	`age` INT,
	`totpSecret` VARCHAR(255),
	`googleId` VARCHAR(255),
	
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS `Articles` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	
	`title` VARCHAR(255),
	`content` TEXT,
	`imageUrl` VARCHAR(255),
	`views` INT NOT NULL DEFAULT 0,
	`userId` INT,
	
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`),
	
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS `Orders` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	
	`userId` INT,
	`foodId` INT,
	
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`),
	FOREIGN KEY (`foodId`) REFERENCES `Foods`(`id`),	
	
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `Foods` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	`name` VARCHAR(255),
	`description` VARCHAR(255) DEFAULT "Chưa có thông tin",
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `Users` (`email`, `fullName`) VALUES ("example@gmail.com", "example")


INSERT INTO
	`Articles` (
		`content`,
		`imageUrl`,
		`views`,
		`userId`,
		`createdAt`,
		`updatedAt`
	)
VALUES
	(
		'Content about learning NextJS...',
		'https://picsum.photos/seed/1/600/400',
		15,
		1,
		'2024-01-01 08:00:00',
		'2024-01-01 08:00:00'
	),
	(
		'Content about mastering React Query...',
		'https://picsum.photos/seed/2/600/400',
		32,
		1,
		'2024-01-02 09:00:00',
		'2024-01-02 09:00:00'
	),
	(
		'Content about JavaScript tips...',
		'https://picsum.photos/seed/3/600/400',
		45,
		1,
		'2024-01-03 10:00:00',
		'2024-01-03 10:00:00'
	),
	(
		'Comparison content...',
		'https://picsum.photos/seed/4/600/400',
		27,
		1,
		'2024-01-04 11:00:00',
		'2024-01-04 11:00:00'
	),
	(
		'Content about TypeScript...',
		'https://picsum.photos/seed/5/600/400',
		12,
		1,
		'2024-01-05 12:00:00',
		'2024-01-05 12:00:00'
	),
	(
		'Content about SQL joins...',
		'https://picsum.photos/seed/6/600/400',
		8,
		1,
		'2024-01-06 13:00:00',
		'2024-01-06 13:00:00'
	),
	(
		'Extensions content...',
		'https://picsum.photos/seed/7/600/400',
		60,
		1,
		'2024-01-07 14:00:00',
		'2024-01-07 14:00:00'
	),
	(
		'Content about React optimization...',
		'https://picsum.photos/seed/8/600/400',
		33,
		1,
		'2024-01-08 15:00:00',
		'2024-01-08 15:00:00'
	),
	(
		'Content about API design...',
		'https://picsum.photos/seed/9/600/400',
		18,
		1,
		'2024-01-09 16:00:00',
		'2024-01-09 16:00:00'
	),
	(
		'Predictions about web development...',
		'https://picsum.photos/seed/10/600/400',
		21,
		1,
		'2024-01-10 17:00:00',
		'2024-01-10 17:00:00'
	);


CREATE TABLE IF NOT EXISTS `ChatGroups` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	`name` VARCHAR(255),
	`ownerId` INT,
	FOREIGN KEY (`ownerId`) REFERENCES `Users`(`id`),
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `ChatGroupMembers` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	`userId` INT,
	`chatGroupId` INT,
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`),
	FOREIGN KEY (`chatGroupId`) REFERENCES `ChatGroups`(`id`),
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `ChatMessages` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	-- mặc định luôn luôn có
	`chatGroupId` INT,
	`userIdSender` INT,
	`messageText` TEXT,
	FOREIGN KEY (`chatGroupId`) REFERENCES `ChatGroups`(`id`),
	FOREIGN KEY (`userIdSender`) REFERENCES `Users`(`id`),
	-- mặc định luôn luôn có
	`deletedBy` INT NOT NULL DEFAULT 0,
	`isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
	`deletedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
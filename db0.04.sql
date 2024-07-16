CREATE TABLE `book` (
	`id`	Bigint	NOT NULL,
	`title`	varchar(50)	NOT NULL,
	`description`	TEXT	NULL,
	`published_date`	datetime	NULL,
	`price`	int unsigned	NOT NULL,
	`quantity`	int unsigned	NOT NULL,
	`selling_price`	int unsigned	NOT NULL,
	`view_count`	bigint unsigned	NOT NULL,
	`packing`	boolean	NOT NULL,
	`author`	varchar(50)	NOT NULL,
	`isbn`	varchar(13)	NOT NULL	COMMENT 'UNIQUE',
	`publisher`	varchar(50)	NOT NULL,
	`created_at`	datetime	NOT NULL
);

CREATE TABLE `category` (
	`id`	bigint	NOT NULL,
	`name`	varchar(30)	NOT NULL,
	`parent_id`	bigint	NULL
);

CREATE TABLE `member` (
	`id`	bigint	NOT NULL,
	`password`	varchar(255)	NOT NULL,
	`point`	bigint	NOT NULL,
	`name`	varchar(255)	NOT NULL,
	`age`	tinyint unsigned	NULL,
	`phone`	varchar(11)	NOT NULL,
	`email`	varchar(320)	NOT NULL	COMMENT 'UNIQUE',
	`birthday`	datetime	NULL,
	`grade`	tinyint(3)	NOT NULL	COMMENT '1. General 2. Royal 3. Gold 4. Platinum',
	`status`	tinyint(3)	NOT NULL	COMMENT '1. Inactive 2. Active 3. Withdrawn',
	`last_login_date`	DATETIME	NULL,
	`created_at`	datetime	NOT NULL,
	`modified_at`	datetime	NULL,
	`deleted_at`	datetime	NULL,
	`auth_provider`	tintint(2)	NOT NULL	COMMENT '1. General 2,Payco'
);

CREATE TABLE `book_like` (
	`id`	bigint	NOT NULL,
	`created_at`	datetime	NOT NULL,
	`book_id`	Bigint	NOT NULL,
	`member_id`	bigint	NOT NULL
);

CREATE TABLE `book-cart` (
	`id`	bigint	NOT NULL,
	`book_id`	Bigint	NOT NULL,
	`cart_id`	VARCHAR(255)	NOT NULL,
	`quantity`	int	NOT NULL,
	`created_at`	datetime	NOT NULL
);

CREATE TABLE `review` (
	`id`	bigint	NOT NULL,
	`title`	varchar(50)	NOT NULL,
	`content`	TEXT	NOT NULL,
	`rating`	double	NOT NULL,
	`created_at`	datetime	NOT NULL,
	`modified_at`	datetime	NULL,
	`deleted_at`	datetime	NULL,
	`review_status`	tinyint(3)	NOT NULL,
	`deleted_reason`	varchar(100)	NULL,
	`purchase_book_id`	Bigint	NOT NULL,
	`updated`	Boolean	NOT NULL	DEFAULT false
);

CREATE TABLE `payment` (
	`id`	bigint	NOT NULL,
	`toss_order_id`	String	NOT NULL,
	`toss_amont`	int	NOT NULL,
	`toss_amount_tax_free`	int	NOT NULL,
	`toss_product_desc`	String	NOT NULL,
	`payment_status`	tinyint(3)	NOT NULL,
	`paid_at`	datetime	NOT NULL,
	`payment_type_id`	int	NOT NULL,
	`id2`	Bigint	NOT NULL
);

CREATE TABLE `review_image` (
	`id`	bigint	NOT NULL,
	`review_id`	VARCHAR(255)	NOT NULL,
	`total_iamge_id`	bigint	NOT NULL
);

CREATE TABLE `purchase` (
	`id`	Bigint	NOT NULL,
	`order_number`	binary(16)	NOT NULL	DEFAULT UUID,
	`stauts`	tinyint(5)	NOT NULL,
	`delivery_price`	int	NOT NULL,
	`total_price`	int	NOT NULL,
	`created_at`	DATETIME	NOT NULL,
	`road`	text	NOT NULL,
	`password`	varchar(100)	NULL,
	`member_type`	tinyiint(2)	NOT NULL,
	`point`	int	NOT NULL,
	`shipping_date`	DATETIME	NOT NULL,
	`is_packing`	boolean	NOT NULL,
	`user_id`	varchar(50)	NULL
);

CREATE TABLE `user_point_record` (
	`id`	bigint	NOT NULL,
	`use_point`	bigint	NOT NULL,
	`create_at`	datetime	NOT NULL,
	`content`	varchar(100)	NOT NULL,
	`member_id`	bigint	NOT NULL,
	`purchase_id`	Bigint	NOT NULL
);

CREATE TABLE `coupon_ form` (
	`id`	bigInt	NOT NULL,
	`start_date`	datetime	NULL,
	`end_date`	datetime	NULL,
	`name`	varchar(100)	NOT NULL,
	`code`	binary(16)	NOT NULL	COMMENT 'UUID',
	`created_at`	datetime	NOT NULL,
	`max_price`	VARCHAR(255)	NOT NULL,
	`min_price`	VARCHAR(255)	NOT NULL,
	`coupon_type_id`	bigint	NOT NULL,
	`coupon_usage_id`	bigint	NOT NULL
);

CREATE TABLE `payment_type` (
	`id`	int	NOT NULL,
	`name`	varchar(50)	NOT NULL
);

CREATE TABLE `purchase_book` (
	`id`	Bigint	NOT NULL,
	`quantity`	int	NULL,
	`price`	int	NULL,
	`book_id`	Bigint	NOT NULL,
	`order_id`	Bigint	NOT NULL
);

CREATE TABLE `simple_review` (
	`id`	bigint	NOT NULL,
	`content`	varchar(100)	NOT NULL,
	`created_at`	datetime	NOT NULL,
	`modified_at`	datetime	NULL,
	`perchase_book_id`	Bigint	NOT NULL
);

CREATE TABLE `comment` (
	`id`	bigint	NOT NULL,
	`content`	varchar(200)	NOT NULL,
	`created_at`	datetime	NULL,
	`deleted_at`	datetime	NULL,
	`modified_at`	datetime	NULL,
	`comment_status`	tinyint(2)	NOT NULL,
	`user_id`	bigint	NOT NULL,
	`review_id`	VARCHAR(255)	NOT NULL
);

CREATE TABLE `address` (
	`id`	Bigint	NOT NULL,
	`member_id`	bigint	NOT NULL,
	`name`	varchar(20)	NOT NULL,
	`country`	varchar(100)	NOT NULL,
	`city`	varchar(100)	NOT NULL,
	`state`	varchar(100)	NOT NULL,
	`road`	varchar(100)	NOT NULL,
	`postal_code`	varchar(20)	NOT NULL
);

CREATE TABLE `member_auth` (
	`id`	bigint	NOT NULL,
	`member_id`	bigint	NOT NULL,
	`auth_id`	bigint	NOT NULL
);

CREATE TABLE `coupon` (
	`id`	bigint	NOT NULL,
	`coupon_status`	tinyInt(2)	NOT NULL,
	`issued_at`	datetime	NOT NULL,
	`member_id`	bigint	NOT NULL,
	`coupon_form_id`	VARCHAR(255)	NULL
);

CREATE TABLE `book_category` (
	`id`	bigint	NOT NULL,
	`category_id`	bigint	NOT NULL,
	`book_id`	Bigint	NOT NULL
);

CREATE TABLE `auth` (
	`id`	bigint	NOT NULL,
	`name`	varchar(50)	NULL	COMMENT '1. USER 2. ADMIN 3. PUBLISHER'
);

CREATE TABLE `purchase_coupon` (
	`id`	bigint	NOT NULL,
	`discount_price`	int	NOT NULL,
	`status`	tinyInt	NOT NULL,
	`purchase_id`	Bigint	NOT NULL,
	`coupon_id`	bigint	NOT NULL
);

CREATE TABLE `book_image` (
	`id`	Bigint	NOT NULL,
	`book_id`	Bigint	NULL,
	`type`	tinyint(2)	NOT NULL,
	`total_image_id`	bigint	NOT NULL
);

CREATE TABLE `tag` (
	`id`	bigint	NOT NULL,
	`name`	varhar(100)	NOT NULL
);

CREATE TABLE `book_tag` (
	`id`	bigint	NOT NULL,
	`tag_id`	bigint	NOT NULL,
	`book_id`	Bigint	NOT NULL
);

CREATE TABLE `cart` (
	`id`	VARCHAR(255)	NOT NULL,
	`member_id`	bigint	NULL
);

CREATE TABLE `review-like` (
	`id`	bigint	NOT NULL,
	`created_at`	datetime	NOT NULL,
	`review_id`	bigint	NOT NULL,
	`member_id`	bigint	NOT NULL
);

CREATE TABLE `Refund` (
	`id`	BigInt	NOT NULL,
	`price`	BigInt	NOT NULL,
	`content`	text	NOT NULL,
	`refund_status`	tinyInt(3)	NOT NULL,
	`createAt`	DATETIME	NOT NULL
);

CREATE TABLE `refund_record` (
	`Key`	VARCHAR(255)	NOT NULL,
	`refundId`	BigInt	NOT NULL,
	`id`	Bigint	NOT NULL,
	`quantity`	int	NULL,
	`price`	int	NULL
);

CREATE TABLE `total_image` (
	`id`	bigint	NOT NULL,
	`url`	varchar(40)	NOT NULL	COMMENT 'UNIQUE'
);

CREATE TABLE `member_grade_record` (
	`id`	bigint	NOT NULL,
	`member_id`	bigint	NOT NULL,
	`grade`	tinyint(3)	NOT NULL
);

CREATE TABLE `member_message` (
	`id`	bigint	NOT NULL,
	`message`	varchar(255)	NOT NULL,
	`send_at`	datetiem	NOT NULL,
	`view_at`	datetime	NULL,
	`member_id`	bigint	NOT NULL
);

CREATE TABLE `coupon_type` (
	`id`	bigint	NOT NULL,
	`type`	varchar(50)	NOT NULL
);

CREATE TABLE `fixed_coupon` (
	`id`	bigint	NOT NULL,
	` coupon_type_id`	bigint	NOT NULL,
	`discount_price`	int	NULL
);

CREATE TABLE `ratio_coupon` (
	`id`	bigint	NOT NULL,
	` coupon_type_id`	bigint	NOT NULL,
	`discount_rate`	double	NOT NULL,
	`discount_max_price`	int	NOT NULL
);

CREATE TABLE `coupon_usage` (
	`id`	bigint	NOT NULL,
	`usage`	varchar(50)	NOT NULL
);

CREATE TABLE `category_coupon` (
	`id`	bigint	NOT NULL,
	`category_id`	bigint	NOT NULL
);

CREATE TABLE `book_coupon` (
	`id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `category_coupon_usage` (
	`ID`	bigint	NOT NULL,
	`coupon_usage_id`	bigint	NOT NULL,
	`category_coupon_id`	bigint	NOT NULL
);

CREATE TABLE `book_coupon_usage` (
	`id`	bigint	NOT NULL,
	`coupon_usage_id`	bigint	NOT NULL,
	`book_coupon_id`	bigint	NOT NULL
);

CREATE TABLE `point_policy` (
	`id`	bigint	NOT NULL,
	`key`	String	NOT NULL,
	`value`	tinyint	NOT NULL
);

ALTER TABLE `book` ADD CONSTRAINT `PK_BOOK` PRIMARY KEY (
	`id`
);

ALTER TABLE `category` ADD CONSTRAINT `PK_CATEGORY` PRIMARY KEY (
	`id`
);

ALTER TABLE `member` ADD CONSTRAINT `PK_MEMBER` PRIMARY KEY (
	`id`
);

ALTER TABLE `book_like` ADD CONSTRAINT `PK_BOOK_LIKE` PRIMARY KEY (
	`id`
);

ALTER TABLE `book-cart` ADD CONSTRAINT `PK_BOOK-CART` PRIMARY KEY (
	`id`
);

ALTER TABLE `review` ADD CONSTRAINT `PK_REVIEW` PRIMARY KEY (
	`id`
);

ALTER TABLE `payment` ADD CONSTRAINT `PK_PAYMENT` PRIMARY KEY (
	`id`
);

ALTER TABLE `review_image` ADD CONSTRAINT `PK_REVIEW_IMAGE` PRIMARY KEY (
	`id`
);

ALTER TABLE `purchase` ADD CONSTRAINT `PK_PURCHASE` PRIMARY KEY (
	`id`
);

ALTER TABLE `user_point_record` ADD CONSTRAINT `PK_USER_POINT_RECORD` PRIMARY KEY (
	`id`
);

ALTER TABLE `coupon_ form` ADD CONSTRAINT `PK_COUPON_ FORM` PRIMARY KEY (
	`id`
);

ALTER TABLE `payment_type` ADD CONSTRAINT `PK_PAYMENT_TYPE` PRIMARY KEY (
	`id`
);

ALTER TABLE `purchase_book` ADD CONSTRAINT `PK_PURCHASE_BOOK` PRIMARY KEY (
	`id`
);

ALTER TABLE `simple_review` ADD CONSTRAINT `PK_SIMPLE_REVIEW` PRIMARY KEY (
	`id`
);

ALTER TABLE `comment` ADD CONSTRAINT `PK_COMMENT` PRIMARY KEY (
	`id`
);

ALTER TABLE `address` ADD CONSTRAINT `PK_ADDRESS` PRIMARY KEY (
	`id`
);

ALTER TABLE `member_auth` ADD CONSTRAINT `PK_MEMBER_AUTH` PRIMARY KEY (
	`id`
);

ALTER TABLE `coupon` ADD CONSTRAINT `PK_COUPON` PRIMARY KEY (
	`id`
);

ALTER TABLE `book_category` ADD CONSTRAINT `PK_BOOK_CATEGORY` PRIMARY KEY (
	`id`
);

ALTER TABLE `auth` ADD CONSTRAINT `PK_AUTH` PRIMARY KEY (
	`id`
);

ALTER TABLE `purchase_coupon` ADD CONSTRAINT `PK_PURCHASE_COUPON` PRIMARY KEY (
	`id`
);

ALTER TABLE `book_image` ADD CONSTRAINT `PK_BOOK_IMAGE` PRIMARY KEY (
	`id`
);

ALTER TABLE `tag` ADD CONSTRAINT `PK_TAG` PRIMARY KEY (
	`id`
);

ALTER TABLE `book_tag` ADD CONSTRAINT `PK_BOOK_TAG` PRIMARY KEY (
	`id`
);

ALTER TABLE `cart` ADD CONSTRAINT `PK_CART` PRIMARY KEY (
	`id`
);

ALTER TABLE `review-like` ADD CONSTRAINT `PK_REVIEW-LIKE` PRIMARY KEY (
	`id`
);

ALTER TABLE `Refund` ADD CONSTRAINT `PK_REFUND` PRIMARY KEY (
	`id`
);

ALTER TABLE `refund_record` ADD CONSTRAINT `PK_REFUND_RECORD` PRIMARY KEY (
	`Key`
);

ALTER TABLE `total_image` ADD CONSTRAINT `PK_TOTAL_IMAGE` PRIMARY KEY (
	`id`
);

ALTER TABLE `member_grade_record` ADD CONSTRAINT `PK_MEMBER_GRADE_RECORD` PRIMARY KEY (
	`id`
);

ALTER TABLE `member_message` ADD CONSTRAINT `PK_MEMBER_MESSAGE` PRIMARY KEY (
	`id`
);

ALTER TABLE `coupon_type` ADD CONSTRAINT `PK_COUPON_TYPE` PRIMARY KEY (
	`id`
);

ALTER TABLE `fixed_coupon` ADD CONSTRAINT `PK_FIXED_COUPON` PRIMARY KEY (
	`id`,
	` coupon_type_id`
);

ALTER TABLE `ratio_coupon` ADD CONSTRAINT `PK_RATIO_COUPON` PRIMARY KEY (
	`id`,
	` coupon_type_id`
);

ALTER TABLE `coupon_usage` ADD CONSTRAINT `PK_COUPON_USAGE` PRIMARY KEY (
	`id`
);

ALTER TABLE `category_coupon` ADD CONSTRAINT `PK_CATEGORY_COUPON` PRIMARY KEY (
	`id`
);

ALTER TABLE `book_coupon` ADD CONSTRAINT `PK_BOOK_COUPON` PRIMARY KEY (
	`id`
);

ALTER TABLE `category_coupon_usage` ADD CONSTRAINT `PK_CATEGORY_COUPON_USAGE` PRIMARY KEY (
	`ID`
);

ALTER TABLE `book_coupon_usage` ADD CONSTRAINT `PK_BOOK_COUPON_USAGE` PRIMARY KEY (
	`id`
);

ALTER TABLE `point_policy` ADD CONSTRAINT `PK_POINT_POLICY` PRIMARY KEY (
	`id`
);

ALTER TABLE `fixed_coupon` ADD CONSTRAINT `FK_coupon_type_TO_fixed_coupon_1` FOREIGN KEY (
	` coupon_type_id`
)
REFERENCES `coupon_type` (
	`id`
);

ALTER TABLE `ratio_coupon` ADD CONSTRAINT `FK_coupon_type_TO_ratio_coupon_1` FOREIGN KEY (
	` coupon_type_id`
)
REFERENCES `coupon_type` (
	`id`
);


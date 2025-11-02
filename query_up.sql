CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(30) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(25),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP 
);

CREATE TABLE user_profiles (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    photo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE categories (
    id INT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    price INT NOT NULL,
    is_flash_sale BOOLEAN,
    is_favorite BOOLEAN,
    is_buy1get1 BOOLEAN,
    is_active BOOLEAN DEFAULT TRUE,
    stock INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE product_images (
    id INT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE product_reviews (
    id INT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE promos (
    id INT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    discount_percentage INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE promo_products (
    id INT PRIMARY KEY,
    promo_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (promo_id) REFERENCES promos(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE delivery_methods (
    id INT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    base_fee INT NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payment_methods (
    id INT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tax_rates (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    rate_percentage DECIMAL(5,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    delivery_address TEXT NOT NULL,
    delivery_method_id INT NOT NULL,
    subtotal INT NOT NULL,
    delivery_fee INT NOT NULL,
    tax_amount INT NOT NULL,
    tax_rate_id INT,
    total INT NOT NULL,
    promo_id INT,
    payment_method_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (delivery_method_id) REFERENCES delivery_methods(id),
    FOREIGN KEY (tax_rate_id) REFERENCES tax_rates(id),
    FOREIGN KEY (promo_id) REFERENCES promos(id) ON DELETE SET NULL,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    size_id INT REFERENCES product_sizes(id),
    temperature_id INT REFERENCES product_temperatures(id),
    unit_price INT NOT NULL,
    is_flash_sale BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE cart_items (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    size_id INT REFERENCES product_sizes(id),
    temperature_id INT REFERENCES product_temperatures(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

SELECT * FROM users;
SELECT * FROM user_profiles;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM product_images;
SELECT * FROM product_reviews;
SELECT * FROM promos;
SELECT * FROM promo_products;
SELECT * FROM delivery_methods;
SELECT * FROM payment_methods;
SELECT * FROM tax_rates;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM cart_items;



INSERT INTO users (id, email, password, role, created_at, updated_at) VALUES
(1, 'admin@harlanholden.com', '$2b$10$abcdefghijklmnopqrstuv', 'admin', '2025-10-15 08:00:00', '2025-10-15 08:00:00'),
(2, 'anggi@email.com', '$2b$10$abcdefghijklmnopqrstuv', 'customer', '2025-10-01 10:30:00', '2025-10-01 10:30:00'),
(3, 'prayoga@email.com', '$2b$10$abcdefghijklmnopqrstuv', 'customer', '2025-10-15 14:20:00', '2025-10-15 14:20:00'),
(4, 'raka@email.com', '$2b$10$abcdefghijklmnopqrstuv', 'customer', '2025-10-01 09:15:00', '2025-10-01 09:15:00'),
(5, 'rangga@email.com', '$2b$10$abcdefghijklmnopqrstuv', 'customer', '2025-10-10 16:45:00', '2025-10-10 16:45:00');

INSERT INTO user_profiles (id, user_id, full_name, phone, address, photo_url, created_at, updated_at) VALUES
(1, 1, 'Admin Harlan Holden', '081234567890', 'Jl. Sudirman, Jakarta Pusat', 'https://id.pinterest.com/pin/625226360811543537/', '2025-10-15 08:00:00', '2025-10-15 08:00:00'),
(2, 2, 'Anggi', '082345678901', 'Jl. Thamrin No. 123, Jakarta Pusat', 'https://id.pinterest.com/pin/295408056838997225/', '2025-10-01 10:30:00', '2025-10-01 10:30:00'),
(3, 3, 'Prayoga', '083456789012', 'Jl. Gatot Subroto No. 45, Jakarta Selatan', 'https://id.pinterest.com/pin/539235755400242280/', '2025-10-15 14:20:00', '2025-10-15 14:20:00'),
(4, 4, 'Raka', '084567890123', 'Jl. HR Rasuna Said No. 78, Jakarta Selatan', 'https://id.pinterest.com/pin/187251297001767651/', '2025-10-01 09:15:00', '2025-10-01 09:15:00'),
(5, 5, 'Rangga', '085678901234', 'Jl. Kuningan No. 90, Jakarta Selatan', 'https://id.pinterest.com/pin/238479742765437125/', '2025-10-10 16:45:00', '2025-10-10 16:45:00');

INSERT INTO categories (id, name, is_active, created_at) VALUES
(1, 'Coffee', TRUE, '2025-10-10 08:00:00'),
(2, 'Non-Coffee', TRUE, '2025-10-10 08:00:00'),
(3, 'Food', TRUE, '2025-10-10 08:00:00'),
(4, 'Addon', TRUE, '2025-10-10 08:00:00');

CREATE TABLE product_sizes (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price_adjustment INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_temperatures (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO product_sizes (id, name, price_adjustment, is_active, created_at) VALUES
(1, 'Regular', 0, TRUE, '2025-10-10 08:00:00'),
(2, 'Medium', 5000, TRUE, '2025-10-10 08:00:00'),
(3, 'Large', 10000, TRUE, '2025-10-10 08:00:00');

INSERT INTO product_temperatures (id, name, is_active, created_at) VALUES
(1, 'Hot', TRUE, '2025-10-10 08:00:00'),
(2, 'Ice', TRUE, '2025-10-10 08:00:00');

INSERT INTO products (id, name, description, category_id, price, is_flash_sale, is_favorite, is_buy1get1, is_active, stock, created_at, updated_at) VALUES
(1, 'Sea Salt Latte', 'Latte topped with Harlan sea salt cream. Items may arrive less cold due to delivery time. Product look may vary due to delivery.', 1, 230000, FALSE, TRUE, FALSE, TRUE, 100, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(2, 'Butterscotch Latte', 'Caramel latte with sea salt, framed with cookie crumble. Items may arrive less hot/cold due to delivery time. Iced drink as seen on photo.', 1, 230000, FALSE, TRUE, FALSE, TRUE, 95, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(3, 'Peanut Butter Latte', 'A flat white with sweet and salty ground peanuts, topped with cookie crumble. Items may arrive less hot/cold due to delivery time. Product look may vary due to delivery.', 1, 220000, FALSE, TRUE, FALSE, TRUE, 90, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(4, 'Cereal Latte', 'Brown sugar latte base with sea salt cream layer and crunchy cereal crack toppings. Iced only.', 1, 250000, FALSE, TRUE, FALSE, TRUE, 85, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(5, 'Pandan Latte', 'Our best selling latte with fresh pandan and cane sugar.', 1, 215000, FALSE, TRUE, FALSE, TRUE, 120, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(6, 'Americano', 'A double shot espresso diluted with water.', 1, 185000, FALSE, TRUE, FALSE, TRUE, 110, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(7, 'Cortado', 'A 5oz drink of double shot espresso with the same amount of milk. It\'s like a small latte.', 1, 185000, FALSE, FALSE, FALSE, TRUE, 100, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(8, 'Cappuccino', 'A double shot of espresso with milk, microfoam, and 1.5cm wet foam.', 1, 190000, FALSE, TRUE, FALSE, TRUE, 105, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(9, 'Flat White', 'A double shot of espresso with milk, microfoam, and 0.5cm wet foam.', 1, 190000, FALSE, TRUE, FALSE, TRUE, 95, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(10, 'Latte', 'A double shot of espresso with milk, microfoam, and 1cm wet foam.', 1, 210000, FALSE, TRUE, FALSE, TRUE, 115, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(11, 'Oat Milk Latte', 'A double shot of espresso with oat milk, microfoam, and 1cm wet foam.', 1, 260000, FALSE, TRUE, FALSE, TRUE, 80, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(12, 'Almond Milk Latte', 'A double shot of espresso with almond milk, microfoam, and 1cm wet foam.', 1, 240000, FALSE, TRUE, FALSE, TRUE, 75, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(13, 'Madagascar', 'Latte with pure vanilla bean. Items may arrive less hot/cold due to delivery time.', 1, 215000, FALSE, TRUE, FALSE, TRUE, 90, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(14, 'Spanish Latte', 'Latte with house made condensed milk. Items may arrive less hot/cold due to delivery time.', 1, 215000, TRUE, TRUE, FALSE, TRUE, 100, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(15, 'Brown Sugar Latte', 'Latte with brown sugar molasses syrup. Items may arrive less hot/cold due to delivery time.', 1, 215000, FALSE, TRUE, FALSE, TRUE, 95, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(16, 'Cold Brew', 'Coffee brewed cold for 12-hours. Consume within 24hrs. Items may arrive less cold due to delivery time. Iced only.', 1, 190000, FALSE, TRUE, FALSE, TRUE, 85, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(17, 'Hazelnut Latte', 'Latte topped with a heavy roasted hazelnut cream. Items may arrive less hot/cold due to delivery time. Product look may vary due to delivery. Iced only.', 1, 240000, FALSE, TRUE, FALSE, TRUE, 70, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(18, 'Campfire Coffee (Short Drink)', 'Espresso and thick, rich and luscious double chocolate drink topped with toasted vanilla marshmallow creme.', 1, 220000, FALSE, TRUE, FALSE, TRUE, 65, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(19, 'Mocha', 'A latte with dark chocolate sauce. Items may arrive less hot/cold due to delivery time.', 1, 215000, FALSE, TRUE, FALSE, TRUE, 100, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(20, 'Spanish Cold Brew', 'Coffee brewed cold for 12-hours with enough cane sugar and heavy cream. Consume within 48hrs. Items may arrive less cold due to delivery time.', 1, 230000, FALSE, TRUE, FALSE, TRUE, 75, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(21, 'Long Black', 'A double shot poured over water.', 1, 135000, FALSE, FALSE, FALSE, TRUE, 110, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(22, 'Matcha Latte', 'Green tea with milk, microfoam, and 1cm wet foam.', 2, 215000, FALSE, TRUE, FALSE, TRUE, 90, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(23, 'Mixed Berries Iced Tea', 'A fresh blend of hibiscus, blueberry, raspberry and blackberry sweetened with cane sugar.', 2, 160000, FALSE, TRUE, FALSE, TRUE, 100, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(24, 'Sparkling Water', 'Sparkling water.', 2, 110000, FALSE, FALSE, FALSE, TRUE, 120, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(25, 'Bottled Purified Water 500ml', 'Bottled water.', 2, 60000, FALSE, FALSE, FALSE, TRUE, 150, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(26, 'Campfire Chocolate (Short Drink)', 'Thick, rich and luscious double chocolate drink topped with toasted vanilla marshmallow creme.', 2, 170000, FALSE, TRUE, FALSE, TRUE, 70, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(27, 'Chocolate Milk', 'Dark chocolate with milk.', 2, 200000, FALSE, TRUE, FALSE, TRUE, 80, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(28, 'Orange Cinnamon Iced Tea', 'A seasonal blend of sweet zesty orange, cinnamon and cloves sweetened with cane sugar. 5 days in the chiller.', 2, 160000, FALSE, FALSE, FALSE, TRUE, 85, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(29, 'Hot Tall Pandan Latte + Hot Honey Chicken Hand Pie', 'Hot tall pandan latte + hot honey chicken hand pie.', 3, 325000, FALSE, TRUE, FALSE, TRUE, 50, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(30, 'Iced Madagascar + Grilled Cheese', 'Best-selling latte lightly sweetened with pure vanilla bean with grilled cheese snack.', 3, 325000, FALSE, TRUE, FALSE, TRUE, 45, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(31, 'Sea Salt Latte + Sea Salt Butter Cookie', 'Our favorite sea salt latte paired with our top-selling sea salt butter cookie.', 3, 380000, FALSE, TRUE, FALSE, TRUE, 40, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(32, 'Hot Tall Brown Sugar Latte + Spinach + Cheese Hand Pie', 'Hot tall brown sugar latte with spinach + cheese hand pie.', 3, 305000, FALSE, TRUE, FALSE, TRUE, 48, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(33, 'Sea Salt Latte + Sourdough Cheesesteak', 'Best-selling sea salt latte with sourdough cheesesteak snack.', 3, 435000, FALSE, TRUE, FALSE, TRUE, 35, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(34, 'Hazelnut Latte + Sourdough Cheesesteak', 'Best-selling latte topped with heavy roasted hazelnut cream with sourdough cheesesteak snack.', 3, 425000, FALSE, TRUE, FALSE, TRUE, 30, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(35, 'Pepperoni Flatbread', 'Savory pepperoni on melted mozzarella cheese and rich vodka cream sauce on a crisp flatbread dough (note: contains seafood).', 4, 135000, FALSE, TRUE, FALSE, TRUE, 60, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(36, 'Four Cheese Flatbread', 'A mix of mozzarella, burrata, parmesan, and cream cheese, seasoned with peppercorn and maldon salt on a crisp flatbread dough.', 4, 135000, FALSE, TRUE, FALSE, TRUE, 55, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(37, 'Hot Honey Chicken Hand Pie', 'Made with ground chicken, zesty hot sauce, and a touch of honey, all wrapped in flaky pastry dough.', 4, 150000, FALSE, TRUE, FALSE, TRUE, 50, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(38, 'Spinach + Cheese Hand Pie', 'Made with chopped spinach blended with mozzarella and cheddar cheese, all enveloped in flaky pastry dough.', 4, 150000, FALSE, TRUE, FALSE, TRUE, 52, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(39, 'Grilled Cheese', 'Pressed pullman with cheese, cheese and cheese.', 4, 150000, FALSE, TRUE, FALSE, TRUE, 65, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(40, 'Sea Salt Butter Cookie', 'Crisp and soft butter cookie dough with sea salt flakes and cookie butter spread.', 4, 150000, FALSE, TRUE, FALSE, TRUE, 70, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(41, 'Chocolate Chip Walnut Cookie', 'Toasted walnuts and dark chocolate in a crunchy chewy cookie.', 4, 135000, FALSE, TRUE, FALSE, TRUE, 60, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(42, 'Double Chocolate Chip Cookie', 'Dark and milk cacao in crunchy chewy cookie.', 4, 135000, FALSE, TRUE, FALSE, TRUE, 58, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(43, 'Swiss Chocolate Brownie', 'Delicious soft and chewy brownie fudge with the right sweetness.', 4, 135000, FALSE, TRUE, FALSE, TRUE, 55, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(44, 'Cheesecake-to-go', 'A classic New York cheesecake slice with graham crust.', 4, 160000, FALSE, TRUE, FALSE, TRUE, 45, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(45, 'Toffee Crack', 'Toffee swiss chocolate bar with maldon salt flakes.', 4, 325000, FALSE, TRUE, FALSE, TRUE, 35, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(46, 'Cheesesteak Melt', 'Flavorful sandwich with roast beef brisket, grilled onions, garlic dressing and melted cheese, all in a pressed pullman.', 4, 210000, FALSE, TRUE, FALSE, TRUE, 40, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(47, 'Wild Mushroom Hand Pie', 'Made with 5 types of mushrooms: button, enoki, shimeji, oyster, and shiitake. Enriched with cream and cheese, seasoned with herbs, and wrapped in flaky pastry dough.', 4, 150000, FALSE, TRUE, FALSE, TRUE, 48, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(48, 'Sourdough Cheesesteak', 'Thinly sliced prime roast beef brisket, cheddar cheese, aioli and parmesan butter in sourdough bread.', 4, 245000, FALSE, TRUE, FALSE, TRUE, 38, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(49, 'Prime Roast Beef', 'Roast beef brisket, horseradish and grilled sweet onions in a freshly bakes sourdough.', 4, 290000, FALSE, TRUE, FALSE, TRUE, 32, '2025-10-12 09:00:00', '2025-10-12 09:00:00'),
(50, 'Salami Napoli Baguette', 'Salami napoli with roasted aioli served in freshly toasted french baguette.', 4, 245000, FALSE, TRUE, FALSE, TRUE, 42, '2025-10-12 09:00:00', '2025-10-12 09:00:00');

INSERT INTO product_images (id, product_id, image_url, is_primary, display_order, created_at) VALUES
(1, 1, 'https://food-cms.grab.com/compressed_webp/items/PHITE2022091202170941286/detail/menueditor_item_3fe658f6d55f480cb1c834354295bc1f_1701164488798975198.webp', TRUE, 1, '2025-10-12 09:30:00'),
(2, 2, 'https://food-cms.grab.com/compressed_webp/items/PHITE20220912025-1095443/detail/menueditor_item_56ff12d0ce194b87b34197432052b26d_1701164376300781634.webp', TRUE, 1, '2025-10-12 09:30:00'),
(3, 3, 'https://food-cms.grab.com/compressed_webp/items/PHITE2025-10304205178836/detail/menueditor_item_03a89bcc43e94dafbdfaf37d75689740_1705983626322871092.webp', TRUE, 1, '2025-10-12 09:30:00'),
(4, 4, 'https://food-cms.grab.com/compressed_webp/items/PHITE2025-10304191964125/detail/menueditor_item_556ec05ae99744afa555fc23e1913597_1705983521589490906.webp', TRUE, 1, '2025-10-12 09:30:00'),
(5, 5, 'https://food-cms.grab.com/compressed_webp/items/PHITE2022091202161897825/detail/menueditor_item_29bcc8780b074c6689f176a334bc3ab6_1701164526305614041.webp', TRUE, 1, '2025-10-12 09:30:00');

INSERT INTO product_reviews (id, product_id, user_id, rating, review_text, created_at) VALUES
(1, 1, 2, 5, 'Sea salt cream on top is amazing! Perfect balance.', '2025-10-05 10:30:00'),
(2, 2, 3, 5, 'Butterscotch latte is so good! Love the cookie crumble.', '2025-10-20 14:15:00'),
(3, 14, 4, 5, 'Pandan latte is the best! Unique and refreshing.', '2025-10-05 11:20:00'),
(4, 8, 2, 5, 'Perfect americano for morning boost!', '2025-10-15 16:30:00'),
(5, 3, 5, 5, 'Matcha latte is authentic and delicious.', '2025-10-20 13:45:00');

INSERT INTO promos (id, code, title, description, discount_percentage, start_date, end_date, is_active, created_at) VALUES
(1, 'MOTHERSDAY', 'HAPPY MOTHER\'S DAY!', 'Get one of our favorite menu for free!', 100, '2025-10-01', '2025-10-12', TRUE, '2025-10-01 00:00:00'),
(2, 'WEEKEND50', 'WEEKEND SPECIAL!', '50% off on all coffee drinks!', 50, '2025-10-01', '2025-10-31', TRUE, '2025-10-01 00:00:00'),
(3, 'BUY1GET1', 'BUY 1 GET 1 FREE', 'On selected items this week only!', 50, '2025-10-01', '2025-10-31', TRUE, '2025-10-01 00:00:00'),
(4, 'FREECOFFEE', 'Get a cup of coffee for free', 'On sunday morning only on may 6!', 100, '2025-10-06', '2025-10-06', TRUE, '2025-10-06 00:00:00');

INSERT INTO promo_products (id, promo_id, product_id, created_at) VALUES
(1, 2, 1, '2025-10-01 00:00:00'),
(2, 2, 2, '2025-10-01 00:00:00'),
(3, 2, 3, '2025-10-01 00:00:00'),
(4, 2, 4, '2025-10-01 00:00:00'),
(5, 3, 8, '2025-10-01 00:00:00'),
(6, 3, 27, '2025-10-01 00:00:00');

INSERT INTO delivery_methods (id, name, base_fee, description, is_active, created_at) VALUES
(1, 'Standard Delivery', 15000, 'Delivery within 45-60 minutes', TRUE, '2025-10-10 08:00:00'),
(2, 'Express Delivery', 25000, 'Priority delivery within 30 minutes', TRUE, '2025-10-10 08:00:00'),
(3, 'Scheduled Delivery', 20000, 'Schedule your delivery time', TRUE, '2025-10-10 08:00:00'),
(4, 'Pick Up', 0, 'Pick up at store location', TRUE, '2025-10-10 08:00:00');

INSERT INTO payment_methods (id, name, description, is_active, created_at) VALUES
(1, 'Bank BRI', 'Transfer via Bank BRI', TRUE, '2025-10-10 08:00:00'),
(2, 'DANA', 'Pay with DANA e-wallet', TRUE, '2025-10-10 08:00:00'),
(3, 'BCA', 'Transfer via Bank BCA', TRUE, '2025-10-10 08:00:00'),
(4, 'GoPay', 'Pay with GoPay e-wallet', TRUE, '2025-10-10 08:00:00'),
(5, 'OVO', 'Pay with OVO e-wallet', TRUE, '2025-10-10 08:00:00'),
(6, 'PayPal', 'Pay with PayPal', TRUE, '2025-10-10 08:00:00'),
(7, 'Cash on Delivery', 'Pay with cash when order arrives', TRUE, '2025-10-10 08:00:00');

INSERT INTO tax_rates (id, name, rate_percentage, is_active, created_at) VALUES
(1, 'PPN 10%', 10.00, TRUE, '2025-10-10 08:00:00'),
(2, 'Service Charge 5%', 5.00, TRUE, '2025-10-10 08:00:00');

INSERT INTO orders (id, order_number, user_id, status, delivery_address, delivery_method_id, subtotal, delivery_fee, tax_amount, tax_rate_id, total, promo_id, payment_method_id, order_date, created_at, updated_at) VALUES
(1, 'HH-2025-1001', 2, 'delivered', 'Jl. Thamrin No. 123, Jakarta Pusat', 1, 140000, 15000, 15400, 1, 170400, 1, 2, '2025-10-10 10:30:00', '2025-10-10 10:30:00', '2025-10-10 11:45:00'),
(2, 'HH-2025-1002', 3, 'delivered', 'Jl. Gatot Subroto No. 45, Jakarta Selatan', 2, 188000, 25000, 20680, 1, 233680, NULL, 4, '2025-10-25 14:15:00', '2025-10-25 14:15:00', '2025-10-25 15:10:00'),
(3, 'HH-2025-1003', 4, 'processing', 'Jl. HR Rasuna Said No. 78, Jakarta Selatan', 1, 195000, 15000, 21450, 1, 231450, 2, 5, '2025-10-10 11:20:00', '2025-10-10 11:20:00', '2025-10-10 11:20:00'),
(4, 'HH-2025-1004', 5, 'pending', 'Jl. Kuningan No. 90, Jakarta Selatan', 4, 220000, 0, 24200, 1, 244200, NULL, 7, '2025-10-28 16:45:00', '2025-10-28 16:45:00', '2025-10-28 16:45:00'),
(5, 'HH-2025-1005', 2, 'delivered', 'Jl. Thamrin No. 123, Jakarta Pusat', 4, 178000, 0, 19580, 1, 197580, 3, 3, '2025-10-05 09:30:00', '2025-10-05 09:30:00', '2025-10-05 10:15:00');

INSERT INTO order_items (id, order_id, product_id, quantity, size, temperature, unit_price, is_flash_sale, created_at) VALUES
(1, 1, 1, 2, 'Regular', 'Iced', 50000, TRUE, '2025-10-10 10:30:00'),
(2, 1, 8, 1, 'Regular', 'Hot', 43000, FALSE, '2025-10-10 10:30:00'),
(3, 2, 14, 2, 'Regular', 'Hot', 50000, FALSE, '2025-10-25 14:15:00'),
(4, 2, 28, 2, NULL, NULL, 40000, FALSE, '2025-10-25 14:15:00'),
(5, 3, 11, 2, 'Regular', 'Hot', 45000, FALSE, '2025-10-10 11:20:00');
INSERT INTO cart_items (id, user_id, product_id, quantity, size, temperature, created_at, updated_at) VALUES
(1, 2, 1, 1, 'Regular', 'Iced', '2025-10-10 10:00:00', '2025-10-10 10:00:00'),
(2, 2, 30, 1, NULL, NULL, '2025-10-10 10:02:00', '2025-10-10 10:02:00'),
(3, 3, 5, 1, 'Regular', 'Iced', '2025-10-11 14:30:00', '2025-10-11 14:30:00'),
(4, 3, 33, 2, NULL, NULL, '2025-10-11 14:32:00', '2025-10-11 14:32:00'),
(5, 4, 11, 1, 'Regular', 'Hot', '2025-10-12 09:15:00', '2025-10-12 09:15:00');
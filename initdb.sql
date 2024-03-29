CREATE TABLE IF NOT EXISTS products(
  identifier INTEGER,
  full_name VARCHAR(255),
  state_name VARCHAR(255)
);

INSERT INTO products(identifier, full_name, state_name) VALUES (1, 'Headset', 'ready');
INSERT INTO products(identifier, full_name, state_name) VALUES (2, 'USB charger', 'discarded');
INSERT INTO products(identifier, full_name, state_name) VALUES (3, 'Dell notebook', 'selled');

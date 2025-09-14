/****************************************************
*          1️⃣ Criação do Banco de Dados           *
****************************************************/
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

/****************************************************
*          2️⃣ Tabelas do Banco de Dados          *
****************************************************/

-- Tabela de clientes (PF ou PJ)
CREATE TABLE client(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(20),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) UNIQUE,
    CNPJ CHAR(14) UNIQUE,
    Address VARCHAR(50),
    client_type ENUM('PF','PJ') NOT NULL
);

-- Tabela de fornecedores
CREATE TABLE supplier(
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    CNPJ CHAR(14) UNIQUE,
    Address VARCHAR(50)
);

-- Tabela de produtos
CREATE TABLE product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(30) NOT NULL,
    classification_kids BOOLEAN,
    category ENUM('Eletrônico','Vestimenta','Brinquedo','Alimentos'),
    price DECIMAL(10,2) NOT NULL,
    size VARCHAR(10),
    stock INT DEFAULT 0,
    idSupplier INT,
    FOREIGN KEY (idSupplier) REFERENCES supplier(idSupplier)
);

-- Tabela de pedidos
CREATE TABLE orders(
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2),
    FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- Tabela de itens do pedido
CREATE TABLE order_item(
    idOrderItem INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    idProduct INT,
    quantity INT DEFAULT 1,
    price DECIMAL(10,2),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- Tabela de pagamento
CREATE TABLE payment(
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    payment_method ENUM('Cartão','Boleto','Pix','Transferência'),
    amount DECIMAL(10,2),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Tabela de entrega
CREATE TABLE delivery(
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    status ENUM('Pendente','Em trânsito','Entregue','Cancelado'),
    tracking_code VARCHAR(50),
    delivery_date DATETIME,
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

/****************************************************
*            3️⃣ Inserção de Dados                 *
****************************************************/

-- Clientes
INSERT INTO client (Fname,Lname,CPF,client_type,Address) VALUES
('Vinicius','Paiva','12345678901','PF','Rua A, 123'),
('EmpresaX',NULL,NULL,'PJ','Av. B, 456');

-- Fornecedores
INSERT INTO supplier (Name,CNPJ,Address) VALUES
('Fornecedor A','12345678000199','Rua Fornecedor, 10'),
('Fornecedor B','98765432000188','Av. Fornecedor, 20');

-- Produtos
INSERT INTO product (Pname, classification_kids, category, price, size, stock, idSupplier) VALUES
('Smartphone',0,'Eletrônico',1500.00,'M',10,1),
('Camiseta',0,'Vestimenta',50.00,'G',50,2),
('Carrinho',1,'Brinquedo',80.00,'P',30,2);

-- Pedidos
INSERT INTO orders (idClient,total) VALUES
(1,1630.00);

-- Itens do pedido
INSERT INTO order_item (idOrder,idProduct,quantity,price) VALUES
(1,1,1,1500.00),
(1,3,2,80.00);

-- Pagamento
INSERT INTO payment (idOrder,payment_method,amount) VALUES
(1,'Cartão',1630.00);

-- Entrega
INSERT INTO delivery (idOrder,status,tracking_code,delivery_date) VALUES
(1,'Em trânsito','TRK123456','2025-09-20 10:00:00');

/****************************************************
*            4️⃣ Queries SQL Exemplos              *
****************************************************/

-- a) Todos os clientes PF
SELECT * FROM client WHERE client_type='PF';

-- b) Quantos pedidos foram feitos por cada cliente
SELECT c.Fname, c.Lname, COUNT(o.idOrder) AS total_orders
FROM client c
LEFT JOIN orders o ON c.idClient = o.idClient
GROUP BY c.idClient;

-- c) Produtos e seus fornecedores
SELECT p.Pname, s.Name AS SupplierName
FROM product p
JOIN supplier s ON p.idSupplier = s.idSupplier;

-- d) Valor total de pedidos e média de produtos vendidos
SELECT o.idOrder, SUM(oi.price * oi.quantity) AS total_order, AVG(oi.quantity) AS avg_quantity
FROM orders o
JOIN order_item oi ON o.idOrder = oi.idOrder
GROUP BY o.idOrder
HAVING total_order > 100;

-- e) Produtos em estoque ordenados por preço
SELECT Pname, stock, price
FROM product
WHERE stock > 0
ORDER BY price DESC;

-- f) Clientes que ainda não fizeram pedidos
SELECT Fname, Lname
FROM client
LEFT JOIN orders o ON client.idClient = o.idClient
WHERE o.idOrder IS NULL;

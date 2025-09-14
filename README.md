# E-commerce Database Project

## Descrição do Projeto
Este projeto apresenta o **esquema de banco de dados para um sistema de e-commerce**, contemplando clientes, fornecedores, produtos, pedidos, pagamentos e entregas. O objetivo é fornecer um **modelo relacional completo** que permita consultas simples e complexas para análise de dados e testes práticos.

O projeto inclui:
- Diferenciação entre clientes PF e PJ.
- Produtos associados a fornecedores.
- Registro de pedidos com itens, pagamentos e status de entrega.
- Queries SQL complexas para recuperação de informações.

---

## Estrutura do Banco de Dados

### Tabelas

1. **client**: clientes PF ou PJ  
   - `idClient` (PK), `Fname`, `Lname`, `CPF`, `CNPJ`, `Address`, `client_type`  

2. **supplier**: fornecedores  
   - `idSupplier` (PK), `Name`, `CNPJ`, `Address`  

3. **product**: produtos  
   - `idProduct` (PK), `Pname`, `classification_kids`, `category`, `price`, `size`, `stock`, `idSupplier` (FK)  

4. **orders**: pedidos  
   - `idOrder` (PK), `idClient` (FK), `order_date`, `total`  

5. **order_item**: itens de pedido  
   - `idOrderItem` (PK), `idOrder` (FK), `idProduct` (FK), `quantity`, `price`  

6. **payment**: pagamentos  
   - `idPayment` (PK), `idOrder` (FK), `payment_method`, `amount`, `payment_date`  

7. **delivery**: entregas  
   - `idDelivery` (PK), `idOrder` (FK), `status`, `tracking_code`, `delivery_date`  

---

## Como Usar

1. Clone este repositório:
```bash
git clone <seu-repositorio>

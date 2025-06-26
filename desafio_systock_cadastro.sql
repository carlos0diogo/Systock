


CREATE TABLE public.venda(
    venda_id int8 NOT NULL,
    data_emissao date NOT NULL,
    horariomov varchar(8) DEFAULT '00:00:00'::character varying NOT NULL,
    produto_id varchar(25) DEFAULT ''::character varying NOT NULL,
    qtde_vendida float8 NULL,
    valor_unitario numeric(12, 4) DEFAULT 0 NOT NULL,
    filial_id int8 DEFAULT 1 NOT NULL,
    item int4 DEFAULT 0 NOT NULL,
    unidade_medida varchar(3) NULL,
    CONSTRAINT pk_consumo PRIMARY KEY (filial_id, venda_id, data_emissao, produto_id, item, horariomov)
);


CREATE TABLE public.pedido_compra(
    pedido_id float8 DEFAULT 0 NOT NULL,
    data_pedido date NULL,
    item float8 DEFAULT 0 NOT NULL,
    produto_id varchar(25) DEFAULT '0' NOT NULL,
    descricao_produto varchar(255) NULL,
    ordem_compra float8 DEFAULT 0 NOT NULL,
    qtde_pedida float8 NULL,
    filial_id int4 NULL,
    data_entrega date NULL,
    qtde_entregue float8 DEFAULT 0 NOT NULL,
    qtde_pendente float8 DEFAULT 0 NOT NULL,
    preco_compra float8 DEFAULT 0 NULL,
    fornecedor_id int4 DEFAULT 0 NULL,
    CONSTRAINT pedido_compra_pkey PRIMARY KEY (pedido_id, produto_id, item)
);


CREATE TABLE public.entradas_mercadoria (
    data_entrada date NULL,
    nro_nfe varchar(255) NOT NULL,
    item float8 DEFAULT 0 NOT NULL,
    produto_id varchar(25) DEFAULT '0' NOT NULL,
    descricao_produto varchar(255) NULL,
    qtde_recebida float8 NULL,
    filial_id int4 NULL,
    custo_unitario numeric(12, 4) DEFAULT 0 NOT NULL,
    ordem_compra float8 NOT NULL, -- Campo necessário para constraint
    CONSTRAINT entradas_mercadoria_pkey PRIMARY KEY (ordem_compra, item, produto_id, nro_nfe)
);




INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES
(1, '2025-01-15', '10:30:00', '12345', 10, 25.50, 1, 1, 'UN'),
(2, '2025-02-10', '14:20:00', '12345', 15, 25.50, 1, 1, 'UN'),
(3, '2025-02-15', '09:15:00', '67890', 8, 45.00, 1, 1, 'UN'),
(4, '2025-02-20', '16:45:00', '12345', 12, 25.50, 1, 2, 'UN'),
(5, '2025-02-25', '11:30:00', '11111', 20, 15.75, 2, 1, 'UN'),
(6, '2025-03-05', '13:00:00', '67890', 5, 45.00, 1, 1, 'UN'),
(7, '2025-01-20', '15:30:00', '22222', 8, 12.00, 1, 1, 'UN'),
(8, '2025-02-05', '08:45:00', '22222', 6, 12.00, 1, 1, 'UN');


INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES
(1, '2025-01-05', 1, '12345', 'Detergente Líquido 500ml', 1001, 50, 1, '2025-01-15', 30, 20, 20.00, 101),
(2, '2025-01-10', 1, '67890', 'Sabão em Pó 1kg', 1002, 25, 1, '2025-01-20', 25, 0, 35.00, 102),
(3, '2025-02-01', 1, '12345', 'Detergente Líquido 500ml', 1003, 40, 1, NULL, 0, 40, 20.00, 101),
(4, '2025-02-05', 1, '11111', 'Amaciante 2L', 1004, 30, 2, '2025-02-15', 30, 0, 12.00, 103),
(5, '2025-02-10', 1, '22222', 'Desinfetante 1L', 1005, 15, 1, NULL, 0, 15, 8.50, 104),
(6, '2025-03-01', 1, '67890', 'Sabão em Pó 1kg', 1006, 35, 1, '2025-03-10', 35, 0, 35.00, 102),
(7, '2025-01-25', 1, '33333', 'Alvejante 1L', 1007, 20, 1, NULL, 0, 20, 9.50, 105),
(8, '2025-02-12', 1, '44444', 'Esponja Multiuso', 1008, 100, 1, NULL, 0, 100, 2.50, 106),
(9, '2025-02-01', 1, '55555', 'Papel Higiênico 12 rolos', 1009, 50, 1, '2025-02-20', 0, 50, 18.00, 107),
(10, '2025-02-05', 1, '66666', 'Shampoo 400ml', 1010, 25, 1, '2025-02-25', 0, 25, 15.50, 108),
(11, '2025-02-08', 1, '77777', 'Condicionador 400ml', 1011, 30, 1, '2025-03-01', 0, 30, 16.00, 108),
(12, '2025-02-15', 1, '88888', 'Creme Dental 90g', 1012, 40, 1, '2025-03-15', 0, 40, 4.50, 109);


INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES
('2025-01-15', 'NFE001', 1, '12345', 'Detergente Líquido 500ml', 30, 1, 20.00, 1001),
('2025-01-20', 'NFE002', 1, '67890', 'Sabão em Pó 1kg', 25, 1, 35.00, 1002),
('2025-02-15', 'NFE003', 1, '11111', 'Amaciante 2L', 30, 2, 12.00, 1004),
('2025-03-10', 'NFE004', 1, '67890', 'Sabão em Pó 1kg', 35, 1, 35.00, 1006);

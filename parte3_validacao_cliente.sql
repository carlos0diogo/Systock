
-- PARTE 3 - ESTRATÉGIA DE VALIDAÇÃO COM O CLIENTE


-- ROTEIRO DE VALIDAÇÃO - FEVEREIRO 2025
-- Este arquivo contém as consultas SQL de apoio para validação com o cliente


-- 1. RESUMO EXECUTIVO DO MÊS


-- 1.1 Totalizadores Gerais de Fevereiro/2025
WITH vendas_fev AS (
    SELECT
        COUNT(DISTINCT produto_id) as produtos_vendidos,
        SUM(qtde_vendida) as total_vendas,
        ROUND((SUM(qtde_vendida * valor_unitario))::numeric, 2) as faturamento_total
    FROM public.venda
    WHERE data_emissao BETWEEN '2025-02-01' AND '2025-02-28'
),
pedidos_fev AS (
    SELECT
        COUNT(DISTINCT produto_id) as produtos_pedidos,
        SUM(qtde_pedida) as total_pedidos
    FROM public.pedido_compra
    WHERE data_pedido BETWEEN '2025-02-01' AND '2025-02-28'
),
entradas_fev AS (
    SELECT
        COUNT(DISTINCT produto_id) as produtos_recebidos,
        SUM(qtde_recebida) as total_recebimentos
    FROM public.entradas_mercadoria
    WHERE data_entrada BETWEEN '2025-02-01' AND '2025-02-28'
)
SELECT
    'RESUMO FEVEREIRO 2025' as periodo,
    v.produtos_vendidos,
    v.total_vendas,
    v.faturamento_total,
    p.produtos_pedidos,
    p.total_pedidos,
    e.produtos_recebidos,
    e.total_recebimentos
FROM vendas_fev v
CROSS JOIN pedidos_fev p
CROSS JOIN entradas_fev e;


-- 2. VALIDAÇÃO DE CONSISTÊNCIA DOS DADOS


-- 2.1 Verificar integridade referencial entre pedidos e entradas
SELECT
    'DIVERGÊNCIAS PEDIDOS x ENTRADAS' as validacao,
    pc.ordem_compra,
    pc.produto_id,
    pc.descricao_produto,
    pc.qtde_pedida,
    pc.qtde_entregue,
    COALESCE(em.qtde_recebida, 0) as qtde_nfe,
    CASE
        WHEN em.qtde_recebida IS NULL THEN 'ENTRADA NÃO ENCONTRADA'
        WHEN pc.qtde_entregue != em.qtde_recebida THEN 'DIVERGÊNCIA DE QUANTIDADE'
        ELSE 'OK'
    END as status_validacao
FROM public.pedido_compra pc
LEFT JOIN public.entradas_mercadoria em ON pc.ordem_compra = em.ordem_compra
    AND pc.produto_id = em.produto_id
WHERE pc.data_pedido BETWEEN '2025-02-01' AND '2025-02-28'
ORDER BY pc.ordem_compra;

-- 2.2 Verificar produtos com estoque negativo (vendas > entradas)
WITH movimento_produtos AS (
    SELECT
        produto_id,
        SUM(CASE WHEN tipo = 'ENTRADA' THEN quantidade ELSE 0 END) as total_entradas,
        SUM(CASE WHEN tipo = 'SAIDA' THEN quantidade ELSE 0 END) as total_saidas
    FROM (
        SELECT produto_id, qtde_recebida as quantidade, 'ENTRADA' as tipo
        FROM public.entradas_mercadoria
        WHERE data_entrada <= '2025-02-28'

        UNION ALL

        SELECT produto_id, qtde_vendida as quantidade, 'SAIDA' as tipo
        FROM public.venda
        WHERE data_emissao <= '2025-02-28'
    ) movimentos
    GROUP BY produto_id
)
SELECT
    'ANÁLISE DE ESTOQUE' as validacao,
    produto_id,
    total_entradas,
    total_saidas,
    (total_entradas - total_saidas) as saldo_teorico,
    CASE
        WHEN (total_entradas - total_saidas) < 0 THEN 'ESTOQUE NEGATIVO - VERIFICAR'
        ELSE 'OK'
    END as status
FROM movimento_produtos
ORDER BY (total_entradas - total_saidas);


-- 3. CONSULTAS PARA APRESENTAÇÃO AO CLIENTE


-- 3.1 Top 5 produtos mais vendidos em Fevereiro
SELECT
    ROW_NUMBER() OVER (ORDER BY SUM(qtde_vendida) DESC) as posicao,
    produto_id,
    SUM(qtde_vendida) as quantidade_vendida,
    ROUND((SUM(qtde_vendida * valor_unitario))::numeric, 2) as faturamento,
    COUNT(*) as numero_vendas
FROM public.venda
WHERE data_emissao BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY produto_id
ORDER BY quantidade_vendida DESC
LIMIT 5;

-- 3.2 Análise de performance de fornecedores
SELECT
    pc.fornecedor_id,
    COUNT(pc.pedido_id) as total_pedidos,
    SUM(pc.qtde_pedida) as qtde_total_pedida,
    SUM(pc.qtde_entregue) as qtde_total_entregue,
    ROUND((SUM(pc.qtde_entregue) * 100.0 / SUM(pc.qtde_pedida))::numeric, 2) as percentual_entrega,
    AVG(CASE
        WHEN pc.data_entrega IS NOT NULL
        THEN pc.data_entrega - pc.data_pedido
        ELSE NULL
    END) as prazo_medio_entrega
FROM public.pedido_compra pc
WHERE pc.data_pedido BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY pc.fornecedor_id
ORDER BY percentual_entrega DESC;

-- 3.3 Produtos com maior giro (vendas vs estoque médio)
SELECT
    v.produto_id,
    SUM(v.qtde_vendida) as total_vendido,
    ROUND((AVG(v.valor_unitario))::numeric, 2) as preco_medio_venda,
    COUNT(DISTINCT v.data_emissao) as dias_com_venda,
    ROUND((SUM(v.qtde_vendida) / COUNT(DISTINCT v.data_emissao))::numeric, 2) as media_venda_dia
FROM public.venda v
WHERE v.data_emissao BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY v.produto_id
ORDER BY media_venda_dia DESC;


-- 4. ALERTAS E EXCEÇÕES PARA DISCUSSÃO


-- 4.1 Pedidos em atraso
SELECT
    'PEDIDOS EM ATRASO' as alerta,
    pc.pedido_id,
    pc.produto_id,
    pc.descricao_produto,
    TO_CHAR(pc.data_pedido, 'DD/MM/YYYY') as data_pedido_formatada,
    CASE
        WHEN pc.data_entrega IS NOT NULL
        THEN TO_CHAR(pc.data_entrega, 'DD/MM/YYYY')
        ELSE 'NÃO DEFINIDA'
    END as data_prevista,
    CASE
        WHEN pc.data_entrega IS NOT NULL
        THEN CURRENT_DATE - pc.data_entrega
        ELSE CURRENT_DATE - pc.data_pedido  -- Dias desde o pedido se não há data prevista
    END as dias_pendente,
    pc.qtde_pendente,
    CASE
        WHEN pc.data_entrega IS NULL THEN 'SEM DATA PREVISTA'
        WHEN pc.data_entrega < CURRENT_DATE THEN 'VENCIDO'
        ELSE 'NO PRAZO'
    END as status,
    pc.fornecedor_id
FROM public.pedido_compra pc
WHERE pc.data_pedido BETWEEN '2025-02-01' AND '2025-02-28'
  AND pc.qtde_pendente > 0
  AND (
    pc.data_entrega IS NULL OR  -- Pedidos sem data prevista
    pc.data_entrega < CURRENT_DATE  -- Pedidos vencidos
  )
ORDER BY
    CASE WHEN pc.data_entrega IS NULL THEN CURRENT_DATE - pc.data_pedido
         ELSE CURRENT_DATE - pc.data_entrega
    END DESC;

-- 4.2 Produtos sem movimento há mais de 30 dias
SELECT
    'PRODUTOS SEM MOVIMENTO' as alerta,
    produto_id,
    MAX(data_emissao) as ultima_venda,
    CURRENT_DATE - MAX(data_emissao) as dias_sem_venda
FROM public.venda
GROUP BY produto_id
HAVING CURRENT_DATE - MAX(data_emissao) > 30
ORDER BY dias_sem_venda DESC;


-- PARTE 2 - TRANSFORMAÇÕES DE DADOS


-- Consulta com transformações de dados conforme especificação:
-- 1. Concatenar produto_id e descricao_produto
-- 2. Transformar datas para formato DD/MM/YYYY
-- 3. Filtrar produtos requisitados mais de 10 vezes no período

WITH produtos_requisitados AS (
    SELECT
        pc.produto_id,
        pc.descricao_produto,
        SUM(pc.qtde_pedida) as qtde_total_requisitada,
        COUNT(*) as numero_requisicoes
    FROM public.pedido_compra pc
    WHERE pc.data_pedido BETWEEN '2025-01-01' AND '2025-03-31'
    GROUP BY pc.produto_id, pc.descricao_produto
    HAVING SUM(pc.qtde_pedida) > 10
)
SELECT
    CASE
        WHEN pr.descricao_produto IS NOT NULL AND pr.descricao_produto != ''
        THEN pr.produto_id || ' - ' || pr.descricao_produto
        ELSE pr.produto_id
    END as produto,
    pr.qtde_total_requisitada as "Qtde Requisitada",
    TO_CHAR(MIN(pc.data_pedido), 'DD/MM/YYYY') as "Data Solicitação"
FROM produtos_requisitados pr
JOIN public.pedido_compra pc ON pr.produto_id = pc.produto_id
WHERE pc.data_pedido BETWEEN '2025-01-01' AND '2025-03-31'
GROUP BY pr.produto_id, pr.descricao_produto, pr.qtde_total_requisitada
ORDER BY pr.qtde_total_requisitada DESC;

-- CONSULTA ALTERNATIVA COM DETALHES POR PEDIDO

-- Versão detalhada mostrando cada pedido individualmente
SELECT
    CASE
        WHEN pc.descricao_produto IS NOT NULL AND pc.descricao_produto != ''
        THEN pc.produto_id || ' - ' || pc.descricao_produto
        ELSE pc.produto_id
    END as produto,
    pc.qtde_pedida as "Qtde Requisitada",
    TO_CHAR(pc.data_pedido, 'DD/MM/YYYY') as "Data Solicitação",
    pc.ordem_compra as "Ordem Compra",
    CASE
        WHEN pc.qtde_entregue > 0 THEN 'Parcialmente Entregue'
        WHEN pc.qtde_pendente > 0 THEN 'Pendente'
        ELSE 'Entregue'
    END as status
FROM public.pedido_compra pc
WHERE pc.data_pedido BETWEEN '2025-01-01' AND '2025-03-31'
  AND pc.qtde_pedida > 10
ORDER BY pc.data_pedido, pc.qtde_pedida DESC;

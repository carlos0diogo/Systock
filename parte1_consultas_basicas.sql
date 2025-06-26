
--PARTE 1 - CONSULTAS SQL BÁSICAS


-- 1.1 - Consumo por produto e mês (Fevereiro 2025)
SELECT
    produto_id,
    SUM(qtde_vendida) as total_consumo,
    COUNT(*) as numero_vendas
FROM public.venda
WHERE EXTRACT(YEAR FROM data_emissao) = 2025
  AND EXTRACT(MONTH FROM data_emissao) = 2
GROUP BY produto_id
ORDER BY total_consumo DESC;

-- 1.2 - Produtos com requisição pendente
SELECT DISTINCT
    pc.produto_id,
    pc.descricao_produto,
    pc.qtde_pendente,
    pc.data_pedido,
    pc.ordem_compra
FROM public.pedido_compra pc
WHERE pc.qtde_pendente > 0
  AND pc.data_pedido BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY pc.qtde_pendente DESC;

-- 1.3 - Produtos não consumidos e não recebidos (Fevereiro 2025)
SELECT DISTINCT
    pc.produto_id,
    pc.descricao_produto,
    pc.qtde_pedida,
    pc.qtde_pendente,
    pc.data_pedido
FROM public.pedido_compra pc
WHERE pc.data_pedido BETWEEN '2025-02-01' AND '2025-02-28'
  AND pc.qtde_pendente > 0  -- Não recebidos
  AND NOT EXISTS (
      -- Não consumidos (não vendidos)
      SELECT 1
      FROM public.venda v
      WHERE v.produto_id = pc.produto_id
        AND v.data_emissao BETWEEN '2025-02-01' AND '2025-02-28'
  )
ORDER BY pc.data_pedido;

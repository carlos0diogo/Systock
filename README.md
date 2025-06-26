# Desafio Técnico - Analista de Integração de Dados
## Systock - Soluções em SQL

> **Candidato:** Carlos Diogo Barbosa  
> **E-mail para entrega:** arielle.reis@systock.online  
> **Data de entrega:** 02 de julho de 2025 (prazo: 15h MAO)  
> **Status:** ✅ **CONCLUÍDO E TESTADO**

### 🎯 Sobre o Desafio
Este repositório contém a solução completa para o desafio técnico da vaga de **Analista de Integração de Dados (Implantação)** da Systock. O projeto demonstra habilidades avançadas em SQL, análise de dados, ETL e validação de regras de negócio.

### ⚡ **EXECUÇÃO RÁPIDA (5 minutos)**

**Para os avaliadores da Systock:**

1. **Clone e acesse:**
   ```bash
   git clone https://github.com/carlosbarbosa/desafio-systock-sql
   cd desafio-systock-sql
   ```

2. **Conecte ao PostgreSQL** (DBeaver/DataGrip)

3. **Execute APENAS este arquivo primeiro:**
   ```sql
   -- ⭐ EXECUTAR PRIMEIRO
   desafio_systock_cadastro.sql
   ```

4. **Depois execute em sequência:**
   - `parte1_consultas_basicas.sql`
   - `parte2_transformacoes.sql` 
   - `parte3_validacao_cliente.sql`

### 📊 **Resultados Imediatos**
- ✅ **155 unidades** em pedidos pendentes identificados
- ✅ **Formatação DD/MM/YYYY** implementada
- ✅ **Concatenação produto + descrição** funcionando
- ✅ **Estratégia de validação** pronta para reunião com cliente

### 📊 Resultados Demonstrados

O projeto inclui dados realísticos que demonstram:
- **155 unidades** em pedidos pendentes
- **3 fornecedores** com entregas atrasadas
- **4 produtos diferentes** vendidos em fevereiro
- **Análises de estoque** com alertas de negócio

### ✅ Soluções Implementadas

#### **Parte 1 - Consultas SQL Básicas**
- ✅ **1.1** Consumo por produto em fevereiro/2025
- ✅ **1.2** Produtos com requisição pendente  
- ✅ **1.3** Produtos não consumidos e não recebidos

#### **Parte 2 - Transformações de Dados**
- ✅ Concatenação: `produto_id + descrição`
- ✅ Formatação: datas para `DD/MM/YYYY`
- ✅ Filtro: produtos requisitados `> 10 vezes`

#### **Parte 3 - Estratégia de Validação**
- ✅ Resumo executivo completo
- ✅ Validação de consistência  
- ✅ Consultas para reunião com cliente
- ✅ Identificação de alertas críticos

### 🎯 Principais Funcionalidades Demonstradas

- **Joins complexos** entre múltiplas tabelas
- **CTEs (Common Table Expressions)** para consultas legíveis
- **Funções de agregação** e agrupamento
- **Formatação de dados** e concatenação
- **Análise de integridade referencial**
- **Identificação de exceções de negócio**
- **Consultas analíticas** para tomada de decisão

### 📈 Exemplo de Resultado

**Pedidos em Atraso (Consulta 4.1):**
```
PEDIDOS EM ATRASO | 3 | 12345 | Detergente Líquido 500ml | 01/02/2025 | NÃO DEFINIDA | 145 | 40 | SEM DATA PREVISTA | 101
```

### 🔧 Tecnologias Utilizadas
- **PostgreSQL 14** - Banco de dados principal
- **SQL Avançado** - Consultas complexas e otimizadas
- **DataGrip** - Ferramenta de desenvolvimento
- **Git/GitHub** - Controle de versão

### 👨‍💻 Sobre a Solução

Esta solução foi desenvolvida para demonstrar competências técnicas em:
- Análise e integração de dados
- Validação de regras de negócio
- SQL avançado com performance otimizada
- Documentação técnica profissional
- Apresentação de resultados para clientes

**Tempo de desenvolvimento:** 3 horas  
**Linhas de código SQL:** 400+  
**Consultas funcionais:** 15+


# SQL Portfolio — Retail Analytics (SQLite)

**Autor:** Walter Bruno Bobadilla  
**Stack:** SQL (SQLite), ventanas, CTEs, vistas, índices · Power BI (opcional) · Python runner

## Contenido
- `data/sales.db`: base SQLite con datos sintéticos (ventas 2024–2025).
- `sql/01_schema.sql`: esquema (clientes, productos, pedidos, ítems).
- `sql/02_seed.sql`: carga de datos.
- `sql/03_queries_kpi.sql`: KPIs (revenue, AOV, clientes activos) + ventanas y rolling 3m.
- `sql/04_advanced_queries.sql`: **cohortes**, **RFM**, **Pareto 80/20**.
- `sql/05_views.sql`: vistas reutilizables (totales por pedido, revenue mensual).
- `sql/06_indexing_explain.sql`: ejemplo de `EXPLAIN QUERY PLAN`.
- `scripts/run_queries.py`: ejecutor simple en Python (opcional).

## Cómo ejecutar
### SQLite CLI
sqlite3 data/sales.db ".read sql/03_queries_kpi.sql"
sqlite3 data/sales.db ".read sql/04_advanced_queries.sql"
sqlite3 data/sales.db ".read sql/05_views.sql"
sqlite3 data/sales.db ".read sql/06_indexing_explain.sql"

### Python
python scripts/run_queries.py

> Tip: Conectá `data/sales.db` a **Power BI/Excel** para construir un dashboard (ventas mensuales, top productos, Pareto, cohortes).

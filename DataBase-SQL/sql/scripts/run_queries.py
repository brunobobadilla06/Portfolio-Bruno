
import sqlite3, pathlib
db = pathlib.Path(__file__).resolve().parents[1]/"data"/"sales.db"
con = sqlite3.connect(db)
cur = con.cursor()

def run(sql_file):
    print("\n===", sql_file, "===")
    sql = (pathlib.Path(__file__).resolve().parents[1]/"sql"/sql_file).read_text(encoding="utf-8")
    try:
        cur.executescript(sql)
        try:
            rows = cur.fetchall()
            for r in rows[:10]:
                print(r)
        except Exception:
            pass
    except Exception as e:
        print("Error:", e)

for f in ["03_queries_kpi.sql", "04_advanced_queries.sql", "05_views.sql", "06_indexing_explain.sql"]:
    run(f)

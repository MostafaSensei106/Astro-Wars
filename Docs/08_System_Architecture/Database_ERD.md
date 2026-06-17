# 🗄️ مخطط قواعد البيانات (Database ERD)

جداول مقترحة للـ PostgreSQL:

* **Users Table:** `id`, `username`, `total_commits`, `created_at`
* **Runs Table (History):** `id`, `user_id`, `commits_earned`, `cause_of_death` (مهم جداً لنظام الـ Profiler), `duration`
* **Upgrades Table:** `user_id`, `upgrade_id`, `level`
* **Leaderboard View:** يتم عمل Materialized View أو الاعتماد على In-memory caching للترتيب المباشر.


---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]

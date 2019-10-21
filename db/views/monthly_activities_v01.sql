WITH dates AS
  (SELECT min(date_trunc('month', created_at)) AS startm,
          max(date_trunc('month', created_at)) AS endm FROM loans),
     months AS
  (SELECT generate_series(startm, endm, '1 month') AS month FROM dates)
SELECT extract(YEAR FROM months.month)::integer AS year,
       extract(MONTH FROM months.month)::integer AS month,
       count(DISTINCT l.id) AS loans_count,
       count(DISTINCT l.member_id) AS active_members_count,
       count(DISTINCT m.id) filter (WHERE m.status = 0) AS pending_members_count,
       count(DISTINCT m.id) filter (WHERE m.status = 1) AS new_members_count
FROM months
LEFT OUTER JOIN loans l ON date_trunc('month', l.created_at) = months.month
LEFT JOIN members m ON date_trunc('month', m.created_at) = months.month
GROUP BY months.month
ORDER BY months.month ASC;
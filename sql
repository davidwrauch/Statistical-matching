#to get all the people who had the click we are looking for:
with link_click as(
select 
tzacid
from EVENT_PIPELINE
where 
timestamp >='9/01/2020'
and timestamp <'12/01/2020'
and location = 'FUNNEL'
and label = 'Click - Link'
),
performance AS (
SELECT
	id,
	purchase_status,
	is_in_flood_zone,
	replacement_amount_number,
	square_footage,
	CASE WHEN completed_funnel THEN 'Yes' ELSE 'No' END
  AS completed_funnel,
	CASE WHEN is_site_applicant THEN 'Yes' ELSE 'No' END
  AS is_site_applicant,
	CASE WHEN is_site_customer THEN 'Yes' ELSE 'No' END
  AS is_site_customer,
	device_type,
	user_visit_type,
	construction_type,
	home_finishing_quality,
	residence_type,
	year_built,
	((COALESCE(SUM(revenue1), 0)) + (COALESCE(SUM(revenue2), 0)) + (COALESCE(SUM(revenue3), 0)) + (COALESCE(SUM(evenue4), 0)) + (COALESCE(SUM(revenue5), 0))) / nullif((COUNT(DISTINCT CASE WHEN is_site_applicant THEN id  ELSE NULL END)),0)  AS total_rpa,
		((COALESCE(SUM(revenue1), 0)) + (COALESCE(SUM(revenue2), 0)) + (COALESCE(SUM(revenue3), 0)) + (COALESCE(SUM(evenue4), 0)) + (COALESCE(SUM(revenue5), 0))) / nullif((COUNT(DISTINCT CASE WHEN is_site_user THEN id  ELSE NULL END)),0)  AS total_rpu,
	((COALESCE(SUM(impressions1), 0)) + (COALESCE(SUM(impressions2), 0)) + (COALESCE(SUM(impressions3), 0))) / nullif((COUNT(DISTINCT CASE WHEN is_site_applicant THEN id  ELSE NULL END)), 0)  AS trinket_density,
	(COALESCE(SUM(sales1), 0)) + (COALESCE(SUM(2sales), 0)) AS sum_num_total_sales,
	COALESCE(SUM(intermediate_click_count), 0) AS intermediate_click_count,
	(COALESCE(SUM(purchase_click_count), 0)) + (COALESCE(SUM(purchase_click_count1), 0)) AS other_purcachse_link_click_count
FROM table
WHERE is_site_user AND ((((timestamp ) >= (CONVERT_TIMEZONE('America/Chicago', 'UTC', CAST(TO_TIMESTAMP('2020-09-01') AS TIMESTAMP_NTZ))) AND (timestamp ) < (CONVERT_TIMEZONE('America/Chicago', 'UTC', CAST(TO_TIMESTAMP('2020-12-01') AS TIMESTAMP_NTZ))))))
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
ORDER BY 13 DESC
)
select distinct p.id, p.purchase_status, p.is_in_flood_zone, p.replacement_amount_number, p.square_footage, p.completed_funnel, p.is_site_applicant,  p.is_site_customer, p.device_type, p.user_visit_type, p.construction_type, p.home_finishing_quality, p.residence_type, p.year_built, p.total_rpa, p.total_rpu, p.trinket_density, p.intermediate_click_count,  p.other_purcachse_link_click_count
from link_click l
inner join performance p on p.id=l.id
where p.replacement_amount_number is not null


#to get all the people DID NOT have the click we want for the same time, same except last CTE, inlcluded below

select distinct p.id, p.purchase_status, p.is_in_flood_zone, p.replacement_amount_number, p.square_footage, p.completed_funnel, p.is_site_applicant,  p.is_site_customer, p.device_type, p.user_visit_type, p.construction_type, p.home_finishing_quality, p.residence_type, p.year_built, p.total_rpa, p.total_rpu, p.trinket_density, p.intermediate_click_count,  p.other_purcachse_link_click_count
from link_click l
right join performance p on p.tzacid=f.tzacid
where f.tzacid is null
and p.replacement_amount_number is not null

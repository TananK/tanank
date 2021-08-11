# Title : BrainStation Admission Challenge
# Author : Tanan Kesornbua
# Date : August 4, 2019

## Pull all data for an overall understanding

select cam.name, cam.launched, cam.deadline, cam.goal, cam.pledged, cam.backers, cam.outcome
, c.name category_name, cou.name country_name, sc.name sub_category_name, cur.name currency_name
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
;

## 1) Are the goals of successful and unsuccessful campaigns significantly different?
## We will only focus on campaign in USD and only sucessful and failed outcome
## The goal is rounded up to the nearest thousand

select cam.outcome, c.name category_name
, round(cam.goal/1000) goal_in_thousand, count(*) total
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where cam.outcome in ("successful", "failed")
and cur.name = 'USD'
and cam.goal < 2500000
group by cam.goal, cam.outcome, c.name
;

## 2) How do successful and unsuccessful campaigns differ in terms of numbers of backers?
## We will only focus on campaign in USD and only sucessful and failed outcome
## The goal is rounded up to the nearest thousand

select cam.outcome, c.name category_name
, cam.backers, count(*) total
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where cam.outcome in ("successful", "failed")
and cur.name = 'USD'
and cam.backers < 4000
group by cam.outcome, c.name, cam.backers
;


## 3) Which categories/subcategories are commonly successful and unsuccessful?
## We will only focus on campaign in USD and only sucessful and failed outcome

select cam.outcome, c.name category
, sc.name sub_category, count(*) total
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where cam.outcome in ("successful", "failed")
and cur.name = 'USD'
group by cam.outcome, c.name, sc.name
;

## 4) How are the pledge/donation amounts and rewards commonly related?
## We will only focus on campaign in USD and only sucessful and failed outcome

select cam.outcome, c.name category_name, sc.name sub_category_name, cam.goal, cam.pledged, cam.outcome
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where cam.outcome in ("successful", "failed")
and cur.name = 'USD'
;

## 5) Is there an impact on the duration of the campaign?
## We will only focus on campaign in USD and only sucessful and failed outcome

select cam.outcome, datediff(cam.deadline, cam.launched) campaign_length_in_days
, c.name category_name, sc.name sub_category_name
, count(*) total
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where outcome in ("successful", "failed")
and cur.name = 'USD'
group by cam.outcome, datediff(cam.deadline, cam.launched)
, c.name, cou.name, sc.name
;

## 6) What are year-over-year trends Kickstarter campaigns that can help assess it as a platform?
## We will only focus on campaign in USD and only sucessful and failed outcome

select cam.outcome, extract(year from cam.launched) year
, c.name category_name
, count(*) total
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where outcome in ("successful", "failed")
and cur.name = 'USD'
group by cam.outcome, extract(year from cam.launched)
, c.name, cou.name
;

## Bonus question : What is the stat for table top games?
select extract(year from cam.launched) year
, datediff(cam.deadline, cam.launched) campaign_length_in_days
, cam.goal, cam.pledged
, cam.backers, cam.outcome
from kickstarter.campaign cam
inner join kickstarter.sub_category sc on cam.sub_category_id = sc.id
inner join kickstarter.category c on c.id = sc.category_id
inner join kickstarter.country cou on cou.id = cam.country_id
inner join kickstarter.currency cur on cur.id = cam.currency_id
where sc.name = 'Tabletop Games'
and outcome in ("successful", "failed")
and cur.name = 'USD'
;

select * from kickstarter.sub_category sc;
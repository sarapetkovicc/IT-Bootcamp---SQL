-- Deo G

create or replace table dim_team as
select *
from teams

create or replace table dim_date as 
select cast(date_format(d, 'yyyyMMdd') as int) as date_key,
d as full_date,
date_format(d, 'EEEE') AS weekday_name,
dayofweek(d) IN (1, 7) AS is_weekend,
case when month(d) >= 7
then concat(year(d), '/', substring(cast(year(d) + 1 as string), 3, 2))
else concat(year(d) - 1, '/', substring(cast(year(d) as string), 3, 2))
end as season
from (select explode(sequence(date'2023-07-01', date'2025-06-30', interval 1 day)) as d)

create or replace table dim_player1 as
select player_id, first_name, last_name, position, nationality 
from players
union all
select -1, 'unknown', 'unknown', 'unknown', 'unknown'

create or replace table dim_referee as
select * from referees

create or replace table fact_card as
select e.event_id, e.match_id, cast(date_format(m.kickoff_ts, 'yyyyMMdd') as int) as date_key,
e.team_id,
case when p.player_id is null then -1 else e.player_id
end as player_id,
m.referee_id, e.event_type as card_type
from match_events e join matches m on m.match_id = e.match_id
left join players p on e.player_id = p.player_id
where e.event_type in ('red_card', 'yellow_card', 'second_yellow')

select count(*) br_kartona
from fact_card
where player_id = -1
-- Ima 2 kartona
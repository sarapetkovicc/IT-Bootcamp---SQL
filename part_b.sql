-- Deo B

-- Prvi zahtev
select season, count(match_id) utakmice, sum(home_goals + away_goals) golovi,
sum(home_goals + away_goals) / count(match_id) as prosek_golova,
sum(case when home_goals > away_goals then 1 else 0 end) * 100.00 / count(match_id) as udeo_pobeda_domacin,
sum(case when home_goals = away_goals then 1 else 0 end) * 100.00/ count(match_id) as udeo_nereseno,
sum(case when home_goals < away_goals then 1 else 0 end) * 100.00/ count(match_id) as udeo_pobeda_gost
from matches 
where season = '2024/25'
group by season

-- Drugi zadatak
select year(kickoff_ts) godina,month(kickoff_ts) as mesec, count(match_id) utakmice, 
round(sum(home_goals + away_goals) / count(match_id), 2) as prosek_golova
from matches m
where m.season = '2024/25'
group by godina, mesec
order by prosek_golova desc

-- Treci zadatak
select s.stadium_name, avg(m.attendance) prosek_popunjenost, 
sum(m.attendance)/sum(s.capacity) popunjenost_po_stadionu,
sum(case when m.attendance is null then 1 else 0 end) bez_podataka,
sum(case when m.attendance = 0 then 1 else 0 end) bez_publike
from matches m join stadiums s on m.stadium_id = s.stadium_id
where m.season = '2024/25'
group by s.stadium_name

-- Cetvrti zadatak
select r.referee_name, count(m.match_id) utakmice, 
sum(case when me.event_type in ('red_card', 'yellow_card', 'second_yellow') then 1 else 0 end)/count(m.match_id) as kartoni_po_utakmici
from referees r join matches m on r.referee_id = m.referee_id 
join match_events me on me.match_id = m.match_id
where m.season = '2024/25'
group by r.referee_name 

-- Peti zadatak
select p.first_name, p.last_name, sum(case when p.player_id = me.player_id and me.event_type in ('penalty_goal', 'goal') then 1 else 0 end) br_golova,
sum(case when p.player_id = me.related_player_id and me.event_type in ('penalty_goal', 'goal') then 1 else 0 end) br_asistencija
from players p join match_events me
on p.player_id = me.player_id or p.player_id = me.related_player_id
group by p.first_name, p.last_name
order by br_golova desc
-- golovi: Leo Marsh, Mattéo O'Brien, José Muñoz, Ben Bennett, Luke	Gibbs

select p.first_name, p.last_name, sum(case when p.player_id = me.player_id and me.event_type in ('penalty_goal', 'goal') then 1 else 0 end) br_golova,
sum(case when p.player_id = me.related_player_id and me.event_type in ('penalty_goal', 'goal') then 1 else 0 end) br_asistencija
from players p join match_events me
on p.player_id = me.player_id or p.player_id = me.related_player_id
group by p.first_name, p.last_name
order by br_asistencija desc
-- asistencija
--Raphaël Moreau, Marcus Kerr, Pablo Fernández, Eirik Solberg, Ryan	Harrison

-- Sesti zadatak:
with prvi as (
select m.match_id, sum(m.home_goals + m.away_goals) golovi
from matches m 
where m.season = '2024/25' 
group by m.match_id
)
, drugi as (
select me.match_id, 
sum(case when me.event_type in ('goal', 'penalty_goal') then 1 else 0 end) as golovi
from match_events me join matches m on me.match_id = m.match_id 
where m.season = '2024/25' 
group by me.match_id
)
select t1.*, t2.*
from prvi t1 join drugi t2
on t1.match_id = t2.match_id
where t1.golovi <> t2.golovi
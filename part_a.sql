-- Deo A

-- Prvi zadatak:
select count(match_id) utakmice
from matches
where kickoff_ts >= '2025-02-01' and kickoff_ts < '2025-03-01'
-- 40 utakmica

-- Drugi zadatak:
select stadium_name,capacity
from stadiums 
order by capacity desc
-- Najveci kapacitet ima National Stadium 80000

select t.team_name, s.stadium_name, s.capacity
from teams t join stadiums s on t.stadium_id = s.stadium_id
order by s.capacity desc
-- Najveci stadion nekog kluba je Northport United 52000

-- Treci zadatak
select count(player_id) igraci
from players
where nationality = 'Serbia'
-- 42 igraca

-- Cetvrti zadatak
select count(match_id)
from matches
where home_goals = 1 and away_goals = 1
-- 94 utakmice

-- Peti zadatak
select season, avg(attendance)
from matches
group by season
-- sezona 2023/24 - 24252.95 i sezona 2024/25 - 24199.49

-- Sesti zadatak
select m.season, sum(case when me.event_type = 'penalty_goal' then 1 else 0 end ) golovi
from matches m join match_events me on m.match_id = me.match_id
group by m.season
-- sezona 2023/24 - 104 i sezona 2024/25 - 109

-- Sedmi zadatak
select distinct me.player_id
from match_events me join matches m on m.match_id = me.match_id
where m.season = '2024/25' and me.event_type in ('penalty_goal', 'goal')
-- 308 igraca

-- Osmi zadatak
select r.referee_name, count(m.match_id) utakmice
from referees r join matches m on r.referee_id = m.referee_id
join teams t on t.team_id = m.home_team_id or t.team_id = m.away_team_id
where t.team_name = 'Northport United'
group by r.referee_name
order by utakmice desc
-- Sudio je Peter Lindgren

-- Deveti zadatak
select r.referee_name, count(m.match_id) utakmice
from matches m join match_events me on m.match_id=me.match_id
join referees r on m.referee_id = r.referee_id
where m.season = '2024/25' and me.event_type in ('penalty_goal', 'penalty_miss')
group by r.referee_name
order by utakmice desc
-- Sudija Peter Lindgren

-- Deseti zadatak
select ms.manager_name, 
sum(case 
when (t.team_id = m.home_team_id and m.home_goals > m.away_goals) or 
(t.team_id = m.away_team_id and m.away_goals > m.home_goals) then 3
when (t.team_id = m.home_team_id and m.home_goals = m.away_goals) or 
(t.team_id = m.away_team_id and m.away_goals = m.home_goals) then 1
else 0 end) bodovi
from matches m join teams t 
on t.team_id = m.home_team_id or t.team_id = m.away_team_id
join manager_spells ms on ms.team_id = t.team_id
where (t.team_id = m.home_team_id and m.home_goals_ht < m.away_goals_ht) or 
(t.team_id = m.away_team_id and m.home_goals_ht > m.away_goals_ht)
group by ms.manager_name
order by bodovi desc
-- Zoran Tosic trener
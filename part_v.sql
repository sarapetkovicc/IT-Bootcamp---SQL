-- Deo V
-- Prvi zadatak
  with golovi as (
    select home_team_id as team_id,
    home_goals as br_golova
    from matches 
    where season = '2024/25' and status = 'played'

    union all

    select away_team_id as team_id,
    away_goals as br_golova
    from matches
    where season = '2024/25' and status = 'played'
  )


  select t.team_name,
  sum(g.br_golova) as golovi,
  sum(g.br_golova) * 100.00 / sum(sum(g.br_golova)) over () as udeo
  from golovi g join teams t 
  on g.team_id = t.team_id
  group by t.team_name
  order by udeo desc
 -- Najveci udeo ima Kingsbridge City, 83 gola i udeo 7.60

  -- Drugi zadatak
  select s.stadium_name, avg(m.attendance) prosecna_poseta,
  dense_rank() over (order by avg(m.attendance) desc) as rank
  from stadiums s join matches m on s.stadium_id = m.stadium_id
  where m.season = '2024/25' and m.status = 'played'
  group by s.stadium_name
  qualify rank <=3
  order by rank
  --Harbourside Park	44074.05263157895	1
  --Kingsbridge Stadium	37968.42105263158	2
  --Northport Arena	36250.166666666664	    3

  -- Treci zadatak

select t.team_name, p.first_name, p.last_name,
m.kickoff_ts, me.minute,
row_number() over (partition by t.team_id order by m.kickoff_ts desc, me.minute desc, me.added_time desc, me.event_id desc) as red
from matches m join match_events me on m.match_id = me.match_id
join teams t on t.team_id = me.team_id
join players p on p.player_id = me.player_id
qualify red = 1
order by m.kickoff_ts desc
-- Poslednji gol najranije su dali Dominic	Fletcher za Brackley Harriers i Ivan Šimić za Westmere Town	

-- Cetvrti zadatak
select m.match_id, m.kickoff_ts,
m.attendance as poseta,
lag(m.attendance) over (order by kickoff_ts) as prethodna,
poseta - prethodna as promena
from matches m join teams t on t.team_id = m.home_team_id or t.team_id=m.away_team_id
where t.team_name = 'Northport United' and m.season ='2024/25' and m.status='played'
order by promena desc 
-- Najveca promena je match id:2262	2025-02-22T15:00:00.000+00:00	16056	47171	-31115

-- Peti zadatak
with bodovi as (
    select m.match_id, m.kickoff_ts,
    case when (t.team_id = m.home_team_id and m.home_goals > m.away_goals) or 
(t.team_id = m.away_team_id and m.away_goals > m.home_goals) then 3
when (t.team_id = m.home_team_id and m.home_goals = m.away_goals) or 
(t.team_id = m.away_team_id and m.away_goals = m.home_goals) then 1
else 0 end bodovi
    from matches m join teams t on t.team_id = m.home_team_id or t.team_id = m.away_team_id
    where t.team_name = 'Northport City' and m.season = '2024/25' and m.status = 'played'
)

,ukupno as (
    select
        match_id,
        kickoff_ts,
        sum(bodovi) over (
            order by kickoff_ts, match_id
            rows between unbounded preceding and current row
        ) as ukupno_bodova
    from bodovi
)

select
    u.match_id,
    u.kickoff_ts,
    u.ukupno_bodova
from ukupno u
where u.ukupno_bodova >= 50
order by u.kickoff_ts
--Presao je 50 bodova: match_id: 2210	2025-01-12T16:30:00.000+00:00	51
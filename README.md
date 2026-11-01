# IT Bootcamp - SQL: Sara Petkovic

## Opis dela G:

- Za analizu kartona kreirana je zvezdasta sema koja se sastoji od 4 dimenzione tabele dim_team, dim_date, dim_player, dim_referee i cinjenicne tabele fact_card
- Jedan red u tabeli fact_card predstavlja jedan dogadjaj na utakmici vezan za kartone
- Za dogadjaje kod kojih igrac ne postoji u tabeli koroisti se player_id = -1
- U nasem konkretnom primeru postoje 2 kartona vezana za igraca kojeg nema u tabeli 
create table plans (
id int,
name varchar(100),
price int
);

create table players (
id int,
username varchar(50),
email varchar(100),
country varchar(100),
plan_id int
);

create table genres (
id int,
genre varchar(100)
);

create table games (
id int,
name varchar(100),
release_year int,
genre_id int
);

create table sessions (
id int,
player_id int,
game_id int,
session_date date,
hours_played int
);

insert into plans (id, name, price) values
(1, 'basic', 5),
(2, 'standard', 10),
(3, 'premium', 25);

insert into players (id, username, email, country, plan_id)
select
    gs as id,
    'username' || gs as username,
    'username' || gs || '@mail.com' as email,
    (array['UA', 'POL', 'USA', 'FR', 'DE', 'UK', 'CAN', 'ES'])[
        floor(random() * 8 + 1)::int
    ] as country,
    floor(random() * 3 + 1)::int as plan_id
from generate_series(1, 500) as gs;

insert into genres (id, genre) values
(1, 'shooter'),
(2, 'rpg'),
(3, 'racing'),
(4, 'strategy');

insert into games (id, name, release_year, genre_id)
select
    gs as id,
    'game' || gs as name,
    floor(random() * 25 + 2000)::int as release_year,
    floor(random() * 8 + 1)::int as genre_id
from generate_series(1, 1000) as gs;

insert into sessions (id, player_id, game_id, session_date, hours_played)
select
    gs as id,
    floor(random() * 500 + 1)::int as player_id,
    floor(random() * 1000 + 1)::int as game_id,
    date '2024-01-01' + floor(random() * 365)::int as session_date,
    floor(random() * 10 + 1)::int as hours_played
from generate_series(1, 10000) as gs;

-- cte player_stats summarizes activity for each player (calculates total hours and number of sessions per player)
with player_stats as (
    select
        s.player_id,
        sum(s.hours_played) as total_hours,
    count(s.id) as session_count
    from sessions s
    group by s.player_id
)

-- main query
select
    pl.username,
    pl.country,
    pln.name as plan_name,
    gr.genre as genre_name,
    sum(s.hours_played) as genre_hours,
    ps.total_hours,
    ps.session_count
from player_stats ps
-- connect player stats with players table
join players pl on pl.id = ps.player_id
-- connect player with subscription plan by plan id
join plans pln on pln.id = pl.plan_id
-- connect player with sessions by player id
join sessions s on s.player_id = pl.id
-- connect sessions with games by game id
join games gm on gm.id = s.game_id
-- connect games with genres by genre id
join genres gr on gr.id = gm.genre_id
group by
pl.username,
pl.country,
pln.name,
gr.genre,
ps.total_hours,
ps.session_count

-- sort by hours from highest to lowest
order by ps.total_hours desc

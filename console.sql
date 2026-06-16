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

insert into players (id, username, email, country, plan_id) values
(1, 'username1', 'username1@mail.com', 'UA', 3),
(2, 'username2', 'username2@mail.com', 'UA', 2),
(3, 'username3', 'username3@mail.com', 'POL', 1),
(4, 'username4', 'username4@mail.com', 'USA', 3),
(5, 'username5', 'username5@mail.com', 'FR', 2);

insert into genres (id, genre) values
(1, 'shooter'),
(2, 'rpg'),
(3, 'racing'),
(4, 'strategy');

insert into games (id, name, release_year, genre_id) values
(1, 'game1', 2020, 1),
(2, 'game2', 2021, 2),
(3, 'game3', 2022, 1),
(4, 'game4', 2023, 3),
(5, 'game5', 2025, 4);

insert into sessions (id, player_id, game_id, session_date, hours_played) values
(1, 1, 1, '2024-03-12', 4),
(2, 1, 2, '2024-05-16', 3),
(3, 2, 1, '2024-08-21', 8),
(4, 2, 5, '2024-03-19', 5),
(5, 3, 2, '2024-01-09', 3),
(6, 3, 4, '2024-05-02', 9),
(7, 4, 3, '2024-11-24', 6),
(8, 4, 1, '2024-09-11', 4),
(9, 5, 4, '2024-10-01', 3),
(10, 5, 1, '2024-04-12', 9);

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
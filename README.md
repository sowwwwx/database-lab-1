Subscription-based gaming platform  with tables players, plans, games, genres, and sessions. Main query analyzes player activity, uses join to connect tables.

- plans: subscription plans (basic / standard / premium)
- players: registered users with country and plan
- genres: game genres (shooter, rpg, racing, strategy)
- games: game catalog with release year and genre
- sessions: play sessions with date and hours played
- CTE (player_stats) aggregates total hours and session count per player
- 5 tables players, plans, sessions, games, genres
- 'where filters' players with more than 5 total hours played
- 'group by' groups results by player, country, plan and genre
- 'order by' sorts total hours desc

For each active player query returns:

- username and country
- subscription plan name
- hours spent per game genre
- total hours and total session count across all games

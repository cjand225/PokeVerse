DB_NAME = pokeverse

.PHONY: create_db drop_db

create_db:
	createdb $(DB_NAME)
	psql $(DB_NAME) < ./database/Pokedex.sql
	psql $(DB_NAME) < $(CURDIR)/data/baseData.sql
	psql $(DB_NAME) < $(CURDIR)/data/nameData.sql
	psql $(DB_NAME) < $(CURDIR)/data/baseStatData.sql
	psql $(DB_NAME) < $(CURDIR)/data/typeData.sql

drop_db:
	dropdb $(DB_NAME)

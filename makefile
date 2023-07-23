DB_NAME = pokeverse
DB_ARGS = -v ON_ERROR_STOP=1

.PHONY: create_db drop_db

create_db:
	set -e; \
	createdb $(DB_NAME) --encoding='UTF8' --lc-collate='en_CA' --lc-ctype='en_CA' --template=template0; \
	psql $(DB_ARGS) -d $(DB_NAME) -f $(CURDIR)/database/Pokedex.sql; \
	psql $(DB_ARGS) -d $(DB_NAME) -f $(CURDIR)/data/baseData.sql; \
	psql $(DB_ARGS) -d $(DB_NAME) -f $(CURDIR)/data/nameData.sql; \
	psql $(DB_ARGS) -d $(DB_NAME) -f $(CURDIR)/data/baseStatData.sql; \
	psql $(DB_ARGS) -d $(DB_NAME) -f $(CURDIR)/data/typeData.sql;

drop_db:
	dropdb $(DB_NAME)

test_db:
	psql $(DB_ARGS) -d $(DB_NAME) -f $(CURDIR)/tests/testPokedex.sql

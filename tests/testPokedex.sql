-- Create Extension before runnning tests.
SET search_path = translation, pokedex, public;
CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

-- Set the amount of tests to run.
SELECT plan(74);

-- Test for the existence of the Pokedex Schema.
SELECT schemas_are(ARRAY[ 'public', 'pokedex', 'translation' ]);

-- Test for the existence of the Pokedex Schema tables.
SELECT tables_are(
    'pokedex', 
    ARRAY[ 'types', 'pokemon', 'names', 'basestats']
);

-- Tests for Pokdex.types table.
SELECT has_column( 'pokedex', 'types', 'id' , 'Id exists in the Pokdex.types table');
SELECT has_column( 'pokedex', 'types', 'lang' , 'lang exists in the Pokdex.types table');
SELECT has_column( 'pokedex', 'types', 'description', 'description exists in the Pokdex.types table');
SELECT has_pk( 'pokedex', 'types', 'primary key exists in Pokdex.Types table' );
SELECT col_is_pk( 'pokedex', 'types', ARRAY['id', 'lang'], 'cols ID/lang exists as primary key in Pokdex.Types table' );

-- Tests for Pokdex.Pokemon table.
SELECT has_column( 'pokedex', 'pokemon', 'id', 'id exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'type', 'type exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'height', 'height exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'weight', 'weight exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'generation', 'generation exists in the Pokdex.Pokemon table');
SELECT has_pk( 'pokedex', 'pokemon', 'primary key exists in Pokdex.Pokemon table' );
SELECT col_is_pk( 'pokedex', 'pokemon', 'id', 'col ID exists as primary key in Pokdex.Pokemon table' );

-- Tests for Pokdex.Names table.
SELECT has_column( 'pokedex', 'names', 'id', 'id exists in the Pokdex.Names table');
SELECT has_column( 'pokedex', 'names', 'lang', 'lang exists in the Pokdex.Names table');
SELECT has_column( 'pokedex', 'names', 'name', 'name exists in the Pokdex.Names table');
SELECT has_pk( 'pokedex', 'names', 'primary key exists in Pokdex.Names table' );
SELECT col_is_pk( 'pokedex', 'names', ARRAY['id', 'lang'], 'cols ID/lang exists as primary key in Pokdex.Names table' );
SELECT col_is_fk( 'pokedex', 'names', 'id', 'col ID exists as foriegn key in Pokdex.Names table' );

-- Tests for Pokdex.baseStats table.
SELECT has_column( 'pokedex', 'basestats', 'id', 'id exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'hp', 'hp exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'attack', 'attack exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'defense', 'defense exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'specialattack', 'specialAttack exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'specialdefense', 'specialDefense exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'speed', 'speed exists in the Pokdex.baseStats table');
SELECT has_pk( 'pokedex', 'basestats', 'primary key exists in Pokdex.baseStats table' );
SELECT col_is_pk( 'pokedex', 'basestats', 'id', 'col ID exists as primary key in Pokdex.baseStats table' );
SELECT col_is_fk( 'pokedex', 'basestats', 'id', 'col ID exists as foriegn key in Pokdex.baseStats table' );

-- Test for the existence of the Pokedex.PokeType enum.
SELECT enums_are('pokedex', ARRAY[ 'poketype' ]);

-- Tests Pokedex.insertType procedure.
SELECT has_function(
    'pokedex', 
    'inserttype',
    ARRAY['int', 'varchar', 'text']
);

-- Setup
CALL Pokedex.insertType(1, 'en', 'Normal');
CALL Pokedex.insertType(1, 'ja', 'ノーマル');

-- Cases for normal insertion
SELECT is( (SELECT count(*) FROM Pokedex.Types WHERE id = '1' AND lang = 'en')::INT, 1, 'Type Inserted.' );
SELECT is( (SELECT count(*) FROM Pokedex.Types WHERE id = '1' AND lang = 'ja')::INT, 1, 'Type Inserted.' );

-- Cases for null insertion
SELECT throws_ok( 'CALL Pokedex.insertType(1, "en", NULL);' );
SELECT throws_ok( 'CALL Pokedex.insertType(1, NULL, NULL);' );
SELECT throws_ok( 'CALL Pokedex.insertType(NULL, NULL, NULL);' );

-- Cases for invalid insertion
SELECT throws_ok( 'CALL Pokedex.insertType("", "", "");' );
SELECT throws_ok( 'CALL Pokedex.insertType(-1, "", "");' );
SELECT throws_ok( 'CALL Pokedex.insertType(1, "cy", "");' );
SELECT throws_ok( 'CALL Pokedex.insertType(1, "cy", "Normal");' );


-- Tests for Pokedex.insertBaseEntry procedure.
-- SELECT has_function(
--     'pokedex', 
--     'insertbaseentry',
--     ARRAY['int', 'text[]', 'int', 'int', 'int']
-- );

-- Setup
CALL Pokedex.insertBaseEntry(1, ARRAY['Grass', 'Poison'], 70, 6900, 1);
CALL Pokedex.insertBaseEntry(4, ARRAY['Fire'], 60, 8500, 1);

-- Cases for normal insertion
SELECT is( (SELECT count(*) FROM Pokedex.Pokemon WHERE id = '1')::INT, 1, 'Base entry Inserted.' );
SELECT is( (SELECT count(*) FROM Pokedex.Pokemon WHERE id = '4')::INT, 1, 'Base entry Inserted. ');

-- Cases for null insertion
SELECT throws_ok( 'CALL Pokedex.insertBaseEntry(5, ARRAY["Grass", "Poison"], 70, 6900, NULL)');
SELECT throws_ok( 'CALL Pokedex.insertBaseEntry(6, NULL, 70, 6900, NULL)' );
SELECT throws_ok( 'CALL Pokedex.insertBaseEntry(2, NULL, 70, 6900, NULL)' );
SELECT throws_ok( 'CALL Pokedex.insertBaseEntry(2, NULL, 70, NULL, NULL)' );
SELECT throws_ok( 'CALL Pokedex.insertBaseEntry(NULL, NULL, NULL, NULL, NULL)' );


-- Cases for invalid insertion
SELECT throws_ok( 'CALL Pokedex.insertBaseEntry(5, ARRAY[], 70, 6900, 1)' );


-- Tests for Pokedex.insertName procedure.
SELECT has_function(
    'pokedex', 
    'insertname',
    ARRAY['int', 'varchar', 'text']
);

-- Setup
CALL Translation.insertSupportedLanguage('en');
CALL Translation.insertSupportedLanguage('ja');
CALL Pokedex.insertName(1, 'en', 'Bulbasaur');
CALL Pokedex.insertName(1, 'ja', 'フシギダネ');

-- Case for normal insertion
SELECT is( (SELECT count(*) FROM Pokedex.Names WHERE id = '1' AND lang = 'en')::INT, 1, 'Correct en name Inserted.' );
SELECT is( (SELECT count(*) FROM Pokedex.Names WHERE id = '1' AND lang = 'ja')::INT, 1, 'Correct ja name Inserted.' );

-- Case for null insertion
SELECT throws_ok( 'CALL Pokedex.insertName(1, NULL, NULL)' );
SELECT throws_ok( 'CALL Pokedex.insertName(1, "fr", NULL)' );
SELECT throws_ok( 'CALL Pokedex.insertName(NULL, NULL, NULL)' );

-- Case for invalid/duplicate insertion
SELECT throws_ok( 'CALL Pokedex.insertName(1, "en", "Bulbasaur")' );
SELECT throws_ok( 'CALL Pokedex.insertName(-12, "en", "Bulbasaur")' );


-- Tests for Pokedex.insertBaseStats procedure.
SELECT has_function(
    'pokedex', 
    'insertbasestats',
    ARRAY['int', 'int', 'int', 'int', 'int', 'int', 'int']
);

-- Setup
CALL Pokedex.insertBaseStats(1, 45, 49, 49, 65, 65, 45);
CALL Pokedex.insertBaseEntry(2, ARRAY['Grass', 'Poison'], 100, 13000, 1);
CALL Pokedex.insertBaseStats(2, 60, 62, 63, 80, 80, 60);

-- Cases for normal insertion
SELECT is( (SELECT count(*) FROM Pokedex.BaseStats WHERE id = '1')::INT, 1, 'Base stats Inserted.' );
SELECT is( (SELECT count(*) FROM Pokedex.BaseStats WHERE id = '2')::INT, 1, 'Base stats Inserted.' );

-- Cases for null insertion
SELECT throws_ok( 'CALL Pokedex.insertBaseStats(1, NULL, NULL, NULL, NULL, NULL, NULL)' );
SELECT throws_ok( 'CALL Pokedex.insertBaseStats(NULL, NULL, NULL, NULL, NULL, NULL, NULL)' );


-- Cases for invalid insertion
SELECT throws_ok( 'CALL Pokedex.insertBaseStats(-1, NULL, NULL, NULL, NULL, NULL, NULL)' );


-- Tests for Pokedex.getPokeTypeIndex function.
SELECT has_function(
    'pokedex', 
    'getpoketypeindex',
    ARRAY['poketype']
);

-- Setup

-- Cases for normal retrieval
SELECT is( (SELECT Pokedex.getPokeTypeIndex('Normal'::Pokedex.pokeType)), 1, 'Type Index Retrieved.' );
SELECT is( (SELECT Pokedex.getPokeTypeIndex('Electric'::Pokedex.pokeType)), 13, 'Type Index Retrieved.' );

-- Cases for null retrieval
SELECT throws_ok( 'CALL Pokedex.getPokeTypeIndex(NULL)' );

-- Cases for invalid retrieval
SELECT throws_ok( 'CALL Pokedex.getPokeTypeIndex("Fantasy")' );

-- Tests for Pokedex.getName function.
SELECT has_function(
    'pokedex', 
    'getname',
    ARRAY['int', 'varchar']
);

-- Setup
CALL Pokedex.insertName('2', 'en', 'Ivysaur');

-- Cases for normal retrieval
SELECT is( (SELECT Pokedex.getName(2, 'en')), 'Ivysaur', 'Name Retrieved' );

-- Cases for null retrieval
SELECT throws_ok( 'CALL Pokedex.getName(NULL, NULL)' );

-- Cases for invalid retrieval
SELECT throws_ok( 'CALL Pokedex.getName(2, "cy")' );

-- Tests for Pokedex.getTypes function.
SELECT has_function(
    'pokedex', 
    'gettypes',
    ARRAY['int', 'varchar']
);

-- Setup
SELECT Pokedex.getTypes(1, 'en');

-- Cases for normal retrieval

-- Cases for null retrieval

-- Cases for invalid retrieval


-- Tests for Pokedex.getPokemon function.
SELECT has_function(
    'pokedex', 
    'getpokemon',
    ARRAY['int', 'varchar']
);

-- Setup

-- Cases for normal retrieval

-- Cases for null retrieval

-- Cases for invalid retrieval


-- Conclude tests.
SELECT * FROM finish();
ROLLBACK;

-- Remove Extension after testing finished.
DROP EXTENSION IF EXISTS pgtap;

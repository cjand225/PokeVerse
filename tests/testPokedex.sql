-- Create Extension before runnning tests.
SET search_path = Pokedex, public;
CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

-- Set the amount of tests to run.
SELECT plan(38);

-- Test for the existence of the Pokedex Schema.
SELECT schemas_are(ARRAY[ 'public', 'pokedex' ]);

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

-- Tests Pokedex.insertType function.
SELECT has_function(
    'pokedex', 
    'inserttype',
    ARRAY['int', 'varchar', 'text']
);

-- Tests for Pokedex.insertBaseEntry function.
SELECT has_function(
    'pokedex', 
    'insertbaseentry',
    ARRAY['int', 'text[]', 'int', 'int', 'int']
);

-- Tests for Pokedex.insertName function.
SELECT has_function(
    'pokedex', 
    'insertname',
    ARRAY['int', 'varchar', 'text']
);

-- Tests for Pokedex.insertBaseStats function.
SELECT has_function(
    'pokedex', 
    'insertbasestats',
    ARRAY['int', 'int', 'int', 'int', 'int', 'int', 'int']
);

-- Tests for Pokedex.getPokeTypeIndex function.
SELECT has_function(
    'pokedex', 
    'getpoketypeindex',
    ARRAY['poketype']
);

-- Tests for Pokedex.getName function.
SELECT has_function(
    'pokedex', 
    'getname',
    ARRAY['int', 'varchar']
);

-- Tests for Pokedex.getTypes function.
SELECT has_function(
    'pokedex', 
    'gettypes',
    ARRAY['int', 'varchar']
);

-- Conclude tests.
SELECT * FROM finish();
ROLLBACK;

-- Remove Extension after testing finished.
DROP EXTENSION IF EXISTS pgtap;

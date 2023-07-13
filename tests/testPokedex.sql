-- Create Extension before runnning tests.
SET search_path = Pokedex, public;
CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

-- Set the amount of tests to run.
SELECT plan(28);

-- Test for the existence of the Pokedex Schema.
SELECT schemas_are(ARRAY[ 'public', 'pokedex' ]);

-- Test for the existence of the Pokedex Schema tables.
SELECT tables_are(
    'pokedex', 
    ARRAY[ 'types', 'pokemon', 'names', 'basestats']
);

-- Test for existance of columns in Pokdex.types table.
SELECT has_column( 'pokedex', 'types', 'id' , 'Id exists in the Pokdex.types table');
SELECT has_column( 'pokedex', 'types', 'lang' , 'lang exists in the Pokdex.types table');
SELECT has_column( 'pokedex', 'types', 'description', 'description exists in the Pokdex.types table');


-- Test for existance of columns in Pokdex.Pokemon table.
SELECT has_column( 'pokedex', 'pokemon', 'id', 'id exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'type', 'type exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'height', 'height exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'weight', 'weight exists in the Pokdex.Pokemon table');
SELECT has_column( 'pokedex', 'pokemon', 'generation', 'generation exists in the Pokdex.Pokemon table');

-- Test for existance of columns in Pokdex.Names table.
SELECT has_column( 'pokedex', 'names', 'id', 'id exists in the Pokdex.Names table');
SELECT has_column( 'pokedex', 'names', 'lang', 'lang exists in the Pokdex.Names table');
SELECT has_column( 'pokedex', 'names', 'name', 'name exists in the Pokdex.Names table');

-- Test for existance of columns in Pokdex.baseStats table.
SELECT has_column( 'pokedex', 'basestats', 'id', 'id exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'hp', 'hp exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'attack', 'attack exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'defense', 'defense exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'specialattack', 'specialAttack exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'specialdefense', 'specialDefense exists in the Pokdex.baseStats table');
SELECT has_column( 'pokedex', 'basestats', 'speed', 'speed exists in the Pokdex.baseStats table');


-- Test for the existence of the Pokedex.PokeType enum.
SELECT enums_are('pokedex', ARRAY[ 'poketype' ]);

-- Test for the existance of Pokedex.insertType function.
SELECT has_function(
    'pokedex', 
    'inserttype',
    ARRAY['int', 'varchar', 'text']
);

-- Test for the existance of Pokedex.insertBaseEntry function.
SELECT has_function(
    'pokedex', 
    'insertbaseentry',
    ARRAY['int', 'text[]', 'int', 'int', 'int']
);

-- Test for the existance of Pokedex.insertName function.
SELECT has_function(
    'pokedex', 
    'insertname',
    ARRAY['int', 'varchar', 'text']
);

-- Test for the existance of Pokedex.insertBaseStats function.
SELECT has_function(
    'pokedex', 
    'insertbasestats',
    ARRAY['int', 'int', 'int', 'int', 'int', 'int', 'int']
);

-- Test for the existance of Pokedex.getPokeTypeIndex function.
SELECT has_function(
    'pokedex', 
    'getpoketypeindex',
    ARRAY['poketype']
);

-- Test for the existance of Pokedex.getName function.
SELECT has_function(
    'pokedex', 
    'getname',
    ARRAY['int', 'varchar']
);

-- Test for the existance of Pokedex.getTypes function.
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

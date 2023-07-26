-- Create Extension before runnning tests.
SET search_path = translation, pokedex, public;
CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;
-- Set the amount of tests to run.
SELECT plan(28);

-- Test for the existence of the Pokedex Schema.
SELECT schemas_are(ARRAY[ 'public', 'translation', 'pokedex' ]);

-- Test for the existence of the Translation Schema tables.
SELECT tables_are(
    'translation', 
    ARRAY[ 'supportedlanguages', 'keytranslations' ]
);

-- Tests for Translation.SupportedLanguages table.
SELECT has_column( 'translation', 'supportedlanguages', 'langcode' , 'langCode exists in the Translation.KeyTranslations table');
SELECT has_pk( 'translation', 'supportedlanguages', 'primary key exists in Translation.KeyTranslations table' );
SELECT col_is_pk( 'translation', 'supportedlanguages', 'langcode', 'col langCode exists as primary key in Translation.KeyTranslations table' );

-- Tests for Translation.KeyTranslations table.
SELECT has_column( 'translation', 'keytranslations', 'keyname' , 'keyName exists in the Translation.KeyTranslations table');
SELECT has_column( 'translation', 'keytranslations', 'lang' , 'lang exists in the Translation.KeyTranslations table');
SELECT has_column( 'translation', 'keytranslations', 'translation', 'translation exists in the Translation.KeyTranslations table');
SELECT has_pk( 'translation', 'keytranslations', 'primary key exists in Translation.KeyTranslations table' );
SELECT col_is_pk( 'translation', 'keytranslations', ARRAY['keyname', 'lang'], 'cols keyName/lang exists as primary key in Translation.KeyTranslations table' );


-- Tests Translation.insertSupportedLanguage procedure.
SELECT has_function(
    'translation', 
    'insertsupportedlanguage',
    ARRAY['varchar']
);

-- Setup
CALL Translation.insertSupportedLanguage('en');

-- Case for regular insertion
SELECT is((SELECT count(*) FROM Translation.SupportedLanguages)::INT, 1, 'One supported language inserted.');

-- Case for null insertion
SELECT throws_ok( 'CALL Translation.insertSupportedLanguage(NULL)' );

-- Case for duplicate insertion
SELECT throws_ok( 'CALL Translation.insertSupportedLanguage("en")' );


-- Tests Translation.insertTranslation procedure.
SELECT has_function(
    'translation', 
    'inserttranslation',
    ARRAY['text', 'varchar', 'text']
);

-- Setup
CALL Translation.insertSupportedLanguage('fr');
CALL Translation.insertSupportedLanguage('ja');
CALL Translation.insertTranslation('id', 'ja', '識別ID');
CALL Translation.insertTranslation('id', 'fr', 'Identifiant');

-- Case for regular insertion
SELECT is((SELECT count(*) FROM Translation.KeyTranslations WHERE keyName = 'id' and lang = 'fr')::INT, 1, 'Translation Inserted.');
SELECT is((SELECT count(*) FROM Translation.KeyTranslations WHERE keyName = 'id' and lang = 'ja')::INT, 1, 'Translation Inserted.');

-- Cases for null insertion
SELECT throws_ok( 'CALL Translation.insertTranslation(NULL, NULL)' );
SELECT throws_ok( 'CALL Translation.insertTranslation("NULL", "en")' );
SELECT throws_ok( 'CALL Translation.insertTranslation("id", NULL)' );

-- Cases for invalid insertion
SELECT throws_ok( 'CALL Translation.insertTranslation("id", "cy")' );


-- Tests Translation.getKeyTranslation function.
SELECT has_function(
    'translation', 
    'getkeytranslation',
    ARRAY['text', 'varchar']
);

-- Cases for regular retrieval
SELECT is((Translation.getKeyTranslation('id'::TEXT, 'fr'::VARCHAR(2))), 'Identifiant', 'Translation retrieved.');
SELECT is((Translation.getKeyTranslation('id'::TEXT, 'ja'::VARCHAR(2))), '識別ID', 'Translation retrieved.');

-- Cases for null retrieval
SELECT throws_ok( 'CALL Translation.getKeyTranslation("id", NULL)' );
SELECT throws_ok( 'CALL Translation.getKeyTranslation(NULL, "en")' );
SELECT throws_ok( 'CALL Translation.getKeyTranslation(NULL, NULL)' );

-- Cases for invalid retrieval
SELECT throws_ok( 'CALL Translation.getKeyTranslation("id", "cy")' );


-- Conclude tests.
SELECT * FROM finish();
ROLLBACK;

-- Remove Extension after testing finished.
DROP EXTENSION IF EXISTS pgtap;

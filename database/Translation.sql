-- File: Translation.sql
CREATE SCHEMA Translation;

-- Create the Supported Languages table
CREATE TABLE Translation.SupportedLanguages (
    langCode VARCHAR(2) PRIMARY KEY
);

-- Create the Translations table
CREATE TABLE Translation.KeyTranslations (
    keyName TEXT,
    lang VARCHAR(2),
    translation TEXT, 
    PRIMARY KEY (keyName, lang)
);

-- Used to insert a new language code into the SupportedLanguages table. 
CREATE OR REPLACE PROCEDURE Translation.insertSupportedLanguage(
    pLangCode VARCHAR(2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF pLangCode IS NULL THEN
        RAISE EXCEPTION 'The language code cannot be null.';
    END IF;

    -- Check if the language code already exists in the SupportedLanguages table
    IF EXISTS (SELECT 1 FROM Translation.SupportedLanguages WHERE langCode = pLangCode) THEN
        RAISE EXCEPTION 'Language code % already exists in the SupportedLanguages table.', pLangCode;
    END IF;

    INSERT INTO Translation.SupportedLanguages (langCode)
    VALUES (pLangCode);
END;
$$;

-- Used to insert translations for keys into the Translation.KeyTranslations table. 
-- The Translation.KeyTranslations table stores translations for different keys in various languages.
CREATE OR REPLACE PROCEDURE Translation.insertTranslation(
    pKeyName TEXT,
    pLang VARCHAR(2),
    pTranslation TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF pKeyName IS NULL THEN
        RAISE EXCEPTION 'The key name cannot be null.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Translation.SupportedLanguages WHERE SupportedLanguages.langCode = pLang) THEN
        RAISE EXCEPTION 'The language: % is current unsupported.', pLang;
    END IF;

    IF pTranslation IS NULL THEN
        RAISE EXCEPTION 'The translation cannot be null.';
    END IF;

    INSERT INTO Translation.KeyTranslations (keyName, lang, translation)
    VALUES (pKeyName, pLang, pTranslation);
END;
$$;

-- Retrieves the translated key of a specific key provided.
CREATE OR REPLACE FUNCTION Translation.getKeyTranslation(
    pKeyName TEXT, 
    pLang VARCHAR(2)
) 
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    translationValue TEXT;
BEGIN
    -- Validation checks
    IF pKeyName IS NULL THEN
        RAISE EXCEPTION 'The key name cannot be null.';
    END IF;

    IF pLang IS NULL THEN
        RAISE EXCEPTION 'The language code cannot be null.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Translation.SupportedLanguages WHERE langCode = pLang) THEN
        RAISE EXCEPTION 'The language: % is currently unsupported', pLang;
    END IF;

    -- Retrieve the translation based on keyName and lang
    SELECT translation
    INTO translationValue
    FROM Translation.KeyTranslations
    WHERE KeyTranslations.keyName = pKeyName AND KeyTranslations.lang = pLang;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Translation not found for key: %, language: %', pKeyName, pLang;
    END IF;

    RETURN translationValue;
END;
$$;

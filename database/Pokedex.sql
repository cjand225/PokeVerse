-- File: Pokemon.sql

CREATE SCHEMA Pokedex;

CREATE TYPE Pokedex.pokeType AS ENUM (
    'Normal',
    'Fire',
    'Water',
    'Electric',
    'Grass',
    'Ice',
    'Fighting',
    'Poison',
    'Ground',
    'Flying',
    'Psychic',
    'Bug',
    'Rock',
    'Ghost',
    'Dragon',
    'Dark',
    'Steel',
    'Fairy'
);

-- Create the Pokemon table
CREATE TABLE Pokedex.Pokemon (
    id INT PRIMARY KEY,
    type Pokedex.pokeType[] DEFAULT NULL,
    height INT DEFAULT NULL, -- cm
    weight INT DEFAULT NULL, -- g
    generation INT DEFAULT NULL
);

-- Create the Names table
CREATE TABLE Pokedex.Names (
    id INT,
    lang VARCHAR(2),
    name TEXT, 
    PRIMARY KEY (id, lang),
    FOREIGN KEY (id) REFERENCES Pokedex.Pokemon (id)
);

-- Create the Base Stats table
CREATE TABLE Pokedex.BaseStats (
    id INT PRIMARY KEY,
    hp INT,
    attack INT,
    defense INT,
    specialAttack INT,
    specialDefense INT,
    speed INT,
    FOREIGN KEY (id) REFERENCES Pokedex.Pokemon (id)
);

-- Create the Gender Ratio table
CREATE TABLE Pokedex.GenderRatio (
    id INT PRIMARY KEY,
    male DECIMAL,
    female DECIMAL,
    hasNoGender BOOLEAN,
    FOREIGN KEY (id) REFERENCES Pokedex.Pokemon (id)
);

-- Create the insertion pokemon function
CREATE OR REPLACE FUNCTION insertBaseEntry(
    pId INT,
    pType text[],
    pHeight INT,
    pWeight INT,
    pGeneration INT
) RETURNS VOID AS $$
DECLARE
    pPokeType Pokedex.PokeType[];
BEGIN
    -- Perform Validation Checks
    IF pId IS NULL THEN
        RAISE EXCEPTION 'The ID cannot be null.';
    END IF;

    IF pId IS NOT NULL AND pId < 0 THEN
        RAISE EXCEPTION 'The ID cannot be less than zero.';
    END IF;

    IF pHeight IS NOT NULL AND pHeight < 0 THEN
        RAISE EXCEPTION 'The height cannot be less than zero.';
    END IF;

    IF pWeight IS NOT NULL AND pWeight < 0 THEN
        RAISE EXCEPTION 'The weight cannot be less than zero.';
    END IF;

    IF pGeneration < 1 OR pGeneration > 10 THEN
        RAISE EXCEPTION 'The generation must be between one and eight.';
    END IF;

    -- Convert text[] to Pokedex.PokeType[]
    SELECT ARRAY(SELECT p::Pokedex.PokeType FROM UNNEST(pType) p) INTO pPokeType;

    -- Insert into the Pokemon table
    INSERT INTO Pokedex.Pokemon (id, type, height, weight, generation)
    VALUES (pId, pPokeType, pHeight, pWeight, pGeneration);
END;
$$ LANGUAGE plpgsql;

-- Create the insertion name function
CREATE OR REPLACE FUNCTION insertName(
    pId INT,
    pLang VARCHAR(2),
    pName TEXT
) RETURNS VOID AS $$
BEGIN
    -- Check for NULL values
    IF pName IS NULL THEN
        RAISE EXCEPTION 'The name cannot be null.';
    END IF;

    -- Check if the ID exists in Pokemon table
    IF NOT EXISTS (SELECT 1 FROM Pokedex.Pokemon WHERE id = pId) THEN
        RAISE EXCEPTION 'The provided ID does not exist in the Pokemon table.';
    END IF;

    -- Insert into the Names table
    INSERT INTO Pokedex.Names (id, lang, name)
    VALUES (pId, pLang, pName);
END;
$$ LANGUAGE plpgsql;

-- Create the insertion base stats function
CREATE OR REPLACE FUNCTION insertBaseStats(
    pId INT,
    pHp INT,
    pAttack INT,
    pDefense INT,
    pSpecialAttack INT,
    pSpecialDefense INT,
    pSpeed INT
) RETURNS VOID AS $$
BEGIN
    -- Perform validation checks
    IF pId IS NULL THEN
        RAISE EXCEPTION 'The ID cannot be null.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Pokedex.Pokemon WHERE id = pId) THEN
        RAISE EXCEPTION 'The ID does not exist in the Pokemon table.';
    END IF;

    IF pHp < 1 OR pHp > 255 THEN
        RAISE EXCEPTION 'The HP value must be between 1 and 255 (inclusive).';
    END IF;

    IF pAttack < 1 OR pAttack > 255 THEN
        RAISE EXCEPTION 'The Attack value must be between 1 and 255 (inclusive).';
    END IF;

    IF pDefense < 1 OR pDefense > 255 THEN
        RAISE EXCEPTION 'The Defense value must be between 1 and 255 (inclusive).';
    END IF;

    IF pSpecialAttack < 1 OR pSpecialAttack > 255 THEN
        RAISE EXCEPTION 'The Special Attack value must be between 1 and 255 (inclusive).';
    END IF;

    IF pSpecialDefense < 1 OR pSpecialDefense > 255 THEN
        RAISE EXCEPTION 'The Special Defense value must be between 1 and 255 (inclusive).';
    END IF;

    IF pSpeed < 1 OR pSpeed > 255 THEN
        RAISE EXCEPTION 'The Speed value must be between 1 and 255 (inclusive).';
    END IF;

    -- Insert the data into the BaseStats table
    INSERT INTO Pokedex.BaseStats (id, hp, attack, defense, specialAttack, specialDefense, speed)
    VALUES (pId, pHp, pAttack, pDefense, pSpecialAttack, pSpecialDefense, pSpeed);
END;
$$ LANGUAGE plpgsql;

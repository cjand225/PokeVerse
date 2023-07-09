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
CREATE OR REPLACE FUNCTION insertPokemon(
    pId INT,
    pType Pokedex.poketype[],
    pHeight INT,
    pWeight INT,
    pGeneration INT
) RETURNS VOID AS $$
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

    IF pGeneration IS NOT NULL AND pGeneration < 1 OR pGeneration > 8 THEN
        RAISE EXCEPTION 'The generation cannot exceed the bounds between one and eight.';
    END IF;


    INSERT INTO Pokedex.Pokemon (id, type, height, weight, generation)
    VALUES (pId, pType, pHeight, pWeight, pGeneration);
END;
$$ LANGUAGE plpgsql;

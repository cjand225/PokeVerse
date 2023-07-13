-- File: Pokemon.sql

CREATE SCHEMA Pokedex;

-- Create the 1-1 Generic Types to Enum pokeType
CREATE TYPE Pokedex.pokeType AS ENUM (
    'Normal',
    'Fighting',
    'Flying',
    'Poison',
    'Ground',
    'Rock',
    'Bug',
    'Ghost',
    'Steel',
    'Fire',
    'Water',
    'Grass',
    'Electric',
    'Psychic',
    'Ice',
    'Dragon',
    'Dark',
    'Fairy'
);

-- Create the Types table
CREATE TABLE Pokedex.Types (
    id INT,
    lang VARCHAR(2) NOT NULL,
    description TEXT NOT NULL,
    PRIMARY KEY (id, lang)
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

-- Create the insertType function
CREATE OR REPLACE FUNCTION Pokedex.insertType(
  pId INT,
  pLang VARCHAR(2),
  pDescription TEXT
) RETURNS VOID AS $$
BEGIN
  -- Check if the record already exists in the table
  IF EXISTS (SELECT 1 FROM Pokedex.Types WHERE id = pId AND lang = pLang) THEN
    RAISE EXCEPTION 'Type with ID % and Lang % already exists.', pokeType, pLang;
  END IF;

  -- Insert the new type into the table
  INSERT INTO Pokedex.Types (id, lang, description)
  VALUES (pId, pLang, pDescription);
END;
$$ LANGUAGE plpgsql;


-- Create the insertion pokemon function
CREATE OR REPLACE FUNCTION Pokedex.insertBaseEntry(
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
CREATE OR REPLACE FUNCTION Pokedex.insertName(
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
CREATE OR REPLACE FUNCTION Pokedex.insertBaseStats(
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

-- Retrieves the index of the PokeType Enum provided.
CREATE OR REPLACE FUNCTION Pokedex.getPokeTypeIndex(
    pokeTypeValue Pokedex.pokeType
) RETURNS INTEGER AS $$
DECLARE
  position INTEGER;
BEGIN
  position := (
    SELECT array_position(enum_range(null::Pokedex.pokeType), pokeTypeValue)
  );
  RETURN position;
END;
$$ LANGUAGE plpgsql;

-- Retrieves the translated name of a Pokémon based on the provided Pokémon ID and language code.
CREATE OR REPLACE FUNCTION Pokedex.getTranslatedName(
    pId INT, 
    pLang VARCHAR(2)
) RETURNS TEXT AS $$
DECLARE
  translatedName TEXT;
BEGIN
    SELECT name INTO translatedName
    FROM Pokedex.Names
    WHERE id = pId AND lang = pLang
    LIMIT 1;
    RETURN translatedName;
END;
$$ LANGUAGE plpgsql;
 
-- Retrieves the translated types of a Pokémon based on the provided Pokémon ID and language code.
CREATE OR REPLACE FUNCTION Pokedex.getTranslatedTypes(
    pId INT, 
    pLang VARCHAR(2)
) RETURNS TEXT[]
AS $$
DECLARE
    typeArray Pokedex.PokeType[];
    intArray INTEGER[];
    i INT;
    descriptionArray TEXT[];
BEGIN
    -- Retrieve the type array for the specified Pokemon ID
    SELECT type INTO typeArray
    FROM Pokedex.Pokemon
    WHERE id = pId;

    -- Convert the type array to an array of integers using the getPokeTypeIndex function
    FOR i IN 1..array_length(typeArray, 1)
    LOOP
        intArray[i] := Pokedex.getPokeTypeIndex(typeArray[i]);
    END LOOP;

    -- Retrieve the translated type descriptions for the specified language and converted type array
    SELECT array_agg(t.description) INTO descriptionArray
    FROM Pokedex.Types t
    WHERE t.id = ANY(intArray) AND t.lang = pLang;

    -- Return the array of translated type descriptions
    RETURN descriptionArray;
END;
$$ LANGUAGE plpgsql;

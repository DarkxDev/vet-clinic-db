/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name = 'Luna';

/* Vet Clinic */

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* NEW TRANSACTION */

BEGIN;

UPDATE animals SET species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;

/* NEW TRANSACTION */

BEGIN;

UPDATE animals SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;

SELECT * FROM animals ORDER BY id;

/* NEW TRANSACTION */

BEGIN;

DELETE FROM animals;

SELECT * FROM animals ORDER BY id;

ROLLBACK;

SELECT * FROM animals ORDER BY id;

/* NEW TRANSACTION */

BEGIN;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT my_savepoint;

SELECT * FROM animals

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1;

SELECT * FROM animals;

ROLLBACK TO my_savepoint;

SELECT * FROM animals;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

SELECT * FROM animals;

COMMIT;

/* Answers */

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals
  WHERE date_of_birth BETWEEN '1990-01-01' AND '2001-01-01'
  GROUP BY species;

/* Multiple Tables */

SELECT animals.name FROM animals
  JOIN owners ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Melody Pond';

SELECT name
FROM animals
JOIN (
  SELECT id
  FROM species
  WHERE name = 'Pokemon'
) AS pokemon ON animals.species_id = pokemon.id;

SELECT owners.full_name, animals.name
  FROM owners
  LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(animals.id) FROM species
  LEFT JOIN animals ON species.id = animals.species_id
  GROUP BY species.name;

SELECT animals.name 
  FROM animals 
  JOIN species ON animals.species_id = species.id 
  JOIN owners ON animals.owner_id = owners.id 
  WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

SELECT animals.name 
  FROM animals 
  JOIN owners ON animals.owner_id = owners.id 
  WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.id) 
  FROM owners 
  LEFT JOIN animals ON owners.id = animals.owner_id 
  GROUP BY owners.full_name 
  ORDER BY COUNT(animals.id) DESC
  LIMIT 1;

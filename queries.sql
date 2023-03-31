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

/* Visits */

SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

SELECT COUNT(DISTINCT visits.animal_id)
FROM visits
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

SELECT vets.name, species.name AS specialization
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

SELECT animals.name
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.visit_date >= '2020-04-01' AND visits.visit_date <= '2020-08-30';

SELECT animals.name, COUNT(*) AS visit_count
FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY visit_count DESC
LIMIT 1;

SELECT animals.name, visits.visit_date
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.visit_date ASC
LIMIT 1;

SELECT animals.name AS animal_name, vets.name AS vet_name, visits.visit_date
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE visits.visit_date = (SELECT MAX(visit_date) FROM visits)
LIMIT 1;

SELECT COUNT(*)
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN specializations ON vets.id = specializations.vet_id
JOIN species ON specializations.species_id = species.id
WHERE species.name = 'Dog';

SELECT s.name AS species_name, COUNT(*) AS num_visits
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN specializations sp ON sp.species_id = a.species_id
JOIN species s ON s.id = sp.species_id
WHERE v.vet_id = 2 -- 2 is Maisy Smith's vet ID
GROUP BY s.name
ORDER BY num_visits DESC
LIMIT 1;

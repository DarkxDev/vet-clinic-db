/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    name varchar(100)
);

/* Vet Clinic */

CREATE DATABASE vet_clinic;
CREATE TABLE animals(
    id int primary key,
    name varchar,
    date_of_birth date,
    escape_attempts int,
    neutered bit,
    weight_kg decimal
);

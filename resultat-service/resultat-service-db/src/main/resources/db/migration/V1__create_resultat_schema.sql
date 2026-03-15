-- Resultat-service database schema

CREATE TABLE institusjon (
    id          VARCHAR(50) PRIMARY KEY,
    navn        VARCHAR(255) NOT NULL,
    kortnavn    VARCHAR(50),
    land        VARCHAR(2)   NOT NULL DEFAULT 'NO'
);

CREATE TABLE resultat (
    id            VARCHAR(50) PRIMARY KEY,
    kategori      VARCHAR(50)  NOT NULL,
    status        VARCHAR(50)  NOT NULL DEFAULT 'GYLDIG',
    utstedt_dato  DATE,
    person_id     VARCHAR(50)  NOT NULL,
    institusjon_id VARCHAR(50) NOT NULL REFERENCES institusjon(id)
);

CREATE TABLE grad (
    id          VARCHAR(50) PRIMARY KEY,
    tittel      VARCHAR(255) NOT NULL,
    nivaa       VARCHAR(50)  NOT NULL,
    resultat_id VARCHAR(50)  NOT NULL UNIQUE REFERENCES resultat(id)
);

CREATE TABLE emne (
    id           VARCHAR(50) PRIMARY KEY,
    emnekode     VARCHAR(50)  NOT NULL,
    emnenavn     VARCHAR(255) NOT NULL,
    karakter     VARCHAR(50)  NOT NULL,
    studiepoeng  INT          NOT NULL,
    dato         DATE,
    resultat_id  VARCHAR(50)  NOT NULL REFERENCES resultat(id)
);

CREATE INDEX idx_resultat_person ON resultat(person_id);
CREATE INDEX idx_emne_resultat ON emne(resultat_id);

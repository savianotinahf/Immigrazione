
CREATE DATABASE IF NOT EXISTS immigrazione_3nf;
USE immigrazione_3nf;

SET FOREIGN_KEY_CHECKS=0;

-- 1. Dimension: Paesi di origine
DROP TABLE IF EXISTS dim_paesi;
CREATE TABLE dim_paesi (
    id_paese INT AUTO_INCREMENT PRIMARY KEY,
    nome_paese VARCHAR(100) NOT NULL UNIQUE,
    regione_mondo VARCHAR(100),
    continente VARCHAR(50)
) ENGINE=InnoDB;

-- 2. Dimension: Regioni Italiane
DROP TABLE IF EXISTS dim_regioni_italia;
CREATE TABLE dim_regioni_italia (
    id_regione INT AUTO_INCREMENT PRIMARY KEY,
    nome_regione VARCHAR(100) NOT NULL UNIQUE,
    macroarea VARCHAR(50)
) ENGINE=InnoDB;

-- 3. Dimension: Tempi (Anni)
DROP TABLE IF EXISTS dim_tempi;
CREATE TABLE dim_tempi (
    anno INT PRIMARY KEY
) ENGINE=InnoDB;

-- 4. Dimension: Sesso
DROP TABLE IF EXISTS dim_sesso;
CREATE TABLE dim_sesso (
    id_sesso CHAR(1) PRIMARY KEY,
    descrizione VARCHAR(20)
) ENGINE=InnoDB;

-- 5. Fact: Flussi Migratori
DROP TABLE IF EXISTS fact_flussi_migratori;
CREATE TABLE fact_flussi_migratori (
    id_flusso INT AUTO_INCREMENT PRIMARY KEY,
    anno INT NOT NULL,
    id_paese INT NOT NULL,
    id_sesso CHAR(1) NOT NULL,
    num_migranti INT DEFAULT 0,
    FOREIGN KEY (anno) REFERENCES dim_tempi(anno) ON DELETE CASCADE,
    FOREIGN KEY (id_paese) REFERENCES dim_paesi(id_paese) ON DELETE CASCADE,
    FOREIGN KEY (id_sesso) REFERENCES dim_sesso(id_sesso) ON DELETE CASCADE,
    UNIQUE KEY (anno, id_paese, id_sesso)
) ENGINE=InnoDB;

-- 6. Fact: Dati Macroeconomici ISTAT
DROP TABLE IF EXISTS fact_economia_istat;
CREATE TABLE fact_economia_istat (
    id_istat INT AUTO_INCREMENT PRIMARY KEY,
    anno INT NOT NULL,
    id_paese INT NOT NULL,
    tasso_occupazione_perc DECIMAL(5,2),
    val_aggiunto_mln DECIMAL(10,2),
    occ_primario_perc DECIMAL(5,2),
    occ_secondario_perc DECIMAL(5,2),
    occ_terziario_perc DECIMAL(5,2),
    FOREIGN KEY (anno) REFERENCES dim_tempi(anno) ON DELETE CASCADE,
    FOREIGN KEY (id_paese) REFERENCES dim_paesi(id_paese) ON DELETE CASCADE,
    UNIQUE KEY (anno, id_paese)
) ENGINE=InnoDB;

-- 7. Fact: Dati Lavorativi INPS
DROP TABLE IF EXISTS fact_contributi_inps;
CREATE TABLE fact_contributi_inps (
    id_inps INT AUTO_INCREMENT PRIMARY KEY,
    anno INT NOT NULL,
    id_paese INT NOT NULL,
    lavoratori_attivi INT,
    stipendio_medio_annuo DECIMAL(10,2),
    contributi_versati_mln DECIMAL(10,2),
    pensionati INT,
    perc_impiego_domestico DECIMAL(5,2),
    FOREIGN KEY (anno) REFERENCES dim_tempi(anno) ON DELETE CASCADE,
    FOREIGN KEY (id_paese) REFERENCES dim_paesi(id_paese) ON DELETE CASCADE,
    UNIQUE KEY (anno, id_paese)
) ENGINE=InnoDB;

-- 8. Fact: Impatto Economico Regionale
DROP TABLE IF EXISTS fact_impatto_regionale;
CREATE TABLE fact_impatto_regionale (
    id_impatto INT AUTO_INCREMENT PRIMARY KEY,
    anno INT NOT NULL,
    id_regione INT NOT NULL,
    occupati_immigrati_k DECIMAL(8,2),
    pil_generato_mld DECIMAL(8,2),
    incidenza_pil_perc DECIMAL(5,2),
    fabbisogno_occupati INT,
    FOREIGN KEY (anno) REFERENCES dim_tempi(anno) ON DELETE CASCADE,
    FOREIGN KEY (id_regione) REFERENCES dim_regioni_italia(id_regione) ON DELETE CASCADE,
    UNIQUE KEY (anno, id_regione)
) ENGINE=InnoDB;

-- 9. Fact: Indicatori di Integrazione e Xenofobia
DROP TABLE IF EXISTS fact_integrazione_sociale;
CREATE TABLE fact_integrazione_sociale (
    id_integrazione INT AUTO_INCREMENT PRIMARY KEY,
    anno INT NOT NULL,
    id_regione INT NOT NULL,
    indice_ghettizzazione DECIMAL(5,2),
    tasso_scolarizzazione_perc DECIMAL(5,2),
    tasso_disoccupazione_immigrati DECIMAL(5,2),
    episodi_razzismo_segnalati INT,
    FOREIGN KEY (anno) REFERENCES dim_tempi(anno) ON DELETE CASCADE,
    FOREIGN KEY (id_regione) REFERENCES dim_regioni_italia(id_regione) ON DELETE CASCADE,
    UNIQUE KEY (anno, id_regione)
) ENGINE=InnoDB;

-- 10. Fact: Statistiche Criminalità ed Esclusione
DROP TABLE IF EXISTS fact_criminalita;
CREATE TABLE fact_criminalita (
    id_crimine INT AUTO_INCREMENT PRIMARY KEY,
    anno INT NOT NULL,
    id_regione INT NOT NULL,
    tasso_criminalita_generale DECIMAL(8,2),
    tasso_reati_immigrati DECIMAL(8,2),
    perc_reati_marginalizzazione DECIMAL(5,2),
    FOREIGN KEY (anno) REFERENCES dim_tempi(anno) ON DELETE CASCADE,
    FOREIGN KEY (id_regione) REFERENCES dim_regioni_italia(id_regione) ON DELETE CASCADE,
    UNIQUE KEY (anno, id_regione)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS=1;

INSERT INTO dim_paesi (id_paese, nome_paese, regione_mondo, continente) VALUES
(1, 'Albania', 'Southern Europe', 'Europe'),
(2, 'Bangladesh', 'Southern Asia', 'Asia'),
(3, 'China', 'Eastern Asia', 'Asia'),
(4, 'Morocco', 'Northern Africa', 'Africa'),
(5, 'Romania', 'Eastern Europe', 'Europe');

INSERT INTO dim_regioni_italia (id_regione, nome_regione, macroarea) VALUES
(1, 'Lombardia', 'Nord-Ovest'),
(2, 'Lazio', 'Centro'),
(3, 'Campania', 'Sud'),
(4, 'Emilia Romagna', 'Nord-Est'),
(5, 'Sicilia', 'Isole');

INSERT INTO dim_tempi (anno) VALUES
(2022),
(2023),
(2024);

INSERT INTO dim_sesso (id_sesso, descrizione) VALUES
('M', 'Maschio'),
('F', 'Femmina');

INSERT INTO fact_flussi_migratori (anno, id_paese, id_sesso, num_migranti) VALUES
(2022, 1, 'M', 42905),
(2022, 1, 'F', 8296),
(2022, 2, 'M', 15328),
(2022, 2, 'F', 16247),
(2022, 3, 'M', 11463),
(2022, 3, 'F', 46753),
(2022, 4, 'M', 48823),
(2022, 4, 'F', 31108),
(2022, 5, 'M', 4003),
(2022, 5, 'F', 44336),
(2023, 1, 'M', 14730),
(2023, 1, 'F', 44920),
(2023, 2, 'M', 42943),
(2023, 2, 'F', 46099),
(2023, 3, 'M', 38170),
(2023, 3, 'F', 48049),
(2023, 4, 'M', 29077),
(2023, 4, 'F', 39242),
(2023, 5, 'M', 28666),
(2023, 5, 'F', 40086),
(2024, 1, 'M', 36190),
(2024, 1, 'F', 18486),
(2024, 2, 'M', 34271),
(2024, 2, 'F', 7973),
(2024, 3, 'M', 40252),
(2024, 3, 'F', 22243),
(2024, 4, 'M', 32849),
(2024, 4, 'F', 5535),
(2024, 5, 'M', 36343),
(2024, 5, 'F', 48836);

INSERT INTO fact_economia_istat (anno, id_paese, tasso_occupazione_perc, val_aggiunto_mln, occ_primario_perc, occ_secondario_perc, occ_terziario_perc) VALUES
(2022, 1, 50.5, 6225.56, 4.9, 42.09, 57.07),
(2022, 2, 60.11, 1504.18, 4.58, 39.5, 51.8),
(2022, 3, 58.45, 6279.56, 4.8, 42.9, 34.09),
(2022, 4, 60.72, 19489.2, 6.92, 36.56, 63.18),
(2022, 5, 54.56, 6498.37, 3.04, 26.98, 34.04),
(2023, 1, 55.34, 18796.44, 10.42, 38.27, 36.85),
(2023, 2, 61.14, 14007.67, 12.96, 43.28, 39.16),
(2023, 3, 56.29, 13453.33, 7.14, 47.44, 48.35),
(2023, 4, 57.99, 5167.09, 14.97, 35.29, 33.64),
(2023, 5, 51.27, 8250.77, 14.95, 35.87, 68.84),
(2024, 1, 65.37, 7463.33, 5.82, 24.74, 30.13),
(2024, 2, 67.41, 6670.45, 10.31, 38.27, 36.11),
(2024, 3, 59.77, 3125.49, 6.72, 49.56, 62.27),
(2024, 4, 69.56, 11121.42, 3.63, 39.79, 67.87),
(2024, 5, 63.8, 14546.03, 7.19, 40.15, 44.94);

INSERT INTO fact_contributi_inps (anno, id_paese, lavoratori_attivi, stipendio_medio_annuo, contributi_versati_mln, pensionati, perc_impiego_domestico) VALUES
(2022, 1, 283879, 17453.67, 3157.22, 14165, 6.04),
(2022, 2, 107787, 16492.09, 1751.86, 10851, 31.56),
(2022, 3, 149595, 12967.16, 4313.72, 44671, 33.25),
(2022, 4, 212141, 20854.52, 2127.36, 35203, 29.66),
(2022, 5, 122869, 16534.1, 4253.5, 31319, 17.96),
(2023, 1, 241136, 14448.11, 2580.17, 45382, 39.63),
(2023, 2, 58414, 20050.46, 2305.24, 18675, 12.38),
(2023, 3, 119436, 13396.3, 3852.45, 44438, 31.15),
(2023, 4, 62351, 20611.03, 1187.79, 30969, 32.72),
(2023, 5, 275648, 21424.31, 3561.28, 25014, 28.86),
(2024, 1, 239292, 20758.53, 1685.25, 75612, 31.67),
(2024, 2, 249887, 13615.49, 4790.75, 79514, 37.15),
(2024, 3, 112770, 12579.25, 4451.04, 20322, 8.0),
(2024, 4, 93287, 14650.57, 4425.95, 65461, 38.75),
(2024, 5, 285828, 17175.76, 1044.52, 39451, 7.24);

INSERT INTO fact_impatto_regionale (anno, id_regione, occupati_immigrati_k, pil_generato_mld, incidenza_pil_perc, fabbisogno_occupati) VALUES
(2022, 1, 32.2, 25.37, 10.06, 6885),
(2022, 2, 158.04, 30.44, 5.57, 39684),
(2022, 3, 74.71, 30.0, 7.25, 112767),
(2022, 4, 216.8, 38.91, 5.98, 54862),
(2022, 5, 488.65, 38.66, 4.17, 146711),
(2023, 1, 143.97, 18.65, 3.7, 104345),
(2023, 2, 443.69, 35.47, 10.94, 132577),
(2023, 3, 53.16, 26.7, 9.03, 144231),
(2023, 4, 156.42, 6.28, 13.68, 69543),
(2023, 5, 171.24, 30.47, 6.77, 74629),
(2024, 1, 285.81, 44.93, 14.95, 24204),
(2024, 2, 185.29, 20.28, 9.52, 84303),
(2024, 3, 404.77, 42.31, 4.61, 35258),
(2024, 4, 418.75, 38.53, 9.06, 70829),
(2024, 5, 467.25, 29.03, 6.14, 120824);

INSERT INTO fact_integrazione_sociale (anno, id_regione, indice_ghettizzazione, tasso_scolarizzazione_perc, tasso_disoccupazione_immigrati, episodi_razzismo_segnalati) VALUES
(2022, 1, 24.26, 68.01, 18.87, 67),
(2022, 2, 63.4, 80.17, 10.92, 206),
(2022, 3, 48.02, 83.57, 19.81, 142),
(2022, 4, 52.18, 66.42, 13.55, 92),
(2022, 5, 70.16, 92.42, 18.18, 241),
(2023, 1, 20.13, 92.43, 17.42, 45),
(2023, 2, 29.29, 93.9, 14.95, 61),
(2023, 3, 29.45, 62.8, 10.23, 100),
(2023, 4, 54.74, 62.87, 15.89, 86),
(2023, 5, 43.75, 70.5, 11.79, 124),
(2024, 1, 52.26, 64.64, 12.19, 131),
(2024, 2, 56.7, 82.89, 8.09, 197),
(2024, 3, 73.38, 65.44, 11.38, 219),
(2024, 4, 74.32, 63.23, 13.08, 237),
(2024, 5, 53.1, 60.34, 8.9, 125);

INSERT INTO fact_criminalita (anno, id_regione, tasso_criminalita_generale, tasso_reati_immigrati, perc_reati_marginalizzazione) VALUES
(2022, 1, 4719.27, 5291.72, 62.13),
(2022, 2, 3945.95, 5196.82, 72.21),
(2022, 3, 3196.84, 3964.4, 72.08),
(2022, 4, 4748.97, 5987.98, 62.26),
(2022, 5, 3332.62, 4501.7, 74.57),
(2023, 1, 3570.5, 3929.87, 80.9),
(2023, 2, 4084.39, 4682.55, 82.44),
(2023, 3, 4190.07, 4807.06, 80.26),
(2023, 4, 4130.45, 5260.95, 69.49),
(2023, 5, 4503.73, 5488.92, 62.18),
(2024, 1, 3137.58, 3957.43, 67.33),
(2024, 2, 4634.21, 5948.01, 68.98),
(2024, 3, 3421.26, 4676.52, 70.29),
(2024, 4, 3553.36, 4873.79, 60.11),
(2024, 5, 4766.21, 6031.64, 87.12);

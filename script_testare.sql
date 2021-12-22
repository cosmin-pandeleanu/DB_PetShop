SET PAGES 100;
---  AFISARE TABELE  ---
SELECT * FROM categorii_animale ORDER BY id_categorie;
SELECT * FROM tipuri_produse ORDER BY id_tip;
SELECT * FROM furnizori ORDER BY id_furnizor;

--- AFISARE CLIENTI + DETALII_CLIENTI ---
SELECT clienti.nr_card, rpad(nume_client, 20, ' ') as "NUME CLIENT", "e-mail" as "ADRESA E-MAIL", 
       rpad(data_nasterii, 13,' ') "DATA NASTERII", lpad(gen, 3, ' ') as "GEN", oras , adresa
FROM clienti, detalii_clienti
WHERE clienti.nr_card = detalii_clienti.nr_card
ORDER BY clienti.nr_card;

--- AFISARE PRODUSE ---
SELECT id_produs, denumire_produs, stoc, pret, um, tipuri_produse.denumire_tip, furnizori.denumire_furnizor 
FROM produse, tipuri_produse, furnizori
WHERE produse.id_tip = tipuri_produse.id_tip (+)
    AND produse.id_furnizor = furnizori.id_furnizor (+)
ORDER BY id_produs;

--- AFISARE PRODUSE + CATEGORIE ---
SELECT produse.id_produs, denumire_produs, 
       rpad(stoc,4,' ') as STOC, rpad(pret,4,' ') as PRET, um, 
       tipuri_produse.denumire_tip, furnizori.denumire_furnizor , 
       categorii_animale.denumire_categorie
FROM produse, tipuri_produse, furnizori, categorie, categorii_animale
WHERE produse.id_tip = tipuri_produse.id_tip (+)
    AND produse.id_furnizor = furnizori.id_furnizor (+)
    AND produse.id_produs = categorie.id_produs
    AND categorie.id_categorie = categorii_animale.id_categorie
ORDER BY produse.id_produs;

---  AFISARE VANZARI  ---
SELECT lpad(nr_bon,6,' ') as "NR_BON", 
       lpad(data_achizitiei, 15 ,' ') as "DATA_ACHIZITIEI",
       lpad(nr_card,7,' ') as "NR_CARD", denumire_produs, 
       rpad(cantitate, 9 , ' ') as "CANTITATE", 
       rpad(pret, 11, ' ') as "PRET_UNITAR", 
       rpad(cantitate*pret, 10, ' ') as "PRET_TOTAL"
FROM vanzari, produse
WHERE vanzari.id_produs = produse.id_produs
ORDER BY nr_bon;

--- Simulare aprovizionare cu produse de la furnizori
UPDATE produse SET stoc = stoc + 20 WHERE id_produs = 1000;
UPDATE produse SET stoc = stoc + 10 WHERE id_produs = 1001;
UPDATE produse SET stoc = stoc + 30 WHERE id_produs = 1002;
UPDATE produse SET stoc = stoc + 50 WHERE id_produs = 1003;

-- Adaugati coloana animal_preferat in tabela detalii_clienti, de tip VARCHAR2(15)
ALTER TABLE detalii_clienti
ADD (animal_preferat VARCHAR2(15));

-- Modificati in ionut_marian@gmail.com adresa de e-mail a clientului cu nr_card = 5
UPDATE detalii_clienti
SET "e-mail" =  'ionut_marian@gmail.com'
WHERE nr_card = 5;

-- Stergeti toate vanzarile efectuate pe data de 10-05-2015
DELETE FROM vanzari
WHERE data_achizitiei = TO_DATE('10.5.2015', 'DD.MM.YYYY');

-- Topul produselor dupa cantitatea vanduta
SELECT denumire_produs, sum(v.cantitate) as "CANTITATE VANDUTA", p.um
FROM vanzari v, produse p
WHERE v.id_produs = p.id_produs
GROUP BY denumire_produs, um
ORDER BY sum(v.cantitate) DESC;

-- Topul produselor dupa totalul incasarilor
SELECT denumire_produs, sum(v.cantitate) as "CANTITATE VANDUTA", p.um, p.pret, sum(v.cantitate * p.pret) as "TOTAL INCASARI"
FROM vanzari v, produse p
WHERE v.id_produs = p.id_produs
GROUP BY denumire_produs, pret, um
ORDER BY sum(v.cantitate * p.pret) DESC;

-- Topul clientilor dupa vanzarea facuta magazinului
SELECT v.nr_card, c.nume_client, sum(v.cantitate * p.pret) as "TOTAL CUMPARATURI"
FROM vanzari v, produse p, clienti c
WHERE v.id_produs = p.id_produs
    AND v.nr_card = c.nr_card
GROUP BY v.nr_card , c.nume_client
ORDER BY sum(v.cantitate * p.pret) DESC;

-- Stocuri aproape de epuizare
SELECT denumire_produs, stoc 
FROM produse p
WHERE stoc < 20
ORDER BY stoc;

--- Informatii diverse
SELECT (c.nume_client || ' ' || TO_CHAR(FLOOR((SYSDATE - dc.data_nasterii)/365)) || ' de ani') 
       as "Care este cel mai in varsta client care are card de fidelitate?"
FROM detalii_clienti dc, clienti c
WHERE data_nasterii = (
        SELECT MIN(data_nasterii)
        FROM detalii_clienti)
      AND dc.nr_card = c.nr_card;

SELECT min(pret) as "Care este pretul celui mai ieftin produs?", 
       max(pret) as "Care este pretul celui mai scump produs?",  
       round(avg(pret)) as "Care este pretul mediu al produselor?"
FROM produse;


SELECT lpad(STATS_MODE(oras),76, ' ') 
	   as "Care este orasul din care provin ei mai multi clienti cu card de fidelitate?" 
FROM detalii_clienti;


SELECT lpad(STATS_MODE(pret),68,' ') 
	   as "Care este pretul cel mai frecvent intalnit la produsele din magazin?" 
FROM produse;


SELECT lpad(SUM(p.pret * vanzari.cantitate),61,' ') 
	   as "Care este totalul vanzarilor de cand s-a infiintat magazinul?" 
FROM vanzari, produse p
WHERE vanzari.id_produs = p.id_produs;


SELECT rpad(c.nume_client, 55, ' ') as "Care sunt clientii care nu au informatii despre adresa?"
FROM detalii_clienti dc, clienti c
WHERE c.nr_card = dc.nr_card 
    AND adresa is NULL 
    AND nume_client != 'FARA CARD'

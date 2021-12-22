---  CATEGORII ANIMALE  ---
INSERT INTO categorii_animale(denumire_categorie) VALUES('caini');
INSERT INTO categorii_animale(denumire_categorie) VALUES('pisici');
INSERT INTO categorii_animale(denumire_categorie) VALUES('pasari');
INSERT INTO categorii_animale(denumire_categorie) VALUES('rozatoare');
INSERT INTO categorii_animale(denumire_categorie) VALUES('pesti');
INSERT INTO categorii_animale(denumire_categorie) VALUES('reptile');

---  TIPURI PRODUSE  ---
INSERT INTO tipuri_produse(denumire_tip) VALUES('hrana');
INSERT INTO tipuri_produse(denumire_tip) VALUES('suplimente nutritive');
INSERT INTO tipuri_produse(denumire_tip) VALUES('produse de ingrijire');
INSERT INTO tipuri_produse(denumire_tip) VALUES('accesorii');
INSERT INTO tipuri_produse(denumire_tip) VALUES('jucarii');

---  FURNIZORI  ---
INSERT INTO furnizori(denumire_furnizor) VALUES('Whiskas');
INSERT INTO furnizori(denumire_furnizor) VALUES('Purina');
INSERT INTO furnizori(denumire_furnizor) VALUES('Felix');
INSERT INTO furnizori(denumire_furnizor) VALUES('Brit Premium');
INSERT INTO furnizori(denumire_furnizor) VALUES('Royal Canin');
INSERT INTO furnizori(denumire_furnizor) VALUES('Happy Dog');
INSERT INTO furnizori(denumire_furnizor) VALUES('Flamingo');
INSERT INTO furnizori(denumire_furnizor) VALUES('Petra Aqua');
INSERT INTO furnizori(denumire_furnizor) VALUES('Tetra');

---  CLIENTI + DETALII ---
INSERT INTO clienti(nume_client) VALUES('FARA CARD');
INSERT INTO detalii_clienti VALUES (clienti_nr_card_seq.CURRVAL, null, null ,null, null, null);
INSERT INTO clienti(nume_client) VALUES('Robert Popa');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL, 'robert1605@yahoo.com', '16.05.2000', 'M', null, 'Iasi');
INSERT INTO clienti(nume_client) VALUES('Ana Maria');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL, 'anaa-maria@gmail.com', '15.01.2001', 'F', 'str.Stefan cel Mare, 23', 'Vaslui');
INSERT INTO clienti(nume_client) VALUES('Bianca Popa');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL, 'biia-popa@ymail.com', '10.09.1999', 'F', 'str.Mihai Viteazul, 25', 'Botosani');
INSERT INTO clienti(nume_client) VALUES('Ionut Marian');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL, 'ionutz-marian@gmail.com', '11.10.1989', 'M', 'str.Voiezorilor, 75', 'Bucuresti');
INSERT INTO clienti(nume_client) VALUES('Petru Ionica');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL, 'petru.ionica89@gmail.com', '21.11.1998', 'M', 'str.Apelor, 175', 'Bucuresti');
INSERT INTO clienti(nume_client) VALUES('Razvan Mitica');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL, 'razvan_mitica@gmail.com', '25.11.2000', 'M', 'str.Florilor, 165', 'Iasi');
INSERT INTO clienti(nume_client) VALUES('Florica Popa');
INSERT INTO detalii_clienti VALUES(clienti_nr_card_seq.CURRVAL,'florica@gmail.com', '01.12.1950', 'F', 'str.Margaretelor, 189', 'Chisinau', 'pisici');

---  PRODUSE  + CATEGORIE  --- 
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Hrana uscata', 100, 10.0, 'kg',  1, 1);
INSERT INTO categorie VALUES (1, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Minge rosie',  100, 5.0,  'buc', 5, 3);
INSERT INTO categorie VALUES (1, produse_id_produs_seq.currval); 
INSERT INTO categorie VALUES (2, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Hrana umeda',  100, 10.0, 'buc', 1, 2);
INSERT INTO categorie VALUES (2, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Vitamine Mix', 100, 25.0, 'buc', 2, 3);
INSERT INTO categorie VALUES (2, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Seminte',      100, 5.5,  'kg',  3, 6);
INSERT INTO categorie VALUES (3, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Asternut',     100, 20.0, 'L',  3, 6);
INSERT INTO categorie VALUES (3, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Lesa',         100, 30.0,  'buc',  5, 2);
INSERT INTO categorie VALUES (1, produse_id_produs_seq.currval);
INSERT INTO categorie VALUES (2, produse_id_produs_seq.currval);
INSERT INTO categorie VALUES (4, produse_id_produs_seq.currval);
INSERT INTO produse(denumire_produs, stoc, pret, um, id_tip, id_furnizor) VALUES('Acvariu',      100, 125.0, 'buc',  4, 8);
INSERT INTO categorie VALUES (5, produse_id_produs_seq.currval);


--- VANZARI + UPDATE stocuri ---
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (2, 1000, 2, SYSDATE);
UPDATE produse SET stoc = stoc-2 WHERE id_produs = 1000;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (4, 1002, 10, SYSDATE-20);
UPDATE produse SET stoc = stoc-10 WHERE id_produs = 1002;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (3, 1001, 5, SYSDATE-2);
UPDATE produse SET stoc = stoc-5 WHERE id_produs = 1001;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (5, 1007, 6, TO_DATE('01.12.2005', 'DD.MM.YYYY'));
UPDATE produse SET stoc = stoc-6 WHERE id_produs = 1007;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (5, 1005, 25, TO_DATE('10.5.2015', 'DD.MM.YYYY'));
UPDATE produse SET stoc = stoc-25 WHERE id_produs = 1005;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (1, 1001, 9, TO_DATE('23.5.2019', 'DD.MM.YYYY'));
UPDATE produse SET stoc = stoc-9 WHERE id_produs = 1001;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (3, 1006, 4, SYSDATE-5);
UPDATE produse SET stoc = stoc-4 WHERE id_produs = 1006;
INSERT INTO vanzari(nr_card, id_produs, cantitate, data_achizitiei) VALUES (3, 1001, 5, TO_DATE('10.5.2015', 'DD.MM.YYYY'));
UPDATE produse SET stoc = stoc-5 WHERE id_produs = 1001;

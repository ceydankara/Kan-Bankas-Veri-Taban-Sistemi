--KAN_GRUBU Tablosunun oluşturulması
CREATE TABLE KAN_GRUBU(
    KAN_GRUBU_ID INT  PRIMARY KEY,
    KANGRUBU  VARCHAR(10)
);
-- KAN_GRUBU Tablosu Verisi
INSERT INTO KAN_GRUBU (KAN_GRUBU_ID, KANGRUBU) VALUES
(1, 'A+'),
(2, 'A-'),
(3, 'B+'),
(4, 'B-'),
(5, 'AB+'),
(6, 'AB-'),
(7, 'O+'),
(8, 'O-');

--CINSIYET Tablosunun oluşturulması
CREATE TABLE CINSIYET(
    CINSIYET_ID VARCHAR(5) PRIMARY KEY,
    CINSIYET VARCHAR(10)
);

-- CINSIYET Tablosu Verisi
INSERT INTO CINSIYET (CINSIYET_ID, CINSIYET) VALUES
('K', 'Erkek'),
('E', 'Kadın');

--HASTANE Tablosunun oluşturulması
CREATE TABLE HASTANE(
    HASTANE_ID INT PRIMARY KEY,
    HASTANE_ADI VARCHAR(50),
    HASTANE_ADRESI VARCHAR(100)
);

-- HASTANE Tablosu Verisi
INSERT INTO HASTANE (HASTANE_ID, HASTANE_ADI, HASTANE_ADRESI) VALUES
(1, 'Acıbadem Hastanesi', 'İstanbul, Kadıköy'),
(2, 'Memorial Şişli Hastanesi', 'İstanbul, Şişli'),
(3, 'Florence Nightingale Hastanesi', 'İstanbul'),
(4, 'Liv Hospital', 'İstanbul, Ulus'),
(5, 'Kocaeli Üniversitesi Hastanesi', 'İstanbul, Pendik'),
(6, 'Medicana International İstanbul', 'İstanbul, Halkalı'),
(7, 'Amerikan Hastanesi', 'İstanbul, Şişli'),
(8, 'Bahçelievler Medical Park Hastanesi', 'İstanbul, Bahçelievler'),
(9, 'GATA Haydarpaşa Hastanesi', 'İstanbul, Haydarpaşa'),
(10, 'Özel Dünya Göz Hastanesi', 'İstanbul, Bakırköy');

--KAN_BANKASI Tablosunun oluşturulması
CREATE TABLE KAN_BANKASI(
    KAN_BANKASI_ID INT PRIMARY KEY,
    KAN_BANKASI_ADI VARCHAR(50),
    KAN_BANKASI_ADRESI VARCHAR(50)
);

-- KAN_BANKASI Tablosu Verisi
INSERT INTO KAN_BANKASI (KAN_BANKASI_ID, KAN_BANKASI_ADI, KAN_BANKASI_ADRESI ) VALUES (1,'KAN BANKASI','İstanbul');


-- HASTALAR Tablosunun oluşturulması
CREATE TABLE HASTALAR (
    HASTA_ID INT PRIMARY  KEY,
    HASTA_ADI VARCHAR(50),
    HASTA_SOYADI VARCHAR(50),
    DOGUM_TARIHI DATE,
    CINSIYET_ID VARCHAR(5),
    KAN_GRUBU_ID INT,
    HASTANE_ID INT,
    FOREIGN KEY (CINSIYET_ID) REFERENCES CINSIYET(CINSIYET_ID),
    FOREIGN KEY (KAN_GRUBU_ID) REFERENCES KAN_GRUBU(KAN_GRUBU_ID),
    FOREIGN KEY (HASTANE_ID) REFERENCES HASTANE(HASTANE_ID)
);

-- BAGISCILAR Tablosunun oluşturulması
CREATE TABLE BAGISCILAR(
    BAGISCI_ID INT PRIMARY KEY,
    BAGISCI_ADI VARCHAR(50),
    BAGISCI_SOYADI VARCHAR(50),
    BAGISCI_ADRESI VARCHAR(50),
    B_ILETISIM_NUM VARCHAR(15),
    KAN_GRUBU_ID INT,
    CINSIYET_ID VARCHAR(5),
    KAN_BANKASI_ID INT,
    FOREIGN KEY (CINSIYET_ID) REFERENCES CINSIYET(CINSIYET_ID),
    FOREIGN KEY (KAN_GRUBU_ID) REFERENCES KAN_GRUBU(KAN_GRUBU_ID),
    FOREIGN KEY (KAN_BANKASI_ID) REFERENCES KAN_BANKASI(KAN_BANKASI_ID)
);

-- STOK Tablosunun oluşturulması
CREATE TABLE STOK(
    STOK_ID INT PRIMARY KEY,
    STOK_MIKTARI INT,
    KAN_BANKASI_ID INT,
    KAN_GRUBU_ID INT,
    FOREIGN KEY (KAN_BANKASI_ID) REFERENCES KAN_BANKASI(KAN_BANKASI_ID),
    FOREIGN KEY (KAN_GRUBU_ID) REFERENCES KAN_GRUBU(KAN_GRUBU_ID)
);

-- STOK Tablosu Verisi
INSERT INTO STOK (STOK_ID, STOK_MIKTARI, KAN_BANKASI_ID, KAN_GRUBU_ID) VALUES
(1, 0, 1, 1),  -- A+
(2, 0, 1, 2),  -- A-
(3, 0, 1, 3),  -- B+
(4, 0, 1, 4),  -- B-
(5, 0, 1, 5),  -- AB+
(6, 0, 1, 6),  -- AB-
(7, 0, 1, 7),  -- O+
(8, 0, 1, 8);  -- O-



-- KAN_BAGISI Tablosunun oluşturulması
CREATE TABLE KAN_BAGISI(
    BAGIS_ID INT PRIMARY KEY,
    BAGISCI_ID INT,
    BAGIS_TARIHI DATE,
    KAN_GRUBU_ID INT,
    STOK_ID INT,
    FOREIGN KEY (BAGISCI_ID) REFERENCES BAGISCILAR(BAGISCI_ID),
    FOREIGN KEY (KAN_GRUBU_ID) REFERENCES KAN_GRUBU(KAN_GRUBU_ID),
    FOREIGN KEY (STOK_ID) REFERENCES STOK(STOK_ID)
);

-- KAN_TALEBI Tablosunun oluşturulması
CREATE TABLE KAN_TALEBI(
    TALEP_ID INT PRIMARY KEY,
    HASTA_ID INT,
    STOK_ID INT,
    FOREIGN KEY (HASTA_ID) REFERENCES HASTALAR(HASTA_ID),
    FOREIGN KEY (STOK_ID) REFERENCES STOK(STOK_ID)
);

--Bağışçı eklendiğinde stokta stok miktarını arttırma trigger'ı
CREATE OR REPLACE TRIGGER STOK_ARTTIR_TRIG
AFTER INSERT ON BAGISCILAR
FOR EACH ROW
BEGIN
  UPDATE STOK
  SET STOK_MIKTARI = STOK_MIKTARI + 1
  WHERE KAN_GRUBU_ID = :NEW.KAN_GRUBU_ID;
END;


--Hasta eklendiğinde stokta stok miktarını azaltma trigger'ı
CREATE OR REPLACE TRIGGER STOK_AZALT_TRIG
AFTER INSERT ON HASTALAR
FOR EACH ROW
BEGIN
  UPDATE STOK
  SET STOK_MIKTARI = STOK_MIKTARI - 1
  WHERE KAN_GRUBU_ID = :NEW.KAN_GRUBU_ID;
END;

CREATE SEQUENCE BAGIS_ID_SEQ
START WITH 151
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE OR REPLACE TRIGGER BAGIS_EKLE_TRIG
AFTER INSERT ON BAGISCILAR
FOR EACH ROW
DECLARE
    v_stok_id INT;
BEGIN
    -- Bağışçının kan grubu ve kan bankasına ait stok ID'sini bul
    SELECT STOK_ID INTO v_stok_id
    FROM STOK
    WHERE KAN_GRUBU_ID = :NEW.KAN_GRUBU_ID
      AND KAN_BANKASI_ID = :NEW.KAN_BANKASI_ID;

    -- KAN_BAGISI tablosuna yeni kayıt ekle
    INSERT INTO KAN_BAGISI (BAGIS_ID, BAGISCI_ID, BAGIS_TARIHI, KAN_GRUBU_ID, STOK_ID)
    VALUES (BAGIS_ID_SEQ.NEXTVAL, :NEW.BAGISCI_ID, SYSDATE, :NEW.KAN_GRUBU_ID, v_stok_id);
END;



CREATE SEQUENCE TALEP_ID_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER HASTA_TALEP_TRIG
AFTER INSERT ON HASTALAR
FOR EACH ROW
DECLARE
    v_stok_id STOK.STOK_ID%TYPE;
    v_stok_miktari STOK.STOK_MIKTARI%TYPE;
BEGIN
    -- İlgili kan grubu ve hastanenin bağlı olduğu kan bankası varsayımıyla (örnek: KAN_BANKASI_ID = 1)
    SELECT STOK_ID, STOK_MIKTARI INTO v_stok_id, v_stok_miktari
    FROM STOK
    WHERE KAN_GRUBU_ID = :NEW.KAN_GRUBU_ID
      AND KAN_BANKASI_ID = 1;  -- Tek bir kan bankası olduğunu varsayıyoruz

    IF v_stok_miktari < 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Yeterli stok yok!');
    END IF;

    -- Stoktan 1 azalt
    UPDATE STOK
    SET STOK_MIKTARI = STOK_MIKTARI - 1
    WHERE STOK_ID = v_stok_id;

    -- Talep tablosuna hasta talebi gir
    INSERT INTO KAN_TALEBI (TALEP_ID, HASTA_ID, STOK_ID)
    VALUES (TALEP_ID_SEQ.NEXTVAL, :NEW.HASTA_ID, v_stok_id);
END;


ALTER TRIGGER BAGIS_EKLE_TRIG DISABLE;

INSERT INTO BAGISCILAR VALUES (1, 'Ayşe', 'Yavuz', 'İstanbul, Pendik', '0555000001', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (2, 'Fatma', 'Yılmaz', 'İstanbul, Pendik', '0555000002', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (3, 'Emine', 'Şahin', 'İstanbul, Pendik', '0555000003', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (4, 'Ahmet', 'Doğan', 'İstanbul, Pendik', '0555000004', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (5, 'Mehmet', 'Aydın', 'İstanbul, Pendik', '0555000005', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (6, 'Zeynep', 'Koç', 'İstanbul, Pendik', '0555000006', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (7, 'Zeynep', 'Yavuz', 'İstanbul, Pendik', '0555000007', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (8, 'Zeynep', 'Doğan', 'İstanbul, Pendik', '0555000008', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (9, 'Ayşe', 'Şahin', 'İstanbul, Pendik', '0555000009', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (10, 'Mehmet', 'Demir', 'İstanbul, Pendik', '0555000010', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (11, 'Elif', 'Çelik', 'İstanbul, Pendik', '0555000011', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (12, 'Mustafa', 'Demir', 'İstanbul, Pendik', '0555000012', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (13, 'Ahmet', 'Kaya', 'İstanbul, Pendik', '0555000013', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (14, 'Mehmet', 'Yavuz', 'İstanbul, Pendik', '0555000014', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (15, 'Elif', 'Yavuz', 'İstanbul, Pendik', '0555000015', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (16, 'Fatma', 'Çelik', 'İstanbul, Pendik', '0555000016', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (17, 'Emine', 'Yavuz', 'İstanbul, Pendik', '0555000017', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (18, 'Elif', 'Yılmaz', 'İstanbul, Pendik', '0555000018', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (19, 'Elif', 'Demir', 'İstanbul, Pendik', '0555000019', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (20, 'Elif', 'Yılmaz', 'İstanbul, Pendik', '0555000020', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (21, 'Mehmet', 'Yılmaz', 'İstanbul, Pendik', '0555000021', 6, 'K', 1);
INSERT INTO BAGISCILAR VALUES (22, 'Ahmet', 'Koç', 'İstanbul, Pendik', '0555000022', 7, 'K', 1);
INSERT INTO BAGISCILAR VALUES (23, 'Emine', 'Kaya', 'İstanbul, Pendik', '0555000023', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (24, 'Ahmet', 'Yavuz', 'İstanbul, Pendik', '0555000024', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (25, 'Elif', 'Doğan', 'İstanbul, Pendik', '0555000025', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (26, 'Ahmet', 'Koç', 'İstanbul, Pendik', '0555000026', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (27, 'Ahmet', 'Şahin', 'İstanbul, Pendik', '0555000027', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (28, 'Fatma', 'Arslan', 'İstanbul, Pendik', '0555000028', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (29, 'Elif', 'Şahin', 'İstanbul, Pendik', '0555000029', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (30, 'Ali', 'Arslan', 'İstanbul, Pendik', '0555000030', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (31, 'Ali', 'Demir', 'İstanbul, Pendik', '0555000031', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (32, 'Mustafa', 'Arslan', 'İstanbul, Pendik', '0555000032', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (33, 'Mehmet', 'Arslan', 'İstanbul, Pendik', '0555000033', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (34, 'Emine', 'Doğan', 'İstanbul, Pendik', '0555000034', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (35, 'Elif', 'Koç', 'İstanbul, Pendik', '0555000035', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (36, 'Ayşe', 'Aydın', 'İstanbul, Pendik', '0555000036', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (37, 'Ayşe', 'Aydın', 'İstanbul, Pendik', '0555000037', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (38, 'Elif', 'Doğan', 'İstanbul, Pendik', '0555000038', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (39, 'Mehmet', 'Çelik', 'İstanbul, Pendik', '0555000039', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (40, 'Mustafa', 'Şahin', 'İstanbul, Pendik', '0555000040', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (41, 'Ali', 'Arslan', 'İstanbul, Pendik', '0555000041', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (42, 'Zeynep', 'Doğan', 'İstanbul, Pendik', '0555000042', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (43, 'Elif', 'Çelik', 'İstanbul, Pendik', '0555000043', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (44, 'Ali', 'Şahin', 'İstanbul, Pendik', '0555000044', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (45, 'Mustafa', 'Kaya', 'İstanbul, Pendik', '0555000045', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (46, 'Elif', 'Kaya', 'İstanbul, Pendik', '0555000046', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (47, 'Emine', 'Aydın', 'İstanbul, Pendik', '0555000047', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (48, 'Hasan', 'Koç', 'İstanbul, Pendik', '0555000048', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (49, 'Mustafa', 'Arslan', 'İstanbul, Pendik', '0555000049', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (50, 'Ayşe', 'Koç', 'İstanbul, Pendik', '0555000050', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (51, 'Zeynep', 'Demir', 'İstanbul, Pendik', '0555000051', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (52, 'Elif', 'Demir', 'İstanbul, Pendik', '0555000052', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (53, 'Mehmet', 'Demir', 'İstanbul, Pendik', '0555000053', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (54, 'Elif', 'Doğan', 'İstanbul, Pendik', '0555000054', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (55, 'Ahmet', 'Şahin', 'İstanbul, Pendik', '0555000055', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (56, 'Ayşe', 'Çelik', 'İstanbul, Pendik', '0555000056', 6, 'K', 1);
INSERT INTO BAGISCILAR VALUES (57, 'Hasan', 'Yavuz', 'İstanbul, Pendik', '0555000057', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (58, 'Mehmet', 'Şahin', 'İstanbul, Pendik', '0555000058', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (59, 'Hasan', 'Doğan', 'İstanbul, Pendik', '0555000059', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (60, 'Emine', 'Çelik', 'İstanbul, Pendik', '0555000060', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (61, 'Ayşe', 'Yavuz', 'İstanbul, Pendik', '0555000061', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (62, 'Ali', 'Koç', 'İstanbul, Pendik', '0555000062', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (63, 'Ali', 'Doğan', 'İstanbul, Pendik', '0555000063', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (64, 'Mustafa', 'Yavuz', 'İstanbul, Pendik', '0555000064', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (65, 'Ayşe', 'Kaya', 'İstanbul, Pendik', '0555000065', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (66, 'Hasan', 'Kaya', 'İstanbul, Pendik', '0555000066', 7, 'K', 1);
INSERT INTO BAGISCILAR VALUES (67, 'Mehmet', 'Demir', 'İstanbul, Pendik', '0555000067', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (68, 'Ali', 'Koç', 'İstanbul, Pendik', '0555000068', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (69, 'Ali', 'Yavuz', 'İstanbul, Pendik', '0555000069', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (70, 'Mehmet', 'Doğan', 'İstanbul, Pendik', '0555000070', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (71, 'Fatma', 'Koç', 'İstanbul, Pendik', '0555000071', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (72, 'Mehmet', 'Aydın', 'İstanbul, Pendik', '0555000072', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (73, 'Zeynep', 'Çelik', 'İstanbul, Pendik', '0555000073', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (74, 'Hasan', 'Yavuz', 'İstanbul, Pendik', '0555000074', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (75, 'Zeynep', 'Aydın', 'İstanbul, Pendik', '0555000075', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (76, 'Mehmet', 'Aydın', 'İstanbul, Pendik', '0555000076', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (77, 'Zeynep', 'Doğan', 'İstanbul, Pendik', '0555000077', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (78, 'Mehmet', 'Kaya', 'İstanbul, Pendik', '0555000078', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (79, 'Ahmet', 'Koç', 'İstanbul, Pendik', '0555000079', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (80, 'Emine', 'Arslan', 'İstanbul, Pendik', '0555000080', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (81, 'Zeynep', 'Şahin', 'İstanbul, Pendik', '0555000081', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (82, 'Hasan', 'Demir', 'İstanbul, Pendik', '0555000082', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (83, 'Ahmet', 'Çelik', 'İstanbul, Pendik', '0555000083', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (84, 'Elif', 'Doğan', 'İstanbul, Pendik', '0555000084', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (85, 'Ali', 'Kaya', 'İstanbul, Pendik', '0555000085', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (86, 'Elif', 'Demir', 'İstanbul, Pendik', '0555000086', 6, 'K', 1);
INSERT INTO BAGISCILAR VALUES (87, 'Fatma', 'Çelik', 'İstanbul, Pendik', '0555000087', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (88, 'Ayşe', 'Yılmaz', 'İstanbul, Pendik', '0555000088', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (89, 'Hasan', 'Demir', 'İstanbul, Pendik', '0555000089', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (90, 'Ali', 'Yılmaz', 'İstanbul, Pendik', '0555000090', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (91, 'Ahmet', 'Arslan', 'İstanbul, Pendik', '0555000091', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (92, 'Emine', 'Demir', 'İstanbul, Pendik', '0555000092', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (93, 'Ali', 'Demir', 'İstanbul, Pendik', '0555000093', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (94, 'Elif', 'Kaya', 'İstanbul, Pendik', '0555000094', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (95, 'Fatma', 'Yavuz', 'İstanbul, Pendik', '0555000095', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (96, 'Hasan', 'Yılmaz', 'İstanbul, Pendik', '0555000096', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (97, 'Elif', 'Çelik', 'İstanbul, Pendik', '0555000097', 7, 'K', 1);
INSERT INTO BAGISCILAR VALUES (98, 'Ali', 'Çelik', 'İstanbul, Pendik', '0555000098', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (99, 'Ahmet', 'Koç', 'İstanbul, Pendik', '0555000099', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (100, 'Mehmet', 'Yılmaz', 'İstanbul, Pendik', '0555000100', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (101, 'Emine', 'Yılmaz', 'İstanbul, Pendik', '0555000101', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (102, 'Ali', 'Yılmaz', 'İstanbul, Pendik', '0555000102', 6, 'K', 1);
INSERT INTO BAGISCILAR VALUES (103, 'Ahmet', 'Yılmaz', 'İstanbul, Pendik', '0555000103', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (104, 'Elif', 'Yılmaz', 'İstanbul, Pendik', '0555000104', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (105, 'Zeynep', 'Koç', 'İstanbul, Pendik', '0555000105', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (106, 'Ayşe', 'Yılmaz', 'İstanbul, Pendik', '0555000106', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (107, 'Zeynep', 'Arslan', 'İstanbul, Pendik', '0555000107', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (108, 'Hasan', 'Kaya', 'İstanbul, Pendik', '0555000108', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (109, 'Ali', 'Yılmaz', 'İstanbul, Pendik', '0555000109', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (110, 'Hasan', 'Arslan', 'İstanbul, Pendik', '0555000110', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (111, 'Ayşe', 'Yılmaz', 'İstanbul, Pendik', '0555000111', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (112, 'Elif', 'Koç', 'İstanbul, Pendik', '0555000112', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (113, 'Zeynep', 'Şahin', 'İstanbul, Pendik', '0555000113', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (114, 'Mehmet', 'Doğan', 'İstanbul, Pendik', '0555000114', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (115, 'Fatma', 'Demir', 'İstanbul, Pendik', '0555000115', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (116, 'Emine', 'Kaya', 'İstanbul, Pendik', '0555000116', 8, 'E', 1);
INSERT INTO BAGISCILAR VALUES (117, 'Hasan', 'Yılmaz', 'İstanbul, Pendik', '0555000117', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (118, 'Mehmet', 'Kaya', 'İstanbul, Pendik', '0555000118', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (119, 'Ali', 'Doğan', 'İstanbul, Pendik', '0555000119', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (120, 'Hasan', 'Çelik', 'İstanbul, Pendik', '0555000120', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (121, 'Ahmet', 'Şahin', 'İstanbul, Pendik', '0555000121', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (122, 'Fatma', 'Doğan', 'İstanbul, Pendik', '0555000122', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (123, 'Elif', 'Yılmaz', 'İstanbul, Pendik', '0555000123', 6, 'K', 1);
INSERT INTO BAGISCILAR VALUES (124, 'Zeynep', 'Koç', 'İstanbul, Pendik', '0555000124', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (125, 'Fatma', 'Arslan', 'İstanbul, Pendik', '0555000125', 6, 'E', 1);
INSERT INTO BAGISCILAR VALUES (126, 'Mehmet', 'Kaya', 'İstanbul, Pendik', '0555000126', 1, 'E', 1);
INSERT INTO BAGISCILAR VALUES (127, 'Elif', 'Çelik', 'İstanbul, Pendik', '0555000127', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (128, 'Mustafa', 'Kaya', 'İstanbul, Pendik', '0555000128', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (129, 'Ali', 'Kaya', 'İstanbul, Pendik', '0555000129', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (130, 'Mustafa', 'Arslan', 'İstanbul, Pendik', '0555000130', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (131, 'Ali', 'Yavuz', 'İstanbul, Pendik', '0555000131', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (132, 'Emine', 'Yılmaz', 'İstanbul, Pendik', '0555000132', 5, 'K', 1);
INSERT INTO BAGISCILAR VALUES (133, 'Ahmet', 'Doğan', 'İstanbul, Pendik', '0555000133', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (134, 'Mehmet', 'Kaya', 'İstanbul, Pendik', '0555000134', 2, 'K', 1);
INSERT INTO BAGISCILAR VALUES (135, 'Ali', 'Arslan', 'İstanbul, Pendik', '0555000135', 8, 'K', 1);
INSERT INTO BAGISCILAR VALUES (136, 'Ali', 'Kaya', 'İstanbul, Pendik', '0555000136', 1, 'K', 1);
INSERT INTO BAGISCILAR VALUES (137, 'Emine', 'Aydın', 'İstanbul, Pendik', '0555000137', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (138, 'Ali', 'Kaya', 'İstanbul, Pendik', '0555000138', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (139, 'Mustafa', 'Şahin', 'İstanbul, Pendik', '0555000139', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (140, 'Mehmet', 'Doğan', 'İstanbul, Pendik', '0555000140', 7, 'E', 1);
INSERT INTO BAGISCILAR VALUES (141, 'Emine', 'Kaya', 'İstanbul, Pendik', '0555000141', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (142, 'Hasan', 'Yılmaz', 'İstanbul, Pendik', '0555000142', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (143, 'Hasan', 'Doğan', 'İstanbul, Pendik', '0555000143', 3, 'E', 1);
INSERT INTO BAGISCILAR VALUES (144, 'Ahmet', 'Şahin', 'İstanbul, Pendik', '0555000144', 2, 'E', 1);
INSERT INTO BAGISCILAR VALUES (145, 'Elif', 'Aydın', 'İstanbul, Pendik', '0555000145', 7, 'K', 1);
INSERT INTO BAGISCILAR VALUES (146, 'Emine', 'Şahin', 'İstanbul, Pendik', '0555000146', 4, 'K', 1);
INSERT INTO BAGISCILAR VALUES (147, 'Ahmet', 'Yılmaz', 'İstanbul, Pendik', '0555000147', 5, 'E', 1);
INSERT INTO BAGISCILAR VALUES (148, 'Ayşe', 'Şahin', 'İstanbul, Pendik', '0555000148', 4, 'E', 1);
INSERT INTO BAGISCILAR VALUES (149, 'Hasan', 'Koç', 'İstanbul, Pendik', '0555000149', 3, 'K', 1);
INSERT INTO BAGISCILAR VALUES (150, 'Emine', 'Koç', 'İstanbul, Pendik', '0555000150', 6, 'E', 1);


INSERT INTO KAN_BAGISI VALUES (1, 1, TO_DATE('2023-10-13', 'YYYY-MM-DD'), 4, 5);
INSERT INTO KAN_BAGISI VALUES (2, 2, TO_DATE('2023-12-27', 'YYYY-MM-DD'), 6, 5);
INSERT INTO KAN_BAGISI VALUES (3, 3, TO_DATE('2023-08-18', 'YYYY-MM-DD'), 8, 4);
INSERT INTO KAN_BAGISI VALUES (4, 4, TO_DATE('2023-12-03', 'YYYY-MM-DD'), 8, 2);
INSERT INTO KAN_BAGISI VALUES (5, 5, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 4, 2);
INSERT INTO KAN_BAGISI VALUES (6, 6, TO_DATE('2023-09-12', 'YYYY-MM-DD'), 1, 4);
INSERT INTO KAN_BAGISI VALUES (7, 7, TO_DATE('2024-08-24', 'YYYY-MM-DD'), 5, 4);
INSERT INTO KAN_BAGISI VALUES (8, 8, TO_DATE('2023-04-19', 'YYYY-MM-DD'), 6, 1);
INSERT INTO KAN_BAGISI VALUES (9, 9, TO_DATE('2023-06-04', 'YYYY-MM-DD'), 8, 3);
INSERT INTO KAN_BAGISI VALUES (10, 10, TO_DATE('2023-09-12', 'YYYY-MM-DD'), 3, 2);

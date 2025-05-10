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

CREATE TABLE CINSIYET(
    CINSIYET_ID VARCHAR(5) PRIMARY KEY,
    CINSIYET VARCHAR(10)
);

-- CINSIYET Tablosu Verisi
INSERT INTO CINSIYET (CINSIYET_ID, CINSIYET) VALUES
('K', 'Erkek'),
('E', 'Kadın');

CREATE TABLE HASTANE(
    HASTANE_ID INT PRIMARY KEY,
    HASTANE_ADI VARCHAR(50),
    HASTANE_ADRESI VARCHAR(100)
);

-- HASTANE Tablosu Verisi
INSERT INTO HASTANE (HASTANE_ID, HASTANE_ADI, HASTANE_ADRESI) VALUES
(1, 'Acıbadem Hastanesi', 'İstanbul, Kadıköy, Acıbadem Caddesi'),
(2, 'Memorial Şişli Hastanesi', 'İstanbul, Şişli, Mecidiyeköy'),
(3, 'Florence Nightingale Hastanesi', 'İstanbul, Beyoğlu, Pera Caddesi'),
(4, 'Liv Hospital', 'İstanbul, Ulus, Beşiktaş'),
(5, 'Kocaeli Üniversitesi Hastanesi', 'İstanbul, Pendik'),
(6, 'Medicana International İstanbul', 'İstanbul, Halkalı, Küçükçekmece'),
(7, 'Amerikan Hastanesi', 'İstanbul, Şişli, Osmanbey'),
(8, 'Bahçelievler Medical Park Hastanesi', 'İstanbul, Bahçelievler'),
(9, 'GATA Haydarpaşa Hastanesi', 'İstanbul, Haydarpaşa, Kadıköy'),
(10, 'Özel Dünya Göz Hastanesi', 'İstanbul, Bakırköy, Ataköy');

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
---- BAGISCILAR TABLOSU OLUŞTURULMASI

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


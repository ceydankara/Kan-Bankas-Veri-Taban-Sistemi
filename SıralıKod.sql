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

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

-- CINSIYET Tablosu Verisi
INSERT INTO CINSIYET (CINSIYET_ID, CINSIYET) VALUES
('K', 'Erkek'),
('E', 'Kadın');

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


-- KAN_BANKASI Tablosu Verisi
INSERT INTO KAN_BANKASI (KAN_BANKASI_ID, KAN_BANKASI_ADI, KAN_BANKASI_ADRESI ) VALUES (1,'KAN BANKASI','İstanbul');
-- STOK Tablosu Verisi
INSERT INTO STOK (STOK_ID, STOK_MIKTARI, KAN_BANKASI_ID, KAN_GRUBU_ID) VALUES
(1, 0, 1, 1),  -- A+
(2, 0, 1, 2),  -- A-
(3, 0, 1, 3),  -- B+
(4, 0, 1, 4),  -- B-
(5, 0, 1, 5),  -- AB+
(6, 0, 1, 6),  -- AB-
(7, 0, 1, 7),  -- O+
(8, 0, 1, 8);  -- O-

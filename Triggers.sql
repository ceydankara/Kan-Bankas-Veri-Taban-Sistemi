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
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- bagıscı eklendiğinde kan bagısı tablosunu günceller. 
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


-- hasta girildiğinde kan talebi tanlosunu günceller
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

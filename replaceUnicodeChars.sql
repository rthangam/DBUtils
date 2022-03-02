CREATE OR REPLACE FUNCTION ascii_only (p_txt IN VARCHAR2)
       RETURN VARCHAR2
    IS
       v_tmp     VARCHAR2 (32767);
       v_clean   VARCHAR2 (32767);
       v_char    VARCHAR2 (3 BYTE);
    BEGIN
       FOR i IN 1 .. LENGTH (p_txt) LOOP
          v_char := SUBSTR (p_txt, i, 1);
          
         -- Choose your range of valid characters
         -- Ascii only looks at first BYTE of character
         -- (note sure if this is a reliable way to detect UTF8 multi-byte characters)
         -- (but it seems to work ok on my 10000 test records)
         IF    (ASCII (v_char) BETWEEN 32 AND 127)
            OR (ASCII (v_char) IN (9, 10, 13)) THEN
            v_clean := v_clean || v_char;
         ELSE
            v_clean := v_clean || '- ';
         END IF;
      END LOOP;
      IF LENGTH (v_clean) != LENGTH (p_txt) THEN
         DBMS_OUTPUT.put_line ('removed '||TO_CHAR(LENGTH(p_txt) - LENGTH(v_clean))||' characters');
      END IF;
      RETURN v_clean;
   END;
   /

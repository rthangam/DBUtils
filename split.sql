DECLARE
    lv_string        VARCHAR2(1000) :=
'/api/v1/bots/sessions/c1/c2/c3/log'
    ;
    prev_pos         PLS_INTEGER := 1;
    next_pos         PLS_INTEGER := 1;
    len              PLS_INTEGER := 0;
    match_found      PLS_INTEGER := 0;
    pattern_start    PLS_INTEGER := 5;
    pattern_end      PLS_INTEGER := 7;
    delim            CHAR(1) := '/';
    TYPE session_ids
      IS TABLE OF VARCHAR2(1000) INDEX BY PLS_INTEGER;
    session_ids_list SESSION_IDS;
BEGIN
    len := Length(lv_string);

    LOOP
        --
        -- Check if there if the starting postion is > length of the string.
        -- If yes then exit.
        --
        IF prev_pos > len THEN
          EXIT;
        END IF;

        next_pos := Instr(lv_string, delim, prev_pos + 1, 1);

        --
        -- If there is no match found then exit
        --
        IF next_pos = 0 THEN
          EXIT;
        END IF;

        --dbms_output.put_line(prev_pos || ' -' || next_pos);
        
        --
        -- If match is found check if the match is the required one or not and
        -- add it to the VARRAY
        --
        IF next_pos > prev_pos THEN
          match_found := match_found + 1;

          --dbms_output.put_line(substr(lv_string, prev_pos+1, next_pos - prev_pos - 1));
          IF match_found >= pattern_start
             AND match_found <= pattern_end THEN
            Session_ids_list(match_found - pattern_start + 1) :=
            Substr(lv_string, prev_pos + 1, next_pos - prev_pos - 1);
          END IF;

          prev_pos := next_pos;
        ELSE
          EXIT;
        END IF;
    END LOOP;

    FOR i IN 1 .. session_ids_list.count LOOP
        dbms_output.Put_line(Session_ids_list(i));
    END LOOP;
END; 

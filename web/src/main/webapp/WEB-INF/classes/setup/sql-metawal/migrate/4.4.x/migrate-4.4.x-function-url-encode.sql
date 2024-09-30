CREATE OR REPLACE FUNCTION url_utf8_percent_encode(input_string TEXT)
RETURNS TEXT LANGUAGE plpgsql AS
$$
DECLARE
    result TEXT := '';
    current_char TEXT;
    hex_value TEXT;
    ascii_value INT;
BEGIN
    FOR i IN 1..LENGTH(input_string) LOOP
        current_char := SUBSTRING(input_string FROM i FOR 1);

        -- Get ASCII value of the current character
        ascii_value := ASCII(current_char);

        -- Check if the character is safe for URLs
        IF ascii_value BETWEEN 48 AND 57 -- 0-9
           OR ascii_value BETWEEN 65 AND 90 -- A-Z
           OR ascii_value BETWEEN 97 AND 122 -- a-z
           OR ascii_value IN (45, 46, 95, 126) -- '-', '.', '_', '~'
        THEN
            result := result || current_char;
        ELSE
            -- Convert the character to its byte representation in UTF-8
            hex_value := ENCODE(CONVERT_TO(current_char, 'UTF8'), 'hex');

            -- Percent-encode each byte of the UTF-8 encoded string
            result := result || '%' || UPPER(SUBSTRING(hex_value, 1, 2));

            -- If the character is multi-byte (more than one byte in UTF-8), append the rest
            IF LENGTH(hex_value) > 2 THEN
                FOR j IN 2..(LENGTH(hex_value) / 2) LOOP
                    result := result || '%' || UPPER(SUBSTRING(hex_value, (j * 2 - 1), 2));
                END LOOP;
            END IF;
        END IF;
    END LOOP;

    RETURN result;
END
$$;

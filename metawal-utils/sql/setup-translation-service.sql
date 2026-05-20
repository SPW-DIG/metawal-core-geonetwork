INSERT INTO settings (name, value) VALUES ('system/translation/provider', 'LibreTranslate') ON CONFLICT (name)
    DO UPDATE SET value = 'LibreTranslate';
INSERT INTO settings (name, value) VALUES ('system/translation/serviceUrl', 'http://localhost:5000/translate') ON CONFLICT (name)
    DO UPDATE SET value = 'http://apps.titellus.net:5000/translate';

ALTER TABLE settings ALTER COLUMN editable TYPE CHAR USING editable::char;

ALTER TABLE settings ALTER COLUMN editable SET DEFAULT  'y';

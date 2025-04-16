DELETE FROM schematrondes WHERE iddes IN (SELECT id FROM schematron WHERE schemaname = 'iso19115-3');
DELETE FROM schematroncriteria WHERE group_schematronid IN (SELECT id FROM schematron WHERE schemaname = 'iso19115-3');
DELETE FROM schematroncriteriagroup WHERE schematronid IN (SELECT id FROM schematron WHERE schemaname = 'iso19115-3');
DELETE FROM schematron WHERE schemaname = 'iso19115-3';

SELECT ndiventanilla
FROM ventanilla Natural Join ev_asignado
WHERE EXTRACT (YEAR FROM dfecha_a) > '2007' and sestado = 'en servicio'
ORDER BY dfecha_a
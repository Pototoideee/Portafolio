SELECT *
FROM Seminario_ciencia..steam_topgames;

--Seleccionamos las valores que necesitamos

SELECT Game, Cant_jugadores,Pico_jugadores, Ultimos_30_dias 
FROM Seminario_ciencia..steam_topgames;

--La columna Ultimos 30 dias es la sumatoria de las horas totales jugadas por todos los jugadores del ultimo mes.
--Necesitamos dividirlo por 30 para saber en promedio cuantas horas totales jugadas generan todos los jugadores.

SELECT Game, (Ultimos_30_dias/30) AS Horas_promedio_totales
FROM Seminario_ciencia..steam_topgames;

-- Creamos la columna Horas promedio totales

ALTER TABLE  Seminario_ciencia..steam_topgames  ADD  Horas_promedio_totales FLOAT;

UPDATE Seminario_ciencia..steam_topgames SET Horas_promedio_totales = Ultimos_30_dias/30;

-- Ahora necesitamos dividir la cantidad de jugadores con las horas totales por dia para obtener
--las horas promedio jugadas por día por jugador y crear otra columna llamada Horas promedio por dia 

ALTER TABLE  Seminario_ciencia..steam_topgames  ADD Horas_promedio_por_dia FLOAT;

UPDATE Seminario_ciencia..steam_topgames SET Horas_promedio_por_dia = Horas_promedio_totales/Pico_jugadores;

--Los numeros tan altos pueden explicarse porque Steam registra como horas jugadas el tiempo que las
--personas permanecen conectadas a la plataforma, no necesariamente jugando pero si con el juego corriendo. 

-- Procedemos a agrupar las 250 filas en grupos de diez, de menor a mayor.

SELECT Horas_promedio_por_dia
FROM Seminario_ciencia..steam_topgames;

-- Este metodo me dio un error. Se ve que la clusula NTILE no puede usarse en SLECT y GROUP By simultaneamente.
-- Hay que separarlas con un sub query

SELECT NTILE(25) OVER (ORDER BY Horas_promedio_por_dia DESC) AS grupo, SUM(Horas_promedio_por_dia) AS suma
FROM Seminario_ciencia..steam_topgames
GROUP BY NTILE(25) OVER (ORDER BY Horas_promedio_por_dia DESC);

-- Sumamos y armamos los grupos
SELECT grupo, SUM(Horas_promedio_por_dia) AS suma
FROM (
    SELECT NTILE(25) OVER (ORDER BY Horas_promedio_por_dia DESC) AS grupo, Horas_promedio_por_dia
    FROM Seminario_ciencia..steam_topgames
) subquery
GROUP BY grupo;

--Hacemos el promedio por grupo

SELECT grupo, (SUM(Horas_promedio_por_dia)/50) AS promedio_grupo
FROM (
    SELECT NTILE(5) OVER (ORDER BY Horas_promedio_por_dia DESC) AS grupo, Horas_promedio_por_dia
    FROM Seminario_ciencia..steam_topgames
) subquery
GROUP BY grupo;





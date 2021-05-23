-- Item2.a) Definir uma visão útil a seu universo de discurso, envolvendo no mínimo 2 tabelas

-- A visão abaixo une os dados sobre um problema resolvido em uma determinada corridas_de_problemas
-- com os dados da corrida
create view view_problemas_corrida as
select *
from problemas_corrida
	join problemas using(id_problema)
	join corridas_de_problemas using(id_corrida);


-- Item2.b) Definir um conjunto de 10 consultas úteis e variadas sobre seu Sistema de Informação, sendo que cada uma
-- delas deve envolver no mínimo 3 tabelas (uma visão conta com uma tabela). Os requisitos quantitativos são:

-- a. No mínimo duas delas devem necessitar serem respondidas com a cláusula group by (isto é, a resposta deve
-- combinar atributos e totalizações sobre grupos ). Uma delas deve incluir também a cláusula Having.

    -- Mostra a quantidade de GMs na modalidade Rapid de cada Clube com mais de X GMs nessa modalidade
    -- USUARIOS x FILIACAO_CLUBE x CLUBES
    -- HAVING e GROUP BY
    SELECT COUNT(usuarios.nome_de_usuario) as rapid_gms, nome_clube, clubes.descricao
	  FROM usuarios
	  JOIN filiacao_clube ON usuarios.nome_de_usuario=filiacao_clube.nome_de_usuario
	  JOIN clubes ON nome_clube=clubes.nome
	  WHERE (usuarios.glicko_rapid > 2500)
	  GROUP BY nome_clube, clubes.descricao
	  HAVING COUNT(usuarios.nome_de_usuario) > 0
	  
    -- PRA TESTAR:
    insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
    values ('cecilia',  'ceci@outlook.com', 'FRA', '2dchto098t3', 2678);
    
    insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
    values ('michael',  'michael@outlook.com', 'USA', '2dchttrv8t3', 2700);
    
    insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
    values ('jorge',  'jorge@outlook.com', 'BRA', '468httrv8t3', 2643);
    
    insert into Filiacao_Clube values ('cecilia', false, 'Enxadristas Otakus');
    insert into Filiacao_Clube values ('michael', false, 'FIDE GMs');
    insert into Filiacao_Clube values ('jorge', false, 'FIDE GMs');
    
    -- Vitorias como brancas de cada usuario em cada torneio
    -- Usuarios x Partidas x Torneios
    SELECT COUNT(partidas.resultado) as vitorias_como_brancas, usuarios.nome_de_usuario, torneios.titulo
	FROM usuarios
	JOIN partidas ON partidas.jogador_brancas=usuarios.nome_de_usuario
	JOIN participacao_torneio ON participacao_torneio.nome_de_usuario=usuarios.nome_de_usuario
	JOIN torneios ON torneios.id_torneio=participacao_torneio.id_torneio
	WHERE partidas.resultado = 'brancas'
	GROUP BY usuarios.nome_de_usuario, torneios.titulo
	
	-- PRA TESTAR
	insert into Partidas values ('d7a23241-d749-4aca-94ff-6d44e9fd1a48', 'brancas', '2021-03-28T20:25:15+00:00', 'caruana', 'magnus', '32e64910-c824-4060-8054-0c80ccc2d072', 100, 100);
    insert into Partidas values ('473448d4-efd3-43c9-8708-e0a38c3f6601', 'pretas', '2021-03-28T20:25:15+00:00', 'caruana', 'magnus', 'c9309e01-832b-4eee-a6d5-9642327537f3', 100, 100);
    insert into Partidas values ('fc32a023-69c4-41a6-94a7-3cf2f6ec7f79', 'pretas', '2021-03-28T20:25:15+00:00', 'magnus', 'bobbyfischer', '9b82a31d-d546-4417-bbeb-eacd100f6177', 100, 100);


-- b. No mínimo duas delas devem necessitar serem respondidas com subconsulta (isto é, não existe formulação
-- equivalente usando apenas joins);

    -- Clubes em comum entre 2 usuários
    -- Usuarios x Filiacao_Clube x Clubes
    select Clubes.nome
    from Filiacao_Clube
    	join Usuarios using(nome_de_usuario)
    	join Clubes on Clubes.nome = Filiacao_Clube.nome_clube
    where nome_de_usuario = 'bobbyfischer'
    and Clubes.nome in (
    	select Clubes.nome
    	from Filiacao_Clube
    		join Usuarios using(nome_de_usuario)
    		join Clubes on Clubes.nome = Filiacao_Clube.nome_clube
    	where nome_de_usuario = 'magnus'
    );
    
    -- Torneios onde não participaram jogadores da nacionalidade X
    -- Participacao_torneio x Torneios x Jogadores
    select distinct Torneios.titulo
    from Torneios
    	left join Participacao_Torneio using(id_torneio)
    	left join Usuarios using(nome_de_usuario)
    where Torneios.titulo not in (
    	select distinct Torneios.titulo
    	from Participacao_Torneio
    		join Torneios using(id_torneio)
    		join Usuarios using(nome_de_usuario)
    	where Usuarios.nacionalidade = 'USA'
    );

-- c. No mínimo uma delas (diferente das consultas acima) deve necessitar do operador NOT EXISTS para
-- responder questões do tipo TODOS ou NENHUM que <referencia> (isto é, não existe formulaçãoo
-- equivalente usando simplemente joins ou subconsultas com (NOT) IN ou demais operadores relacionais)

    -- Torneios onde nenhuma partida empatou
    -- Partida_Torneio x Torneios x Partidas
    select distinct Torneios.titulo
    from Torneios
    	left join Partida_Torneio using(id_torneio)
    where NOT EXISTS (
    	select distinct Partidas.id_partida
    	from Partida_Torneio
    		join Partidas using(id_partida)
    	where Partida_Torneio.id_torneio = Torneios.id_torneio
    		and Partidas.resultado = 'empate'
    );


-- d. No mínimos duas delas devem utilizar a visão definida no item anterior.

    -- TODO: Membros do clube X que ja resolveram problemas do tema Y em corridas de problemas
    
    -- TODO: 


-- Outras 3 quaisquer


    -- Invictos no Mundial de Xadrez
    -- Usuarios x Partidas x Torneios
    select usuarios.nome_de_usuario as invictos_mundial_de_xadrez
    from usuarios 
    where nome_de_usuario not in (
        select partidas.jogador_brancas
        from partidas 
            join partida_torneio on partida_torneio.id_partida = partidas.id_partida
            join torneios on torneios.id_torneio = partida_torneio.id_torneio
        where partidas.resultado = 'pretas' 
            and torneios.titulo = 'Torneio Mundial de Xadrez'
        union
            select partidas.jogador_pretas
            from partidas
                join partida_torneio on partida_torneio.id_partida = partidas.id_partida
                join torneios on torneios.id_torneio = partida_torneio.id_torneio
            where partidas.resultado = 'brancas' 
                and torneios.titulo = 'Torneio Mundial de Xadrez'
    )
        and nome_de_usuario in (
            select nome_de_usuario
                from participacao_torneio
                    join torneios on participacao_torneio.id_torneio=torneios.id_torneio
                where torneios.titulo='Torneio Mundial de Xadrez'
        )
        
    -- Quantidade de problemas resolvidos em cada batalha de problemas
    -- problemas x problemas_batalha x batalhas_de_problemas
    select count(problemas.id_problema), batalhas_de_problemas.id_batalha
    from problemas
    join problemas_batalha on problemas_batalha.id_problema = problemas.id_problema
    join batalhas_de_problemas on batalhas_de_problemas.id_batalha = problemas_batalha.id_batalha
    group by batalhas_de_problemas.id_batalha

    -- 


-- e. Sua base de dados deve estar populada de forma a retornar resultados para todas consultas. Recomenda-se
-- que as instâncias sejam pensadas para testar se as consultas estão corretas, abrangendo vários resultados.


-- f. As consultas devem ser significativamente distintas entre si. Será considerada a utilidade e diversidade das
-- consultas


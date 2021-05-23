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
    -- Usuarios x Filiacao_Clube x Clubes
    -- having e group by
    select count(usuarios.nome_de_usuario) as rapid_gms, nome_clube, clubes.descricao
    from usuarios
    join filiacao_clube on usuarios.nome_de_usuario=filiacao_clube.nome_de_usuario
    join clubes on nome_clube=clubes.nome
    where (usuarios.glicko_rapid > 2500)
    group by nome_clube, clubes.descricao
    having count(usuarios.nome_de_usuario) > 0
    
    -- Vitorias como brancas de cada usuario em cada torneio
    -- Usuarios x Partidas x Torneios
    select count(partidas.resultado) as vitorias_como_brancas, usuarios.nome_de_usuario, torneios.titulo
    from usuarios
        join partidas on partidas.jogador_brancas=usuarios.nome_de_usuario
        join partida_torneio on partida_torneio.id_partida=partidas.id_partida
        join torneios on torneios.id_torneio=partida_torneio.id_torneio
    where partidas.resultado = 'brancas'
    group by usuarios.nome_de_usuario, torneios.titulo

    -- vitorias de cada usuario com cada cor em cada torneio
    select nome_de_usuario,
        sum(vitorias_como_brancas) as vitorias_como_brancas, 
        sum(vitorias_como_pretas) as vitorias_como_pretas, 
        titulo 
        from (
        select count(partidas.resultado) as vitorias_como_brancas, 
            0 vitorias_como_pretas, 
            usuarios.nome_de_usuario, 
            torneios.titulo
        from usuarios
            join partidas on partidas.jogador_brancas=usuarios.nome_de_usuario
            join partida_torneio on partida_torneio.id_partida=partidas.id_partida
            join torneios on torneios.id_torneio=partida_torneio.id_torneio
        where partidas.resultado = 'brancas'
        group by usuarios.nome_de_usuario, torneios.titulo
        union 
        select 0, 
            count(partidas.resultado) as vitorias_como_pretas, 
            usuarios.nome_de_usuario, 
            torneios.titulo
        from usuarios
            join partidas on partidas.jogador_pretas=usuarios.nome_de_usuario
            join partida_torneio on partida_torneio.id_partida=partidas.id_partida
            join torneios on torneios.id_torneio=partida_torneio.id_torneio
        where partidas.resultado = 'pretas'
        group by usuarios.nome_de_usuario, torneios.titulo
        ) as union_vitorias_brancas_pretas 
        group by titulo, nome_de_usuario
        order by titulo
  
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
-- responder questões do tipo TODOS ou NENHUM que <referencia> (isto é, não existe formulação
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

    -- Membros do clube X que ja resolveram problemas do tema Y em corridas de problemas
    -- usuarios x filiacao_clube x view_problemas_corrida
    select usuarios.nome_de_usuario, filiacao_clube.nome_clube, view_problemas_corrida.tema, view_problemas_corrida.id_corrida
    from usuarios
        join filiacao_clube on filiacao_clube.nome_de_usuario=usuarios.nome_de_usuario
        join view_problemas_corrida on usuario=usuarios.nome_de_usuario
    where filiacao_clube.nome_clube = 'FIDE GMs' and view_problemas_corrida.tema='en-passant'
    
    -- Dificuldade media dos problemas resolvidos por membros de determinado clube
    select avg(view_problemas_corrida.dificuldade) as glicko_medio_dos_problemas_resolvidos_pelos_membros, nome_clube
    from usuarios
        join filiacao_clube on filiacao_clube.nome_de_usuario=usuarios.nome_de_usuario
        join view_problemas_corrida on usuario=usuarios.nome_de_usuario
    where filiacao_clube.nome_clube = 'FIDE GMs'
    group by nome_clube

-- Outras 3 quaisquer

    -- Invictos no Mundial de Xadrez
    -- Usuarios x Partidas x Torneios
    select usuarios.nome_de_usuario as invictos, titulo as torneio
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

    -- Numero de partidas jogadas por cada usuario para uma dada modalidade
    -- partidas x usuarios x formatos_partida
    select nome_de_usuario, count(id_partida)
    from (
        select id_partida, nome_de_usuario, modalidade
        from partidas
            join usuarios on partidas.jogador_pretas = usuarios.nome_de_usuario
            join formatos_partida using(id_formato)
        union
        select id_partida, nome_de_usuario, modalidade
        from partidas
            join usuarios on partidas.jogador_brancas = usuarios.nome_de_usuario
            join formatos_partida using(id_formato)
    ) as partidas_usuario
    where modalidade = 'blitz'
    group by nome_de_usuario;

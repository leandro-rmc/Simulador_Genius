Algoritmo "Genius 1.1"
// Disciplina   : Constru��o de Algoritmos
// Professor   : Eug�nio da Silva
// Descri��o   : Simulador do Genius com fun��es novas, como Ranking e Trapa�a
// Autor(a)    : Leandro Rocha Musser Carneiro
// E-mail      : leandro.musser@gmail.com
// Data atual  : 9/13/2019

const
   //Indica de quantos em quantos elementos o vetor sequ�ncia aumentar�.
   AUMENTO_ELEMENTOS = 2
   
   COR_INICIAL = "branco"
   
   //O valor base do delay entre cada elemento desenhado na tela (o quadrado).
   DELAY_LISTA_ELEMENTOS = 400
   
   //C�digos de cada dificuldade. Os n�meros s�o usados tamb�m na f�rmula...
   //...de velocidade. Quanto maior o n�mero, mais r�pido os elementos...
   //...aparecer�o e desaparecer�o da tela.
   DIFICULDADE_FACIL = 1
   DIFICULDADE_MEDIA = 2
   DIFICULDADE_DIFICIL = 3
   
   //Limite m�ximo de quanto o vetor sequ�ncia pode ter de tamanho.
   //Foi pedido pelo professor o valor 10 e n�o pode ser mudado.
   MAX_ELEMENTOS = 10
   
   //M�ximo de escolhas poss�veis que o usu�rio deve memorizar.
   //No c�digo s�o gerados n�meros aleat�rios que representam qual das...
   //...luzes do Genius acendeu. Como s� h� 4 luzes, esse � o limite.
   MAX_ESCOLHAS = 4
   
   //Tamanho m�ximo do ranking. � um top 10.
   MAX_RANKING = 10
   
  //Mostra as trapa�as dispon�veis com o comando 'ajuda' apenas se...
  //Simula uma esp�cie de modo de desenvolvedor ou modo de testes.
  //Seria desativado ao entregar para o jogador real.
   MOSTRAR_TRAPACAS = verdadeiro
   
   //Para evitar repeti��o e manter um padr�o, esse texto � exibido sempre...
   //...que o usu�rio precisar inserir algum comando.
   TEXTO_CAIXA_DE_TEXTO = "- Seu comando: "
   
   //Constantes criadas para reduzir o que chamamos de 'n�meros m�gicos'...
   //...dentro do c�digo. Ao acessar a matriz de trapa�as, pode se...
   //...usar as constantes para acessar algo espec�fico.
   TRAPACA_ATIVADA = 4
   TRAPACA_COMANDO = 3
   TRAPACA_DESCRICAO = 2
   TRAPACA_NOME = 1
   TRAPACA_CONTINUA = 5
   TRAPACA_OLHO_MILENIO = 1
   TRAPACA_POTE_GANANCIA = 2
   
   //Informa o tamanho do n�mero de trapa�as da matriz.
   QUANTIDADE_TRAPACAS = 3

//Inicialmente seria usado um registro para as trapa�as.
//Infelizmente, o visualg gera um erro aleat�rio ao usar registro muitas vezes.
//O erro � mais f�cil de ser detectado em c�digos mais complexos ou...
//...utiliza��o de breakpoints, passando por cima dos comandos de acesso ao...
//...registro. O erro � completamente ALEAT�RIO e pode acontecer vez sim, vez n�o.

//Tipo
   //t_trapaca = registro
      //nome: caractere
      //texto: caractere
      //comando: caractere
      //estaAtivada: logico
      //eContinua: logico
   //fimregistro

Var
   dificuldade, placar, totalElementos, round, totalRanking: inteiro
   sequencia: vetor[1..MAX_ELEMENTOS] de inteiro
   escolhasPossiveis: vetor[1..MAX_ESCOLHAS] de caractere
   //trapacas: vetor[1..QUANTIDADE_TRAPACAS] de t_trapaca
   nomeJogador: caractere
   ranking: vetor[1..MAX_RANKING, 1..2] de caractere

//Propriedades de Y:
//1 = Nome, 2 = Descri��o, 3 = Comando, 4 = Ativado?, 5 = Efeito Continuo?
trapacasM: vetor[1..QUANTIDADE_TRAPACAS, 1..5] de caractere

procedimento listarRanking()
var i: inteiro
inicio
      para i de 1 ate totalRanking faca
         escreval("Nome: ",ranking[i,1]," | Pontos: ", ranking[i,2])
      fimpara

fimprocedimento

//Este procedimento � sempre chamado quando a pessoa DEVE ser inserida...
//...no ranking, pois j� foram feitas verifica��es anteriores.
procedimento inserirNoRanking(nome, pontosObtidos: caractere)
var posicao: inteiro
inicio
      //Se o ranking estiver vazio, o primeiro lugar ser� usado...
      //...para o primeiro que entrar no ranking.
      se (totalRanking = 0) entao
         posicao <- 1
         //Aumenta o n�mero de pessoas no ranking
         totalRanking <- totalRanking + 1
      senao
         //Caso tenha j� pessoas no ranking, mas tenha espa�o vazio nele,...
         //...o usu�rio ser� inserido na mesma posi��o da �ltima pessoa + 1.
         se (totalRanking < MAX_RANKING) entao
            posicao <- totalRanking + 1
            totalRanking <- totalRanking + 1
            senao
               //Caso o ranking esteja cheio, a pessoa ocupar� o lugar da �ltima.
               //� exatamente como ocorre em um ranking normal.
               posicao <- MAX_RANKING
         fimse
      fimse
      
      ranking[posicao,1] <- nome
      ranking[posicao,2] <- pontosObtidos
      //Chama o procedimento que ordena o vetor em ordem decrescente.
      rankingMaiorParaMenor()
      
fimprocedimento

funcao checarRanking(pontosObtidos: inteiro): logico
inicio
     retorne falso
     //Verifica se h� espa�o vazio no ranking. Se sim, qualquer pontua��o...
     //...poder� entrar no ranking, mas n�o pode ser 0.
     se ((totalRanking < MAX_RANKING) e (pontosObtidos > 0)) entao
        retorne verdadeiro
     senao
          //Caso o ranking esteja cheio, s� obtendo uma pontua��o superior...
          //...a de algu�m para entrar, ent�o ele verificar� aqui.
          //Desta forma comentada abaixo est� dando erro no Visualg... Verificar depois
          //se ((pontosObtidos > 0) e (totalRanking > 0) e (Caracpnum(ranking[totalRanking,2]) < pontosObtidos)) entao
          //    retorne verdadeiro
          //fimse
          se (pontosObtidos > 0) entao
             se (totalRanking > 0) entao
                se (Caracpnum(ranking[totalRanking,2) < pontosObtidos) entao
                   retorne verdadeiro
                fimse
             fimse
          fimse
     fimse
fimfuncao

procedimento rankingMaiorParaMenor()
var i,j: inteiro
temp, temp2: caractere
inicio
      //Como trata-se de um jogo simples e feito com tempo...
      //...limitado, n�o estou aplicando um m�todo...
      //...mais complexo para a organiza��o dos vetores. Neste m�todo, a cada...
      //...inser��o, o vetor � completamente organizado, mesmo que...
      //...precisasse apenas mover determinados elementos 1 �ndice para frente...
      //...e antes eliminando o que era o �ltimo (se necess�rio).

      i <- 1
      j <- 1

      //Bubble Sort para organizar o vetor do Ranking.
      para i de 1 ate totalRanking faca
         para j de 1 ate totalRanking - 1 faca
           se (Caracpnum(ranking[j,2]) < Caracpnum(ranking[j+1,2])) entao
              temp <- ranking[j+1,2]
              temp2 <- ranking[j+1,1]
              ranking[j+1,2] <- ranking[j,2]
              ranking[j+1,1] <- ranking[j,1]
              ranking[j,2] <- temp
              ranking[j,1] <- temp2
           fimse
         fimpara
      fimpara

fimprocedimento

procedimento alertaCor(cor: caractere; duracao: inteiro)
inicio
      mudacor(cor, "frente")
      timer duracao
      timer 0
      mudacor(COR_INICIAL, "frente")
fimprocedimento

procedimento montarLinhaVaziaVisualGenius()
inicio
      //Para evitar repeti��es desnecess�rias.
      //Uma das linhas SEMPRE estar� vazia.
      escreval("��          �          ��")
      escreval("��          �          ��")
      escreval("��          �          ��")
      escreval("��          �          ��")
      escreval("��          �          ��")
fimprocedimento

procedimento montarQuadradosVaziosVisualGenius()
inicio
      //Faz parte do procedimento de desenho
      //Usado para evitar repeti��o de c�digo
      escreval("�������������������������")
      montarLinhaVaziaVisualGenius()
      escreval("�������������������������")
      montarLinhaVaziaVisualGenius()
      escreval("�������������������������")
fimprocedimento

procedimento montarVisualGenius(posicao: inteiro; duracao: inteiro)
inicio
      //Este procedimento de montar os quadrados seguem uma l�gica.
      //N�o � apenas um monte de escreval repetido.
      //Por�m, ser� mesmo que que � melhor uma l�gica mais complexa...
      // do que repeti��o de c�digo?
      mudacor(COR_INICIAL,"frente")
      montarQuadradosVaziosVisualGenius()
      timer duracao
      timer 0
      limpatela
      escreval("�������������������������")

      se ((posicao = 3) ou (posicao = 4)) entao
         montarLinhaVaziaVisualGenius()
         escreval("�������������������������")
      fimse

      se ((posicao = 1) ou (posicao = 3)) entao
         escreval("�������������          ��")
         escreval("����     ����          ��")
         escreval("���� ",posicao,"  ����          ��")
         escreval("����     ����          ��")
         escreval("�������������          ��")
      fimse

      se ((posicao = 2) ou (posicao = 4)) entao
         escreval("��          �������������")
         escreval("��          ����     ����")
         escreval("��          ���� ",posicao,"  ����")
         escreval("��          ����     ����")
         escreval("��          �������������")
      fimse

      se ((posicao = 1) ou (posicao = 2)) entao
         escreval("�������������������������")
         montarLinhaVaziaVisualGenius()
      fimse
      escreval("�������������������������")

      se (dificuldade < 3) entao
         escolha(posicao)
            caso 1
                 mudacor("verde","frente")
            caso 2
                 mudacor("vermelho","frente")
            caso 3
                 mudacor("amarelo","frente")
            caso 4
                 mudacor("azul","frente")
         fimescolha
       fimse
      timer duracao
      timer 0
      mudacor(COR_INICIAL,"frente")
fimprocedimento

procedimento mostrarElementos()
var i: inteiro
inicio
   para i de 1 ate totalElementos faca
        //O delay entre cada elemento usa a f�rmula abaixo.
        //Quanto maior a dificuldade, maior seu c�digo, ent�o menor o delay.
        limpatela
        montarVisualGenius(sequencia[i], DELAY_LISTA_ELEMENTOS - 100 * dificuldade)

   fimpara
   limpatela
fimprocedimento

procedimento addElementoAleatorio(quantidade: inteiro)
var i: inteiro
inicio
      para i de 1 ate quantidade faca
           //Se o vetor de sequencia estiver cheio, n�o dar� para...
           //..inserir mais elementos e dar� erro se n�o tivesse a compara��o.
           se (totalElementos < MAX_ELEMENTOS) entao
              sequencia[totalElementos + 1] <- randi(MAX_ESCOLHAS) + 1
              totalElementos <- totalElementos + 1
           fimse
      fimpara
fimprocedimento

procedimento alertar(msg: caractere; duracao: inteiro)
inicio
      //Procedimento usado para enviar uma mensagem importante na tela.
      limpatela
      escreva(msg)
      timer duracao
      timer 0
      limpatela
fimprocedimento

procedimento controlarTrapacas(comando: caractere)
var i: inteiro
inicio
      //Convers�o para mai�sculo para facilitar
      comando <- Maiusc(comando)
      //Passa por cada trapa�a da matriz
      para i de 1 ate QUANTIDADE_TRAPACAS faca
           //Compara na matriz se o comando digitado pelo usu�rio � o...
           //...comando usado para ativar a trapa�a.
           se (comando = trapacasM[i, TRAPACA_COMANDO]) entao
               se (trapacasM[i, TRAPACA_ATIVADA] = "verdadeiro") entao


                  trapacasM[i, TRAPACA_ATIVADA] <- "falso"
                  escreval("")
                  escreval("-----------------------------------------")
                  escreval("Trapa�a desativada: ",trapacasM[i, TRAPACA_NOME],".")
                  escreval("-----------------------------------------")
               senao
                  //Trapa�as N�O continuas s�o aquelas em que o efeito n�o...
                  //...permanece ativado, causando um efeito at� que seja...
                  //...desativado. Exemplo: Ganhar 500 pontos.
                  //Trapa�as asim n�o podem ser desativadas, por isso a verifica��o.
                  se (trapacasM[i, TRAPACA_CONTINUA] = "verdadeiro") entao
                     trapacasM[i, TRAPACA_ATIVADA] <- "verdadeiro"
                  fimse
                  escreval("")
                  escreval("-----------------------------------------")
                  escreval("Trapa�a ativada: ",trapacasM[i, TRAPACA_NOME],".")
                  escreval(trapacasM[i, TRAPACA_DESCRICAO])
                  //Se a trapa�a ativada for TRAPACA_POTE_GANANCIA, o efeito �...
                  //...aplicado imediatamente.
                  se (i = TRAPACA_POTE_GANANCIA) entao
                     placar <- placar + 200
                     escreval("Seu placar atualizado �:",placar," pontos.")
                  fimse
                  escreval("-----------------------------------------")
               fimse
           fimse
      fimpara



fimprocedimento

procedimento desenharQuadradoDemonstrativo()
inicio
    //Desenha o quadrado que aparece durante o jogo principal, ao pedir para...
    //..o usu�rio digitar um n�mero de 1 a 4. Tamb�m � desenhado ao digitar...
    //..o comando 'bloco'.
    escreval("�������������������������")
    escreval("��          �          ��")
    //Caso esteja na dificuldade mais dif�cil, as cores ser�o removidas.
    se (dificuldade < 3) entao
       escreval("��    1     �    2     ��")
       escreval("��  Verde   � Vermelho ��")
    senao
       escreval("��    1     �     2    ��")
       escreval("��    _     �     _    ��")
    fimse
    escreval("��          �          ��")
    escreval("�������������������������")
    escreval("��          �          ��")
    //Caso esteja na dificuldade mais dif�cil, as cores ser�o removidas.
    se (dificuldade < 3) entao
       escreval("��    3     �    4     ��")
       escreval("�� Amarelo  �   Azul   ��")
    senao
       escreval("��    3     �    4     ��")
       escreval("��    _     �    _     ��")
    fimse
    escreval("��          �          ��")
    escreval("�������������������������")
fimprocedimento

procedimento controlarRanking()
inicio
    //Verifica se a dificuldade � a correta para poder entrar no ranking...
    //...e envia o placar para a fun�ao de checagem.
    se ((checarRanking(placar)) e (dificuldade = 2)) entao
       inserirNoRanking(nomeJogador,Numpcarac(placar))
       escreval(nomeJogador,", voc� conseguiu uma posi��o no Ranking.")
    fimse
fimprocedimento

procedimento resetarVariaveisDeJogo()
inicio
    //Reseta todas as vari�veis de controle do jogo para iniciar um novo jogo.
    placar <- 0
    round <- 0
    totalElementos <- 0
fimprocedimento

procedimento controlarJogoNoModoSozinho()
var i, elementoEscolhido, opcaoEscolhida: inteiro
digitado: caractere
jogando: logico
velocidadeDificuldade: inteiro
inicio
    //Este reset inicializa um novo jogo.
    resetarVariaveisDeJogo()
    //A velocidade de cada dificuldade nada mais � do que 100 vezes...
    //...o c�digo da dificuldade (que foi inserido no...
    //...'controlarMenuModoSozinho()'). Resultar� em um valor em ms que ser�...
    //...usado como delay entre os elementos da tela.
    velocidadeDificuldade <- 100 * dificuldade
    jogando <- verdadeiro
    se (dificuldade = 2) entao
       repita
         limpatela
         escreval("O modo oficial precisa do seu nome para te colocar no Ranking.")
         escreval("Digite o seu nome.")
         escreva(TEXTO_CAIXA_DE_TEXTO)
         leia(nomeJogador)
       ate (nomeJogador <> "")
    fimse
    alertar("Iniciando jogo...", 1200)
    
    //S� sair� daqui de dentro quando o jogo terminar de alguma forma.
    enquanto (jogando = verdadeiro) faca
       i <- 1
       //Adiciona uma quantidade de elementos aleat�rios dentro do vetor
       //A quantidade � definida pela constante AUMENTO_ELEMENTOS
       addElementoAleatorio(AUMENTO_ELEMENTOS)
       //Mostra na tela todos os elementos de dentro do vetor
       mostrarElementos()
       round <- round + 1
       desenharQuadradoDemonstrativo()
       escreval("")
       escreval("[Round:",round," | Placar:",placar," pontos]")
       escreval("Digite o comando 'ajuda' para ver alguns comandos.")
       escreval("")
       //Repete um n�mero de vezes igual ao n�mero de elementos do vetor...
       //...sequencia. Aqui ele percorrer� elemento por elemento e o usu�rio...
       //...ter� que digitar o c�digo correspondente.
       enquanto (i <= totalElementos) faca
                //Verifica se uma determinada trapa�a est� ativada.
                //Caso esteja, o comando ser� executado aqui.
                //No caso, a resposta aparecer� acima da mensagem de digitar...
                //...o n�mero.
                se (trapacasM[TRAPACA_OLHO_MILENIO, TRAPACA_ATIVADA] = "verdadeiro") entao
                   escreval("Resposta:",sequencia[i],".")
                fimse
                escreval("Digite o n�mero do ",i,"� bloco que foi ativado:")
                escreva(TEXTO_CAIXA_DE_TEXTO)
                leia(digitado)
                escolha (digitado)
                   //Faz uma 'convers�o' de caracter para inteiro
                   //Como � permitido digitar outros tipos de comandos...
                   //..., sem ser n�meros, n�o � bom usar Caracpnum()
                   caso "1"
                        elementoEscolhido <- 1
                   caso "2"
                        elementoEscolhido <- 2
                   caso "3"
                        elementoEscolhido <- 3
                   caso "4"
                        elementoEscolhido <- 4
                   outrocaso
                        elementoEscolhido <- -1
                fimescolha

                //Se n�o foi digitado um n�mero de 1 a 4, ent�o pode ser...
                //...um comando v�lido ou inv�lido.
                //O usu�rio n�o perder� o jogo ao digitar um comando inv�lido.
                se ((elementoEscolhido <> 1) e (elementoEscolhido <> 2) e (elementoEscolhido <> 3) e (elementoEscolhido <> 4)) entao
                   elementoEscolhido <- -1
                fimse
                se (elementoEscolhido = -1) entao
                    //Se o usu�rio apenas aprtou enter, o jogo nem verificar�...
                    //...se isso � um comando de trapa�a.
                    se (digitado <> "") entao
                       //Envia o comando digitado para o procedimento de trapa�as.
                       controlarTrapacas(digitado)
                    fimse

                    //Maiusc � usado para retirar o case-sensitive, convertendo...
                    //...tudo para mai�sculo.
                    se (Maiusc(digitado) = "AJUDA") entao
                       escreval("")
                       escreval("Comandos dispon�veis: ")
                       escreval("")
                       escreval("Voltar ao menu anterior: 'sair'")
                       escreval("Mostrar o bloco de demonstra��o na tela: 'bloco'")

                       //Mostra as trapa�as dispon�veis no menu apenas se...
                       //...a constante for verdadeira. Simula uma esp�cie...
                       //...de modo de desenvolvedor ou modo de testes.
                       //Seria desativado ao entregar para o jogador real.
                       se (MOSTRAR_TRAPACAS = verdadeiro) entao
                          escreval("")
                          escreval("Visualiza��o deve ser desativada ao entregar para o usu�rio:")
                          escreval("[TRAPA�A] Ver todas as respostas: 'baguvix'")
                          escreval("[TRAPA�A] Ganhar 200 pontos: 'ripazha'")
                       fimse
                    fimse

                    se (Maiusc(digitado) = "SAIR") entao
                       jogando <- falso
                       interrompa
                    fimse

                    se (Maiusc(digitado) = "BLOCO") entao
                       escreval("")
                       desenharQuadradoDemonstrativo()
                    fimse
                    i <- i - 1
                senao
                   //Se o usu�rio digitou um comando de 1 a 4, esse bloco...
                   //...ir� ser executado.
                   se (elementoEscolhido <> sequencia[i]) entao
                      escreval("")
                      escreval("Voc� errou!")
                      escreval("Sua pontua��o foi de:",placar," pontos.")
                      //Verifica nas vari�veis locais e no vetor ranking se...
                      //H� a possibilidade de o usus�rio ter entrado no ranking...
                      //... ent�o ele � inserido l�, caso sim.
                      controlarRanking()
                      timer 1200
                      timer 0
                      //Reseta tudo para preparar um novo jogo.
                      resetarVariaveisDeJogo()
                      escreval("")
                      repita
                            escreval("Recome�ar? (1) Sim - (2) N�o")
                            escreva(TEXTO_CAIXA_DE_TEXTO)
                            leia(opcaoEscolhida)
                            se (opcaoEscolhida = 2) entao
                               //O 'enquanto' principal deixar� de funcionar ao...
                               //..atribuir falso � vari�vel 'jogando'.
                               //Ap�s isso, ele ir� para o fim do procedimento...
                               //Assim, retornando para o menu anterior (que...
                               //...� um procedimento que o chamou).
                               jogando <- falso
                               interrompa
                            fimse
                            escreval("")
                      ate ((opcaoEscolhida = 1) ou (opcaoEscolhida = 2))
                   fimse
                   //Se o usu�rio acertou o �ltimo elemento � porque ele acertou...
                   //...todos os anteriores. N�o tem como ser diferente.
                   //Portanto ele receber� pontua��o e novos elementos ser�o...
                   //...adicionados ao vetor sequencia.
                   se ((elementoEscolhido = sequencia[i]) e (totalElementos = i)) entao
                      placar <- placar + totalElementos
                      escreval("")
                      //MAX_ELEMENTOS � o limite de 10 elementos pedido pelo...
                      //...professor.
                      se (totalElementos >= MAX_ELEMENTOS) entao
                         escreval("Voc� atingiu a pontua��o m�xima, parab�ns!")
                         escreval("Sua pontua��o foi de:",placar," pontos.")
                         mostrarCreditos()
                         escreval("")
                         controlarRanking()
                         
                         totalElementos <- 0
                         repita
                               escreval("Jogar de novo? (1) Sim - (2) N�o")
                               escreva(TEXTO_CAIXA_DE_TEXTO)
                               leia(opcaoEscolhida)
                               se (opcaoEscolhida = 2) entao
                                  jogando <- falso
                                  interrompa
                               fimse
                               escreval("")
                         ate ((opcaoEscolhida = 1) ou (opcaoEscolhida = 2))
                      senao
                           escreval("Correto! Pr�ximo round...")
                      fimse
                      timer 1200
                      timer 0
                   fimse
                fimse
                i <- i + 1
                escreval("")
       fimenquanto
    fimenquanto
    limpatela
fimprocedimento

procedimento controlarMenuModoSozinho()
var
   opcaoEscolhida: inteiro
inicio
      enquanto (verdadeiro) faca
         escreval("[Menu Inicial > Modos de Jogo > Jogar Sozinho]")
         escreval("")
         escreval("Escolha um n�vel de dificuldade para iniciar o jogo.")
         escreval("")
         escreval("(1) Mais f�cil (Mais lento)")
         escreval("(2) Oficial (Permite o uso do Ranking)")
         escreval("(3) Mais dif�cil (Sem cores e mais r�pido)")
         escreval("")
         escreval("(9) Voltar")
         escreval("")
         escreva(TEXTO_CAIXA_DE_TEXTO)
         leia (opcaoEscolhida)
         limpatela
         escolha (opcaoEscolhida)
              caso 1, 2, 3

                   dificuldade <- opcaoEscolhida
                   controlarJogoNoModoSozinho()

                   //Este submenu � parte do anterior e n�o deve ser...
                   //...chamado diretamente, portanto o interrompa jogar� o...
                   //...fluxo para o submenu anterior a este
                   interrompa
              caso 9
                   interrompa
              outrocaso
                  //Alguma coisa
         fimescolha
      fimenquanto
fimprocedimento

procedimento controlarMenuDeModos()
var
   opcaoEscolhida: inteiro
inicio
      enquanto (verdadeiro) faca

         escreval("[Menu Inicial > Modos de Jogo]")
         escreval("")
         escreval("(1) Jogar sozinho")
         escreval("(2) Jogar contra algu�m (Fechado para manuten��o)")
         escreval("")
         escreval("(9) Voltar")
         escreval("")
         escreva(TEXTO_CAIXA_DE_TEXTO)
         leia(opcaoEscolhida)
         limpatela
         //Pula para outro submenu ou interrompe e volta para o menu que...
         //...chamou este.
         escolha (opcaoEscolhida)
              caso 1
                   controlarMenuModoSozinho()
              caso 2
                   //multiplayer
                   //Aqui teria a chamada para um procedimento de multiplayer...
                   //...mas n�o foi criado devido a falta de tempo.
              caso 9
                   interrompa
              outrocaso
                  //Alguma coisa
         fimescolha

      fimenquanto

fimprocedimento

procedimento controlarMenuRanking()
var
   opcaoEscolhida: inteiro
inicio

      enquanto (verdadeiro) faca
         escreval("[Menu Inicial > Ranking]")
         escreval("")
         //Verifica a vari�vel que foi inicializada como 0 logo no in�cio
         //Ela indica a quantidade de pessoas no ranking (quantidade de...
         //...pessoas dentro do vetor.)
         se (totalRanking = 0) entao
            escreval("Nenhum jogador no ranking.")
         senao
            //Lista todas as pessoas que est�o no ranking.
            listarRanking()
         fimse
         escreval("")
         escreva("Aperte enter para voltar...")
         leia(opcaoEscolhida)
         //Limpa a tela antes de voltar ao menu inicial
         //Todo submenu � respons�vel por limpar a tela antes de retornar
         limpatela
         interrompa
      fimenquanto

fimprocedimento

procedimento mostrarCreditos()
inicio
      escreval("Genius 1.1 | Desenvolvido por Leandro Rocha Musser Carneiro.")
      escreval("UEZO - Centro Universit�rio Estadual da Zona Oeste.")
fimprocedimento

procedimento controlarMenuInicial()
var
   opcaoEscolhida: inteiro
inicio

   //Um loop infinito � utilizado para controlar o menu.
   //Poderia ser colocada outra condi��o n�o infinita, como por exemplo...
   //...'enquanto (opcaoEscolhida <> 9)', depois seria s� mover o 'caso 9'...
   //... para depois do loop, mas eu quis manter um padr�o entre os menus.
   enquanto (verdadeiro) faca
      mostrarCreditos()
      escreval("-")
      escreval("")
      escreval("[Menu Inicial]")
      escreval("")
      escreval("(1) Iniciar")
      escreval("(2) Ranking")
      escreval("")
      escreval("(9) Sair")
      escreval("")
      escreva(TEXTO_CAIXA_DE_TEXTO)
      leia (opcaoEscolhida)
      //Limpa a tela para ser redirecionado a outro menu limpo
      limpatela
      escolha (opcaoEscolhida)
              caso 1
                   controlarMenuDeModos()
              caso 2
                   controlarMenuRanking()
              caso 9
                  escreval("Obrigado por jogar o G�nius!")
                  interrompa
      fimescolha
   fimenquanto

fimprocedimento

procedimento inicializarDados()
inicio
      //Inicializa a matriz de trapa�as.
      trapacasM[1, TRAPACA_NOME] <- "Olho do Mil�nio"
      trapacasM[1, TRAPACA_DESCRICAO] <- "Agora voc� pode ver as respostas."
      trapacasM[1, TRAPACA_COMANDO] <- "BAGUVIX"
      trapacasM[1, TRAPACA_ATIVADA] <- "falso"
      trapacasM[1, TRAPACA_CONTINUA] <- "verdadeiro"
      trapacasM[2, TRAPACA_NOME] <- "Pote da Gan�ncia"
      trapacasM[2, TRAPACA_DESCRICAO] <- "Voc� ganhou 200 pontos."
      trapacasM[2, TRAPACA_COMANDO] <- "RIPAZHA"
      trapacasM[2, TRAPACA_ATIVADA] <- "falso"
      trapacasM[2, TRAPACA_CONTINUA] <- "falso"
      
      //Vari�veis de controle que s�o muito utilizadas pelo c�digo inteiro.
      //S�o utilizadas para saber qual a quantidade de dados dentro de...
      //..seus respectivos vetores.
      totalRanking <- 0
      totalElementos <- 0

fimprocedimento

Inicio
      //Seta o valor de diversas vari�veis, para que possam ser utilizadas...
      //...pelo jogo.
      inicializarDados()
      controlarMenuInicial()
Fimalgoritmo
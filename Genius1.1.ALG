Algoritmo "Genius 1.1"
// Disciplina   : Construção de Algoritmos
// Professor   : Eugênio da Silva
// Descrição   : Simulador do Genius com funções novas, como Ranking e Trapaça
// Autor(a)    : Leandro Rocha Musser Carneiro
// E-mail      : leandro.musser@gmail.com
// Data atual  : 9/13/2019

const
   //Indica de quantos em quantos elementos o vetor sequência aumentará.
   AUMENTO_ELEMENTOS = 2
   
   COR_INICIAL = "branco"
   
   //O valor base do delay entre cada elemento desenhado na tela (o quadrado).
   DELAY_LISTA_ELEMENTOS = 400
   
   //Códigos de cada dificuldade. Os números são usados também na fórmula...
   //...de velocidade. Quanto maior o número, mais rápido os elementos...
   //...aparecerão e desaparecerão da tela.
   DIFICULDADE_FACIL = 1
   DIFICULDADE_MEDIA = 2
   DIFICULDADE_DIFICIL = 3
   
   //Limite máximo de quanto o vetor sequência pode ter de tamanho.
   //Foi pedido pelo professor o valor 10 e não pode ser mudado.
   MAX_ELEMENTOS = 10
   
   //Máximo de escolhas possíveis que o usuário deve memorizar.
   //No código são gerados números aleatórios que representam qual das...
   //...luzes do Genius acendeu. Como só há 4 luzes, esse é o limite.
   MAX_ESCOLHAS = 4
   
   //Tamanho máximo do ranking. É um top 10.
   MAX_RANKING = 10
   
  //Mostra as trapaças disponíveis com o comando 'ajuda' apenas se...
  //Simula uma espécie de modo de desenvolvedor ou modo de testes.
  //Seria desativado ao entregar para o jogador real.
   MOSTRAR_TRAPACAS = verdadeiro
   
   //Para evitar repetição e manter um padrão, esse texto é exibido sempre...
   //...que o usuário precisar inserir algum comando.
   TEXTO_CAIXA_DE_TEXTO = "- Seu comando: "
   
   //Constantes criadas para reduzir o que chamamos de 'números mágicos'...
   //...dentro do código. Ao acessar a matriz de trapaças, pode se...
   //...usar as constantes para acessar algo específico.
   TRAPACA_ATIVADA = 4
   TRAPACA_COMANDO = 3
   TRAPACA_DESCRICAO = 2
   TRAPACA_NOME = 1
   TRAPACA_CONTINUA = 5
   TRAPACA_OLHO_MILENIO = 1
   TRAPACA_POTE_GANANCIA = 2
   
   //Informa o tamanho do número de trapaças da matriz.
   QUANTIDADE_TRAPACAS = 3

//Inicialmente seria usado um registro para as trapaças.
//Infelizmente, o visualg gera um erro aleatório ao usar registro muitas vezes.
//O erro é mais fácil de ser detectado em códigos mais complexos ou...
//...utilização de breakpoints, passando por cima dos comandos de acesso ao...
//...registro. O erro é completamente ALEATÓRIO e pode acontecer vez sim, vez não.

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
//1 = Nome, 2 = Descrição, 3 = Comando, 4 = Ativado?, 5 = Efeito Continuo?
trapacasM: vetor[1..QUANTIDADE_TRAPACAS, 1..5] de caractere

procedimento listarRanking()
var i: inteiro
inicio
      para i de 1 ate totalRanking faca
         escreval("Nome: ",ranking[i,1]," | Pontos: ", ranking[i,2])
      fimpara

fimprocedimento

//Este procedimento é sempre chamado quando a pessoa DEVE ser inserida...
//...no ranking, pois já foram feitas verificações anteriores.
procedimento inserirNoRanking(nome, pontosObtidos: caractere)
var posicao: inteiro
inicio
      //Se o ranking estiver vazio, o primeiro lugar será usado...
      //...para o primeiro que entrar no ranking.
      se (totalRanking = 0) entao
         posicao <- 1
         //Aumenta o número de pessoas no ranking
         totalRanking <- totalRanking + 1
      senao
         //Caso tenha já pessoas no ranking, mas tenha espaço vazio nele,...
         //...o usuário será inserido na mesma posição da última pessoa + 1.
         se (totalRanking < MAX_RANKING) entao
            posicao <- totalRanking + 1
            totalRanking <- totalRanking + 1
            senao
               //Caso o ranking esteja cheio, a pessoa ocupará o lugar da última.
               //É exatamente como ocorre em um ranking normal.
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
     //Verifica se há espaço vazio no ranking. Se sim, qualquer pontuação...
     //...poderá entrar no ranking, mas não pode ser 0.
     se ((totalRanking < MAX_RANKING) e (pontosObtidos > 0)) entao
        retorne verdadeiro
     senao
          //Caso o ranking esteja cheio, só obtendo uma pontuação superior...
          //...a de alguém para entrar, então ele verificará aqui.
          //Desta forma comentada abaixo está dando erro no Visualg... Verificar depois
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
      //...limitado, não estou aplicando um método...
      //...mais complexo para a organização dos vetores. Neste método, a cada...
      //...inserção, o vetor é completamente organizado, mesmo que...
      //...precisasse apenas mover determinados elementos 1 índice para frente...
      //...e antes eliminando o que era o último (se necessário).

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
      //Para evitar repetições desnecessárias.
      //Uma das linhas SEMPRE estará vazia.
      escreval("¦¦          ¦          ¦¦")
      escreval("¦¦          ¦          ¦¦")
      escreval("¦¦          ¦          ¦¦")
      escreval("¦¦          ¦          ¦¦")
      escreval("¦¦          ¦          ¦¦")
fimprocedimento

procedimento montarQuadradosVaziosVisualGenius()
inicio
      //Faz parte do procedimento de desenho
      //Usado para evitar repetição de código
      escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
      montarLinhaVaziaVisualGenius()
      escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
      montarLinhaVaziaVisualGenius()
      escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
fimprocedimento

procedimento montarVisualGenius(posicao: inteiro; duracao: inteiro)
inicio
      //Este procedimento de montar os quadrados seguem uma lógica.
      //Não é apenas um monte de escreval repetido.
      //Porém, será mesmo que que é melhor uma lógica mais complexa...
      // do que repetição de código?
      mudacor(COR_INICIAL,"frente")
      montarQuadradosVaziosVisualGenius()
      timer duracao
      timer 0
      limpatela
      escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")

      se ((posicao = 3) ou (posicao = 4)) entao
         montarLinhaVaziaVisualGenius()
         escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
      fimse

      se ((posicao = 1) ou (posicao = 3)) entao
         escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦          ¦¦")
         escreval("¦¦¦¦     ¦¦¦¦          ¦¦")
         escreval("¦¦¦¦ ",posicao,"  ¦¦¦¦          ¦¦")
         escreval("¦¦¦¦     ¦¦¦¦          ¦¦")
         escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦          ¦¦")
      fimse

      se ((posicao = 2) ou (posicao = 4)) entao
         escreval("¦¦          ¦¦¦¦¦¦¦¦¦¦¦¦¦")
         escreval("¦¦          ¦¦¦¦     ¦¦¦¦")
         escreval("¦¦          ¦¦¦¦ ",posicao,"  ¦¦¦¦")
         escreval("¦¦          ¦¦¦¦     ¦¦¦¦")
         escreval("¦¦          ¦¦¦¦¦¦¦¦¦¦¦¦¦")
      fimse

      se ((posicao = 1) ou (posicao = 2)) entao
         escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
         montarLinhaVaziaVisualGenius()
      fimse
      escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")

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
        //O delay entre cada elemento usa a fórmula abaixo.
        //Quanto maior a dificuldade, maior seu código, então menor o delay.
        limpatela
        montarVisualGenius(sequencia[i], DELAY_LISTA_ELEMENTOS - 100 * dificuldade)

   fimpara
   limpatela
fimprocedimento

procedimento addElementoAleatorio(quantidade: inteiro)
var i: inteiro
inicio
      para i de 1 ate quantidade faca
           //Se o vetor de sequencia estiver cheio, não dará para...
           //..inserir mais elementos e dará erro se não tivesse a comparação.
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
      //Conversão para maiúsculo para facilitar
      comando <- Maiusc(comando)
      //Passa por cada trapaça da matriz
      para i de 1 ate QUANTIDADE_TRAPACAS faca
           //Compara na matriz se o comando digitado pelo usuário é o...
           //...comando usado para ativar a trapaça.
           se (comando = trapacasM[i, TRAPACA_COMANDO]) entao
               se (trapacasM[i, TRAPACA_ATIVADA] = "verdadeiro") entao


                  trapacasM[i, TRAPACA_ATIVADA] <- "falso"
                  escreval("")
                  escreval("-----------------------------------------")
                  escreval("Trapaça desativada: ",trapacasM[i, TRAPACA_NOME],".")
                  escreval("-----------------------------------------")
               senao
                  //Trapaças NÃO continuas são aquelas em que o efeito não...
                  //...permanece ativado, causando um efeito até que seja...
                  //...desativado. Exemplo: Ganhar 500 pontos.
                  //Trapaças asim não podem ser desativadas, por isso a verificação.
                  se (trapacasM[i, TRAPACA_CONTINUA] = "verdadeiro") entao
                     trapacasM[i, TRAPACA_ATIVADA] <- "verdadeiro"
                  fimse
                  escreval("")
                  escreval("-----------------------------------------")
                  escreval("Trapaça ativada: ",trapacasM[i, TRAPACA_NOME],".")
                  escreval(trapacasM[i, TRAPACA_DESCRICAO])
                  //Se a trapaça ativada for TRAPACA_POTE_GANANCIA, o efeito é...
                  //...aplicado imediatamente.
                  se (i = TRAPACA_POTE_GANANCIA) entao
                     placar <- placar + 200
                     escreval("Seu placar atualizado é:",placar," pontos.")
                  fimse
                  escreval("-----------------------------------------")
               fimse
           fimse
      fimpara



fimprocedimento

procedimento desenharQuadradoDemonstrativo()
inicio
    //Desenha o quadrado que aparece durante o jogo principal, ao pedir para...
    //..o usuário digitar um número de 1 a 4. Também é desenhado ao digitar...
    //..o comando 'bloco'.
    escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
    escreval("¦¦          ¦          ¦¦")
    //Caso esteja na dificuldade mais difícil, as cores serão removidas.
    se (dificuldade < 3) entao
       escreval("¦¦    1     ¦    2     ¦¦")
       escreval("¦¦  Verde   ¦ Vermelho ¦¦")
    senao
       escreval("¦¦    1     ¦     2    ¦¦")
       escreval("¦¦    _     ¦     _    ¦¦")
    fimse
    escreval("¦¦          ¦          ¦¦")
    escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
    escreval("¦¦          ¦          ¦¦")
    //Caso esteja na dificuldade mais difícil, as cores serão removidas.
    se (dificuldade < 3) entao
       escreval("¦¦    3     ¦    4     ¦¦")
       escreval("¦¦ Amarelo  ¦   Azul   ¦¦")
    senao
       escreval("¦¦    3     ¦    4     ¦¦")
       escreval("¦¦    _     ¦    _     ¦¦")
    fimse
    escreval("¦¦          ¦          ¦¦")
    escreval("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
fimprocedimento

procedimento controlarRanking()
inicio
    //Verifica se a dificuldade é a correta para poder entrar no ranking...
    //...e envia o placar para a funçao de checagem.
    se ((checarRanking(placar)) e (dificuldade = 2)) entao
       inserirNoRanking(nomeJogador,Numpcarac(placar))
       escreval(nomeJogador,", você conseguiu uma posição no Ranking.")
    fimse
fimprocedimento

procedimento resetarVariaveisDeJogo()
inicio
    //Reseta todas as variáveis de controle do jogo para iniciar um novo jogo.
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
    //A velocidade de cada dificuldade nada mais é do que 100 vezes...
    //...o código da dificuldade (que foi inserido no...
    //...'controlarMenuModoSozinho()'). Resultará em um valor em ms que será...
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
    
    //Só sairá daqui de dentro quando o jogo terminar de alguma forma.
    enquanto (jogando = verdadeiro) faca
       i <- 1
       //Adiciona uma quantidade de elementos aleatórios dentro do vetor
       //A quantidade é definida pela constante AUMENTO_ELEMENTOS
       addElementoAleatorio(AUMENTO_ELEMENTOS)
       //Mostra na tela todos os elementos de dentro do vetor
       mostrarElementos()
       round <- round + 1
       desenharQuadradoDemonstrativo()
       escreval("")
       escreval("[Round:",round," | Placar:",placar," pontos]")
       escreval("Digite o comando 'ajuda' para ver alguns comandos.")
       escreval("")
       //Repete um número de vezes igual ao número de elementos do vetor...
       //...sequencia. Aqui ele percorrerá elemento por elemento e o usuário...
       //...terá que digitar o código correspondente.
       enquanto (i <= totalElementos) faca
                //Verifica se uma determinada trapaça está ativada.
                //Caso esteja, o comando será executado aqui.
                //No caso, a resposta aparecerá acima da mensagem de digitar...
                //...o número.
                se (trapacasM[TRAPACA_OLHO_MILENIO, TRAPACA_ATIVADA] = "verdadeiro") entao
                   escreval("Resposta:",sequencia[i],".")
                fimse
                escreval("Digite o número do ",i,"º bloco que foi ativado:")
                escreva(TEXTO_CAIXA_DE_TEXTO)
                leia(digitado)
                escolha (digitado)
                   //Faz uma 'conversão' de caracter para inteiro
                   //Como é permitido digitar outros tipos de comandos...
                   //..., sem ser números, não é bom usar Caracpnum()
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

                //Se não foi digitado um número de 1 a 4, então pode ser...
                //...um comando válido ou inválido.
                //O usuário não perderá o jogo ao digitar um comando inválido.
                se ((elementoEscolhido <> 1) e (elementoEscolhido <> 2) e (elementoEscolhido <> 3) e (elementoEscolhido <> 4)) entao
                   elementoEscolhido <- -1
                fimse
                se (elementoEscolhido = -1) entao
                    //Se o usuário apenas aprtou enter, o jogo nem verificará...
                    //...se isso é um comando de trapaça.
                    se (digitado <> "") entao
                       //Envia o comando digitado para o procedimento de trapaças.
                       controlarTrapacas(digitado)
                    fimse

                    //Maiusc é usado para retirar o case-sensitive, convertendo...
                    //...tudo para maiúsculo.
                    se (Maiusc(digitado) = "AJUDA") entao
                       escreval("")
                       escreval("Comandos disponíveis: ")
                       escreval("")
                       escreval("Voltar ao menu anterior: 'sair'")
                       escreval("Mostrar o bloco de demonstração na tela: 'bloco'")

                       //Mostra as trapaças disponíveis no menu apenas se...
                       //...a constante for verdadeira. Simula uma espécie...
                       //...de modo de desenvolvedor ou modo de testes.
                       //Seria desativado ao entregar para o jogador real.
                       se (MOSTRAR_TRAPACAS = verdadeiro) entao
                          escreval("")
                          escreval("Visualização deve ser desativada ao entregar para o usuário:")
                          escreval("[TRAPAÇA] Ver todas as respostas: 'baguvix'")
                          escreval("[TRAPAÇA] Ganhar 200 pontos: 'ripazha'")
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
                   //Se o usuário digitou um comando de 1 a 4, esse bloco...
                   //...irá ser executado.
                   se (elementoEscolhido <> sequencia[i]) entao
                      escreval("")
                      escreval("Você errou!")
                      escreval("Sua pontuação foi de:",placar," pontos.")
                      //Verifica nas variáveis locais e no vetor ranking se...
                      //Há a possibilidade de o ususário ter entrado no ranking...
                      //... então ele é inserido lá, caso sim.
                      controlarRanking()
                      timer 1200
                      timer 0
                      //Reseta tudo para preparar um novo jogo.
                      resetarVariaveisDeJogo()
                      escreval("")
                      repita
                            escreval("Recomeçar? (1) Sim - (2) Não")
                            escreva(TEXTO_CAIXA_DE_TEXTO)
                            leia(opcaoEscolhida)
                            se (opcaoEscolhida = 2) entao
                               //O 'enquanto' principal deixará de funcionar ao...
                               //..atribuir falso à variável 'jogando'.
                               //Após isso, ele irá para o fim do procedimento...
                               //Assim, retornando para o menu anterior (que...
                               //...é um procedimento que o chamou).
                               jogando <- falso
                               interrompa
                            fimse
                            escreval("")
                      ate ((opcaoEscolhida = 1) ou (opcaoEscolhida = 2))
                   fimse
                   //Se o usuário acertou o último elemento é porque ele acertou...
                   //...todos os anteriores. Não tem como ser diferente.
                   //Portanto ele receberá pontuação e novos elementos serão...
                   //...adicionados ao vetor sequencia.
                   se ((elementoEscolhido = sequencia[i]) e (totalElementos = i)) entao
                      placar <- placar + totalElementos
                      escreval("")
                      //MAX_ELEMENTOS é o limite de 10 elementos pedido pelo...
                      //...professor.
                      se (totalElementos >= MAX_ELEMENTOS) entao
                         escreval("Você atingiu a pontuação máxima, parabéns!")
                         escreval("Sua pontuação foi de:",placar," pontos.")
                         mostrarCreditos()
                         escreval("")
                         controlarRanking()
                         
                         totalElementos <- 0
                         repita
                               escreval("Jogar de novo? (1) Sim - (2) Não")
                               escreva(TEXTO_CAIXA_DE_TEXTO)
                               leia(opcaoEscolhida)
                               se (opcaoEscolhida = 2) entao
                                  jogando <- falso
                                  interrompa
                               fimse
                               escreval("")
                         ate ((opcaoEscolhida = 1) ou (opcaoEscolhida = 2))
                      senao
                           escreval("Correto! Próximo round...")
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
         escreval("Escolha um nível de dificuldade para iniciar o jogo.")
         escreval("")
         escreval("(1) Mais fácil (Mais lento)")
         escreval("(2) Oficial (Permite o uso do Ranking)")
         escreval("(3) Mais difícil (Sem cores e mais rápido)")
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

                   //Este submenu é parte do anterior e não deve ser...
                   //...chamado diretamente, portanto o interrompa jogará o...
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
         escreval("(2) Jogar contra alguém (Fechado para manutenção)")
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
                   //...mas não foi criado devido a falta de tempo.
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
         //Verifica a variável que foi inicializada como 0 logo no início
         //Ela indica a quantidade de pessoas no ranking (quantidade de...
         //...pessoas dentro do vetor.)
         se (totalRanking = 0) entao
            escreval("Nenhum jogador no ranking.")
         senao
            //Lista todas as pessoas que estão no ranking.
            listarRanking()
         fimse
         escreval("")
         escreva("Aperte enter para voltar...")
         leia(opcaoEscolhida)
         //Limpa a tela antes de voltar ao menu inicial
         //Todo submenu é responsável por limpar a tela antes de retornar
         limpatela
         interrompa
      fimenquanto

fimprocedimento

procedimento mostrarCreditos()
inicio
      escreval("Genius 1.1 | Desenvolvido por Leandro Rocha Musser Carneiro.")
      escreval("UEZO - Centro Universitário Estadual da Zona Oeste.")
fimprocedimento

procedimento controlarMenuInicial()
var
   opcaoEscolhida: inteiro
inicio

   //Um loop infinito é utilizado para controlar o menu.
   //Poderia ser colocada outra condição não infinita, como por exemplo...
   //...'enquanto (opcaoEscolhida <> 9)', depois seria só mover o 'caso 9'...
   //... para depois do loop, mas eu quis manter um padrão entre os menus.
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
                  escreval("Obrigado por jogar o Gênius!")
                  interrompa
      fimescolha
   fimenquanto

fimprocedimento

procedimento inicializarDados()
inicio
      //Inicializa a matriz de trapaças.
      trapacasM[1, TRAPACA_NOME] <- "Olho do Milênio"
      trapacasM[1, TRAPACA_DESCRICAO] <- "Agora você pode ver as respostas."
      trapacasM[1, TRAPACA_COMANDO] <- "BAGUVIX"
      trapacasM[1, TRAPACA_ATIVADA] <- "falso"
      trapacasM[1, TRAPACA_CONTINUA] <- "verdadeiro"
      trapacasM[2, TRAPACA_NOME] <- "Pote da Ganância"
      trapacasM[2, TRAPACA_DESCRICAO] <- "Você ganhou 200 pontos."
      trapacasM[2, TRAPACA_COMANDO] <- "RIPAZHA"
      trapacasM[2, TRAPACA_ATIVADA] <- "falso"
      trapacasM[2, TRAPACA_CONTINUA] <- "falso"
      
      //Variáveis de controle que são muito utilizadas pelo código inteiro.
      //São utilizadas para saber qual a quantidade de dados dentro de...
      //..seus respectivos vetores.
      totalRanking <- 0
      totalElementos <- 0

fimprocedimento

Inicio
      //Seta o valor de diversas variáveis, para que possam ser utilizadas...
      //...pelo jogo.
      inicializarDados()
      controlarMenuInicial()
Fimalgoritmo
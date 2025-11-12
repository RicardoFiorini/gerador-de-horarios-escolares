algoritmo "Gerador de Horários Escolares Aprimorado"

// --- Constantes de Limite ---
const
   LIMITE_PROFS = 10
   LIMITE_DISC = 20
   DIAS_SEMANA = 5 // Seg a Sex
   PERIODOS_DIA = 6 // 6 aulas por dia

// --- Definição dos Tipos (Registros) ---
tipo Professor
   nome: caractere
   disponibilidade: vetor[1..DIAS_SEMANA, 1..PERIODOS_DIA] de logico
fimTipo

tipo Disciplina
   nome: caractere
   indiceProfessor: inteiro // Armazena o ÍNDICE (ex: 1) do professor
   cargaHoraria: inteiro
fimTipo

tipo SlotHorario // O que é exibido no horário final
   disciplina: caractere
   professor: caractere
fimTipo

// --- Variáveis Globais ---
var
   professores: vetor[1..LIMITE_PROFS] de Professor
   disciplinas: vetor[1..LIMITE_DISC] de Disciplina
   horarioEscolar: vetor[1..DIAS_SEMANA, 1..PERIODOS_DIA] de SlotHorario

   totalProfessores, totalDisciplinas: inteiro
   opcao: inteiro

// --- Procedimento: Pausa a execução ---
procedimento Pausar()
var
   tecla: caractere
inicio
   escreva("\n(Pressione [ENTER] para voltar ao menu...)")
   leia(tecla)
fimprocedimento

// --- Função: Retorna o nome do dia da semana ---
funcao ObterNomeDia(dia: inteiro) : caractere
   escolha dia
      caso 1: retorne "Segunda-feira"
      caso 2: retorne "Terça-feira"
      caso 3: retorne "Quarta-feira"
      caso 4: retorne "Quinta-feira"
      caso 5: retorne "Sexta-feira"
      padrão: retorne "Dia Inválido"
   fimescolha
fimfuncao

// --- Procedimento: Cadastrar Professor (com validação) ---
procedimento cadastrarProfessor()
var
   i, j, disponivel: inteiro
inicio
   limpatela
   escreva("--- Cadastro de Professor ---\n")
   
   se (totalProfessores >= LIMITE_PROFS) entao
      escreva("[ERRO] Limite de (", LIMITE_PROFS, ") professores atingido!\n")
   senao
      totalProfessores <- totalProfessores + 1
      escreva("Nome do Professor: ")
      leia(professores[totalProfessores].nome)

      escreva("Definindo a disponibilidade do professor (1=Sim, 0=Não):\n")
      para i de 1 até DIAS_SEMANA faca
         para j de 1 até PERIODOS_DIA faca
            
            // Loop de validação (só aceita 0 ou 1)
            disponivel <- -1
            enquanto (disponivel <> 0) e (disponivel <> 1) faca
               escreva(ObterNomeDia(i), ", Período ", j, "? (1=S, 0=N): ")
               leia(disponivel)
            fimenquanto
            
            // Converte o inteiro (0/1) para lógico (falso/verdadeiro)
            professores[totalProfessores].disponibilidade[i, j] <- (disponivel = 1)
            
         fimpara
      fimpara
      escreva("\nProfessor cadastrado com sucesso!\n")
   fimse
fimprocedimento

// --- Procedimento: Cadastrar Disciplina (com validação) ---
procedimento cadastrarDisciplina()
var
   i, idxProfessor, carga: inteiro
inicio
   limpatela
   escreva("--- Cadastro de Disciplina ---\n")
   
   se (totalDisciplinas >= LIMITE_DISC) entao
      escreva("[ERRO] Limite de (", LIMITE_DISC, ") disciplinas atingido!\n")
   senao se (totalProfessores = 0) entao
      escreva("[ERRO] Cadastre um professor antes de cadastrar uma disciplina.\n")
   senao
      totalDisciplinas <- totalDisciplinas + 1
      escreva("Nome da Disciplina: ")
      leia(disciplinas[totalDisciplinas].nome)

      // --- MELHORIA CRÍTICA: Validação do Professor ---
      escreva("\n--- Professores Disponíveis ---\n")
      para i de 1 ate totalProfessores faca
         escreva(i, " - ", professores[i].nome, "\n")
      fimpara
      escreva("---------------------------------\n")

      idxProfessor <- 0
      enquanto (idxProfessor < 1) ou (idxProfessor > totalProfessores) faca
         escreva("Digite o ÍNDICE do professor responsável: ")
         leia(idxProfessor)
         se (idxProfessor < 1) ou (idxProfessor > totalProfessores) entao
            escreva("[ERRO] Índice inválido. Escolha um da lista.\n")
         fimse
      fimenquanto
      
      disciplinas[totalDisciplinas].indiceProfessor <- idxProfessor
      
      carga <- 0
      enquanto (carga <= 0) ou (carga > DIAS_SEMANA * PERIODOS_DIA) faca
         escreva("Carga Horária (número de aulas semanais): ")
         leia(carga)
         se (carga <= 0) ou (carga > DIAS_SEMANA * PERIODOS_DIA) entao
            escreva("[ERRO] Carga horária deve ser entre 1 e ", DIAS_SEMANA * PERIODOS_DIA, ".\n")
         fimse
      fimenquanto
      disciplinas[totalDisciplinas].cargaHoraria <- carga
      
      escreva("\nDisciplina cadastrada com sucesso!\n")
   fimse
fimprocedimento

// --- Procedimento: Gerar o Horário Escolar ---
procedimento gerarHorarioEscolar()
var
   i, j, dia, periodo, aulasRestantes, idxProf: inteiro
   aulasNaoAlocadas: inteiro
   
   // --- MELHORIA CRÍTICA: Matriz de ocupação ---
   // [Índice do Professor, Dia, Período]
   professorOcupado: vetor[1..LIMITE_PROFS, 1..DIAS_SEMANA, 1..PERIODOS_DIA] de logico
   
inicio
   limpatela
   escreva("--- Gerando Horário Escolar ---\n")
   

   // 1. Inicializa a matriz de horário escolar (para a turma)
   para dia de 1 até DIAS_SEMANA faca
      para periodo de 1 até PERIODOS_DIA faca
         horarioEscolar[dia, periodo].disciplina <- "" // Vago
         horarioEscolar[dia, periodo].professor <- ""
      fimpara
   fimpara
   
   // 2. Inicializa a matriz de ocupação dos professores
   para i de 1 ate totalProfessores faca
      para dia de 1 até DIAS_SEMANA faca
         para periodo de 1 até PERIODOS_DIA faca
            professorOcupado[i, dia, periodo] <- falso // Todos os profs. livres
         fimpara
      fimpara
   fimpara

   aulasNaoAlocadas <- 0

   // 3. Tenta alocar as disciplinas (algoritmo "guloso" - "greedy")
   para i de 1 até totalDisciplinas faca // Para cada disciplina...
      
      aulasRestantes <- disciplinas[i].cargaHoraria
      idxProf <- disciplinas[i].indiceProfessor
      
      // Tenta alocar as aulas nos primeiros horários que encontrar
      para dia de 1 até DIAS_SEMANA faca
         para periodo de 1 até PERIODOS_DIA faca
            
            se (aulasRestantes > 0) entao
               
               // --- VERIFICAÇÃO TRIPLA (A MÁGICA ESTÁ AQUI) ---
               
               // 1. O horário da TURMA está vago?
               se (horarioEscolar[dia, periodo].disciplina = "") entao
                  
                  // 2. O professor PODE dar aula (disponibilidade dele)?
                  se (professores[idxProf].disponibilidade[dia, periodo]) entao
                     
                     // 3. O professor JÁ ESTÁ ocupado com OUTRA disciplina?
                     se (professorOcupado[idxProf, dia, periodo] = falso) entao
                        
                        // --- SUCESSO! ALOCAR AULA ---
                        horarioEscolar[dia, periodo].disciplina <- disciplinas[i].nome
                        horarioEscolar[dia, periodo].professor <- professores[idxProf].nome
                        
                        // Marca o professor como ocupado neste slot
                        professorOcupado[idxProf, dia, periodo] <- verdadeiro
                        
                        aulasRestantes <- aulasRestantes - 1
                        
                     fimse
                  fimse
               fimse
            fimse
         fimpara // Fim 'periodo'
      fimpara // Fim 'dia'
      
      // 4. Reporta se não conseguiu alocar tudo
      se (aulasRestantes > 0) entao
         escreval("[ALERTA] Não foi possível alocar ", aulasRestantes, " de ", disciplinas[i].cargaHoraria, " aulas de '", disciplinas[i].nome, "' (Professor: ", professores[idxProf].nome, ")")
         aulasNaoAlocadas <- aulasNaoAlocadas + aulasRestantes
      fimse
      
   fimpara // Fim 'i' (disciplinas)

   se (aulasNaoAlocadas = 0) entao
      escreva("\nHorário escolar gerado com SUCESSO! Todas as aulas alocadas.\n")
   senao
      escreva("\nHorário gerado com FALHAS. Total de aulas não alocadas: ", aulasNaoAlocadas, "\n")
      escreva("Verifique a disponibilidade dos professores ou a carga horária.\n")
   fimse
fimprocedimento

// --- Procedimento: Exibir o Horário Escolar (Formato de Lista) ---
procedimento exibirHorarioEscolar()
var
   dia, periodo: inteiro
   slotVazio: logico
inicio
   limpatela
   escreva("=========================================\n")
   escreva("=           HORÁRIO ESCOLAR           =\n")
   escreva("=========================================\n")
   
   para dia de 1 até DIAS_SEMANA faca
      escreva("\n--- ", ObterNomeDia(dia), " ---\n")
      slotVazio <- verdadeiro
      
      para periodo de 1 até PERIODOS_DIA faca
         se (horarioEscolar[dia, periodo].disciplina <> "") entao
            escreva("  Período ", periodo, ": ", horarioEscolar[dia, periodo].disciplina:15, " (Prof. ", horarioEscolar[dia, periodo].professor, ")\n")
            slotVazio <- falso
         senao
            // Opcional: Para não poluir, podemos esconder os vagos
            // escreva("  Período ", periodo, ": Vago\n")
         fimse
      fimpara
      
      se (slotVazio) entao
         escreva("  (Sem aulas neste dia)\n")
      fimse
   fimpara
   escreva("=========================================\n")
fimprocedimento

// --- Bloco Principal (Início da Execução) ---
inicio
   totalProfessores <- 0
   totalDisciplinas <- 0
   opcao <- -1

   // Menu principal
   repita
      limpatela
      escreva("=========================================\n")
      escreva("=     Gerador de Horários Escolares     =\n")
      escreva("=========================================\n")
      escreva(" Professores: ", totalProfessores, "/", LIMITE_PROFS, " | Disciplinas: ", totalDisciplinas, "/", LIMITE_DISC, "\n")
      escreva("=========================================\n")
      escreva("1. Cadastrar Professor\n")
      escreva("2. Cadastrar Disciplina\n")
      escreva("3. Gerar Horário Escolar\n")
      escreva("4. Exibir Horário Escolar\n")
      escreva("0. Sair\n")
      escreva("-----------------------------------------\n")
      escreva("Escolha uma opção: ")
      leia(opcao)

      escolha opcao
         caso 1
            cadastrarProfessor()
            Pausar()
         caso 2
            cadastrarDisciplina()
            Pausar()
         caso 3
            gerarHorarioEscolar()
            Pausar()
         caso 4
            exibirHorarioEscolar()
            Pausar()
         caso 0
            escreva("\nSaindo do sistema...\n")
         padrão
            escreva("\n[ERRO] Opção inválida. Tente novamente.\n")
            Pausar()
      fimescolha
      
   até (opcao = 0)
fimalgoritmo

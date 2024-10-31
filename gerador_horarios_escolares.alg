algoritmo "Gerador de Horários Escolares"

// Definindo os tipos para professores, disciplinas e horários
variáveis
    tipo Professor
        nome : caractere
        disponibilidade : vetor[1..5, 1..6] de logico // Segunda a sexta, períodos 1 a 6
    fimTipo

    tipo Disciplina
        nome : caractere
        professor : inteiro // índice do professor responsável
        cargaHoraria : inteiro // número de aulas por semana
    fimTipo

    tipo Horario
        dia : inteiro
        periodo : inteiro
        disciplina : caractere
        professor : caractere
    fimTipo

    professores : vetor[1..10] de Professor
    disciplinas : vetor[1..20] de Disciplina
    horarioEscolar : vetor[1..5, 1..6] de Horario // Segunda a sexta, períodos 1 a 6

    totalProfessores, totalDisciplinas : inteiro
    i, j, dia, periodo : inteiro

início
    totalProfessores ← 0
    totalDisciplinas ← 0

    // Função para cadastrar professor
    funcao cadastrarProfessor()
        totalProfessores ← totalProfessores + 1
        escreva("Nome do Professor: ")
        leia(professores[totalProfessores].nome)
        
        // Definindo a disponibilidade do professor
        para i de 1 até 5 faça
            para j de 1 até 6 faça
                escreva("Professor disponível no dia ", i, ", período ", j, "? (1 para Sim, 0 para Não): ")
                leia(professores[totalProfessores].disponibilidade[i, j])
            fimpara
        fimpara
        escreva("Professor cadastrado com sucesso!\n")
    fimfuncao

    // Função para cadastrar disciplina
    funcao cadastrarDisciplina()
        totalDisciplinas ← totalDisciplinas + 1
        escreva("Nome da Disciplina: ")
        leia(disciplinas[totalDisciplinas].nome)
        
        escreva("Índice do Professor Responsável: ")
        leia(disciplinas[totalDisciplinas].professor)
        
        escreva("Carga Horária (número de aulas semanais): ")
        leia(disciplinas[totalDisciplinas].cargaHoraria)
        escreva("Disciplina cadastrada com sucesso!\n")
    fimfuncao

    // Função para gerar o horário escolar
    funcao gerarHorarioEscolar()
        // Inicializando as matrizes para evitar conflitos
        para dia de 1 até 5 faça
            para periodo de 1 até 6 faça
                horarioEscolar[dia, periodo].disciplina ← ""
                horarioEscolar[dia, periodo].professor ← ""
            fimpara
        fimpara

        // Alocando as disciplinas de acordo com a disponibilidade dos professores
        para i de 1 até totalDisciplinas faça
            var aulasRestantes : inteiro
            aulasRestantes ← disciplinas[i].cargaHoraria

            para dia de 1 até 5 faça
                para periodo de 1 até 6 faça
                    se aulasRestantes > 0 então
                        // Verifica se o professor está disponível
                        se professores[disciplinas[i].professor].disponibilidade[dia, periodo] então
                            se horarioEscolar[dia, periodo].disciplina = "" então
                                // Aloca a aula no horário disponível
                                horarioEscolar[dia, periodo].disciplina ← disciplinas[i].nome
                                horarioEscolar[dia, periodo].professor ← professores[disciplinas[i].professor].nome
                                aulasRestantes ← aulasRestantes - 1
                            fimse
                        fimse
                    fimse
                fimpara
            fimpara
        fimpara

        escreva("Horário escolar gerado com sucesso!\n")
    fimfuncao

    // Função para exibir o horário escolar
    funcao exibirHorarioEscolar()
        para dia de 1 até 5 faça
            escreva("Dia ", dia, ":\n")
            para periodo de 1 até 6 faça
                se horarioEscolar[dia, periodo].disciplina <> "" então
                    escreva("Período ", periodo, ": ", horarioEscolar[dia, periodo].disciplina, " - ", horarioEscolar[dia, periodo].professor, "\n")
                senão
                    escreva("Período ", periodo, ": Vago\n")
                fimse
            fimpara
        fimpara
    fimfuncao

    // Menu principal do sistema
    repita
        escreva("\n=== Gerador de Horários Escolares ===\n")
        escreva("1. Cadastrar Professor\n")
        escreva("2. Cadastrar Disciplina\n")
        escreva("3. Gerar Horário Escolar\n")
        escreva("4. Exibir Horário Escolar\n")
        escreva("0. Sair\n")
        escreva("Escolha uma opção: ")
        leia(opcao)

        escolha opcao
            caso 1
                cadastrarProfessor()
            caso 2
                cadastrarDisciplina()
            caso 3
                gerarHorarioEscolar()
            caso 4
                exibirHorarioEscolar()
            caso 0
                escreva("Saindo do sistema...\n")
            caso contrário
                escreva("Opção inválida. Tente novamente.\n")
        fimescolha
    até opcao = 0
fimalgoritmo

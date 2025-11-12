# 📅 Gerador de Horários Escolares (Portugol)

Este é um algoritmo de console altamente complexo que implementa um gerador de horários escolares, focado em resolver conflitos de alocação de professores. O projeto utiliza Registros (`tipo`), matrizes e um algoritmo de alocação "guloso" (greedy algorithm) para satisfazer as restrições.



## ✨ Funcionalidades Principais

* **1. Cadastrar Professor:**
    * Permite o cadastro de professores.
    * **Disponibilidade Detalhada:** O sistema solicita a disponibilidade do professor para cada período de cada dia da semana (ex: Segunda, Período 1? Sim/Não).
    * **Validação:** Impede o cadastro se o limite de professores for atingido.

* **2. Cadastrar Disciplina:**
    * Permite o cadastro de disciplinas (ex: Matemática, História).
    * **Vinculação de Professor:** Exibe uma lista de professores cadastrados e exige que o usuário vincule um professor (por índice) à disciplina.
    * **Validação:** Garante que o índice do professor seja válido.
    * **Carga Horária:** Define quantas aulas semanais a disciplina exige.

* **3. Gerar Horário Escolar (O Cérebro do Sistema):**
    * Executa um algoritmo que tenta alocar todas as aulas de todas as disciplinas no horário da turma.
    * **Lógica de Verificação Tripla:** Para alocar uma aula em um slot (ex: Terça, Período 3), o sistema verifica **três** condições:
        1.  O horário da **Turma** está vago?
        2.  O **Professor** *pode* trabalhar naquele horário (baseado na disponibilidade dele)?
        3.  O **Professor** já não está *ocupado* com outra disciplina (ex: dando aula de Física para outra turma) naquele mesmo horário? (Este é o ponto crucial).
    * **Relatório de Falhas:** Ao final, o sistema informa se conseguiu alocar todas as aulas ou se falhou, reportando quais aulas de quais disciplinas não puderam ser alocadas.

* **4. Exibir Horário Escolar:**
    * Mostra o horário final gerado, formatado por dia da semana, listando a disciplina e o professor alocado em cada período.

## 🏛️ Estrutura e Lógica

Este sistema é definido por três Registros (`tipo`):

1.  **`tipo Professor`**: Armazena o nome e uma matriz `[5, 6]` de `logico` (verdadeiro/falso) para sua disponibilidade.
2.  **`tipo Disciplina`**: Armazena o nome, a carga horária e o **índice** do professor responsável (ex: `1`, que aponta para o Professor "João" no vetor `professores`).
3.  **`tipo SlotHorario`**: Usado na matriz `horarioEscolar`, armazena as *strings* finais (nome da disciplina e nome do professor) para exibição.

### O Algoritmo de Geração

O procedimento `gerarHorarioEscolar` é a parte mais complexa. Ele usa duas matrizes principais:

1.  `horarioEscolar` (para a Turma): Verifica se o slot `[dia, periodo]` está vago.
2.  `professorOcupado` (local): Uma matriz `[indice_prof, dia, periodo]` que é zerada no início. Quando uma aula de Matemática do Prof. João é alocada na Segunda/Período 1, o sistema marca `professorOcupado[1, 1, 1] <- verdadeiro`.

Isso impede que a próxima disciplina (ex: Física), também do Prof. João, seja alocada no mesmo slot, resolvendo o principal conflito de geração de horários.

## 🚀 Como Executar

Para executar este algoritmo, você precisará de um interpretador de Portugol.

1.  **VisualG (Recomendado):**
    * Baixe e instale o [VisualG](http://visualg.com.br/cli/).
    * Copie o código-fonte (`.alg`) do arquivo.
    * Abra o VisualG e cole o código.
    * Pressione **F9** (ou clique em "Rodar") para executar o programa.

# 🎬 CineLista – Minha Lista de Filmes

Aplicativo multiplataforma (web, Android e iOS a partir do mesmo código) para organizar filmes que quero assistir e registrar os que já assisti, com nota e comentário pessoal. Desenvolvido em **Flutter/Dart** com **Firebase Authentication** e **Cloud Firestore**.

## Funcionalidades principais

- **Autenticação:** cadastro, login e logout com e-mail e senha.
- **Proteção de telas:** somente usuários autenticados acessam a lista de filmes.
- **CRUD completo de filmes:**
  - **Criar:** título, gênero, ano, status (Quero assistir / Assistido), nota (1 a 5 estrelas) e comentário.
  - **Ler:** lista em tempo real, com filtro por status.
  - **Atualizar:** tocar em um filme abre o formulário de edição.
  - **Excluir:** botão de lixeira com confirmação.
- **Validação de formulários:** campos obrigatórios, e-mail válido, senha mínima de 6 caracteres, confirmação de senha e ano válido.
- **Tratamento de erros:** login inválido, campos vazios, e-mail já cadastrado, senha fraca, falta de conexão (mensagens em português).
- **Layout responsivo:** 1 coluna no celular e várias colunas no desktop/navegador.

## Tecnologias utilizadas

| Tecnologia | Uso |
|---|---|
| Flutter + Dart | Interface e lógica (Material 3) |
| Firebase Authentication | Login e cadastro (e-mail/senha) |
| Cloud Firestore | Banco de dados NoSQL em nuvem |
| Navigator (rotas nomeadas) | Navegação entre telas |

## Estrutura do projeto

```
lib/
├── main.dart                  # Inicialização do Firebase, tema e rotas
├── routes.dart                # Nomes das rotas
├── firebase_options.dart      # Gerado pelo FlutterFire CLI
├── models/
│   └── movie.dart             # Modelo Movie
├── services/
│   ├── auth_service.dart      # Login, cadastro, logout, tradução de erros
│   └── database_service.dart  # CRUD no Firestore
├── screens/
│   ├── auth_gate.dart         # Proteção de telas (logado ou não)
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart       # Lista + filtro + excluir
│   └── movie_form_screen.dart # Criar e editar filme
├── widgets/
│   └── movie_card.dart        # Card de filme
└── utils/
    └── validators.dart        # Validações de formulário
```

## Como executar o projeto

**Pré-requisitos:** [Flutter SDK](https://docs.flutter.dev/get-started/install), Google Chrome e uma conta Google para o Firebase.

1. Clone o repositório:
   ```bash
   git clone https://github.com/SEU_USUARIO/cinelista.git
   cd cinelista
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Crie um projeto no [Firebase Console](https://console.firebase.google.com) e ative:
   - **Authentication** → método **E-mail/senha**
   - **Firestore Database**
4. Conecte o app ao seu projeto Firebase:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   (isso gera o arquivo `lib/firebase_options.dart`)
5. Publique as regras de segurança do Firestore (veja abaixo).
6. Execute:
   ```bash
   flutter run -d chrome
   ```

## Autenticação

Usa o **Firebase Authentication** com e-mail e senha. O `AuthService` encapsula `signInWithEmailAndPassword`, `createUserWithEmailAndPassword` e `signOut`. O `AuthGate` escuta `authStateChanges()` e exibe a Home apenas se houver usuário logado; caso contrário, mostra a tela de login.

## Base de dados

Usa o **Cloud Firestore**. Cada usuário possui sua própria coleção de filmes:

```
users/{uid}/movies/{movieId}
  title, genre, year, rating, status ("watchlist" | "watched"), comment, createdAt
```

Regras de segurança (cada usuário acessa somente os próprios dados):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/movies/{movieId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

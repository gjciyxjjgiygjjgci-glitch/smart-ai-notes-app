# Contributing to Smart AI Notes

Thank you for your interest in contributing! 🎉

## How to Contribute

### 1. Fork & Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/smart-ai-notes-app.git
cd smart-ai-notes-app
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 3. Make Changes

- Write clean, readable code
- Follow existing code style
- Add comments for complex logic
- Update documentation if needed

### 4. Test Your Changes

```bash
# Backend tests
cd backend
npm test

# Flutter tests
cd mobile
flutter test

# Manual testing
flutter run
```

### 5. Commit & Push

```bash
git add .
git commit -m "feat: add new feature description"
git push origin feature/your-feature-name
```

### 6. Create Pull Request

- Go to GitHub and create a PR
- Describe your changes clearly
- Link related issues
- Wait for review

## Commit Message Format

Use conventional commits:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

Examples:
```
feat: add flashcard generation
fix: resolve audio recording crash on Android 12
docs: update API documentation
```

## Code Style

### Backend (JavaScript)
- Use ES6+ features
- 2 spaces for indentation
- Semicolons required
- Use async/await over promises

### Mobile (Dart/Flutter)
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Prefer const constructors
- Use meaningful variable names

## What to Contribute

### Good First Issues
- UI improvements
- Documentation updates
- Bug fixes
- Test coverage
- Translation improvements

### Feature Ideas
- New summary formats
- Additional language support
- Export formats
- Study tools (flashcards, quizzes)
- Collaboration features

### Bug Reports
When reporting bugs, include:
- Device/OS version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs if applicable

## Development Setup

See [docs/SETUP.md](docs/SETUP.md) for detailed setup instructions.

## Questions?

- Open an issue for discussion
- Check existing issues first
- Be respectful and constructive

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for making Smart AI Notes better! 🙏**

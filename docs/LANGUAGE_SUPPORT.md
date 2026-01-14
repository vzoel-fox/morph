# Morph Language Support

## GitHub Linguist Integration

Repository ini sudah dikonfigurasi untuk GitHub Linguist recognition:

- **File Extension**: `.fox` 
- **Language Name**: Morph
- **Color**: `#ff6b35` (orange)
- **Type**: Programming Language

### Files Configured:
- `.gitattributes` - Language detection rules
- `.github/linguist-languages.yml` - Language definition
- `.github/morphfox.tmLanguage.json` - Syntax highlighting grammar

## Syntax Highlighting

### Keywords:
- **Control Flow**: `fungsi`, `tutup_fungsi`, `utama`, `jika`, `selama`, `kembali`
- **Variables**: `var`, `Ambil`
- **Types**: `i64`, `ptr`, `String`
- **Builtins**: `sistem`, `print_line`

### Comments:
- Line comments: `# comment`
- Block comments: `### comment ###`

### Example:
```morph
fungsi utama()
    # Tes ekspresi matematika
    var a = 10
    var b = 20
    (a + b) * 2
tutup_fungsi
```

## Editor Support

### VS Code
Copy `.github/morphfox.tmLanguage.json` to VS Code extensions untuk syntax highlighting.

### Vim/Neovim
Buat `~/.vim/syntax/morphfox.vim` dengan pattern matching untuk keywords.

### GitHub
Otomatis detect setelah push dengan `.gitattributes` configuration.

## Language Statistics

Setelah push ke GitHub, repository akan menampilkan:
- Morph sebagai primary language
- Proper syntax highlighting di web interface
- Language statistics di repository insights

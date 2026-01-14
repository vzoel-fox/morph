# Brainlib - MorphFox Standard Library

Brainlib adalah reimplementasi modern dari `corelib` yang dirancang khusus untuk **Self-Hosting Compiler**. Library ini mengatasi keterbatasan environment bootstrap (`bin/morph` v1.5.1) dan menyediakan struktur data yang efisien.

## Fitur Utama

### 1. Manajemen Memori Robust
*   **Syscall Bypass**: Menggunakan `sys_mmap` (via `sistem 9`) secara langsung melalui `brainlib/memory.fox`. Ini menghindari kegagalan resolusi simbol `__mf_mem_alloc` pada binary bootstrap.
*   **Defensive Programming**: Semua fungsi alokasi (`string_new`, `vector_new`, `hashmap_new`) memiliki pengecekan `NULL` untuk mencegah *Silent Crash*.
*   **Centralized API**: Semua modul menggunakan `brainlib/memory.fox` sebagai *Source of Truth*.

### 2. String & String View
*   **Struktur**: `[Len (0), DataPtr (8)]`. Kompatibel penuh dengan instruksi `OP_PRINT` / `sys_write` di `executor.s`.
*   **Ownership Model**:
    *   `string_new(ptr, len)`: Membuat **String View** (wrapper). Tidak menyalin data. **JANGAN** di-free menggunakan `string_free` jika data adalah literal statis. Gunakan `string_free_wrapper`.
    *   `string_from(ptr, len)`: Membuat **Owned String**. Menyalin data ke heap. Aman di-free menggunakan `string_free`.

### 3. HashMap dengan String Key
*   Berbeda dengan `corelib` lama (Integer Key), `brainlib/hashmap.fox` mendukung **String Key** (via pointer).
*   Melakukan **Deep Copy** pada key saat insersi (`hashmap_insert`) untuk menjamin keamanan memori.
*   Otomatis membersihkan memori key saat `hashmap_remove` atau `hashmap_free`.

## Panduan Migrasi (Corelib -> Brainlib)

1.  **Import**: Ganti `ambil "corelib/lib/..."` dengan `ambil "brainlib/..."`.
2.  **String**: Perhatikan lifecycle. Jika membuat string dari literal untuk sementara, gunakan `string_new`. Jika menyimpan string jangka panjang (misal di Struct/HashMap), gunakan `string_from`.
3.  **HashMap**: Key sekarang harus berupa String Pointer, bukan Integer Hash. Hapus panggilan `string_hash()` manual di kode pengguna sebelum insert; HashMap akan melakukannya internal.

## Status Kompatibilitas
*   **Bootstrap v1.5.1**: Terverifikasi (Pilot Lexer berjalan).
*   **Executor Syscalls**: Menggunakan ID yang valid (`9` untuk mmap, `11` untuk munmap).

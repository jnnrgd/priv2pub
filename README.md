# priv2pub

An [Oh My Zsh](https://ohmyz.sh/) plugin that derives EC / EdDSA public keys from raw hex private scalars.
Supports Bitcoin/EVM secp256k1, the NIST P-256/384/521 curves, and Ed25519 / Ed448.
Pure zsh + `openssl`, no other runtime.

## Installation

Requires `openssl` and `xxd` (package `vim-common` / `vim`).

### Oh My Zsh

Clone the repository into your custom plugins directory:

```zsh
git clone https://github.com/jnnrgd/priv2pub.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/priv2pub
```

Add `priv2pub` to your `plugins` list in `~/.zshrc`:

```zsh
plugins=(
  git
  priv2pub
)
```

Reload your environment:

```zsh
source ~/.zshrc
```

### Manual

Source the plugin directly from your `~/.zshrc`:

```zsh
source /path/to/priv2pub/priv2pub.plugin.zsh
```

## Usage

```sh
priv2pub [curve] [-c|--compressed] [-u|--uncompressed] [key1 key2 ...]
cat keys.txt | priv2pub [curve] [-c]
```

- One key per line via stdin, or space-separated key arguments.
- Keys are hex digits (case-insensitive), with an optional `0x`/`0X` prefix; short keys are
  zero-padded to the curve's key length, longer keys are rejected as an error.
- Default curve: `secp256k1`. Default form: uncompressed.
- One hex public key printed per line, in input order.

```sh
$ priv2pub 1
0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

$ priv2pub secp256k1 -c 1
0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798

$ priv2pub ed25519 1
4cb5abf6ad79fbf5abbccafcc269d85cd2651ed4b885b5869f241aedf0a5ba29
```

Convenience aliases pre-select a curve:

| Alias      | Equivalent              |
|------------|-------------------------|
| `k1pub`    | `priv2pub secp256k1`    |
| `r1pub`    | `priv2pub p256`         |
| `p384pub`  | `priv2pub p384`         |
| `p521pub`  | `priv2pub p521`         |
| `edpub`    | `priv2pub ed25519`      |
| `ed448pub` | `priv2pub ed448`        |

```sh
$ k1pub -c 0000000000000000000000000000000000000000000000000000000000000001
0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
```

## Curves

| Name                 | Aliases                          | Key     | Output (uncompressed / compressed) |
|----------------------|----------------------------------|---------|------------------------------------|
| secp256k1 (default)  | `k1`, `256`                      | 32 B    | 65 B / 33 B hex point              |
| NIST P-256           | `p256`, `r1`, `secp256r1`, `prime256v1` | 32 B | 65 B / 33 B hex point        |
| NIST P-384           | `p384`, `secp384r1`, `prime384v1` | 48 B   | 97 B / 49 B hex point              |
| NIST P-521           | `p521`, `secp521r1`, `prime521v1`, `521`, `512`, `p512` | 66 B | 133 B / 67 B hex point |
| Ed25519              | `ed25519`, `25519`               | 32 B    | 32 B raw point (`-c` ignored)      |
| Ed448                | `ed448`, `448`                   | 57 B    | 57 B raw point (`-c` ignored)      |

The "Key" column is the private scalar for the prime-field curves, and the RFC 8032
seed for Ed25519/Ed448 (OpenSSL expands it via SHA-512; the input is not used as a scalar).

## Completion

Ships a zsh completion (`_priv2pub`) covering `priv2pub` and all aliases; it is
picked up automatically once the plugin's directory is on `fpath` (which the
plugin does at load). Curve names, `-c`/`-u`/`-h`, and key files complete.

## Notes

- Compressed/uncompressed applies to the prime-field curves only; Ed curves always emit raw points.
- Uses `openssl` internally (`ec` / `pkey`), so output matches `openssl` for the same scalar.
- Invalid hex prints an error to stderr and skips that key.

## License

This project is dedicated to the public domain under the [Creative Commons Zero v1.0 Universal (CC0 1.0)](LICENSE). You can copy, modify, distribute, and perform the work, even for commercial purposes, all without asking permission.


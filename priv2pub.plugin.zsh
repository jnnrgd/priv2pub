0="${ZERO:-${${0:A}:-$functrace[1]%:*}}"
local PLUGIN_DIR="${0:A:h}"
fpath=("${PLUGIN_DIR}" $fpath)

# Dynamically source all modular library files
for _lib_file in "${PLUGIN_DIR}"/lib/*.zsh(N); do
  source "$_lib_file"
done
unset _lib_file

priv2pub() {
  local curve="secp256k1"
  local compressed=false
  local -a keys=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -c|--compressed)
        compressed=true
        shift
        ;;
      -u|--uncompressed)
        compressed=false
        shift
        ;;
      secp256k1|k1|256|p256|secp256r1|prime256v1|r1|p384|secp384r1|prime384v1|384|p521|secp521r1|prime521v1|521|512|p512|ed25519|25519|ed448|448)
        curve="$1"
        shift
        ;;
      -h|--help)
        cat << 'EOF'
Usage: priv2pub [curve] [-c|--compressed] [key1 key2 ...]
       cat keys.txt | priv2pub [curve] [-c]

Curves:
  secp256k1 (k1)      Bitcoin / Ethereum (32-byte scalar) [default]
  p256 (r1)           NIST P-256 / secp256r1 (32-byte scalar)
  p384 (384)          NIST P-384 / secp384r1 (48-byte scalar)
  p521 (521, 512)     NIST P-521 / secp521r1 (66-byte scalar)
  ed25519             Ed25519 raw point (32-byte seed)
  ed448 (448)         Ed448 raw point (57-byte seed)

Flags:
  -c, --compressed    Output compressed public key
  -u, --uncompressed  Output uncompressed public key (default)
  -h, --help          Show this message
EOF
        return 0
        ;;
      *)
        keys+=("$1")
        shift
        ;;
    esac
  done

  # Read from stdin if no keys were passed as positional arguments
  if [[ ${#keys[@]} -eq 0 ]]; then
    if [[ -t 0 ]]; then
      echo "priv2pub: no keys provided via arguments or stdin. See 'priv2pub --help'." >&2
      return 1
    fi
    local raw_input
    raw_input="$(tr -d '\r')"
    keys=(${=raw_input})
  fi

  for key in "${keys[@]}"; do
    _priv2pub_derive_key "$curve" "$compressed" "$key"
  done
}

# Curve convenience aliases
alias k1pub="priv2pub secp256k1"
alias r1pub="priv2pub p256"
alias p384pub="priv2pub p384"
alias p521pub="priv2pub p521"
alias edpub="priv2pub ed25519"
alias ed448pub="priv2pub ed448"

_priv2pub_derive_key() {
  local curve="$1"
  local compressed="$2"
  local key="$3"

  # Strip optional 0x and normalize to lowercase
  key="${key#0[xX]}"
  key="${(L)key}"

  [[ -z "$key" ]] && return 0

  if [[ "$key" =~ [^0-9a-f] ]]; then
    echo "priv2pub: invalid hex characters in key: '$key'" >&2
    return 1
  fi

  # Reject keys wider than the curve's scalar; padding never truncates, so an
  # over-length key would otherwise yield silently malformed output.
  local want
  case "$curve" in
    p384|secp384r1|prime384v1|384) want=96 ;;
    p521|secp521r1|prime521v1|521|512|p512) want=132 ;;
    ed448|448) want=114 ;;
    *) want=64 ;;
  esac
  if (( ${#key} > want )); then
    echo "priv2pub: key too long for ${curve}: ${#key} hex chars, max ${want}" >&2
    return 1
  fi

  case "$curve" in
    secp256k1|k1|256)
      _priv2pub_secp256k1 "$key" "$compressed"
      ;;
    p256|secp256r1|prime256v1|r1)
      _priv2pub_p256 "$key" "$compressed"
      ;;
    p384|secp384r1|prime384v1|384)
      _priv2pub_p384 "$key" "$compressed"
      ;;
    p521|secp521r1|prime521v1|521|512|p512)
      _priv2pub_p521 "$key" "$compressed"
      ;;
    ed25519|25519)
      _priv2pub_ed25519 "$key"
      ;;
    ed448|448)
      _priv2pub_ed448 "$key"
      ;;
    *)
      echo "priv2pub: unsupported curve '${curve}'" >&2
      return 1
      ;;
  esac
}

_priv2pub_ed25519() {
  local key="${(l:64::0:)1}"
  local der="302e020100300506032b657004220420${key}"

  echo -n "$der" | xxd -r -p \
    | openssl pkey -inform DER -pubout -outform DER 2>/dev/null \
    | tail -c 32 | xxd -p -c 32
}
